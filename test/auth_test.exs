defmodule Battlenet.AuthTest do
  use ExUnit.Case, async: false

  @config Application.get_all_env(:battlenet)

  setup do
    HTTPoison.start()
    start_supervised!(Battlenet.Auth.Stash)
    start_supervised!(Battlenet.Auth)
    bypass = Bypass.open()
    Application.put_env(:battlenet, :site_url, "http://localhost:#{bypass.port}")
    context = %{bypass: bypass}
    {:ok, context}
  end

  test "authorize_url" do
    parsed_url = URI.parse(Battlenet.Auth.authorize_url())

    assert parsed_url.path == "/oauth/authorize"
    assert query_param(parsed_url, "client_id") == @config[:client_id]
    assert query_param(parsed_url, "redirect_uri") == @config[:redirect_uri]
    assert query_param(parsed_url, "response_type") == "code"
  end

  test "retrieving access token with authorization code server flow", context do
    Bypass.expect(context.bypass, fn conn ->
      assert conn.request_path == "/oauth/token"
      assert conn.method == "POST"

      {:ok, body_params, _} = Plug.Conn.read_body(conn)
      body = URI.decode_query(body_params)
      assert body["code"] == "test-auth-code"
      assert body["grant_type"] == "authorization_code"
      assert body["redirect_uri"] == @config[:redirect_uri]

      [client_id, client_secret] = basic_auth_credentials(conn)
      assert client_id == @config[:client_id]
      assert client_secret == @config[:client_secret]

      Plug.Conn.resp(conn, 200, response())
    end)

    assert response_token() == Battlenet.Auth.token("test-auth-code")
  end

  test "retrieving access token with client credential flow", context do
    Bypass.expect(context.bypass, fn conn ->
      assert conn.request_path == "/oauth/token"
      assert conn.method == "GET"

      Plug.Conn.resp(conn, 200, response())
    end)

    assert response_token() == Battlenet.Auth.token()
  end

  test "requesting access token with client credential flow more than once returns saved value",
       context do
    Bypass.expect(context.bypass, fn conn ->
      Plug.Conn.resp(conn, 200, response())
    end)

    Bypass.expect(context.bypass, "GET", "/oauth/check_token", fn conn ->
      Plug.Conn.resp(conn, 200, valid_token_response())
    end)

    token = Battlenet.Auth.token()

    assert token == Battlenet.Auth.token()
  end

  test "requesting a access token with a authentication code does not alter the saved client credential token",
       context do
    Bypass.expect(context.bypass, "POST", "/oauth/token", fn conn ->
      Plug.Conn.resp(
        conn,
        200,
        "{\"access_token\": \"test-token-from-code\", \"expires_in\": 2591999, \"token_type\": \"bearer\"}"
      )
    end)

    Bypass.expect(context.bypass, "GET", "/oauth/token", fn conn ->
      Plug.Conn.resp(conn, 200, response())
    end)

    Bypass.expect(context.bypass, "GET", "/oauth/check_token", fn conn ->
      Plug.Conn.resp(conn, 200, valid_token_response())
    end)

    client_cred_token = Battlenet.Auth.token()
    code_token = Battlenet.Auth.token("test-auth-code")

    refute client_cred_token == code_token
    assert client_cred_token == Battlenet.Auth.token()
  end

  test "retrieves a new token using client credentials if saved token is expired", context do
    the_past = DateTime.utc_now() |> DateTime.to_unix() |> (fn n -> n - 10 end).()
    {:ok, call_count} = Agent.start_link(fn -> 0 end)

    Bypass.expect(context.bypass, "GET", "/oauth/check_token", fn conn ->
      Agent.update(call_count, fn n -> n + 1 end)

      Plug.Conn.resp(
        conn,
        200,
        "{\"exp\": #{the_past}, \"client_id\": \"#{@config[:client_id]}\"}"
      )
    end)

    Bypass.expect(context.bypass, "GET", "/oauth/token", fn conn ->
      Plug.Conn.resp(conn, 200, response())
    end)

    # Calls to Battlenet API would not return an expired token in normal circumstances
    Battlenet.Auth.token()

    # Second call triggers token validation on existing token
    Battlenet.Auth.token()
    assert 1 == Agent.get(call_count, fn n -> n end)
  end

  defp basic_auth_credentials(conn) do
    {_header, authorization_body} =
      Enum.find(conn.req_headers, fn {header, _body} ->
        header == "authorization"
      end)

    ["Basic", base64_encoded_body] = String.split(authorization_body, " ")

    base64_encoded_body
    |> Base.decode64!()
    |> String.split(":")
  end

  defp query_param(url, param) do
    url
    |> Map.get(:query)
    |> URI.decode_query()
    |> Map.get(param)
  end

  defp response_token do
    "test-token"
  end

  defp response do
    "{\"access_token\": \"#{response_token()}\", \"token_type\": \"bearer\", \"expires_in\": 2591999}"
  end

  defp valid_token_response do
    "{\"exp\": #{DateTime.utc_now() |> DateTime.to_unix() |> (fn n -> n + 10 end).()}, \"client_id\": \"#{
      @config[:client_id]
    }\" }"
  end
end

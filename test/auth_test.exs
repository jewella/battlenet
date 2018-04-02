defmodule Battlenet.AuthTest do
  use ExUnit.Case

  @config Application.get_all_env(:battlenet)

  setup do
    bypass = Bypass.open
    Application.put_env(:battlenet, :site_url, "http://localhost:#{bypass.port}")
    context = %{bypass: bypass}
    {:ok, context}
  end

  test "authorize_url" do
    parsed_url = URI.parse(Battlenet.Auth.authorize_url)

    assert parsed_url.path == "/oauth/authorize"
    assert query_param(parsed_url, "client_id") == @config[:client_id]
    assert query_param(parsed_url, "redirect_uri") == @config[:redirect_uri]
    assert query_param(parsed_url, "response_type") == "code"
  end

  test "retrieving access token with authorization code server flow", context do
    Bypass.expect context.bypass, fn conn ->
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

      Plug.Conn.resp(conn, 200, "{\"access_token\": \"test-token\"}")
    end

    assert "test-token" == Battlenet.Auth.token("test-auth-code")
  end

  test "retrieving access token with client credential flow", context do
    Bypass.expect context.bypass, fn conn ->
      assert conn.request_path == "/oauth/token"
      assert conn.method == "GET"

      Plug.Conn.resp(conn, 200, "{\"access_token\": \"test-token\"}")
    end

    assert "test-token" == Battlenet.Auth.token()
  end

  defp basic_auth_credentials(conn) do
    {_header, authorization_body} = Enum.find(conn.req_headers, fn({header, _body}) ->
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
end

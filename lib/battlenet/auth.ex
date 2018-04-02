defmodule Battlenet.Auth do
  alias Battlenet.Config

  @doc """
  Request for access tokens that you can then use with other APIs
  """
  def token() do
    url = token_url() <> token_params()
    IO.puts url
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> Poison.decode!()
        |> Map.get("access_token")
    end
  end

  @doc """
  Used to turn in an authorization code for access tokens that you can then use
  with other APIs
  """
  def token(code) do
    req_body = {:form, token_params(code)}
    req_options = [hackney: [basic_auth: basic_auth_credentials()]]

    case HTTPoison.request(:post, token_url(), req_body, [], req_options) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> Poison.decode!()
        |> Map.get("access_token")
    end
  end

  @doc """
  Used to get player authorization for you to access certain resources of
  theirs, like a list of Diablo III characters.
  """
  def authorize_url do
    "#{Config.site_url}/oauth/authorize?#{authorize_params()}"
  end

  defp authorize_params do
    "client_id=#{Config.client_id}&redirect_uri=#{Config.redirect_uri}&response_type=code"
  end

  defp token_url, do: "#{Config.site_url}/oauth/token?"

  defp token_params do
    "grant_type=client_credentials&client_id=#{Config.client_id}&client_secret=#{Config.client_secret}"
  end

  defp token_params(code) do
    [code: code,
     grant_type: "authorization_code",
     redirect_uri: Config.redirect_uri]
  end

  defp basic_auth_credentials, do: {Config.client_id, Config.client_secret}

end

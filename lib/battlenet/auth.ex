defmodule Battlenet.Auth do
  use GenServer

  alias Battlenet.Config
  alias Battlenet.Auth.AccessToken

  @me __MODULE__

  # API

  def start_link(_) do
    GenServer.start_link(@me, nil, name: @me)
  end

  @doc """
  Request access token that you can then use with other APIs
  """
  def token() do
    GenServer.call(@me, :token)
  end

  @doc """
  Turn in an authorization code for access tokens that you can then use
  with other APIs
  """
  def token(code) do
    GenServer.call(@me, {:token, code})
  end

  @doc """
  Clears any stored access token obtained using client credentials
  """
  def clear_token do
    GenServer.cast(@me, :clear_token)
  end

  # Server Implementation

  def init(_) do
    {:ok, Battlenet.Auth.Stash.get_access_token()}
  end

  def handle_call(:token, _from, nil) do
    token = request_token_with()
    {:reply, token.access_token, token}
  end

  def handle_call(:token, _from, current_token) do
    case AccessToken.is_valid?(current_token) do
      true ->
        {:reply, current_token.access_token, current_token}

      false ->
        with token <- request_token_with() do
          {:reply, token.access_token, token}
        end
    end
  end

  def handle_call({:token, code}, _from, current_token) do
    token = request_token_with(code)
    {:reply, token.access_token, current_token}
  end

  def handle_cast(:clear_token, _current_token) do
    {:noreply, nil}
  end

  @doc """
  Used to get player authorization for you to access certain resources of
  theirs, like a list of Diablo III characters.
  """
  def authorize_url do
    "#{Config.site_url()}/oauth/authorize?#{authorize_params()}"
  end

  def terminate(_reason, access_token) do
    Battlenet.Auth.Stash.update_access_token(access_token)
  end

  defp authorize_params do
    "client_id=#{Config.client_id()}&redirect_uri=#{Config.redirect_uri()}&response_type=code"
  end

  defp token_url, do: "#{Config.site_url()}/oauth/token?"

  defp token_params do
    "grant_type=client_credentials&client_id=#{Config.client_id()}&client_secret=#{
      Config.client_secret()
    }"
  end

  defp token_params(code) do
    [code: code, grant_type: "authorization_code", redirect_uri: Config.redirect_uri()]
  end

  defp basic_auth_credentials, do: {Config.client_id(), Config.client_secret()}

  defp request_token_with do
    url = token_url() <> token_params()

    case HTTPoison.get!(url) do
      %HTTPoison.Response{body: body} ->
        body
        |> Poison.decode!(as: %AccessToken{})
    end
  end

  defp request_token_with(code) do
    req_body = {:form, token_params(code)}
    req_options = [hackney: [basic_auth: basic_auth_credentials()]]

    case HTTPoison.post!(token_url(), req_body, [], req_options) do
      %HTTPoison.Response{body: body} ->
        body
        |> Poison.decode!(as: %AccessToken{})
    end
  end
end

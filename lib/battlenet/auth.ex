defmodule Battlenet.Auth do
  @moduledoc """
  Provides functions for retrieving access tokens and authorizing
  OAuth clients using the Battlenet API.
  """
  use GenServer

  alias Battlenet.Config
  alias Battlenet.Auth.AccessToken

  @me __MODULE__

  # API

  @doc false
  def start_link(_) do
    GenServer.start_link(@me, nil, name: @me)
  end

  @doc """
  Request access token that you can then use with other APIs. The token
  is validated on each successive token request. The token is saved in a
  separate process on process failure and fetched on re-initialization.
  If a token is expired, or was created by a different client id, a new
  token is fetched.

  ## Example

      Battlenet.Auth.token()
      "zevtpr9bt65g8dt4berkyp99"
  """
  def token do
    GenServer.call(@me, :token)
  end

  @doc """
  Turn in an authorization code for access tokens that you can then use
  with other APIs.  This token is not persisted, and a new token will be
  fetched on each call.

  ## Parameters

    - code: Authorization code that represents the user's agreement to
    allow you data based on the scope.

  ## Example

      Battlenet.Auth.token("123abc")
      zevtpr9bt65g8dt4berkyp99"      
  """
  def token(code) do
    GenServer.call(@me, {:token, code})
  end

  @doc """
  Clears any stored access token obtained using client credentials.

  ## Example

      Battlenet.Auth.token()
      "zevtpr9bt65g8dt4berkyp99"
      Battlenet.Auth.clear_token()
      :ok
      Battlenet.Auth.token()
      "eaf7dqe6t93sbfzh93v89kyr"

  """
  def clear_token do
    GenServer.cast(@me, :clear_token)
  end

  @doc """
  Used to get player authorization for you to access certain resources of
  theirs, like a list of World of Warcraft characters. For an authorization
  code request, you need to either redirect the browser or open a new window
  to this url.

  ## Example

      Battlenet.Auth.authorize_url()
      "https://US.battle.net/oauth/authorize?client_id=1234abcde
      &redirect_uri=https://localhost.test/auth/callback&response_type=code"
  """
  def authorize_url do
    "#{Config.site_url()}/oauth/authorize?#{authorize_params()}"
  end

  # Server Implementation

  @doc false
  def init(_) do
    {:ok, Battlenet.Auth.Stash.get_access_token()}
  end

  @doc false
  def handle_call(:token, _from, nil) do
    token = request_token_with()
    {:reply, token.access_token, token}
  end

  @doc false
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

  @doc false
  def handle_call({:token, code}, _from, current_token) do
    token = request_token_with(code)
    {:reply, token.access_token, current_token}
  end

  @doc false
  def handle_cast(:clear_token, _current_token) do
    {:noreply, nil}
  end

  @doc false
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

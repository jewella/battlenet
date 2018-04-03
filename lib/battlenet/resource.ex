defmodule Battlenet.Resource do
  alias Battlenet.Auth
  alias Battlenet.Config

  def get(path) do
    get_with_token(path, Auth.token())
  end

  def get_with_token(path, cast) when is_map(cast) do
    get_with_token(path, Auth.token(), cast)
  end

  def get_with_token(path, access_token) when is_binary(access_token) do
    case HTTPoison.get(resource_url(path, access_token)) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> Poison.decode!()
    end
  end

  def get_with_token(path, access_token, cast) do
    case HTTPoison.get(resource_url(path, access_token)) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> Poison.decode!(as: cast)
    end
  end

  def get_with_api_key(path) do
    case HTTPoison.get(apikey_resource_url(path)) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> Poison.decode!()
    end
  end

  def get_with_api_key(path, cast) do
    case HTTPoison.get(apikey_resource_url(path)) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> Poison.decode!(as: cast)
    end
  end

  defp resource_url(path, access_token) do
    "#{Config.api_site_url()}/#{path}?access_token=#{access_token}"
  end

  defp apikey_resource_url(path) do
    "#{Config.api_site_url()}/#{path}?locale=#{Config.locale()}&apikey=#{Config.client_id()}"
  end
end

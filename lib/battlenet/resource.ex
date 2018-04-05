defmodule Battlenet.Resource do
  @moduledoc """
  Provides generic functions for interacting with the Battlenet
  REST API
  """
  alias Battlenet.Auth
  alias Battlenet.Config

  @doc """
  Retrieve information for the provided path using a
  fetched and stored access token

  ## Parameters

    - path: the url path for the desired resource.

  ## Example

      Battlenet.Resource.get("data/d3/season/")
      {:ok,
      %{
        "_links" => %{
          "self" => %{
            "href" => "https://us.api.battle.net/data/d3/season/?namespace=2-6-US"
          }
        },
        "current_season" => 13,
      ...
  """
  def get(path) do
    get_with_token(path, Auth.token())
  end

  @doc """
  Retrieve information for the provided path and cast
  into provided map/struct using a fetched and stored
  access token.

  ## Parameters

    - path: the url path for the desired resource
    - cast: a map or struct to cast the response as
  """
  def get(path, cast) when is_map(cast) do
    get_with_token(path, Auth.token(), cast)
  end

  @doc """
  Retrieve information for the provided path using
  the provided access token

  ## Parameters

    - path: the url path for the desired resource
    - access_token: the access token string to use
  """
  def get_with_token(path, access_token) when is_binary(access_token) do
    get_with_token(path, access_token, %{})
  end

  def get_with_token(path, %Battlenet.Auth.AccessToken{access_token: access_token}) do
    get_with_token(path, access_token, %{})
  end

  @doc """
  Retrieve information for the provided path using the
  provided access token into provided map/struct.

  ## Parameters

    - path: the url path for the desired resource
    - access_token: the access token or acces token string string to use
    - cast: a map or struct to cast the response as
  """
  def get_with_token(path, %Battlenet.Auth.AccessToken{access_token: access_token}, cast) do
    get_with_token(path, access_token, cast)
  end

  def get_with_token(path, access_token, cast) when is_binary(access_token) do
    path
    |> resource_url(access_token)
    |> fetch(cast)
  end

  @doc """
  Retrieve information for the provided path using
  an api key.

  ## Parameters

    - path: the url path for the desired resource
  """
  def get_with_api_key(path) do
    path
    |> apikey_resource_url()
    |> fetch()
  end

  @doc """
  Retrieve information for the provided path using
  an api and casting into the provided map/struct

  ## Parameters

    - path: the url path for the desired resource
    - cast: a map or struct to cast the response as
  """
  def get_with_api_key(path, cast) do
    path
    |> apikey_resource_url()
    |> fetch(cast)
  end

  defp resource_url(path, access_token) do
    "#{Config.api_site_url()}/#{path}?access_token=#{access_token}"
  end

  defp apikey_resource_url(path) do
    "#{Config.api_site_url()}/#{path}?locale=#{Config.locale()}&apikey=#{Config.client_id()}"
  end

  defp fetch(url, cast \\ %{}) do
    case HTTPoison.get(url, [], [ ssl: [{:versions, [:'tlsv1.2']}] ]) do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
        resource =
          body
          |> Poison.decode!(as: cast)

        {:ok, resource}

      {:ok, %HTTPoison.Response{body: body, status_code: 404}} ->
        reason =
          body
          |> Poison.decode!()
          |> Map.get(:reason, "The requested data could not be found.")

        {:error,  reason}

      {:ok, %HTTPoison.Response{body: body }} ->
        reason =
          body
          |> Poison.decode!()
          |> Map.get(:reason, "Battlenet service did not return a successful response.")

        {:error,  reason}

      {:error, reason} ->
        {:error, reason}
    end
  end
end

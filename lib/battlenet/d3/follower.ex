defmodule Battlenet.D3.Follower do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 followers.
  """
  alias Battlenet.Resource
  
  @doc """
  Get a single follower by slug

  ## Parameters

    - slug: slug that represents the desired follower

  ## Example

      iex> Battlenet.D3.Follower.get("templar")
      %{
        "name" => "Templar",
        "portrait" => "templar",
        "realName" => "Kormac",
        "skills" => [
      ...
  """
  def get(slug) do
    Resource.get_with_api_key("d3/data/follower/#{slug}")
  end
end
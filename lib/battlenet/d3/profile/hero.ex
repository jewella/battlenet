defmodule Battlenet.D3.Profile.Hero do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 heros
  """
  alias Battlenet.Resource

  @doc """
  Get a single hero

  ## Parameters

    - battle_tag: the Battle Tag for the account.
    - hero_id: the id of the hero

  ## Example

      iex> Battlenet.D3.Profile.Hero.get("Example#123", 123123)
      %{
        "alive" => true,
        "class" => "wizard",
        "followers" => %{
      ...
  """
  def get(battle_tag, hero_id) do
    Resource.get_with_api_key("d3/profile/#{battle_tag}/hero/#{hero_id}")
  end
end
defmodule Battlenet.D3.Profile.Hero.FollowerItems do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 hero followers items
  """
  alias Battlenet.Resource

  @doc """
  Get a list of items for the specified hero's followers

  ## Parameters

    - battle_tag: the Battle Tag for the account.
    - hero_id: the id of the hero

  ## Examples

      iex> Battlenet.D3.Profile.Hero.FollowerItems.get("Example#123", 12341234)
      %{
        "enchantress" => %{
          "mainHand" => %{
            "accountBound" => false,
            "armor" => 0.0,
      ...
  """
  def get(battle_tag, hero_id) do
    Resource.get_with_api_key("d3/profile/#{battle_tag}/hero/#{hero_id}/follower-items")
  end
end
defmodule Battlenet.D3.Profile.Hero.Items do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 hero items.
  """
  alias Battlenet.Resource

  @doc """
  Get a list of items for the specified hero

  ## Parameters

    - battle_tag: the Battle Tag for the account.
    - hero_id: the id of the hero

  ## Example

      Battlenet.D3.Profile.Hero.Items.get("Example#123", 12341234)
      {:ok,
      %{
        "bracers" => %{
          "accountBound" => true,
          "armor" => 379.66666,
          "attacksPerSecond" => 0.0,
          "attributes" => %{
  """
  def get(battle_tag, hero_id) do
    Resource.get_with_api_key("d3/profile/#{battle_tag}/hero/#{hero_id}/items")
  end
end
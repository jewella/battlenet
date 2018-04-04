defmodule Battlenet.D3.ItemType do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 item types.
  """
  alias Battlenet.Resource

  @doc """
  Get a single item type by slug

  ## Parameters

    - slug: slug that represents the desired item type.

  ## Example

      Battlenet.D3.ItemType.get("sword2h")
      {:ok,
      [
        %{
          "icon" => "sword_2h_101_demonhunter_male",
          "id" => "Sword_2H_101",
          "name" => "Great Sword",
          "path" => "item/great-sword-Sword_2H_101",
          "slug" => "great-sword"
        },
      ...
  """
  def get(slug) do
    Resource.get_with_api_key("d3/data/item-type/#{slug}")
  end

  @doc """
  Get an index of item types

  ## Example

      Battlenet.D3.ItemType.index()
      {:ok,
      [
        %{
          "id" => "Shoulders_Barbarian",
          "name" => "Shoulders",
          "path" => "item-type/shouldersbarbarian"
        },
      ...
  """
  def index() do
    Resource.get_with_api_key("d3/data/item-type/")
  end
end
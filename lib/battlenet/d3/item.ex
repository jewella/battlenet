defmodule Battlenet.D3.Item do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 items.
  """
  alias Battlenet.Resource

  @doc """
  Get a single item by item slug and ID

  ## Parameters

    - item_name: Name of the item
    - item_id: Id of the item

  ## Examples

      iex> Battlenet.D3.Item.get("corrupted-ashbringer", "Unique_Sword_2H_104_x1")
      %{
        "accountBound" => true,
        "attributes" => %{
          "other" => [],
          "primary" => [
      ...
  """
  def get(item_name, item_id) do
    Resource.get_with_api_key("d3/data/item/#{item_name <> "-" <> item_id}")
  end
end
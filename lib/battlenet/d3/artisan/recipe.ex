defmodule Battlenet.D3.Artisan.Recipe do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 artisan recipes.
  """
  alias Battlenet.Resource

  @doc """
  Get a single recipe by slug for the specified artisan

  ## Parameters

    - artisan_slug: the slug of the artisan
    - recipe_slug: the slug of the recipe

  ## Example

      iex> Battlenet.D3.Artisan.Recipe.get("blacksmith", "apprentice-flamberge")
      %{
        "cost" => 1000,
        "id" => "Sword_2H_003",
        "itemProduced" => %{ 
      ...
  """
  def get(artisan_slug, recipe_slug) do
    Resource.get_with_api_key("d3/data/artisan/#{artisan_slug}/recipe/#{recipe_slug}")
  end
end
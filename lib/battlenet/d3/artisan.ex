defmodule Battlenet.D3.Artisan do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 artisans.
  """
  alias Battlenet.Resource

  @doc """
  Get a single artisan by slug

  ## Parameters
  
    - slug: The slug that corresponds to the desired artisan

  ## Examples

      Battlenet.D3.Artisan.get("blacksmith")
      {:ok,
      %{
        "slug" => "blacksmith",
        "name" => "Blacksmith",
        "portrait" => "pt_blacksmith",
        "training" => %{
      ...
  """
  def get(slug) do
    Resource.get_with_api_key("/d3/data/artisan/#{slug}")
  end
end
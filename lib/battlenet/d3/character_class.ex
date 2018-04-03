defmodule Battlenet.D3.CharacterClass do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3
  character classes.
  """
  alias Battlenet.Resource

  @doc """
  Get a single character class by slug

  ## Parameters

    - slug: slug that corresponds to the desired class

  ## Example

      iex> Battlenet.D3.CharacterClass.get("wizard")
      %{
        "femaleName" => "Wizard",
        "icon" => "wizard_female",
        "maleName" => "Wizard",
        "name" => "Wizard",
        "skillCategories" => [
      ...
  """
  def get(slug) do
    Resource.get_with_api_key("d3/data/hero/#{slug}")
  end
end
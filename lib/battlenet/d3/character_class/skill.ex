defmodule Battlenet.D3.CharacterClass.Skill do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 class skills
  """
  alias Battlenet.Resource

  @doc """
  Get a single skill by slug, for a specific character class

  ## Parameters

    - class_slug: the slug of the character class
    - skill_slug: the slug of the skill

  ## Example

      Battlenet.D3.CharacterClass.Skill.get("wizard", "audacity")
      {:ok,
      %{
        "skill" => %{
          "description" => "You deal 30% additional damage to enemies within 15 yards.",
      ...
  """
  def get(class_slug, skill_slug) do
    Resource.get_with_api_key("d3/data/hero/#{class_slug}/skill/#{skill_slug}")
  end
end

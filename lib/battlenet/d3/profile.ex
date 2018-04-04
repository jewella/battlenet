defmodule Battlenet.D3.Profile do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 profiles.
  """
  alias Battlenet.Resource

  @doc """
  Get a single profile
  
  ## Parameters

    - battle_tag: the Battle Tag for the account.

  ## Examples

      Battlenet.D3.Profile.get("Example#1234")
      {:ok,
      %{
        "battleTag" => "Example#1234",
        "blacksmith" => %{"level" => 12, "slug" => "blacksmith"},
        "blacksmithHardcore" => %{"level" => 0, "slug" => "blacksmith"},
        "blacksmithSeason" => %{"level" => 12, "slug" => "blacksmith"},
      ...
  """
  def get(battle_tag) do
    Resource.get_with_api_key("d3/profile/#{battle_tag}/")
  end
end
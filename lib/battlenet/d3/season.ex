defmodule Battlenet.D3.Season do
  @moduledoc """
  Provides functions for retreiving information about Diablo 3 Seasons
  """
  alias Battlenet.Resource

  @doc """
  Returns a leaderboard list for a particular season

  ## Parameters

    - id: The season to lookup

  ## Example

      iex> Battlenet.D3.Season.get(13)
      %{
        "_links" => %{
          "self" => %{
            "href" => "https://us.api.battle.net/data/d3/season/13?namespace=2-6-US"
          }
        },
        "generated_by" => "LAX1A-D3-PURPLE-JOB001-01 2.6.1 branches/2_6_1a_Hotfix-branches/2_6_1a_Hotfix",
        "last_update_time" => "Tue, 03 Apr 2018 01:46:00 UTC",
        "leaderboard" => [    
      ...
  """
  def get(id) do
    Resource.get("data/d3/season/#{id}")
  end

  @doc """
  Returns base information about available seasons

  ## Example

      iex> Battlenet.D3.Season.index()
      %{
        "_links" => %{
          "self" => %{
            "href" => "https://us.api.battle.net/data/d3/season/?namespace=2-6-US"
          }
        },
        "current_season" => 13,
        "generated_by" => "LAX1A-D3-PURPLE-JOB001-01 2.6.1 branches/2_6_1a_Hotfix-branches/2_6_1a_Hotfix",
        "last_update_time" => "Tue, 03 Apr 2018 01:47:00 UTC",
        "season" => [
      ...
  """
  def index() do
    Resource.get("data/d3/season/")
  end
end

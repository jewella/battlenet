defmodule Battlenet.D3.Era.Leaderboard do
  @moduledoc """
  Provides functions for retriving information about Diablo 3 era leaderboards.  
  """
  alias Battlenet.Resource

  @doc """
  Returns a leaderboard

  ## Parameters

    - era_id: the era to lookup
    - leaderboard: the leaderboard to lookup, you can find these strings in the Era API call 

  ## Example

      Battlenet.D3.Era.Leaderboard.get(10, "rift-wizard")
      {:ok,
      %{
        "_links" => %{
            "self" => %{
                "href" => "https://us.api.battle.net/data/d3/era/10/leaderboard/rift-wizard?namespace=2-6-US"
            }
        },
        "row" => [%{
      ...
  """
  def get(era_id, leaderboard) do
    Resource.get("/data/d3/era/#{era_id}/leaderboard/#{leaderboard}")
  end
end

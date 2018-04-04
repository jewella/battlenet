defmodule Battlenet.D3.Season.Leaderboard do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 season leaderboards.
  """
  alias Battlenet.Resource

  @doc """
  Returns a leaderboard

  ## Parameters

    - season_id: the season to lookup
    - leaderboard: the leaderboard to lookup, you can find these strings in the Season API call

  ## Examples

      Battlenet.D3.Season.Leaderboard.get(13, "rift-wizard")
      {:ok,
      %{
          "_links" => %{
              "self" => %{
                  "href" => "https://us.api.battle.net/data/d3/season/13/leaderboard/rift-wizard?namespace=2-6-US"
              }
          },
          "row" => [%{
              "player" => [%{
      ...
  """
  def get(season_id, leaderboard) do
    Resource.get "data/d3/season/#{season_id}/leaderboard/#{leaderboard}"
  end
end

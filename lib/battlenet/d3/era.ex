defmodule Battlenet.D3.Era do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 eras
  and era leaderboards.
  """
  alias Battlenet.Resource

  @doc """
  Returns a leaderboard list for a particular era

  ## Parameter

    - id: id of the desired era

  ## Example
  
      Battlenet.D3.Era.get(10)
      {:ok,
      %{
        "_links" => %{
          "self" => %{
            "href" => "https://us.api.battle.net/data/d3/era/10?namespace=2-6-US"
          }
        },
        "era_id" => 10,
        "era_start_date" => 1519434000,
        "generated_by" => "LAX1A-D3-PURPLE-JOB001-01 2.6.1 branches/2_6_1a_Hotfix-branches/2_6_1a_Hotfix",
        "last_update_time" => "Tue, 03 Apr 2018 01:12:00 UTC",
        "leaderboard" => [
      ...
  """
  def get(id) do
    Resource.get("/data/d3/era/#{id}")
  end

  @doc """
  Returns base information about available eras

  ## Example

      Battlenet.D3.Era.index()
      {:ok,
      %{
        "_links" => %{
          "self" => %{
            "href" => "https://us.api.battle.net/data/d3/era/?namespace=2-6-US"
          }
        },
        "current_era" => 10,
        "era" => [
      ...
  """
  def index() do
    Resource.get("/data/d3/era/")
  end
end

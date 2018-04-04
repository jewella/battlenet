defmodule Battlenet.D3.Act do
  @moduledoc """
  Provides functions for retrieving information about Diablo 3 acts.
  """

  alias Battlenet.Resource


  @doc """
  Get a single act by slug

  ## Parameters
  
  - slug: The slug that corresponds to the desired act.
  
  ## Examples
  
      Battlenet.D3.Act.get("act-ii")
      {:ok,
      %{
        "name" => "Act II",
        "number" => 2,
        ...

      Battlenet.D3.Act.get("act-i")
      {:ok,
      %{
        "name" => "Act I",
        "number" => 1,
        ...
  """
  def get(slug) do
    Resource.get_with_api_key("d3/data/act/#{slug}")
  end

  @doc """
  Get an index of acts

  ## Examples

      Battlnet.D3.Act.index()
      {:ok,
      %{
        "acts" => [
          %{
            "name" => "Act I",
            "number" => 1,
      ...
  """
  def index() do
    Resource.get_with_api_key("d3/data/act/")
  end
end
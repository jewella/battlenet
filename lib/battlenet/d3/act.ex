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
  
      iex> Battlenet.D3.Act.get("act-ii")
      %{
        "name" => "Act II",
        "number" => 2,
        ...

      iex> Battlenet.D3.Act.get("act-i")
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

      iex> Battlnet.D3.Act.index()
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
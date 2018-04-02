defmodule Battlenet.User do
  defstruct id: nil, battletag: nil

  alias Battlenet.Config

  def with_token(access_token) do
    case HTTPoison.get(Config.resource_url("account/user", access_token)) do
      {:ok, %HTTPoison.Response{body: body}} ->
        body
        |> Poison.decode!(as: %Battlenet.User{})
    end
  end
end

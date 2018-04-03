defmodule Battlenet.User do
  defstruct id: nil, battletag: nil

  alias Battlenet.Resource

  def with_token(access_token) do
    Resource.get_with_token("account/user", access_token, %Battlenet.User{})
  end
end

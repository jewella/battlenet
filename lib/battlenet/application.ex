defmodule Battlenet.Application do
  @moduledoc false

  use Application

  def start(_type, _) do
    children = [
      {Battlenet.Auth.Stash, nil},
      {Battlenet.Auth, nil}
    ]

    opts = [strategy: :rest_for_one, name: Battlenet.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule Battlenet.Mixfile do
  use Mix.Project

  @description """
  Elixir library for the Battle.net API.
  """

  def project do
    [
      app: :battlenet,
      version: "0.0.3",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: @description,
      aliases: [test: "test --no-start"],
      package: package(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      mod: {
        Battlenet.Application, []
      },
      registered: [
        Battlenet.Auth
      ],
      extra_applications: [:logger, :httpoison]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:httpoison, "~> 1.0.0"},
      {:poison, "~> 3.1"},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.18.3", only: :dev},
      {:bypass, "~> 0.8", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Daniel Grieve"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/danielgrieve/battlenet"}
    ]
  end
end

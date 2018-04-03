defmodule Battlenet.Auth.AccessToken do
  @moduledoc """
  Provides model for access token and functions for
  verifying that the token is valid.
  """
  @derive [Poison.Encoder]

  alias Battlenet.Config

  defstruct [:access_token, :token_type, :expires_in]

  @doc """
  Validates the access token string or struct

  ## Parameters
    
    - access_token: the access token string or struct to be validated

  ## Examples

      iex(1)> token = Battlenet.Auth.token()
      "zu5pu7ss3575nxe7zm4vupup"
      iex(2)> Battlenet.Auth.AccessToken.is_valid?(token)
      true
      iex(3)> token_struct = %Battlenet.Auth.AccessToken{ access_token: token }
      %Battlenet.Auth.AccessToken{
        access_token: "u5pu7ss3575nxe7zm4vupup",
        expires_in: nil,
        token_type: nil
      }
      iex(4)> Battlenet.Auth.AccessToken.is_valid?(token_struct)
      true
  """
  def is_valid?(access_token) when is_binary(access_token) do
    is_valid?(%Battlenet.Auth.AccessToken{access_token: access_token})
  end

  def is_valid?(%Battlenet.Auth.AccessToken{access_token: nil}) do
    false
  end

  def is_valid?(%Battlenet.Auth.AccessToken{access_token: access_token}) do
    case HTTPoison.get!(check_token_url(access_token)) do
      %HTTPoison.Response{body: body} ->
        body
        |> Poison.decode!()
        |> validate
    end
  end

  defp check_token_url(token) do
    "#{Config.site_url()}/oauth/check_token?token=#{token}"
  end

  defp validate(%{"exp" => exp, "client_id" => client_id}) do
    is_expiration_in_future?(exp) && was_issued_by_this_client?(client_id)
  end

  defp is_expiration_in_future?(time) do
    now =
      DateTime.utc_now()
      |> DateTime.to_unix()

    time > now
  end

  defp was_issued_by_this_client?(client_id) do
    client_id == Config.client_id()
  end
end

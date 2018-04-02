defmodule Battlenet.Auth.AccessToken do
  @derive [Poison.Encoder]

  alias Battlenet.Config

  defstruct [:access_token, :token_type, :expires_in]

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

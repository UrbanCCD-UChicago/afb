defmodule Afb.Auth.Guardian do
  use Guardian, otp_app: :afb

  alias Afb.Auth.User

  def subject_for_token(user, _claims), do: {:ok, user.id}

  def resource_from_claims(claims) do
    case User.get(claims["sub"]) do
      nil -> {:error, "Anonymous"}
      user -> {:ok, user}
    end
  end
end

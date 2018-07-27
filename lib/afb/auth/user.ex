defmodule Afb.Auth.User do
  use Ecto.Schema

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
  end

  import Ecto.Changeset

  @email_regex ~r/.+@.+\..+/

  def changeset(user, params) do
    user
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> unique_constraint(:email)
    |> validate_format(:email, @email_regex)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: plaintext}} = changeset) do
    hashed = Comeonin.Bcrypt.hashpwsalt(plaintext)
    put_change(changeset, :password_hash, hashed)
  end
  defp hash_password(changeset), do: changeset

  alias Afb.Repo

  alias Afb.Auth.User

  def get(id) when is_integer(id), do: Repo.get(User, id)
  def get(identifier) do
    case Regex.match?(~r/^\d+$/, identifier) do
      false -> Repo.get_by(User, email: identifier)
      true -> Repo.get_by(User, id: identifier)
    end
  end

  def create(email, password) do
    changeset(%User{}, %{email: email, password: password})
    |> Repo.insert()
  end

  def change_password(user, new_password) do
    changeset(user, %{password: new_password})
    |> Repo.update()
  end

  @auth_msg "Incorrect email or password."

  def authenticate(nil, _), do: {:error, @auth_msg}
  def authenticate(user, password) do
    case Comeonin.Bcrypt.checkpw(password, user.password_hash) do
      true -> {:ok, user}
      false -> {:error, @auth_msg}
    end
  end
end

defmodule Jinbookroo.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
    |> put_password_hash()
  end


  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    changeset
    |> change(%{password_hash: Argon2.hash_pwd_salt(password), password: nil})
  end

  defp put_password_hash(changeset), do: changeset
end

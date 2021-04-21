defmodule JinbookrooWeb.Auth.Guardian do
  use Guardian, otp_app: :jinbookroo
  alias Jinbookroo.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    user = Accounts.get_user!(id)
    {:ok,  user}
  end

  def authenticate(email, password) do
    try do
      user = Accounts.get_user_by_email!(email)

      case validate_password(password, user.password_hash) do
        true -> create_token(user)
        false -> {:error, :unauthorized}
      end
    rescue
      Ecto.NoResultsError -> {:error, :unauthorized}
    end
  end

  defp validate_password(password, password_hash) do
    Argon2.verify_pass(password, password_hash)
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user)
    {:ok, user, token}
  end
end

defmodule InverseAuth.Method.JWT do
  def verify(token) do
    jwt_secret = Application.get_env(:inverse_auth, :jwt_secret)

    joken =
      token
      |> Joken.token()
      |> Joken.with_signer(Joken.hs512(jwt_secret))
      |> Joken.verify()

    case joken.error do
      nil -> {:ok, {joken.header, joken.claims}}
      _   -> {:error, joken.error}
    end
  end
end

defmodule InverseAuth.JWT do
  import Joken, except: [verify: 1]

  def verify(token) do
    jwt_secret = Application.get_env(:inverse_auth, :jwt_secret)

    joken =
      token
      |> token
      |> with_signer(hs512(jwt_secret))
      |> Joken.verify

    case joken.error do
      nil -> {:ok, {joken.header, joken.claims}}
      _   -> {:error, joken.error}
    end
  end
end

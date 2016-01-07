defmodule JWT do
  import Joken, except: [verify: 1]

  @jwt_secret Application.get_env(:plug_auth, :jwt_secret)

  def verify(candidate) do
    joken =
      candidate
      |> token
      |> with_signer(hs512(@jwt_secret))
      |> Joken.verify

    case joken.error do
      nil -> {:ok, {joken.header, joken.claims}}
      _   -> {:error, joken.error}
    end
  end
end

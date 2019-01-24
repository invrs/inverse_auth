defmodule InverseAuth.JWT do

  import Joken.Config

  def verify(token) do
    secret = Application.get_env(:inverse_auth, :jwt_secret)
    signer = Joken.Signer.create("HS512", secret)
    Joken.verify(token, signer)
  end
end

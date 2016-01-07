defmodule PlugAuth.Auth do
  use Behaviour

  @type reason :: atom | binary

  defcallback authenticate(Plug.Conn.t) :: {:ok, Plug.Conn.t} | {:error, reason}
end

defmodule InverseAuth.Auth do
  @type reason :: atom | binary

  @callback authenticate(Plug.Conn.t) :: {:ok, Plug.Conn.t} | {:error, reason}
end

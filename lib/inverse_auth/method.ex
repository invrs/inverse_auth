defmodule InverseAuth.Method do

  @doc """
  Verifies a token in exchange for a tuple containing header metadata and claims
  """
  @callback verify(token :: String.t) :: {:ok, Tuple.t} | {:error, String.t}
end

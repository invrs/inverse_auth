defmodule InverseAuth.Plug do
  import Plug.Conn

  @behaviour Plug
  @methods   ~w(POST PUT PATCH DELETE)

  def init(opts), do: opts

  def call(conn = %{method: method}, config) when method in @methods do
    param = Keyword.fetch! config, :param
    auth  = Keyword.fetch! config, :auth

    IO.inspect conn

    IO.puts "CHECKING AUTH PARAM #{inspect param} WITH AUTH #{inspect auth}"
    result =
      with {:ok, token}      <- Map.fetch(conn.params, param) |> IO.inspect(),
           {:ok, {_, user}}  <- InverseAuth.JWT.verify(token) |> IO.inspect(),
           conn              <- assign(conn, :user, user),
           {:ok, conn}       <- auth.authenticate(conn) |> IO.inspect(),
      do:  {:ok, conn}

    case result do
      {:ok, conn} ->
        conn

      :error ->
        conn
        |> send_resp(:unauthorized, "")
        |> halt()

      {:error, reason} ->
        conn
        |> send_resp(:unauthorized, to_string(reason))
        |> halt()
    end
  end
  def call(conn, _config), do: conn
end

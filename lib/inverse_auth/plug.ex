defmodule InverseAuth.Plug do
  import Plug.Conn

  @behaviour Plug
  @methods   ~w(POST PUT PATCH DELETE)

  def init(opts), do: opts

  def call(conn = %{method: method}, config) when method in @methods do
    param = Keyword.fetch! config, :param
    auth  = Keyword.fetch! config, :auth

    result =
      with {:ok, token}      <- fetch_token(conn, param),
           {:ok, {_, user}}  <- InverseAuth.JWT.verify(token),
           conn              <- assign(conn, :user, user),
           {:ok, conn}       <- auth.authenticate(conn),
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

  defp fetch_token(conn, param) do
    if (token = Map.get(conn.params, param) || fetch_from_cookies(conn, param)),
      do: {:ok, token}, else: :error
  end

  defp fetch_from_cookies(conn, param) do
    case conn |> fetch_cookies do
      %{cookies: %{^param => token}} -> token
      _                              -> nil
    end
  end
end

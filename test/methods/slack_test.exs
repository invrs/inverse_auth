defmodule InverseAuth.Method.SlackTest do
  use ExUnit.Case
  alias InverseAuth.Method.Slack

  setup do
    bypass     = Bypass.open()
    url        = "http://localhost:#{bypass.port}"
    config     = Application.get_env :inverse_auth, Slack
    new_config = Keyword.merge config, [slack_endpoint: url]

    Application.put_env :inverse_auth, Slack, new_config

    on_exit fn ->
      Application.put_env :inverse_auth, Slack, config

      :ok
    end

    {:ok, bypass: bypass}
  end

  test "authenticates a user given a token", %{bypass: bypass} do
    Bypass.expect bypass, &handle/1

    token  = "fake-token"
    output = Slack.verify(token)

    assert {:ok, {_, user}} = output

    assert user["id"]   == "U0G9QF9C6"
    assert user["name"] == "Sonny Whether"
  end

  # Handle Slack request
  defp handle(conn) do
    assert conn.method       == "GET"
    assert conn.request_path == "/api/users.identity"

    json =
      [ __DIR__ | ~w( .. support fixtures users.identity.json) ]
      |> Path.join()
      |> File.read!()

    Plug.Conn.resp conn, 200, json
  end
end

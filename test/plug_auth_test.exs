defmodule InverseAuthTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @param "my-token"
  @token "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjoiMTIzLXRlc3QifQ.jPUatqZfWkdKTHSvcGSjAmERAXmqj8wUM1OVfSBQAznQxsZxLxZ9nk60TgEI8BDNvIDIlG0i4Dqe-E5a8AJBbg"

  test "401s requests without authorization parameters" do
    opts = InverseAuth.Plug.init([auth: TestAuth, param: @param])
    conn =
      :post
      |> conn("/")
      |> InverseAuth.Plug.call(opts)

    assert conn.status == 401
    assert conn.halted
  end

  test "401s requests with invalid authorization parameters" do
    opts = InverseAuth.Plug.init([auth: TestAuth, param: @param])
    conn =
      :post
      |> conn("/")
      |> put_req_cookie(@param, "blah")
      |> InverseAuth.Plug.call(opts)

    assert conn.status == 401
    assert conn.halted
  end

  test "supports cookie-based auth" do
    Application.put_env(:inverse_auth, :jwt_secret, "fssecret")
    opts = InverseAuth.Plug.init([auth: TestAuth, param: @param])
    conn =
      :post
      |> conn("/")
      |> put_req_cookie(@param, @token)
      |> InverseAuth.Plug.call(opts)

    assert is_nil(conn.status)
    refute conn.halted
  end
end

defmodule TestAuth do
  def authenticate(conn), do: {:ok, conn}
end

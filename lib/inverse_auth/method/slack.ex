defmodule InverseAuth.Method.Slack do

  use HTTPoison.Base
  require Logger

  def verify(token) do
    case fetch_user(token) do
      {:ok, user, headers} ->
        {:ok, {headers, user}}

      other ->
        other
    end
  end

  def fetch_user(token) do
    response = get config(:identity_endpoint), [], query: [token: token]

    with {:ok, %{body: body}}       <- response,
         {:ok, %{headers: headers}} <- response,
         {:ok, true}                <- Map.fetch(body, "ok"),
         team_id                     = config(:team_id),
         {:ok, %{"id" => ^team_id}} <- Map.fetch(body, "team")
     do
       {:ok, body["user"], headers}
     else
       _ ->
         {:error, :fetch_error}
     end
  end

  def process_url(path) do
    config(:slack_endpoint) <> path
  end
  defp process_response_body(body), do: Poison.decode!(body)

  defp config(key), do: Application.get_env(:inverse_auth, __MODULE__)[key]
end

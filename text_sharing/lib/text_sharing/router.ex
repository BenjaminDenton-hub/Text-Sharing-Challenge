defmodule TextSharing.Router do
  use Plug.Router

  plug(:match)
  plug(Plug.Parsers, parsers: [:urlencoded], pass: ["text/*"])
  plug(:dispatch)

  @template_dir "lib/text_sharing/views"

  get "/" do
    render(conn, "home.html")
  end

  post "/share" do
    text = conn.body_params["shared_text"]
    share_url = TextSharing.new_share(text)

    conn
    |> put_status(201)
    |> render("share.html", share_url: share_url, new_shared_text: text)
  end

  get "/:text_id/details" do
    %{current_text: current_text, created: created, revision_history: revision_history} =
      TextSharing.get_text(text_id)

    string_revision_history =
      Map.keys(revision_history)
      |> Enum.map(fn key -> "<br>#{key}: {#{map_crap(revision_history[key])}}" end)
      |> Enum.join(",<br>")

    render(conn, "details.html",
      current_text: current_text,
      created: DateTime.to_string(created),
      revision_history: string_revision_history
    )
  end

  get "/:text_id" do
    %{current_text: new_text, revision_history: _, created: _} = TextSharing.get_text(text_id)
    render(conn, "text.html", text_id: text_id, new_shared_text: new_text)
  end

  post "/:text_id" do
    new_text = conn.body_params["shared_text"]
    TextSharing.update_text(text_id, new_text)
    render(conn, "text.html", text_id: text_id, new_shared_text: new_text)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end

  defp render(%{status: status} = conn, template, assigns \\ []) do
    body =
      @template_dir
      |> Path.join(template)
      |> String.replace_suffix(".html", ".html.eex")
      |> EEx.eval_file(assigns)

    send_resp(conn, status || 200, body)
  end

  defp map_crap(map) do
    Map.keys(map)
      |> Enum.map(fn key -> "#{key}: #{map[key]}" end)
      |> Enum.join(", ")
  end
end

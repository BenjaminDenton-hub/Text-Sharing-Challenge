defmodule TextSharing.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  # get "/shorten/:url" do
  #   send_resp(conn, 200, TextSharing.shorten(url))
  # end

  get "/shorten/:url" do
    send_resp(conn, 200, TextSharing.shorten(url))
  end

  get "/:short_url_token" do
    # redirect(to: TextSharing.get_url(short_url_token))
    send_resp(conn, 200, TextSharing.get_url(short_url_token))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end

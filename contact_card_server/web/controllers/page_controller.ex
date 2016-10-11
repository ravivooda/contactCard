defmodule ContactCardServer.PageController do
  use ContactCardServer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

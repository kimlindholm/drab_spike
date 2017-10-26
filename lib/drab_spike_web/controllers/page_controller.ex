defmodule DrabSpikeWeb.PageController do
  use DrabSpikeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

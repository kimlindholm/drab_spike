defmodule DrabSpikeWeb.PageController do
  use DrabSpikeWeb, :controller
  use Drab.Controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end

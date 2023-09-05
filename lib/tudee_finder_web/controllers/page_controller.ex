defmodule TudeeFinderWeb.PageController do
  use TudeeFinderWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def presentation(conn, _params) do
    # Skip the default app layout since we're using reveal.js
    render(conn, :presentation, layout: false)
  end
end

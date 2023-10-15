defmodule ShapeFinderWeb.ShapeLive.Show do
  use ShapeFinderWeb, :live_view

  alias ShapeFinder.Shapes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:shape, Shapes.get_shape!(id))}
  end

  defp page_title(:show), do: "Show Shape"
  defp page_title(:edit), do: "Edit Shape"
end

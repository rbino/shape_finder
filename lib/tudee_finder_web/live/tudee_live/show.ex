defmodule TudeeFinderWeb.TudeeLive.Show do
  use TudeeFinderWeb, :live_view

  alias TudeeFinder.Tudees

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:tudee, Tudees.get_tudee!(id))}
  end

  defp page_title(:show), do: "Show Tudee"
  defp page_title(:edit), do: "Edit Tudee"
end

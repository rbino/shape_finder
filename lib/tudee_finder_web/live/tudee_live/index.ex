defmodule TudeeFinderWeb.TudeeLive.Index do
  use TudeeFinderWeb, :live_view

  alias TudeeFinder.Tudees
  alias TudeeFinder.Tudees.Tudee

  import TudeeFinderWeb.TudeeLive.TudeeComponent

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :tudees, Tudees.list_tudees())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tudee")
    |> assign(:tudee, Tudees.get_tudee!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tudee")
    |> assign(:tudee, %Tudee{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tudees")
    |> assign(:tudee, nil)
  end

  @impl true
  def handle_info({TudeeFinderWeb.TudeeLive.FormComponent, {:saved, tudee}}, socket) do
    {:noreply, stream_insert(socket, :tudees, tudee)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tudee = Tudees.get_tudee!(id)
    {:ok, _} = Tudees.delete_tudee(tudee)

    {:noreply, stream_delete(socket, :tudees, tudee)}
  end
end

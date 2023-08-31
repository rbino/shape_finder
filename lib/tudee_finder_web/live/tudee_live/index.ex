defmodule TudeeFinderWeb.TudeeLive.Index do
  use TudeeFinderWeb, :live_view

  alias TudeeFinder.Selector
  alias TudeeFinder.Selector.Parser
  alias TudeeFinder.Tudees
  alias TudeeFinder.Tudees.Tudee

  import TudeeFinderWeb.TudeeLive.TudeeComponent

  @impl true
  def mount(%{"selector" => selector}, _session, socket)
      when is_binary(selector) and selector != "" do
    {:ok, update_selector_and_filter_tudees(socket, selector)}
  end

  def mount(_params, _session, socket) do
    {:ok, reset_selector(socket)}
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

  def handle_event("selector_updated", %{"selector" => ""}, socket) do
    {:noreply, reset_selector(socket)}
  end

  def handle_event("selector_updated", %{"selector" => selector}, socket) do
    {:noreply, update_selector_and_filter_tudees(socket, selector)}
  end

  defp reset_selector(socket) do
    socket
    |> assign(:selector, nil)
    |> assign(:selector_error, nil)
    |> stream(:tudees, Tudees.list_tudees(), reset: true)
  end

  defp update_selector_and_filter_tudees(socket, selector) do
    case Selector.where(selector) do
      {:ok, where} ->
        socket
        |> assign(:selector, selector)
        |> assign(:selector_error, nil)
        |> stream(:tudees, Tudees.list_tudees(where: where), reset: true)

      {:error, %Parser.Error{message: message}} ->
        # We might hit this parse error on mount, in that case show a flash and just drop
        # the query parameter so we stream the unfiltered list
        if socket.assigns[:streams][:tudees] == nil do
          socket
          |> put_flash(:error, "Invalid selector passed as parameter")
          |> push_navigate(to: ~p"/tudees")
        else
          # TODO: provide some more detailed feedback in the input field
          socket
          |> assign(:selector, selector)
          |> assign(:selector_error, message)
        end
    end
  end
end

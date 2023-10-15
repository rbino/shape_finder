defmodule ShapeFinderWeb.ShapeLive.Index do
  use ShapeFinderWeb, :live_view

  alias ShapeFinder.Selector
  alias ShapeFinder.Selector.Parser
  alias ShapeFinder.Shapes
  alias ShapeFinder.Shapes.Shape

  import ShapeFinderWeb.ShapeLive.ShapeComponent

  @impl true
  def mount(%{"selector" => selector}, _session, socket)
      when is_binary(selector) and selector != "" do
    {:ok, update_selector_and_filter_shapes(socket, selector)}
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
    |> assign(:page_title, "Edit Shape")
    |> assign(:shape, Shapes.get_shape!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Shape")
    |> assign(:shape, %Shape{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Shapes")
    |> assign(:shape, nil)
  end

  @impl true
  def handle_info({ShapeFinderWeb.ShapeLive.FormComponent, {:saved, shape}}, socket) do
    {:noreply, maybe_insert_shape(socket, shape)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    shape = Shapes.get_shape!(id)
    {:ok, _} = Shapes.delete_shape(shape)

    {:noreply, stream_delete(socket, :shapes, shape)}
  end

  def handle_event("selector_updated", %{"selector" => ""}, socket) do
    {:noreply, reset_selector(socket)}
  end

  def handle_event("selector_updated", %{"selector" => selector}, socket) do
    {:noreply, update_selector_and_filter_shapes(socket, selector)}
  end

  defp maybe_insert_shape(%{assigns: %{selector_ast: nil}} = socket, shape) do
    stream_insert(socket, :shapes, shape)
  end

  defp maybe_insert_shape(%{assigns: %{selector_ast: selector_ast}} = socket, shape) do
    if Selector.match?(shape, selector_ast) do
      stream_insert(socket, :shapes, shape)
    else
      socket
    end
  end

  defp reset_selector(socket) do
    socket
    |> assign(:selector, nil)
    |> assign(:selector_ast, nil)
    |> assign(:selector_error, nil)
    |> stream(:shapes, Shapes.list_shapes(), reset: true)
  end

  defp update_selector_and_filter_shapes(socket, selector) do
    case Selector.parse(selector) do
      {:ok, ast} ->
        # This cannot fail
        {:ok, where} = Selector.where(ast)

        socket
        |> assign(:selector, selector)
        |> assign(:selector_ast, ast)
        |> assign(:selector_error, nil)
        |> stream(:shapes, Shapes.list_shapes(where: where), reset: true)

      {:error, %Parser.Error{message: message}} ->
        # We might hit this parse error on mount, in that case show a flash and just drop
        # the query parameter so we stream the unfiltered list
        if socket.assigns[:streams][:shapes] == nil do
          socket
          |> put_flash(:error, "Invalid selector passed as parameter")
          |> push_navigate(to: ~p"/")
        else
          # TODO: provide some more detailed feedback in the input field
          # Do not touch the AST, so we keep filtering with the old one
          socket
          |> assign(:selector, selector)
          |> assign(:selector_error, message)
        end
    end
  end
end

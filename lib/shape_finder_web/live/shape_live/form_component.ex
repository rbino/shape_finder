defmodule ShapeFinderWeb.ShapeLive.FormComponent do
  use ShapeFinderWeb, :live_component

  alias ShapeFinder.Shapes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage shape records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="shape-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:color]}
          type="select"
          label="Color"
          prompt="Choose a value"
          options={Ecto.Enum.values(ShapeFinder.Shapes.Shape, :color)}
        />
        <.input field={@form[:sides]} type="number" label="Sides" />
        <.input
          field={@form[:dimensions]}
          type="select"
          label="Dimensions"
          prompt="Choose a value"
          options={Ecto.Enum.values(ShapeFinder.Shapes.Shape, :dimensions)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Shape</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{shape: shape} = assigns, socket) do
    changeset = Shapes.change_shape(shape)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"shape" => shape_params}, socket) do
    changeset =
      socket.assigns.shape
      |> Shapes.change_shape(shape_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"shape" => shape_params}, socket) do
    save_shape(socket, socket.assigns.action, shape_params)
  end

  defp save_shape(socket, :edit, shape_params) do
    case Shapes.update_shape(socket.assigns.shape, shape_params) do
      {:ok, shape} ->
        notify_parent({:saved, shape})

        {:noreply,
         socket
         |> put_flash(:info, "Shape updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_shape(socket, :new, shape_params) do
    case Shapes.create_shape(shape_params) do
      {:ok, shape} ->
        notify_parent({:saved, shape})

        {:noreply,
         socket
         |> put_flash(:info, "Shape created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end

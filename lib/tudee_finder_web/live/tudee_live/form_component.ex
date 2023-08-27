defmodule TudeeFinderWeb.TudeeLive.FormComponent do
  use TudeeFinderWeb, :live_component

  alias TudeeFinder.Tudees

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tudee records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="tudee-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:color]}
          type="select"
          label="Color"
          prompt="Choose a value"
          options={Ecto.Enum.values(TudeeFinder.Tudees.Tudee, :color)}
        />
        <.input field={@form[:sides]} type="number" label="Sides" />
        <.input
          field={@form[:dimensions]}
          type="select"
          label="Dimensions"
          prompt="Choose a value"
          options={Ecto.Enum.values(TudeeFinder.Tudees.Tudee, :dimensions)}
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Tudee</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tudee: tudee} = assigns, socket) do
    changeset = Tudees.change_tudee(tudee)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tudee" => tudee_params}, socket) do
    changeset =
      socket.assigns.tudee
      |> Tudees.change_tudee(tudee_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"tudee" => tudee_params}, socket) do
    save_tudee(socket, socket.assigns.action, tudee_params)
  end

  defp save_tudee(socket, :edit, tudee_params) do
    case Tudees.update_tudee(socket.assigns.tudee, tudee_params) do
      {:ok, tudee} ->
        notify_parent({:saved, tudee})

        {:noreply,
         socket
         |> put_flash(:info, "Tudee updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_tudee(socket, :new, tudee_params) do
    case Tudees.create_tudee(tudee_params) do
      {:ok, tudee} ->
        notify_parent({:saved, tudee})

        {:noreply,
         socket
         |> put_flash(:info, "Tudee created successfully")
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

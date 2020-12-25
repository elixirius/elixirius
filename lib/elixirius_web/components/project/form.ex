defmodule ElixiriusWeb.Components.Project.Form do
  @moduledoc false
  use Surface.LiveComponent

  alias Elixirius.Workshop
  alias Surface.Components.{Form, Form.Field, Form.TextInput, Form.Label, Form.ErrorTag}

  prop changeset, :changeset
  prop action, :atom
  prop project, :any
  prop return_to, :any

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-3">
      <Form
        opts={{ id: "form--" <> @id, class: "space-y-3" }}
        for={{ @changeset }}
        action="#"
        change="validate"
        submit="save"
      >
        <Field name="name">
          <Label />
          <TextInput value={{ @changeset.changes["name"] }} />
          <ErrorTag class="text-red-700" />
        </Field>

        <Field name="slug" :if={{ @action == :new }}>
          <Label />
          <TextInput value={{ @changeset.changes["slug"] }} />
          <ErrorTag />

          <p>
            <small>Please, be  careful with the project's slug. It cannot be changed in the future</small>
          </p>
        </Field>

        <button
          class="button-primary"
          type="submit"
          phx-disable-with="Saving..."
        >
          Save
        </button>
      </Form>

      <div :if={{ @action == :setup }}>
        <h3 class="text-indigo-700 font-bold pb-3 mb-3 border-b border-gray-100">
          Danger zone
        </h3>
        <button
          :on-click="delete"
          data-confirm="Are you sure?"
          class="button-danger"
        >
          Delete Project
        </button>
      </div>
    </div>
    """
  end

  @impl true
  def update(%{project: project} = assigns, socket) do
    changeset = Workshop.change_project(project)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset =
      socket.assigns.project
      |> Workshop.change_project(project_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"project" => project_params}, socket) do
    save_project(socket, socket.assigns.action, project_params)
  end

  defp save_project(socket, :new, project_params) do
    case Workshop.create_project(
           Map.put_new(project_params, "user_id", socket.assigns.__context__.current_user.id)
         ) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp save_project(socket, :setup, project_params) do
    case Workshop.update_project(socket.assigns.project, project_params) do
      {:ok, _project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

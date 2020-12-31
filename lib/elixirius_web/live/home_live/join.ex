defmodule ElixiriusWeb.HomeLive.Join do
  use ElixiriusWeb, :surface_live_view

  alias Surface.Components.{
    Form,
    Form.Field,
    Form.TextInput,
    Form.PasswordInput,
    Form.Label,
    Form.ErrorTag
  }

  alias Elixirius.Accounts
  alias Elixirius.Accounts.User

  # -- Events

  # @impl true
  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    {:ok,
     socket
     |> assign(:changeset, changeset)}
  end

  # --- Component
  @impl true
  def render(assigns) do
    ~H"""
    <UI.Layouts.AuthLayout flash={{ @flash }}>
      <div class="grid place-items-center h-full">
        <UI.Heading>
          Register
        </UI.Heading>

        <div class="space-y-6">
          <Form
            change="validate"
            opts={{ class: "space-y-3", method: "POST" }}
            for={{ @changeset }}
            action={{ Routes.user_registration_path(@socket, :create) }}
          >
            <Field name="name">
              <Label/>
              <TextInput value={{ @changeset.changes["name"] }} />
              <ErrorTag />
            </Field>

            <Field name="email">
              <Label/>
              <TextInput value={{ @changeset.changes["email"] }} />
              <ErrorTag />
            </Field>

            <Field name="password">
              <Label/>
              <PasswordInput />
              <ErrorTag />
            </Field>

            <button
              class="button-primary"
              type="submit"
              phx-disable-with="Updating..."
            >
              Register
            </button>
          </Form>
        </div>

        <UI.Home.AuthLinks register={{ true }} forgot_password={{ true }} />
      </div>
    </UI.Layouts.AuthLayout>
    """
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      Accounts.change_user_registration(%User{}, user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
end

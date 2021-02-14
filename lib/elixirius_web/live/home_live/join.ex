defmodule ElixiriusWeb.HomeLive.Join do
  @moduledoc false
  use ElixiriusWeb, :surface_live_view

  alias Elixirius.Accounts
  alias Elixirius.Accounts.User

  alias Surface.Components.{
    Form,
    Form.EmailInput,
    Form.ErrorTag,
    Form.Field,
    Form.Label,
    Form.PasswordInput,
    Form.TextInput
  }

  prop changeset, :any

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
    <UI.Layouts.AuthLayout flash={{ @flash }} heading="Sign up for a new account">
      <div class="grid place-items-center h-full">
        <div class="space-y-6 mb-6">
          <Form
            change="validate"
            opts={{ class: "space-y-3", method: "POST" }}
            for={{ @changeset }}
            action={{ Routes.user_registration_path(@socket, :create) }}
          >
            <Field name="name">
              <Label/>
              <TextInput value={{ @changeset.changes["name"] }} opts={{ required: true }} />
              <ErrorTag class="flex text-red-700 text-sm" />
            </Field>

            <Field name="email">
              <Label/>
              <EmailInput value={{ @changeset.changes["email"] }} opts={{ required: true }} />
              <ErrorTag class="flex text-red-700 text-sm" />
            </Field>

            <Field name="password">
              <Label/>
              <PasswordInput opts={{ required: true }} />
              <ErrorTag class="flex text-red-700  text-sm" />
            </Field>

            <div class="flex justify-center">
              <button
                class="button-primary"
                type="submit"
                phx-disable-with="Updating..."
              >
                Register
              </button>
            </div>
          </Form>
        </div>

        <UI.Home.AuthLinks enter forgot_password />
      </div>
    </UI.Layouts.AuthLayout>
    """
  end

  @impl true
  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset =
      Accounts.change_user_registration(%User{}, user_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
end

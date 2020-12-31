defmodule ElixiriusWeb.HomeLive.ResetPassword do
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
  def mount(params, _session, socket) do
    %{"token" => token} = params

    if user = Accounts.get_user_by_reset_password_token(token) do
      changeset = Accounts.change_user_password(user)

      {:ok, socket
      |> assign(:user, user)
      |> assign(:token, token)
      |> assign(:changeset, changeset)
      |> assign(:password, %{"password" => "", "password_confirmation" => ""})}
    else
      {:ok, socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> push_redirect(to: "/")}
    end
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
            submit="submit"
            change="validate"
            opts={{ class: "space-y-3" }}
            for={{ @changeset }}
          >
            <Field name="password">
              <Label/>
              <PasswordInput value= {{ @password["password"] }} />
              <ErrorTag />
            </Field>

            <Field name="password_confirmation">
              <Label/>
              <PasswordInput value= {{ @password["password_confirmation"] }} />
              <ErrorTag />
            </Field>

            <button
              class="button-primary"
              type="submit"
              phx-disable-with="Updating..."
            >
              Reset password
            </button>
          </Form>
        </div>

        <nav class="flex flex-col space-y-2 text-indigo-700 text-center">
          <LivePatch to={{ Routes.home_join_path(@socket, :new) }}>
            Register
          </LivePatch>

          <LivePatch to={{ Routes.home_enter_path(@socket, :new) }}>
            Log In
          </LivePatch>
        </nav>
      </div>
    </UI.Layouts.AuthLayout>
    """
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    password = Map.merge(socket.assigns.password, user_params)
    changeset =
      Accounts.change_user_password(%User{}, user_params)
      |> Map.put(:action, :validate)

    {:noreply,
    socket
    |> assign(:changeset, changeset)
    |> assign(:password, password)}
  end

  def handle_event("submit", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply, socket
        |> put_flash(:info, "Password reset successfully.")
        |> push_redirect(to: Routes.home_enter_path(socket, :new))}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end

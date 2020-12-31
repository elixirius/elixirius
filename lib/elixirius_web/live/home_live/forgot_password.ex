defmodule ElixiriusWeb.HomeLive.ForgotPassword do
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

  # --- Component
  @impl true
  def render(assigns) do
    ~H"""
    <UI.Layouts.AuthLayout flash={{ @flash }}>
      <div class="grid place-items-center h-full">
        <UI.Heading>
          Forgot your password?
        </UI.Heading>

        <div class="space-y-6">
          <Form
            opts={{ class: "space-y-3" }}
            for={{ :user }}
            submit="submit"
          >

            <Field name="email">
              <Label/>
              <TextInput />
              <ErrorTag />
            </Field>

            <button
              class="button-primary"
              type="submit"
              phx-disable-with="Sending..."
            >
              Send instructions to reset password
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

  def handle_event("submit", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &Routes.home_reset_password_url(socket, :edit, &1)
      )
    end

    # Regardless of the outcome, show an impartial success/error message.
    {:noreply,
     socket
     |> put_flash(
       :info,
       "If your email is in our system, you will receive instructions to reset your password shortly."
     )
     |> push_redirect(to: "/")}
  end
end

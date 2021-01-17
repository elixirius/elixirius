defmodule ElixiriusWeb.HomeLive.ForgotPassword do
  use ElixiriusWeb, :surface_live_view

  alias Surface.Components.{
    Form,
    Form.Field,
    Form.EmailInput,
    Form.Label,
    Form.ErrorTag
  }

  alias Elixirius.Accounts

  # --- Component
  @impl true
  def render(assigns) do
    ~H"""
    <UI.Layouts.AuthLayout flash={{ @flash }} heading="Forgot your password?">
      <div class="grid place-items-center h-full">
        <div class="space-y-6 mb-6">
          <Form
            opts={{ class: "space-y-3" }}
            for={{ :user }}
            submit="submit"
          >

            <Field name="email">
              <Label/>
              <EmailInput opts={{ required: true }} />
              <ErrorTag />
            </Field>

            <div class="flex justify-center">
              <button
                class="button-primary"
                type="submit"
                phx-disable-with="Sending..."
              >
                Send instructions
              </button>
            </div>
          </Form>
        </div>

        <UI.Home.AuthLinks register enter />
      </div>
    </UI.Layouts.AuthLayout>
    """
  end

  @impl true
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

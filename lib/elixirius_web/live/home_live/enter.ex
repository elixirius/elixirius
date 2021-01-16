defmodule ElixiriusWeb.HomeLive.Enter do
  use ElixiriusWeb, :surface_live_view

  alias Surface.Components.{
    Form,
    Form.Field,
    Form.EmailInput,
    Form.PasswordInput,
    Form.Label,
    Form.ErrorTag,
    Form.Checkbox
  }

  # --- Component
  @impl true
  def render(assigns) do
    ~H"""
    <UI.Layouts.AuthLayout flash={{ @flash }} heading="Sign in to your account">
      <div class="grid place-items-center h-full">
        <div class="space-y-6 mb-6">
          <Form
            for={{ :user }}
            opts={{ class: "space-y-3", method: "POST" }}
            action={{ Routes.user_session_path(@socket, :create) }}
          >
            <Field name="email">
              <Label/>
              <EmailInput opts={{ required: true }} />
              <ErrorTag />
            </Field>

            <Field name="password">
              <Label/>
              <PasswordInput opts={{ required: true }} />
              <ErrorTag />
            </Field>

            <Field name="remember_me" class="flex items-center">
              <Checkbox class="mr-3" />
              <Label class="pb-0" />
            </Field>

            <div class="flex justify-center">
              <button
                class="button-primary"
                type="submit"
                phx-disable-with="Updating..."
              >
                Sign in
              </button>
            </div>
          </Form>
        </div>

        <UI.Home.AuthLinks register forgot_password />
      </div>
    </UI.Layouts.AuthLayout>
    """
  end
end

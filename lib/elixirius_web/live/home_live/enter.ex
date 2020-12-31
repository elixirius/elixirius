defmodule ElixiriusWeb.HomeLive.Enter do
  use ElixiriusWeb, :surface_live_view

  alias Surface.Components.{
    Form,
    Form.Field,
    Form.TextInput,
    Form.PasswordInput,
    Form.Label,
    Form.ErrorTag
  }

  # --- Component
  @impl true
  def render(assigns) do
    ~H"""
    <UI.Layouts.AuthLayout flash={{ @flash }}>
      <div class="grid place-items-center h-full">
        <UI.Heading>
          Log In
        </UI.Heading>

        <div class="space-y-6">
          <Form
            for={{ :user }}
            opts={{ class: "space-y-3", method: "POST" }}
            action={{ Routes.user_session_path(@socket, :create) }}
          >
            <Field name="email">
              <Label/>
              <TextInput />
              <ErrorTag />
            </Field>

            <Field name="password">
              <Label/>
              <PasswordInput />
              <ErrorTag />
            </Field>

            <div class="flex items-center">
              <input type="checkbox" id="remember_me" name="remember_me">
              <label for="remember_me">Keep me logged in for 60 days</label>
            </div>

            <button
              class="button-primary"
              type="submit"
              phx-disable-with="Updating..."
            >
              Log in
            </button>
          </Form>
        </div>

        <UI.Home.AuthLinks register={{ true }} forgot_password={{ true }} />
      </div>
    </UI.Layouts.AuthLayout>
    """
  end
end

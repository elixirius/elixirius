defmodule ElixiriusWeb.Components.Profile.Form do
  @moduledoc false
  use Surface.LiveComponent

  alias Elixirius.Accounts

  alias Surface.Components.{
    Form,
    Form.Field,
    Form.TextInput,
    Form.PasswordInput,
    Form.Label,
    Form.ErrorTag
  }

  prop email_changeset, :changeset
  prop password_changeset, :changeset
  prop return_to, :any

  # --- Events

  def update(%{__context__: %{current_user: user}} = assigns, socket) do
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:email_changeset, email_changeset)
     |> assign(:password_changeset, password_changeset)}
  end

  # --- Component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <h3 class="text-indigo-700 font-bold pb-3 border-b border-gray-100">Change Email:</h3>
      <Form
        opts={{ id: "form-email--" <> @id, class: "space-y-3" }}
        for={{ @email_changeset }}
        action="#"
        change="validate_email_form"
        submit="update_email"
      >
        <Field name="email">
          <Label/>
          <TextInput value={{ @email_changeset.changes["email"] }} />
          <ErrorTag />
        </Field>

        <Field name="current_password">
          <Label/>
          <PasswordInput />
          <ErrorTag />
        </Field>

        <button
          class="button-primary"
          type="submit"
          phx-disable-with="Updating..."
        >
          Change Email
        </button>
      </Form>

      <h3 class="text-indigo-700 font-bold pb-3 border-b border-gray-100">Change Password:</h3>

      <Form
        opts={{ id: "form-password--" <> @id, class: "space-y-3" }}
        for={{ @password_changeset }}
        action="#"
        change="validate_password_form"
        submit="update_password"
      >
        <Field name="password">
          <Label/>
          <PasswordInput />
          <ErrorTag />
        </Field>

        <Field name="password_confirmation">
          <Label/>
          <PasswordInput />
          <ErrorTag />
        </Field>

        <Field name="current_password">
          <Label/>
          <PasswordInput />
          <ErrorTag />
        </Field>

        <button
          class="button-primary"
          type="submit"
          phx-disable-with="Updating..."
        >
          Change Password
        </button>
      </Form>
    </div>
    """
  end
end

defmodule ElixiriusWeb.Components.Card do
  use Surface.LiveComponent

  @doc "Card title"
  prop title, :string, default: "Card Title", required: true

  @doc "Aria label"
  prop aria_label, :string, default: ""

  # --- Component

  def render(assigns) do
    ~H"""
    <div class="border border-gray-200 min-w-md w-full">
      <header class="p-4 bg-gray-100 border-b border-gray-200">
        <h1 class="font-bold text-base">{{ @title }}</h1>
      </header>
      <div class="p-4 bg-white">
        <slot />
      </div>
    </div>
    """
  end

  # --- Helpers

  defp get_html(markdown) do
    {_status, html_doc, _errors} = Earmark.as_html(markdown)
    html_doc
  end
end

defmodule ElixiriusWeb.Components.NodeDocs do
  use Surface.Component

  prop node, :map

  def render(assigns) do
    ~H"""
    <div class="text-sm">
      <div class="markdown text-gray-600">
        {{ raw(get_html(get_docs(Module.concat ["ElixiriusWeb", "Components", @node.content.element]))) }}
      </div>
      <style>
        .markdown h3 {
          font-weight: 600;
          padding-bottom: 0.5rem;
          margin-bottom: 0.5rem;
          border-bottom: 1px solid #e5e7eb;
        }

        .markdown strong {
          color: #6366f1;
        }

        .markdown em {
          font-weight: 600;
          font-style: normal;
          display: block;
        }

        .markdown li {
          margin-bottom: 1rem;
        }
      </style>
    </div>
    """
  end

  # --- Helpers

  defp get_docs(module) do
    case Code.fetch_docs(module) do
      {:docs_v1, _, _, "text/markdown", %{"en" => docs}, %{}, _} ->
        docs

      _ ->
        nil
    end
  end

  defp get_html(markdown) do
    {_status, html_doc, _errors} = Earmark.as_html(markdown)
    html_doc
  end
end

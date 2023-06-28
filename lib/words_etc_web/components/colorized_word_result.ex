defmodule WordsEtcWeb.Components.ColorizedWordResult do
  use Phoenix.Component

  def render(assigns) do
    assigns = assign(assigns, marked_up_word: mark_up_word(assigns[:word]))

    ~H"""
    <%= Phoenix.HTML.raw(@marked_up_word) %>
    """
  end

  defp mark_up_word(word) do
    word
    |> String.graphemes()
    |> Enum.map(fn ch ->
      if ch =~ ~r/[a-z]/ do
        "<span class='text-danger'>#{String.upcase(ch)}</span>"
      else
        ch
      end
    end)
    |> Enum.join()
  end
end

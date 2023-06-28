defmodule WordsEtcWeb.Components.WordResultsList do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="container">
      <h3>Solutions</h3>
      <%= if assigns[:error] do %>
        <div class="alert alert-danger" role="alert">
          {@error}
        </div>
      <% else %>
        <%= for {count, words} <- @solutions do %>
          <h4 class="mt-3"><%= count %> letters</h4>
          <div class="row">
            <%= for {word, score, definition} <- words do %>
              <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                <div class="card mb-3">
                  <div
                    class="card-body"
                    data-bs-toggle="collapse"
                    data-bs-target={"#collapse" <> word}
                    role="button"
                    aria-expanded="false"
                  >
                    <h5 class="card-title"><%= word %></h5>
                    <p class="card-text"><b><%= score %> points</b></p>
                  </div>
                  <div class="collapse" id={"collapse" <> word}>
                    <div class="card-body">
                      <p class="card-text"><%= definition %></p>
                    </div>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end

  def _render(assigns) do
    ~H"""
    <div class="container">
      <h3>Solutions</h3>
      <%= if assigns[:error] do %>
        <div class="alert alert-danger" role="alert">
          {@error}
        </div>
      <% else %>
        <%= for {count, words} <- @solutions do %>
          <h4 class="mt-3"><%= count %> letters</h4>
          <div class="row">
            <%= for {word, score, definition} <- words do %>
              <div class="col-12 col-sm-6 col-md-4 col-lg-3">
                <div class="card mb-3">
                  <div class="card-body">
                    <h5 class="card-title" title={definition}><%= word %></h5>
                    <p class="card-text"><b><%= score %> points</b></p>
                  </div>
                </div>
              </div>
            <% end %>
          </div>
        <% end %>
      <% end %>
    </div>
    """
  end
end

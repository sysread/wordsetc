defmodule WordsEtcWeb.Components.WordSolverForm do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="container py-4">
      <h3>Word Solver</h3>

      <form id="word-solver-form" action={@action} method="POST" novalidate>
        <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />

        <div class="input-group input-group-lg mb-3">
          <label for="letters" class="input-group-text d-none d-md-block">Letters</label>

          <input
            id="letters"
            name="letters"
            type="text"
            value={@letters}
            class="form-control text-uppercase w-50"
            required
            pattern="[A-Z?]*"
            minlength="1"
            maxlength="10"
            autocomplete="off"
            autocorrect="off"
            autocapitalize="off"
          />

          <button id="clear-letters" type="button" class="btn btn-outline-secondary">
            X
          </button>

          <button id="submit-button" type="submit" class="btn btn-outline-primary">
            Solve!
          </button>
        </div>

        <div>
          <div class="input-group mb-3">
            <label for="filter" class="input-group-text">
              Positional Filter
            </label>

            <input
              id="filter"
              name="filter"
              type="text"
              value={@filter}
              class="form-control text-uppercase"
              pattern="[A-Z0-9]*"
              maxlength="5"
              autocomplete="off"
              autocorrect="off"
              autocapitalize="off"
            />

            <button
              id="filter-instructions-button"
              type="button"
              class="btn btn-outline-secondary"
              data-bs-toggle="collapse"
              href="#filter-instructions"
            >
              ?
            </button>
          </div>

          <div id="filter-instructions" class="card collapse mb-3">
            <div class="card-header">
              Instructions
            </div>
            <div class="card-body">
              Specify an existing tile you wish to play on along with the number of empty tiles on either side of it.
              <table class="table">
                <tbody>
                  <tr>
                    <td><code>3M4</code></td>
                    <td>3 tiles, M, 4 tiles</td>
                  </tr>
                  <tr>
                    <td><code>2M3ED</code></td>
                    <td>2 tiles, M, 3 tiles, E, D</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <div class="input-group">
          <label for="sort" class="input-group-text">Sort</label>
          <select id="sort" name="sort" class="form-select">
            <option value="score" selected={@sort == :score}>by score</option>
            <option value="alpha" selected={@sort == :alpha}>by word</option>
          </select>
        </div>

        <div class="invalid-feedback">
          Please enter 1-10 letters or ? for a wildcard tile.
        </div>

        <%= if @error do %>
          <div class="validation-error invalid-feedback">
            <%= @error %>
          </div>
        <% end %>
      </form>
    </div>

    <script type="text/javascript">
      $(document).ready(function() {
        if ($(".validation-error").length > 0) {
          $(".validation-error").show();
        }

        // Clear form input when X is clicked
        $("#clear-letters").on('click', function() {
          $("#letters").val('');
          $("#letters").focus();
          $("#word-solver-form").removeClass('was-validated').addClass('needs-validation');
        });

        // Convert letters to uppercase
        $("#letters, #filter").on('input', function() {
          $(this).val($(this).val().toUpperCase());
          $("#word-solver-form").removeClass('was-validated').addClass('needs-validation');
        });

        $("#word-solver-form").on('submit', function(e) {
          if (!e.target.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
          }

          $(this).addClass('was-validated');
        });
      });
    </script>
    """
  end
end

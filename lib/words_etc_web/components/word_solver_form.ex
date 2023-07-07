defmodule WordsEtcWeb.Components.WordSolverForm do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="container py-4">
      <h3>Word Solver</h3>

      <form id="word-solver-form" action={@action} method="POST" novalidate>
        <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />

        <div class="input-group input-group-lg">
          <label for="letters" class="input-group-text" id="basic-addon1">Letters</label>

          <input
            id="letters"
            type="text"
            name="letters"
            class="form-control text-uppercase"
            value={@letters}
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

        $("#letters").on('input', function() {
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

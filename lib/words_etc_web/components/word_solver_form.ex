defmodule WordsEtcWeb.Components.WordSolverForm do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="container py-4">
      <h3>Word solver</h3>

      <form id="word-solver-form" action={@action} method="POST" class="row g-3" novalidate>
        <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />

        <div class="col-6 position-relative">
          <label for="letters" class="form-label">Letters</label>

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

          <button
            id="clear-letters"
            type="button"
            class="btn btn-primary rounded-pill position-absolute top-50 end-0 translate-middle-y"
          >
            X
          </button>

          <%= if @error do %>
            <div class="validation-error invalid-feedback">
              <%= @error %>
            </div>
          <% end %>

          <div class="invalid-feedback">
            Please enter 1-10 letters or ? for a wildcard tile.
          </div>
        </div>

        <div class="col-4 d-flex align-items-end">
          <button id="submit-button" type="submit" class="btn btn-primary">Solve!</button>
        </div>
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

        // When form input is clicked, select all text in the input
        $("#letters").on('click', function() {
          $(this).select();
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

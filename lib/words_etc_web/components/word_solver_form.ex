defmodule WordsEtcWeb.Components.WordSolverForm do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <div class="container py-4">
      <h3>Word solver</h3>

      <form
        id="word-solver-form"
        action={@action}
        method="POST"
        class="needs-validation row g-3"
        novalidate
      >
        <input type="hidden" name="_csrf_token" value={Plug.CSRFProtection.get_csrf_token()} />

        <div class="col-6 position-relative">
          <label for="letters" class="form-label">Letters</label>

          <input
            id="letters"
            type="text"
            name="letters"
            class="form-control text-uppercase"
            required
            pattern="[A-Z?]*"
            value={@letters}
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

          <div class="invalid-feedback">Please enter letters or ? only.</div>
        </div>

        <div class="col-4 d-flex align-items-end">
          <button id="submit-button" type="submit" class="btn btn-primary">Solve!</button>
        </div>
      </form>
    </div>

    <script type="text/javascript">
      $(document).ready(function() {
        // Clear form input when X is clicked
        $("#clear-letters").on('click', function() {
          $("#letters").val('');
          $("#letters").focus();
        });

        // When form input is clicked, select all text in the input
        $("#letters").on('click', function() {
          $(this).select();
        });

        $("#letters").on('input', function() {
          $(this).val($(this).val().toUpperCase());
        });

        // Bootstrap form validation
        (function () {
          'use strict'

          // Fetch all the forms we want to apply custom Bootstrap validation styles to
          var forms = document.querySelectorAll('.needs-validation')

          // Loop over them and prevent submission
          Array.prototype.slice.call(forms)
            .forEach(function (form) {
              form.addEventListener('submit', function (event) {
                if (!form.checkValidity()) {
                  event.preventDefault()
                  event.stopPropagation()
                }

                form.classList.add('was-validated')
              }, false)
            })
        })()
      });
    </script>
    """
  end
end

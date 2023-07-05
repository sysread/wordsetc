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

        <div class="col-8">
          <label for="letters" class="form-label">Letters</label>
          <input
            id="letters"
            type="text"
            name="letters"
            class="form-control"
            required
            pattern="[a-zA-Z]*"
            value={@letters}
            autocomplete="off"
            autocorrect="off"
            autocapitalize="off"
          />
          <div class="invalid-feedback">Please enter letters only.</div>
        </div>

        <div class="col-4 d-flex align-items-end">
          <button id="submit-button" type="submit" class="btn btn-primary">Solve!</button>
        </div>
      </form>
    </div>

    <script>
      $(document).ready(function() {
        // Disable the submit button after click
        $("#submit-button").on('click', function() {
          $(this).prop('disabled', true);
          return true;
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

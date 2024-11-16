document.addEventListener("turbo:submit-end", function (event) {
    const xhr = event.detail.fetchResponse.response;
    if (!xhr.ok) { // Check if the response is not successful
        xhr.json().then(data => {
            if (data.error) {
                updateFlashMessage("alert", data.error);
            }
        });
    }
});

function updateFlashMessage(type, message) {
    const flashDiv = document.getElementById('flash');
    flashDiv.innerHTML = `
      <div class="callout ${type}">
        <p>${message}</p>
      </div>
    `;
}
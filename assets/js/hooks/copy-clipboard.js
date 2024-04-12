let CopyToClipboard = {
  mounted() {
    const link = this.el;
    const targetContainerId = link.dataset.targetContainer;
    const messageContainerId = link.dataset.messageContainer;

    link.addEventListener("click", (event) => {
      event.preventDefault();

      const targetContainer = document.getElementById(targetContainerId);

      if (targetContainer) {
        const textToCopy = targetContainer.textContent || targetContainer.innerText;

        navigator.clipboard.writeText(textToCopy.trim())
          .then(() => {
            // Display the message
            const messageElement = document.getElementById(messageContainerId);
            messageElement.textContent = "Copied!";

            // Hide the message after 2 seconds (adjust as needed)
            setTimeout(() => {
              messageElement.textContent = "";
            }, 2000);
          })
          .catch((err) => {
            console.error("Failed to copy content:", err);
          });
      } else {
        console.error("Target div with ID", targetContainerId, "not found");
      }
    });
  }
};

export default CopyToClipboard
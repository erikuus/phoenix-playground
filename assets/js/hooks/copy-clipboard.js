let CopyToClipboard = {
  mounted() {
    const link = this.el;
    const targetDivId = link.dataset.targetDiv; // Get target div ID from data attribute

    link.addEventListener("click", (event) => {
      event.preventDefault(); // Prevent default link behavior

      const targetDiv = document.getElementById(targetDivId);

      if (targetDiv) {
        const textToCopy = targetDiv.textContent || targetDiv.innerText; // Get content

        navigator.clipboard.writeText(textToCopy.trim())
          .then(() => {
            // Success message (optional)
            console.log("Content copied to clipboard!");
          })
          .catch((err) => {
            // Error handling (optional)
            console.error("Failed to copy content:", err);
          });
      } else {
        console.error("Target div with ID", targetDivId, "not found");
      }
    });
  }
};

export default CopyToClipboard
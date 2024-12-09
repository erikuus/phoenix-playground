let ScrollToTop = {
  mounted() {
    // Initialize previousPage with the current page number
    this.previousPage = parseInt(this.el.getAttribute("data-current-page"), 10);
  },

  updated() {
    // Get the current page number from the data attribute
    const currentPage = parseInt(this.el.getAttribute("data-current-page"), 10);

    // Compare with the previous page number
    if (currentPage !== this.previousPage) {
      // Page has changed, perform the scroll to top
      window.scrollTo({ top: 0, behavior: "auto" }); // Use 'smooth' for smooth scroll

      // Update the previousPage to the current page
      this.previousPage = currentPage;
    }
    // If the page hasn't changed, do nothing
  },
};

export default ScrollToTop;

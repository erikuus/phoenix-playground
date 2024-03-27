let PreserveScroll = {
  mounted() {
    // Attempt to restore scroll position on mount
    const savedScrollTop = localStorage.getItem("scrollPosition");
    if (savedScrollTop) {
      this.el.scrollTop = parseInt(savedScrollTop, 10);
    }

    // Listen for scroll events to update the saved position
    this.el.addEventListener("scroll", () => {
      localStorage.setItem("scrollPosition", this.el.scrollTop.toString());
    });
  },
  destroyed() {
    // Clean up the event listener if the hook's element is destroyed
    this.el.removeEventListener("scroll", this.listener);
  }
};

export default PreserveScroll;
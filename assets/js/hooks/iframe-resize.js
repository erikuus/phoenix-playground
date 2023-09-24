let isResizing = false;

let IframeResize = {
  mounted() {
    this.el.addEventListener('mousedown', startResize);

    const container = document.getElementById(this.el.dataset.container);
    const overlay = document.getElementById(this.el.dataset.overlay);
    const ruler = document.getElementById(this.el.dataset.ruler);

    function startResize(e) {
      isResizing = true;
      document.addEventListener('mousemove', resize);
      document.addEventListener('mouseup', stopResize);
      overlay.style.pointerEvents = 'auto'; // Enable overlay to capture mouse events

      // Prevent default actions to avoid text selection while resizing
      e.preventDefault();
    }

    function resize(e) {
      if (isResizing) {
        const newWidth = e.clientX - container.getBoundingClientRect().left;
        if (newWidth > 400 && newWidth < ruler.offsetWidth) {
          container.style.width = newWidth + 'px';
        }
      }
    }

    function stopResize() {
      isResizing = false;
      document.removeEventListener('mousemove', resize);
      document.removeEventListener('mouseup', stopResize);
      overlay.style.pointerEvents = 'none'; // Disable overlay to allow iframe interaction
    }
  }
};

export default IframeResize;
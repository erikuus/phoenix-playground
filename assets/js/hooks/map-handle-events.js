import Map from "../leaflets/map-handle-events.js"

let MapHandleEvents = {
  mounted() {
    this.map = new Map(this.el, [58.6307, 25.3397], 7)

    this.handleEvent("add-marker", location => {
      this.map.addMarker(location);
      this.map.highlightMarker(location);
    })

    this.handleEvent("highlight-marker", location => {
      this.map.highlightMarker(location);
    })
  }
};

export default MapHandleEvents;
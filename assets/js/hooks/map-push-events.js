import Map from "../leaflets/map-push-events.js"

let MapPushEvents = {
  mounted() {
    this.map = new Map(this.el, [58.668252, 25.048828], 7, event => {
      locationId = event.target.options.locationId
      this.pushEvent("marker-clicked", locationId, (reply, ref) => {
        this.scrollTo(reply.location.id);
      })
    })

    this.pushEvent("get-locations", {}, (reply, ref) => {
      reply.locations.forEach(location => {
        this.map.addMarker(location);
      })
      this.map.fitMarkers();
    })
  },

  scrollTo(locationId) {
    const locationElement =
      document.getElementById(`location-${locationId}`);

    locationElement.scrollIntoView(false);
  }
};

export default MapPushEvents;
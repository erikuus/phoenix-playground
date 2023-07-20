import Map from "../leaflets/map-dataset.js"

let MapDataset = {
  mounted() {
    this.map = new Map(this.el, [58.6307, 25.3397], 7)

    JSON.parse(this.el.dataset.locations).forEach(location => {
      this.map.addMarker(location);
    })

    this.map.fitMarkers();
  },
};

export default MapDataset;
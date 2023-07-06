import Map from "./map"

let MapDataset = {
  mounted() {
    this.map = new Map(this.el, [58.668252, 25.048828], 7, event => {

    })

    JSON.parse(this.el.dataset.locations).forEach(location => {
      this.map.addMarker(location);
    })

  },
};

export default MapDataset;
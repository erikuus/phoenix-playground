import L from "leaflet";

class Map {
  constructor(element, center, zoom) {
    this.map = L.map(element).setView(center, zoom);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      maxZoom: 18,
      tileSize: 512,
      zoomOffset: -1
    }).addTo(this.map);
  }

  addMarker(location) {
    const marker =
      L.marker([location.lat, location.lng], { locationId: location.id })
        .addTo(this.map)
        .bindPopup(location.name)

    marker.on("click", e => {
      marker.openPopup();
    });

    return marker;
  }

  fitMarkers() {
    var markers = new L.FeatureGroup();
    this.map.eachLayer(layer => {
      if (layer instanceof L.Marker) {
        markers.addLayer(layer);
      }
    });
    const bounds = markers.getBounds();
    this.map.fitBounds(bounds);
  }
}

export default Map;

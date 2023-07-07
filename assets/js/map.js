/*
install required library as follows:
cd assets
npm install --save leaflet@1.7.1
*/
import L from "leaflet";

class Map {
  constructor(element, center, zoom, markerClickedCallback) {
    this.map = L.map(element).setView(center, zoom);

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      maxZoom: 18,
      tileSize: 512,
      zoomOffset: -1
    }).addTo(this.map);

    this.markerClickedCallback = markerClickedCallback;
  }

  addMarker(location) {
    const marker =
      L.marker([location.lat, location.lng], { locationId: location.id })
        .addTo(this.map)
        .bindPopup(location.name)

    marker.on("click", e => {
      marker.openPopup();
      this.markerClickedCallback(e);
    });

    return marker;
  }

  highlightMarker(location) {
    const marker = this.markerForLocation(location);

    marker.openPopup();

    this.map.panTo(marker.getLatLng());
  }

  markerForLocation(location) {
    let markerLayer;
    this.map.eachLayer(layer => {
      if (layer instanceof L.Marker) {
        const markerPosition = layer.getLatLng();
        if (markerPosition.lat === location.lat &&
          markerPosition.lng === location.lng) {
          markerLayer = layer;
        }
      }
    });

    return markerLayer;
  }
}

export default Map;

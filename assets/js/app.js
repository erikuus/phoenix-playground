// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons
import "phoenix_html";
// Establish Phoenix Socket and LiveView configuration
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

import CopyToClipboard from "./hooks/copy-clipboard";
import PreserveScroll from "./hooks/preserve-scroll";
import ScrollToTop from "./hooks/scroll-to-top";
import IframeResize from "./hooks/iframe-resize";
import MapDataset from "./hooks/map-dataset";
import MapPushEvents from "./hooks/map-push-events";
import MapHandleEvents from "./hooks/map-handle-events";
import S3 from "./uploaders/S3";

let Hooks = {
  CopyToClipboard: CopyToClipboard,
  PreserveScroll: PreserveScroll,
  ScrollToTop: ScrollToTop,
  IframeResize: IframeResize,
  MapDataset: MapDataset,
  MapPushEvents: MapPushEvents,
  MapHandleEvents: MapHandleEvents,
};

let Uploaders = {
  S3: S3,
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  uploaders: Uploaders,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;

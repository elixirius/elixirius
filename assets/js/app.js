// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import '../css/app.css'
import '../css/phoenix.css'

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import 'phoenix_html'
import 'alpinejs'
import { Socket } from 'phoenix'
import topbar from 'topbar'
import { LiveSocket } from 'phoenix_live_view'

/**
 * Helpers
 */

const Hooks = {}

Hooks.LiveViewPushEvent = {
  mounted() {
    const liveView = this

    this.liveViewPushEvent = function (e) {
      liveView.pushEvent(e.detail.event, e.detail.payload)
    }

    this.liveViewPushEventTo = function (e) {
      liveView.pushEventTo(e.detail.selector, e.detail.event, e.detail.payload)
    }

    window.addEventListener('liveview-push-event', this.liveViewPushEvent)

    window.addEventListener('liveview-push-event-to', this.liveViewPushEventTo)
  },

  destroyed() {
    window.removeEventListener('liveview-push-event', this.liveViewPushEvent)

    window.removeEventListener(
      'liveview-push-event-to',
      this.liveViewPushEventTo
    )
  }
}

/**
 * Functions
 */

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute('content')
let liveSocket = new LiveSocket('/live', Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if (from.__x) {
        window.Alpine.clone(from.__x, to)
      }
    }
  },
  params: {
    _csrf_token: csrfToken
  },
  hooks: Hooks
})

// Show progress bar on live navigation and form submits
topbar.config({
  className: 'opacity-50',
  barColors: { 0: '#7209B7', 0.5: '#B5179E', 1: '#B5179E' },
  barThickness: 1,
  shadowColor: 'rgba(0, 0, 0, .3)'
})
window.addEventListener('phx:page-loading-start', (_info) => topbar.show())
window.addEventListener('phx:page-loading-stop', (_info) => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

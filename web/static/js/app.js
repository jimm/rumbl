import "deps/phoenix_html/web/static/js/phoenix_html"

import socket from "./socket"
import Video from "./video"
Video.init(socket, document.getElementById("video"))

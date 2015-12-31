import Player from "./player"

let Video = {
  init(socket, element) {
    if (!element)
      return

    let msgContainer = document.getElementById("msg-container")
    let msgInput     = document.getElementById("msg-input")
    let postButton   = document.getElementById("msg-submit")
    let videoId      = document.getElementById("data-id")
    let playerId     = document.getElementById("data-player-id")
    Player.init(element.id, playerId)

    socket.connect()
    let vidChannel = socket.channel("videos:" + videoId)
    // TODO join the vidChannel
  }
}
export default Video

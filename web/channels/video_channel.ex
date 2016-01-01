defmodule Rumbl.VideoChannel do
	use Rumbl.Web, :channel

  def join("videos:" <> video_id, _params, socket) do
    {:ok, assign(socket, :video_id, video_id)}
  end
end

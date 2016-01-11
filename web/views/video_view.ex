defmodule Rumbl.VideoView do
  use Rumbl.Web, :view

  def truncate(url, maxlen \\ 30) do
    truncated = String.slice(url, 0, maxlen)
    if truncated != url do
      truncated <> "..."
    else
      url
    end
  end
end

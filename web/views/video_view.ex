defmodule Rumbl.VideoView do
  use Rumbl.Web, :view

  def truncate(url, maxlen \\ 30) do
    if String.length(url) > maxlen do
      String.slice(url, 0, maxlen) <> "..."
    else
      url
    end
  end
end

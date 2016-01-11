defmodule Rumbl.VideoViewTest do
	use Rumbl.ConnCase, async: true
  import Phoenix.View

  test "renders index.html", %{conn: conn} do
    videos = [%Rumbl.Video{id: "1", title: "dogs", slug: "dogs"},
              %Rumbl.Video{id: "1", title: "cats", slug: "cats"}]
    content = render_to_string(Rumbl.VideoView, "index.html",
                               conn: conn, videos: videos)

    assert String.contains?(content, "Listing videos")
    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new.html", %{conn: conn} do
    cs = Rumbl.Video.changeset(%Rumbl.Video{})
    categories = [{"cats", 123}]
    content = render_to_string(Rumbl.VideoView, "new.html",
                               conn: conn, changeset: cs,
                               categories: categories)

    assert String.contains?(content, "New video")
  end

  test "truncate", _ do
    s = "abcdefg"
    trunc = Rumbl.VideoView.truncate(s, 3)
    assert trunc == "abc..."
  end
end

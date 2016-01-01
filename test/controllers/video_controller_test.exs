defmodule Rumbl.VideoControllerTest do
  use Rumbl.ConnCase

  alias Rumbl.Video
  @valid_attrs %{description: "some content", title: "some content",
                 url: "some content"}
  @invalid_attrs %{title: "invalid"}

  setup %{conn: conn} = config do
    if config[:no_login] do
      :ok
    else
      user = insert_user(username: "max")
      conn = assign(conn(), :current_user, user)
      {:ok, conn: conn, user: user}
    end
  end

  defp video_count(query), do: Repo.one(from v in query, select: count(v.id))

  @tag no_login: true
  test "requires user auth on all actions", %{conn: conn} do
    # Remove the user from the connection
    Enum.each([
      get(conn, video_path(conn, :index)),
      get(conn, video_path(conn, :show, "123")),
      get(conn, video_path(conn, :edit, "123")),
      get(conn, video_path(conn, :update, "123", %{})),
      get(conn, video_path(conn, :create, %{})),
      get(conn, video_path(conn, :delete, "123"))
    ], fn(conn) ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  test "lists all user's videos on index", %{conn: conn, user: user} do
    user_video = insert_video(user, title: "funny cats")
    other_video = insert_video(insert_user(username: "other"),
                               title: "another video")
    conn = get conn, video_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing videos"
    assert String.contains?(conn.resp_body, user_video.title)
    refute String.contains?(conn.resp_body, other_video.title)
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, video_path(conn, :new)
    assert html_response(conn, 200) =~ "New video"
  end

  test "creates user video and redirects", %{conn: conn, user: user} do
    conn = post conn, video_path(conn, :create), video: @valid_attrs
    assert redirected_to(conn) == video_path(conn, :index)
    assert Repo.get_by!(Video, @valid_attrs).user_id == user.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    count_before = video_count(Video)
    conn = post conn, video_path(conn, :create), video: @invalid_attrs
    assert html_response(conn, 200) =~ "New video"
    assert video_count(Video) == count_before
  end

  test "shows chosen resource", %{conn: conn} do
    video = Repo.insert! video_of_current_user(conn)
    conn = get conn, video_path(conn, :show, video)
    assert html_response(conn, 200) =~ "Show video"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, video_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    video = Repo.insert! video_of_current_user(conn)
    conn = get conn, video_path(conn, :edit, video)
    assert html_response(conn, 200) =~ "Edit video"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    video = Repo.insert! video_of_current_user(conn)
    conn = put conn, video_path(conn, :update, video), video: @valid_attrs
IO.puts "redir to = #{redirected_to(conn)}"
IO.puts "video_path #{video_path(conn, :show, video)}"
# FIXME: This should pass because in the controller video_path is correct.
#        Here, video_path is generating the wrong value. The slug it
#        generates is wrong.
    assert redirected_to(conn) == video_path(conn, :show, video)
    assert Repo.get_by(Video, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    video = Repo.insert! video_of_current_user(conn)
    conn = put conn, video_path(conn, :update, video), video: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit video"
  end

  test "deletes chosen resource", %{conn: conn} do
    video = Repo.insert! video_of_current_user(conn)
    conn = delete conn, video_path(conn, :delete, video)
    assert redirected_to(conn) == video_path(conn, :index)
    refute Repo.get(Video, video.id)
  end

  test "prevents users from accessing videos owned by others",
    %{user: owner, conn: conn} do

    video = insert_video(owner, @valid_attrs)
    non_owner = insert_user(username: "other")
    conn = assign(conn, :current_user, non_owner)

    assert_raise Ecto.NoResultsError, fn ->
      get(conn, video_path(conn, :show, video))
    end
    assert_raise Ecto.NoResultsError, fn ->
      get(conn, video_path(conn, :edit, video))
    end
    assert_raise Ecto.NoResultsError, fn ->
      get(conn, video_path(conn, :update, video, video: @valid_attrs))
    end
    assert_raise Ecto.NoResultsError, fn ->
      get(conn, video_path(conn, :delete, video))
    end

  end

  defp video_of_current_user(conn) do
    conn.assigns.current_user
    |> build(:videos)
  end
end

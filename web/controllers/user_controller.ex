defmodule Rumbl.UserController do
  use Rumbl.Web, :controller
  alias Rumbl.User
  plug :authenticate_user when action in [:index, :show]
  
  def index(conn, _params) do
    users = Repo.all(Rumbl.User)
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumbl.User, id |> String.to_integer)
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    cset = User.changeset(%User{})
    render conn, "new.html", changeset: cset
  end

  def create(conn, %{"user" => user_params}) do
    cset = User.registration_changeset(%User{}, user_params)
    case Repo.insert(cset) do
      {:ok, user} ->
        conn
        |> Rumbl.Auth.login(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
      {:error, cset} ->
        render(conn, "new.html", changeset: cset)
    end
  end
end

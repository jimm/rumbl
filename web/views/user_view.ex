defmodule Rumbl.UserView do
  use Rumbl.Web, :view
  alias Rumbl.User

  def first_name(%User{name: name}) do
    name |> String.split(" ") |> hd
  end

  def surname(%User{name: name}) do
    name |> String.split(" ") |> tl
  end
end

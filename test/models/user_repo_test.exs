defmodule Rumbl.UserRepoTest do
	use Rumbl.ModelCase
  alias Rumbl.User

  @valid_attrs %{name: "A User", username: "eva"}

  test "converts unique_constrainton username to error" do
    insert_user(username: "eric")
    attrs = Map.put(@valid_attrs, :username, "eric")
    cs = User.changeset(%User{}, attrs)

    assert {:error, cs} = Repo.insert(cs)
    assert {:username, "has already been taken"} in cs.errors
  end
end

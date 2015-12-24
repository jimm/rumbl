defmodule Rumbl.CategoryRepoTest do
	use Rumbl.ModelCase
  alias Rumbl.Category

  test "alphabetical/0 orders by name" do
    Repo.delete_all(Category)
    for name <- ~w(c a b) do
      Repo.insert!(%Category{name: name})
    end
    query = from c in Category.alphabetical(), select: c.name
    first = from c in Category.alphabetical(query), limit: 1

    assert Repo.one(first) == "a"
    assert Repo.all(query) == ~w(a b c)
  end
end

alias Rumbl.Repo
alias Rumbl.Category

for category <- ~w(Action Drama Romance Comedy Sci-Fi Music) do
  cs = %Category{} |> Category.changeset(%{name: category})
  unless cs.errors do
    Repo.insert! cs
  end
end

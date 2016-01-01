defmodule Rumbl.TestHelpers do
	alias Rumbl.Repo

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
          name: "Some User",
          username: "user#{Base.encode16(:crypto.rand_bytes(8))}",
          password: "supersecret"
                     }, attrs)
    %Rumbl.User{}
    |> Rumbl.User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_video(user, attrs \\ %{}) do
    # Duplicates Video.slugify code, but that is private
    default_slug = attrs[:title]
    |> String.downcase
    |> String.replace(~r/[^\w-]+/, "-")
    user
    |> Ecto.Model.build(:videos, Dict.merge(%{slug: default_slug}, attrs))
    |> Repo.insert!()
  end
end

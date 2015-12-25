defmodule Rumbl.Repo.Migrations.AddSlugToVideo do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :slug, :string
    end

    Repo.all(Video)
    |> Enum.each(fn(v) ->
      v
      |> Video.changeset(%{slug: Video
      Repo.update!(cs)
    end)
  end
end

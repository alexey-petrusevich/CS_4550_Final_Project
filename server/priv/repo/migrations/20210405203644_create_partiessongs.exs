defmodule Server.Repo.Migrations.CreatePartiessongs do
  use Ecto.Migration

  def change do
    create table(:partiessongs) do
      add :song_id, references(:songs, on_delete: :nothing)
      add :party_id, references(:parties, on_delete: :nothing)
    end

    create index(:partiessongs, [:song_id])
    create index(:partiessongs, [:party_id])
  end
end

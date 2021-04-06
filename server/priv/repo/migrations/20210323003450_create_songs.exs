defmodule Server.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :track_uri, :string, null: false
      add :title, :string, null: false
      add :artist, :string, null: false
      add :party_id, references(:parties, on_delete: :nothing), null: false

      timestamps()
    end

  end
end

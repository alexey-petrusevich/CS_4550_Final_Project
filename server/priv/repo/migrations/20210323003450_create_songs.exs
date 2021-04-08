defmodule Server.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :track_uri, :string, null: false
      add :title, :string, null: false
      add :artist, :string, null: false
      add :played, :boolean, null: false
      add :party_id, references(:parties, on_delete: :nothing), null: false
      add :genre, :string, null: false
      add :energy, :float, null: false, default: 0
      add :danceability, :float
      add :loudness, :float
      add :valence, :float

      timestamps()
    end

  end
end

defmodule Server.Repo.Migrations.CreateSongs do
  use Ecto.Migration

  def change do
    create table(:songs) do
      add :track_uri, :string, null: false
      add :title, :string, null: false
      add :artist, :string, null: false
      add :party_id, references(:parties, on_delete: :nothing), null: false
      add :genre, :string, null: false
      add :energy, :float, null: false, default: 0
      add :danceability, :float, default: 0
      add :loudness, :float, default: 0
      add :valence, :float, default: 0
      add :played, :boolean

      timestamps()
    end

  end
end

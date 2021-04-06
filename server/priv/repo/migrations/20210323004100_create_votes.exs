defmodule Server.Repo.Migrations.CreateVotes do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :value, :integer, null: false
      add :song_id, references(:songs, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:votes, [:song_id])
    create index(:votes, [:user_id])
  end
end

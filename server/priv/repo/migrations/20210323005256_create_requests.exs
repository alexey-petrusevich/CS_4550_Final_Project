defmodule Server.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :title, :string, null: false
      add :artist, :string
      add :party_id, references(:parties, on_delete: :nothing), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:requests, [:party_id])
  end
end
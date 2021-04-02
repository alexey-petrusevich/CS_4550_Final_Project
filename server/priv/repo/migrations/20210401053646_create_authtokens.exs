defmodule Server.Repo.Migrations.CreateAuthtokens do
  use Ecto.Migration

  def change do
    create table(:authtokens) do
      add :token, :text, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:authtokens, [:user_id])
  end
end

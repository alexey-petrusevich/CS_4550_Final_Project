defmodule Server.Repo.Migrations.CreateParties do
  use Ecto.Migration

  def change do
    create table(:parties) do
      add :name, :string, null: false
      add :roomcode, :string, null: false
      add :description, :text, null: false
      add :host_id, references(:users, on_delete: :nothing), null: false
      add :attendees, {:array, :integer}, null: false

      timestamps()
    end

    create index(:parties, [:host_id])
    #create index(:parties, [:attendee_id])
  end
end

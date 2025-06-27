defmodule ElixirGist.Repo.Migrations.CreateSavedgists do
  use Ecto.Migration

  def change do
    create table(:savedgists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :gist_id, references(:gists, on_delete: :delete_all, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:savedgists, [:user_id])
    create index(:savedgists, [:gist_id])
  end
end

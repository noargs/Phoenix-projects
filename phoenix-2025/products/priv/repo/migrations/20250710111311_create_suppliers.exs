defmodule Products.Repo.Migrations.CreateSuppliers do
  use Ecto.Migration

  def change do
    create table(:suppliers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :tin, :string
      add :name, :string, null: false
      add :discount, :integer, default: 0

      timestamps(type: :utc_datetime)
    end

    create unique_index(:suppliers, [:tin])
    create unique_index(:suppliers, [:name])
  end
end

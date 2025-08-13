defmodule Products.Repo.Migrations.SupplierLegalName do
  use Ecto.Migration

  def change do
    alter table(:suppliers) do
      add :legal_name, :string
    end
  end
end

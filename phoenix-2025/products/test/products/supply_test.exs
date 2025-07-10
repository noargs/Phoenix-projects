defmodule Products.SupplyTest do
  use Products.DataCase

  alias Products.Supply

  describe "suppliers" do
    alias Products.Supply.Supplier

    import Products.SupplyFixtures

    @invalid_attrs %{name: nil, tin: nil, discount: nil}

    test "list_suppliers/0 returns all suppliers" do
      supplier = supplier_fixture()
      assert Supply.list_suppliers() == [supplier]
    end

    test "get_supplier!/1 returns the supplier with given id" do
      supplier = supplier_fixture()
      assert Supply.get_supplier!(supplier.id) == supplier
    end

    test "create_supplier/1 with valid data creates a supplier" do
      valid_attrs = %{name: "some name", tin: "some tin", discount: 42}

      assert {:ok, %Supplier{} = supplier} = Supply.create_supplier(valid_attrs)
      assert supplier.name == "some name"
      assert supplier.tin == "some tin"
      assert supplier.discount == 42
    end

    test "create_supplier/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Supply.create_supplier(@invalid_attrs)
    end

    test "update_supplier/2 with valid data updates the supplier" do
      supplier = supplier_fixture()
      update_attrs = %{name: "some updated name", tin: "some updated tin", discount: 43}

      assert {:ok, %Supplier{} = supplier} = Supply.update_supplier(supplier, update_attrs)
      assert supplier.name == "some updated name"
      assert supplier.tin == "some updated tin"
      assert supplier.discount == 43
    end

    test "update_supplier/2 with invalid data returns error changeset" do
      supplier = supplier_fixture()
      assert {:error, %Ecto.Changeset{}} = Supply.update_supplier(supplier, @invalid_attrs)
      assert supplier == Supply.get_supplier!(supplier.id)
    end

    test "delete_supplier/1 deletes the supplier" do
      supplier = supplier_fixture()
      assert {:ok, %Supplier{}} = Supply.delete_supplier(supplier)
      assert_raise Ecto.NoResultsError, fn -> Supply.get_supplier!(supplier.id) end
    end

    test "change_supplier/1 returns a supplier changeset" do
      supplier = supplier_fixture()
      assert %Ecto.Changeset{} = Supply.change_supplier(supplier)
    end
  end
end

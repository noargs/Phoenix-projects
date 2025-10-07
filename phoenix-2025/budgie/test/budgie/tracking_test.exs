defmodule Budgie.TrackingTest do
  use Budgie.DataCase
  import Budgie.TrackingFixtures
  alias Budgie.Tracking

  describe "budgets" do
    alias Budgie.Tracking.Budget

    test "create_budget/1 with valid data creates budget" do
      user = Budgie.AccountsFixtures.user_fixture()

      valid_attrs = valid_budget_attributes(%{creator_id: user.id})

      assert {:ok, %Budget{} = budget} = Tracking.create_budget(valid_attrs)
      assert budget.name == "weekly budget"
      assert budget.description == "my budget described"
      assert budget.start_date == ~D[2025-08-01]
      assert budget.end_date == ~D[2025-08-31]
      assert budget.creator_id == user.id
    end

    test "create_budget/1 requires name" do
      attrs =
        valid_budget_attributes()
        |> Map.delete(:name)

      assert {:error, %Ecto.Changeset{} = changeset} = Tracking.create_budget(attrs)
      assert changeset.valid? == false
      assert Keyword.keys(changeset.errors) == [:name]
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "create_budget/1 requires valid dates" do
      attrs =
        valid_budget_attributes()
        |> Map.merge(%{
          start_date: ~D[2025-08-01],
          end_date: ~D[2025-07-01]
        })

      assert {:error, %Ecto.Changeset{} = changeset} =
               Tracking.create_budget(attrs)

      assert changeset.valid? == false
      assert %{end_date: ["must end after start date"]} = errors_on(changeset)
    end

    # test "list_budgets/0 returns all budgets" do
    #   budgets = insert_pair(:budget)
    #   assert Tracking.list_budgets() == without_preloads(budgets)
    # end
  end
end

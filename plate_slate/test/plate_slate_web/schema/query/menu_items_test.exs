defmodule PlateSlateWeb.Schema.Query.MenuItemsTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  {
    menuItems {
      name
    }
  }
  """
  test "menuItems field returns menu items" do
    conn = build_conn()
    conn = get conn, "/api", query: @query
    assert json_response(conn, 200) == %{"data" => %{"menuItems" => [
      %{"name" => "Bánh mì"},
      %{"name" => "Chocolate Milkshake"},
      %{"name" => "Croque Monsieur"},
      %{"name" => "French Fries"},
      %{"name" => "Lemonade"},
      %{"name" => "Masala Chai"},
      %{"name" => "Muffuletta"},
      %{"name" => "Papadum"},
      %{"name" => "Pasta Salad"},
      %{"name" => "Reuben"},
      %{"name" => "Soft Drink"},
      %{"name" => "Vada Pav"},
      %{"name" => "Vanilla Milkshake"},
      %{"name" => "Water"}
    ]}}
  end

  @query """
  {
    menuItems(filter: {name: "reu"}) {
      name
    }
  }
  """
  test "menuItems field returns menu items filtered by name" do
    conn = build_conn()
    conn = get conn, "/api", query: @query
    assert json_response(conn, 200) == %{
      "data" => %{
        "menuItems" => [
          %{"name" => "Reuben"},
#          %{"name" => "Croque Monsieur"},
#          %{"name" => "Muffuletta"},
#          %{"name" => "Bánh mì"},
#          %{"name" => "Vada Pav"},
#          %{"name" => "French Fries"},
#          %{"name" => "Papadum"},
#          %{"name" => "Pasta Salad"},
#          %{"name" => "Water"},
#          %{"name" => "Soft Drink"},
#          %{"name" => "Lemonade"},
#          %{"name" => "Masala Chai"},
#          %{"name" => "Vanilla Milkshake"},
#          %{"name" => "Chocolate Milkshake"},

        ]
      }
    }
  end

  @query """
  {
    menuItems(filter: 123) {
      name
    }
  }
  """
  test "menuItems field returns errors when using a bad value" do
    response = get(build_conn(), "/api", query: @query)
    assert %{"errors" => [
      %{"message" => message}
    ]} = json_response(response, 200)
    assert message == "Argument \"filter\" has invalid value 123."
  end


  @query """
  query ($filter: MenuItemFilter) {
    menuItems(filter: $filter) {
      name
    }
  }
  """
  @variables %{"filter" => %{"name" => "reu"}}
  test "menuItems field filters by name when using a variable" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert json_response(response, 200) == %{
      "data" => %{
        "menuItems" => [
          %{"name" => "Reuben"}
        ]
      }
    }
  end

  @query """
  {
    menuItems(order: DESC) {
      name
    }
  }
  """
  test "menuItems field returns items descending using literals" do
    response = get(build_conn(), "/api", query: @query)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Water"} | _]}
    } = json_response(response, 200)
  end


  # SortOrder automatically converts to title case "sort_order" which
  # is a type for "order"
  # exclamation mark ! tells the GraphQL developer that variables is mandatory
  @query """
  query ($order: SortOrder!){
    menuItems(order: $order){
      name
    }
  }
  """
  @variables %{"order" => "DESC"}
  test "menuItems field returns items descending using variables" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Water"} | _]}
    } = json_response(response, 200)
  end

  @query """
  {
    menuItems(filter: {category: "Sandwiches", tag: "Vegetarian"}){
      name
    }
  }
  """
  test "menuItems field returns menuItems, filtering with a literal" do
    response = get(build_conn(), "/api", query: @query)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}
    } == json_response(response, 200)
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{"tag" => "Vegetarian", "category" => "Sandwiches"}}
  test "menuItems field returns menuItems, filtering with a variables" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{
      "data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}
    } == json_response(response, 200)
  end

  @query """
  query($filter: MenuItemFilter!) {
    menuItems(filter: $filter){
      name
    }
  }
  """
  @variables %{filter: %{"addedBefore" => "not-a-date"}}
  test "menuItems filtered by custom scalar with error" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{"errors" => [%{"locations" => [
      %{"column" => 0, "line" => 2 }], "message" => message}
    ]} = json_response(response, 400)
    expected = """
    Argument "filter" has invalid value $filter.
    In field "addedBefore": Expected type "Date", found "not-a-date".\
    """
    assert expected == message
  end


end






























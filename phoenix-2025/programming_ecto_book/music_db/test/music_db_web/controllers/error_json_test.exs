defmodule MusicDBWeb.ErrorJSONTest do
  use MusicDBWeb.ConnCase, async: true

  test "renders 404" do
    assert MusicDBWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert MusicDBWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end

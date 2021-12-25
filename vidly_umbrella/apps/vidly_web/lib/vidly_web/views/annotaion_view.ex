defmodule VidlyWeb.AnnotaionView do
  use VidlyWeb, :view

  def render("annotation.json", %{annotaion: annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: render_one(annotation.user, VidlyWeb.UserView, "user.json")
    }
  end

end

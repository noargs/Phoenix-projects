defmodule Vidly.MultimediaFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vidly.Multimedia` context.
  """

  @doc """
  Generate a video.
  """
  def video_fixture(attrs \\ %{}) do
    {:ok, video} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title",
        url: "some url"
      })
      |> Vidly.Multimedia.create_video()

    video
  end
end

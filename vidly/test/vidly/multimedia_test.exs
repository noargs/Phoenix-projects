defmodule Vidly.MultimediaTest do
  use Vidly.DataCase

  alias Vidly.Multimedia

  describe "videos" do
    alias Vidly.Multimedia.Video

    import Vidly.MultimediaFixtures

    @invalid_attrs %{description: nil, title: nil, url: nil}

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Multimedia.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Multimedia.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      valid_attrs = %{description: "some description", title: "some title", url: "some url"}

      assert {:ok, %Video{} = video} = Multimedia.create_video(valid_attrs)
      assert video.description == "some description"
      assert video.title == "some title"
      assert video.url == "some url"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Multimedia.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()
      update_attrs = %{description: "some updated description", title: "some updated title", url: "some updated url"}

      assert {:ok, %Video{} = video} = Multimedia.update_video(video, update_attrs)
      assert video.description == "some updated description"
      assert video.title == "some updated title"
      assert video.url == "some updated url"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Multimedia.update_video(video, @invalid_attrs)
      assert video == Multimedia.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Multimedia.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Multimedia.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Multimedia.change_video(video)
    end
  end
end

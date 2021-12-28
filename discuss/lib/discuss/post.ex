defmodule Discuss.Post do
  @moduledoc """
  The Post context
  Mostly public
  Post context can only access Discuss.Post.Topic
  """

  alias Discuss.Repo
  alias Discuss.Post.Topic


  def get_topic(id) do
    Topic
    |> Repo.get(id)
  end

  def get_topic!(id) do
    Topic
    |> Repo.get!(id)
  end

  def list_topics do
    Repo.all(Topic)
  end

  def change_topic(%Topic{} = topic) do
    Topic.changeset(topic, %{})
  end

  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end



end

defmodule Discuss.Post do
  @moduledoc """
  The Post context
  Mostly public
  Post context can only access Discuss.Post.Topic
  """

  alias Discuss.Repo
  alias Discuss.Post.Topic


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

end

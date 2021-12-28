defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Post
  alias Discuss.Post.Topic

  def index(conn, _params) do
    topics = Post.list_topics()
    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Post.change_topic(%Topic{})
    render(conn, "new.html", changeset: changeset)
  end


  @doc """
      def create(conn, params) do
        IO.inspect(params)
      end

  params will give you map of "_csrf_token" as well as "topic"

      %{
      "_csrf_token" => "JR0eKTYpLDx7S1cAHCUKDxFibDUGMwl9aTDezSmJB36WriDdF19zEeQ6",
      "topic" => %{"title" => "Hello topic"}
      }

  "topic" => topic_params
  topic_params -> %{"title" => "Hello topic"}

  [Success case]
  Post.create_topic(topic_params) will return following
  Topic struct map (i.e. Record from database)
      %Discuss.Post.Topic{
      __meta__: #Ecto.Schema.Metadata<:loaded, "topics">,
      id: 1,
      inserted_at: ~N[2021-12-26 03:58:15],
      title: "JS Frameworks",
      updated_at: ~N[2021-12-26 03:58:15]
      }

  [Failed case]
  Post.create_topic(topic_params) will return following changeset
      #Ecto.Changeset<
      action: :insert,
      changes: %{},
      errors: [title: {"can't be blank", [validation: :required]}],
      data: #Discuss.Post.Topic<>,
      valid?: false
      >
  """
  def create(conn, %{"topic" => topic_params}) do
    case Post.create_topic(topic_params) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "#{topic.title |> String.slice(0..14)}... created!")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


  def edit(conn, %{"id" => topic_id}) do
    topic = Post.get_topic(topic_id)
    changeset = Post.change_topic(topic)

    render(conn, "edit.html", topic: topic, changeset: changeset)
  end

  @doc """
  "topic" => topic_params will give us updated topic
  from 'put request'

  But we still need to grab old topic from database with
      Post.get_topic(topic_id)

  Both old and new topic will be given to changeset through
      Post.update_topic(old_topic, new_topic_plucked_from_params)
  """
  def update(conn, %{"id" => topic_id, "topic" => topic_params}) do
    topic = Post.get_topic(topic_id)

    case Post.update_topic(topic, topic_params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated successfully.")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", topic: topic, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    topic = Post.get_topic!(topic_id)

    {:ok, _topic} = Post.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted successfully.")
    |> redirect(to: Routes.topic_path(conn, :index))
  end

end







































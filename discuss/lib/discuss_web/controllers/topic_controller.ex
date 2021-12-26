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

end

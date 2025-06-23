## Blog    
    
```bash
$ mix ecto.create
$ mix ecto.migrate
$ iex -S mix phx.server
```       
    
### Check Route   
```elixir
$ mix phx.routes
Generated blog app
  GET     /                                      BlogWeb.PageController :home
  GET     /articles                              BlogWeb.ArticleController :index
  GET     /articles                              BlogWeb.ArticleController :index
  GET     /articles/:id/edit                     BlogWeb.ArticleController :edit
  GET     /articles/new                          BlogWeb.ArticleController :new
  GET     /articles/:id                          BlogWeb.ArticleController :show
  POST    /articles                              BlogWeb.ArticleController :create
  PATCH   /articles/:id                          BlogWeb.ArticleController :update
  PUT     /articles/:id                          BlogWeb.ArticleController :update
  DELETE  /articles/:id                          BlogWeb.ArticleController :delete
  GET     /dev/dashboard/css-:md5                Phoenix.LiveDashboard.Assets :css
  GET     /dev/dashboard/js-:md5                 Phoenix.LiveDashboard.Assets :js
  GET     /dev/dashboard                         Phoenix.LiveDashboard.PageLive :home
  GET     /dev/dashboard/:page                   Phoenix.LiveDashboard.PageLive :page
  GET     /dev/dashboard/:node/:page             Phoenix.LiveDashboard.PageLive :page
  *       /dev/mailbox                           Plug.Swoosh.MailboxPreview []
  WS      /live/websocket                        Phoenix.LiveView.Socket
  GET     /live/longpoll                         Phoenix.LiveView.Socket
  POST    /live/longpoll                         Phoenix.LiveView.Socket
```    
    
### Create Route    
```elixir
# Create route in `lib/blog_web/router.ex`
scope "/", BlogWeb do
    pipe_through :browser

    # get "/", PageController, :home
    get "/articles", ArticleController, :index
end   
```    
    
### Create Controller   
```elixir 
# Create controller at `lib/blog_web/controller/article_controller.ex`
defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
```      
    
### Create Html view    
```elixir 
# create html view at `lib/blog_web/controllers/article_html.ex`
defmodule BlogWeb.ArticleHTML do
  use BlogWeb, :html

  embed_templates "article_html/*"
end
```    
    
### Create Html template
```heex
<%!--  create html template at `lib/blog_web/controllers/article_html/index.html.heex`   --%>
<h1 class="text-lg text-brand">
    Hello Phoenix
</h1>
```       
    
### Generate Schema (model | context, schema | Table)    
```bash
$ mix phx.gen.schema MyBlog.Article articles title:string body:text
  * creating lib/blog/my_blog/article.ex
  * creating priv/repo/migrations/20240311211707_create_articles.exs

Remember to update your repository by running migrations:

    $ mix ecto.migrate
```    
- Above command created two new files, **1. Schema file** `lib/blog/my_blog/article.ex`. **2. Migration file** `priv/repo/migrations/<timestamp>_create_articles.exs`    
    
```elixir
defmodule Blog.MyBlog.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :title, :string
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
  end
end
```    
    
> Now run command `$ mix ecto.migrate` to migrate the above Article Schema    
    
### Spin Ecto in iex and (insert)    
```bash
# Spin ecto by `iex -S mix`
iex(1)> alias Blog.MyBlog.Article
Blog.MyBlog.Article
iex(2)> alias Blog.Repo
Blog.Repo
iex(3)> article = Repo.insert(%Article{title: "Hello Phoenix", body: "I am on Phoenix!"})
[debug] QUERY OK source="articles" db=5.4ms decode=1.2ms queue=1.2ms idle=1222.6ms
INSERT INTO "articles" ("title","body","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Hello Phoenix", "I am in Phoenix", ~U[2025-06-19 08:38:31Z], ~U[2025-06-19 08:38:31Z]]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
{:ok,
 %Blog.MyBlog.Article{
   __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
   id: 1,
   title: "Hello Phoenix",
   body: "I am on Phoenix!",
   inserted_at: ~U[2025-06-19 08:38:31Z],
   updated_at: ~U[2025-06-19 08:38:31Z]
 }}
```    
    
### Spin Ecto in iex and (get one)  
```bash
iex(5)> Repo.get!(Article, 1)
[debug] QUERY OK source="articles" db=0.8ms queue=0.4ms idle=1284.0ms
SELECT a0."id", a0."title", a0."body", a0."inserted_at", a0."updated_at" FROM "articles" AS a0 WHERE (a0."id" = $1) [1]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
%Blog.MyBlog.Article{
  __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
  id: 1,
  title: "Hello Phoenix",
  body: "I am in Phoenix",
  inserted_at: ~U[2025-06-19 08:38:31Z],
  updated_at: ~U[2025-06-19 08:38:31Z]
}
```      
    
### Spin Ecto in iex and (get all)  
```bash
iex(6)> Repo.all(Article)
[debug] QUERY OK source="articles" db=1.8ms queue=1.2ms idle=1074.3ms
SELECT a0."id", a0."title", a0."body", a0."inserted_at", a0."updated_at" FROM "articles" AS a0 []
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
[
  %Blog.MyBlog.Article{
    __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
    id: 1,
    title: "Hello Phoenix",
    body: "I am in Phoenix",
    inserted_at: ~U[2025-06-19 08:38:31Z],
    updated_at: ~U[2025-06-19 08:38:31Z]
  }
]
```    
     
### Show list of Articles in website   
```elixir
# create `MyBlog` context at `lib/blog/my_blog.ex`   
defmodule Blog.MyBlog do
  import Ecto.Query, warn: false

  alias Blog.Repo
  alias Blog.MyBlog.Article

  def list_articles() do
    Repo.all(Article)
  end
end
```    
     
#### Change the controller index action    
```elixir
defmodule BlogWeb.ArticleController do
  use BlogWeb, :controller

  alias Blog.MyBlog

  def index(conn, _params) do
    articles = MyBlog.list_articles()
    render(conn, :index, articles: articles)
  end
end
```     
    
#### Change the template index    
```heex
<%!--  create html template at `lib/blog_web/controllers/article_html/index.html.heex`   --%>
<h1 class="text-lg text-brand">
    Hello Phoenix
</h1>
<ul class="pt-5">
    <%= for article <- @articles do %>
    <li>
        <%= article.title %>
    </li>
    <% end %>
</ul>
```    
    
## CRUD    
change route `ArticleController`'s **get** into **resources**    
```elixir
 scope "/", BlogWeb do
    pipe_through :browser

    #get "/", ArticleController, :index
    resources "/articles", ArticleController
  end
```   
   
Run `mix phx.routes` to check your routes    
   
# Adding a second context (model)    
    
```bash
 $ mix phx.gen.context MyBlog Comment comments commenter:string body:text article_id:references:articles
```     
    
**Fix Comments' migration to `delete_all` after Article deleted**     

```elixir
# change the line in `priv/migrations/20250620045822_create_comments`
def change do
    create table(:comments) do
      add :commenter, :string
      add :body, :text
      add :article_id, references(:articles, on_delete: :delete_all)
```      
      
**Run `$ mix ecto.migrate`**       
    
## Create relationship (Associating models Comment and Article)      
create relationship of Comments (`belongs_to` an Article) and Article (`has_many` Comments)        
     
### Comment *belongs_to* an Article
     
```elixir
# change the line in `lib/blog/my_blog/comment.ex`
defmodule Blog.MyBlog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :body, :string
    field :commenter, :string
    belongs_to :article, Blog.MyBlog.Article

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:commenter, :body, :article_id])
    |> validate_required([:commenter, :body])
    |> assoc_constraint(:article)
  end
end
```   
   
### Article *has_many* Comments   
```elixir   
defmodule Blog.MyBlog.Article do
  use Ecto.Schema
  import Ecto.Changeset

  schema "articles" do
    field :title, :string
    field :body, :string
    has_many :comments, Blog.MyBlog.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> validate_length(:body, min: 10)
  end
end    
```    
    
### Ecto; Insert Article and Comment into database    

```bash
iex(1)> alias Blog.MyBlog.Article
Blog.MyBlog.Article

iex(2)> article = %Article{title: "Comment belongs_to Article and Article has_many Comments", body: "Has many comments"}
%Blog.MyBlog.Article{
  __meta__: #Ecto.Schema.Metadata<:built, "articles">,
  id: nil,
  title: "Comment belongs_to Article and Article has_many Comments",
  body: "Has many comments",
  comments: #Ecto.Association.NotLoaded<association :comments is not loaded>,
  inserted_at: nil,
  updated_at: nil
}

iex(3)> alias Blog.Repo
Blog.Repo

iex(4)> article = Repo.insert!(article)
[debug] QUERY OK source="articles" db=6.4ms decode=1.3ms queue=2.9ms idle=607.8ms
INSERT INTO "articles" ("title","body","inserted_at","updated_at") VALUES ($1,$2,$3,$4) RETURNING "id" ["Comment belongs_to Article and Article has_many Comments", "Has many comments", ~U[2025-06-20 05:11:51Z], ~U[2025-06-20 05:11:51Z]]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
%Blog.MyBlog.Article{
  __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
  id: 3,
  title: "Comment belongs_to Article and Article has_many Comments",
  body: "Has many comments",
  comments: #Ecto.Association.NotLoaded<association :comments is not loaded>,
  inserted_at: ~U[2025-06-20 05:11:51Z],
  updated_at: ~U[2025-06-20 05:11:51Z]
}

iex(5)> comment = Ecto.build_assoc(article, :comments, %{commenter: "First commenter", body: "Sweet article"})
%Blog.MyBlog.Comment{
  __meta__: #Ecto.Schema.Metadata<:built, "comments">,
  id: nil,
  body: "Sweet article",
  commenter: "First commenter",
  article_id: 3,
  article: #Ecto.Association.NotLoaded<association :article is not loaded>,
  inserted_at: nil,
  updated_at: nil
}

iex(6)> Repo.insert!(comment)
[debug] QUERY OK source="comments" db=4.1ms queue=1.0ms idle=1138.5ms
INSERT INTO "comments" ("body","commenter","article_id","inserted_at","updated_at") VALUES ($1,$2,$3,$4,$5) RETURNING "id" ["Sweet article", "First commenter", 3, ~U[2025-06-20 05:26:41Z], ~U[2025-06-20 05:26:41Z]]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
%Blog.MyBlog.Comment{
  __meta__: #Ecto.Schema.Metadata<:loaded, "comments">,
  id: 1,
  body: "Sweet article",
  commenter: "First commenter",
  article_id: 3,
  article: #Ecto.Association.NotLoaded<association :article is not loaded>,
  inserted_at: ~U[2025-06-20 05:26:41Z],
  updated_at: ~U[2025-06-20 05:26:41Z]
}
iex(7)>
```   
     
### Ecto; Read Article and Comment from database    

```bash
iex(7)> Repo.get(Article, article.id) |> Repo.preload(:comments)
[debug] QUERY OK source="articles" db=0.4ms queue=0.4ms idle=1317.8ms
SELECT a0."id", a0."title", a0."body", a0."inserted_at", a0."updated_at" FROM "articles" AS a0 WHERE (a0."id" = $1) [3]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
[debug] QUERY OK source="comments" db=1.9ms queue=1.4ms idle=308.6ms
SELECT c0."id", c0."body", c0."commenter", c0."article_id", c0."inserted_at", c0."updated_at", c0."article_id" FROM "comments" AS c0 WHERE (c0."article_id" = $1) ORDER BY c0."article_id" [3]
↳ :elixir.eval_external_handler/3, at: src/elixir.erl:386
%Blog.MyBlog.Article{
  __meta__: #Ecto.Schema.Metadata<:loaded, "articles">,
  id: 3,
  title: "Comment belongs_to Article and Article has_many Comments",
  body: "Has many comments",
  comments: [
    %Blog.MyBlog.Comment{
      __meta__: #Ecto.Schema.Metadata<:loaded, "comments">,
      id: 1,
      body: "Sweet article",
      commenter: "First commenter",
      article_id: 3,
      article: #Ecto.Association.NotLoaded<association :article is not loaded>,
      inserted_at: ~U[2025-06-20 05:26:41Z],
      updated_at: ~U[2025-06-20 05:26:41Z]
    }
  ],
  inserted_at: ~U[2025-06-20 05:11:51Z],
  updated_at: ~U[2025-06-20 05:11:51Z]
}
iex(8)>
```     

## Adding a route for Comments    

```elixir
# change the `lib/blog_web/router.ex`
scope "/", BlogWeb do
  pipe_through :browser

  get "/", PageController, :home
  get "/articles", ArticleController, :index
  resources "/articles", ArticleController do
    resources "/comments", CommentController
  end
end
```        

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

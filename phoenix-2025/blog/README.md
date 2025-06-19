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

### PlateSlate.  
    
 ```bash
$ mix phx.new plate_slate --no-install --adapter cowboy
 ```   

 ### Dependencies added 
```elixir
  {:absinthe, "~> 1.7"},
  {:absinthe_plug, "~> 1.5"},
  {:absinthe_phoenix, "~> 2.0"},
  {:absinthe_relay, "~> 1.5"}
```
    
* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`      

<img src="../../img/graphql_overview.png" alt="Graphql request response overview">    
    
 GraphQL schemas are more than just structural metadata and actually define behavior, they’re the API implementation itself.    
    
To build a GraphQL API, you’ll need to construct a GraphQL schema, which defines its domain model and how data is retrieved.     

Query from client look as follows:
```graphql
{
  menuItems {
    name 
  }
}
```     
    
Response from server will look as follow:
```elixir
{
  "data": {
    "menuItems": [
      {"name": "Reuben"},
      {"name": "Croque Monsieur"}, {"name": "Muffuletta"}
    ] 
  }
}
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

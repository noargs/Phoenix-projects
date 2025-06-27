### Gist   
    
```bash
$ mix phx.new elixir_gist --no-install --binary-id

$ mix deps.get

$ mix phx.gen.auth Accounts User users  # press `Y` for `Do you want to create a LiveView based authentication system?` 

$ mix ecto.setup   # its a collection of two commands `mix ecto.create` and `mix ecto.migrate`

$ mix phx.gen.context Gists Gist gists user_id:references:users name:string description:text markup_text:text
```    
     
### Recover Postgres Docker passowrd      
```bash
$ docker ps    

# here your `NAMES` (i.e. `bs_db_local`) from above command
# Scroll up to find `Env` variable and your `POSTGRES_USER/PASSWORD`
$ docker inspect bs_db_local   
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

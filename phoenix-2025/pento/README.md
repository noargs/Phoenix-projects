### Pento.     
     
```bash
$ mix phx.new pento
$ mix ecto.create
$ mix phx.gen.auth Accounts User users
$ mix phx.gen.live Catalog Product products \
  name:string description:string unit_price:float sku:integer:unique
$ mix run priv/repo/seeds.ex
```     
    
### Components    
Components can be found in `deps/phoenix/priv/templates/*`.  
```elixir
<.header>
Listing Products ...
</header>

<.header class="bold" > Listing Products
...
</header>

def header(assigns) do
  ~H"""
<%= @class %> """
end
```   
    
The `header/1` function component implements <ins>three slots</ins> for rendering custom content.     
1. **inner block**:  Its default slot. Any content in between `<.header>` that isn't encapsulated in named slot like `<:actions>` becomes the value of `@inner_block`. It renders the @inner_block assignment like this: `<%= render_slot(@inner_block) %>`
2. **subtitle**, `<%= render_slot(@subtitle) %>`  
3. and **actions** slots: `<%= render_slot(@actions) %>`    

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

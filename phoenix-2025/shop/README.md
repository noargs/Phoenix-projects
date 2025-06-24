## Shop

```bash
$ mix phx.gen.schema Product products name:string slug:string:unique console:enum:pc:xbox:nintendo:playstation
```.  
    
```bash
$ mix phx.gen.context Consoles Console consoles name:string price:integer 
```    
    
```bash
$ mix phx.gen.html Promotions Promotion promotions name:string code:string:unique expires_at:utc_datetime
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

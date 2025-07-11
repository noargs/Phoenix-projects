## Products     
    
```bash
$ mix phx.new products --binary-id --no-assets --no-gettext --no-html --no-live --no-mailer

$ mix ecto.create
```     


### Domain-driven design     
     
- **Supply context:** this covers the supply side, i.e. describes how the suppliers organize their offerings. This doesn’t necessarily match how our business organizes the products internally, or how we organize them when we present them to customers—more on that soon.    
   
  – **Supplier schema:** the suppliers table will hold information about the supplier companies.    
  
  – **Brand schema:** the brands table will hold information about the brands of products that suppliers trade products in.     
  
  – **Family schema:** the families table will hold information about the product families related to each brand.
  
- **Catalog context:** this covers the list of products that our trading business distributes, i.e.    
   
  – **Variant schema:** the variants table will hold information about the product variants of each family.     
  
  – **KitComposition schema:** the kit_composition association table will hold information about the composition of a kit, i.e. the parent variant representing a kit, the component variants it includes, and their respective quantities.     
      
      
> In the split of context above, it is a fair observation that a **Variant** is actually what a supplier offers. However, since we will also be creating our own variants by “breaking bulk”, recombining, and bundling items, we move the **Variant** schema to the **Catalog** context. Thus, **Supply** and **Catalog** represent the two sides of the domain boundary,    
> with **Supply** representing the upstream, supplier-facing domain, and **Catalog** representing the downstream, sales-facing domain.    
    
- **Taxonomy context:** this organizes variants and/or families (TBD which one, or both) in high-level groups:     
     
  - **Category schema:** the categories table will hold information about our own company-internal, harmonized grouping of product families across suppliers.     

     
```bash
$ mix phx.gen.json Supply Supplier suppliers tin:string name:string discount:integer
```     
    
Add the resource to the  `/api` scope in `lib/products_web/router.ex`   
```elixir
  resources "/suppliers", SupplierController, except: [:new, :edit]
```    
    
```bash
$ mix ecto.migrate
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

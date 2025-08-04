### MyApp     
Created this simple mix project by running `mix new my_app --sup` to add Ecto manually to demonstrate how to add Ecto to your non-phoenix App.      
    
> Notice the **--sup** above while creating mix project `my_app`. This because Ecto does all of its work in separate OTP processes. It needs to be part of a supervision tree to make sure that it starts up correctly and restarted if a process fails.  
> **--sup** also generate `application.ex` file  

### 1. Add Ecto's Dependencies    
```elixir
defp deps do
  [
    # use `myxql` driver if using MySQL/MariaDB
    {:postgrex, ">= 0.0.0"},
    {:ecto_sql, "~> 3.10"}
  ]        
```     
     
### 2. Create Repo module     
at `lib/my_app/repo.ex`, **use** keyword will make available all the Repo functions to your module   
```elixir
defmodule MyApp.Repo do
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapters.Postgres
end 
```    
     
### 3. Add config file     
Create top level folder and then elixir script file `config/config.exs` with following contents:         
```elixir
import Config

config :my_app, MyApp.Repo, 
  database: "my_app_database",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :my_app, :ecto_repos, [MyApp.Repo]
```    
> `pool_size` default to 10 however you can increase that. you can provide `:url: ecto://UNAME:PASS@HOST/DB` instead of providing separately as above    
> For Ecto's mix tasks to find the repository we added `config :my_app, :ecto_repos, [MyApp.Repo]`     
     
### 4. Add Ecto to Supervision Tree     
Last step is to ensure repository is started when the application starts. Hence we will add repository to the *application supervision tree* by adding `MyApp.Repo` into the list of children `children = [ ]`   
```elixir
children = [
  MyApp.Repo
] 
```     
     
### 5. (Optional) Using muptiple Ecto Repos     
In case of using multiple Databases, you will have their multiple correspoding `Repo`s module.     
```elixir
# `2. Create Repo module `
defmodule MyApp.OtherRepo do
  use Ecto.Repo, otp_app: :my_app, adapter: Ecto.Adapter.Postgres
end    

# `3. Add config file`; we will add into already created `config/config.exs`
config :my_app, MyApp.OtherRepo, 
  database: "my_app_database", 
  username: "postgres", 
  password: "postgres", 
  hostname: "localhost"

config :my_app, :ecto_repos, [MyApp.Repo, MyApp.OtherRepo]

# `4. Add Ecto to Supervision Tree`
children = [MyApp.Repo, MyApp.OtherRepo]
```     
    
### 6. Start your App     
- Fetch dependencies, compile the application, 
- Test the already created database with `MyApp.Repo.aggregate` 
- or create new database with `ecto.create`     
```bash
$ mix do deps.get, compile
```    
```elixir
# Already created database, test to see if everything okay by
MyApp.Repo.aggregate("some_table", :count, :some_column)  
```    
```bash
# or create database by running 
$ mix ecto.create
```




**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `my_app` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:my_app, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/my_app>.


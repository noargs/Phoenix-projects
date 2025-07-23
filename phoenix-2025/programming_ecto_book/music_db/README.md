## MusicDB     
    
MusicDB app contains four tables, `artists`, `albums`, `tracks`, and `generes`    
    
**Association between tables**    
- Artist <ins>has_many</ins> Albums    
- An Album <ins>has_many</ins> Tracks   
- Albums have a <ins>many-to-many</ins> relationship with Generes    

```bash
# Created MusicDB app by running following command:
# `lib/music_db_web` is redundant
$ mix phx.new music_db --no-assets --no-dashboard --no-esbuild --no-gettext --no-html --no-live --no-mailer --no-tailwind  

$ mix ecto.create

$ mix phx.gen.schema Artist artists name:string birth_data:date death_date:date

$ mix phx.gen.schema Album albums title:string artist_id:references:artists

$ mix phx.gen.schema Track tracks title:string duration:integer index:integer number_of_plays:integer album_id:references:albums

$ mix phx.gen.schema Genre genres name:string wiki_tag:string

$ mix ecto.gen.migration create_albums_genres

$ mix phx.gen.schema Log logs operation:string item:map changes:map

$ mix ecto.gen.migration create_albums_with_embeds

$ mix ecto.gen.migration create_notes_tables

$ mix ecto.gen.migration create_notes_join_tables

$ mix ecto.migrate

$ mix run priv/repo/seeds.ex
```    
    
> Run `mix ecto.reset` if come across any error related to database    
> Any code which is unable to write in IEx shell, you can write in `priv/repo/playground.exs` and run `mix run priv/repo/playground.exs` to get the result.    
     
### Data Model of this App     
- artits    
- albums    
- tracks   
- genres     

**Association**      
- an `artist` can have many `albums` (one-to-many / has many) 
- an `album` can have many `tracks` (one-to-many / has many)    
- `albums` have a <ins>many-to-many</ins> relationship with `genres`           
      
### Repository pattern    
Ecto follows the Repository pattern. All communication to and fro with the database happens through module name `Repo`. This is called Repository pattern. The main characteristics of this pattern is the presence of a single module or class, called the Repository (`Repo`), through which all the communication with the database passes.      
      
> If you are using `_all` (i.e. `insert_all` or `update_all` etc) functions then you may get an error of **null value in column "updated_at"/"inserted_at"**. Hence you have to provide the timestamp for both `inserted_at` and `updated_at`. (You can also provide multiple values via List instead of maps as shown below)
```elixir
Repo.insert_all(Post, %{
  title: "My post", 
  inserted_at: DateTime.utc_now(),
  updated_at: DateTime.utc_now()
})

Repo.insert_all(Post, [
  title: "My post", 
  inserted_at: DateTime.utc_now(),
  updated_at: DateTime.utc_now()
])
```      
     
### SQL vanilla query    
To use SQL Vanilla Query as follows:
```elixir
Ecto.Adapters.SQL.query(Repo, "select * from posts")
```     
    
Ecto also makes the function available through Repo as follows:   
```elixir
Repo.query("select * from posts")
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

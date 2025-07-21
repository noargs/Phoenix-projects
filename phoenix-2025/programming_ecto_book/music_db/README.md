## MusicDb     
    
MusicDb app contains four tables, `artists`, `albums`, `tracks`, and `generes`    
    
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

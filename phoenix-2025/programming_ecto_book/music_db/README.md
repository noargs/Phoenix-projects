# Ecto     
Ecto is split into 4 main components:

- **Ecto.Repo** - repositories are wrappers around the data store.
      Via the repository, we can create, update, destroy and query
      existing entries. A repository needs an adapter (postgrex or myxql) and credentials
      to communicate to the database. (Configuration for the Repo must be in your application environment, usually defined in your `config/config.exs`)

- **Ecto.Schema** - schemas are used to map external data into Elixir
      structs. We often use them to map database tables to Elixir data but
      they have many other use cases

- **Ecto.Query** - written in Elixir syntax, queries are used to retrieve
      information from a given repository. Ecto queries are secure and composable

- **Ecto.Changeset** - changesets provide a way to track and validate changes
      before they are applied to the data

  In summary:

    * `Ecto.Repo` - **where** the data is
    * `Ecto.Schema` - **what** the data is
    * `Ecto.Query` - **how to read** the data
    * `Ecto.Changeset` - **how to change** the data


## MusicDB     
    
MusicDB app contains four tables, `artists`, `albums`, `tracks`, and `generes`    
    
**Association between tables**    
- Artist <ins>has_many</ins> Albums    
- An Album <ins>has_many</ins> Tracks   
- Albums have a <ins>many-to-many</ins> relationship with Generes    
     
<img src="./images/entity_relationship.png" alt="Entity Relationship">     

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
> Run example code by `mix run priv/examples/[filename].exs`      
     
Repo module in `lib/music_db/repo.ex` has option `otp_app: :music_db`      
```elixir
defmodule MusicDB.Repo do
  use Ecto.Repo,
  otp_app: :music_db,
  adapter: Ecto.Adapters.Postgres
end
```      
Above option `otp_app: :music_db` tells the Ecto where to look for configuration values it needs to connect to your database. That can be found in `config/dev.exs` as follows      
```elixir
config :music_db, MusicDB.Repo,
  database: "music_db",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"  
```         
     
You can also provide above information as a single url parameter. The format of the URL should be `ecto://USERNAME:PASSWORD@HOSTNAME/DATABASE_NAME`   
```elixir
config :music_db, MusicDB.Repo,
  url: "ecto://postgres:postgres@localhost/music_db"
```      
     
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
     
### Customising the Repo     
There are several aggregate functions supplied by underlying database, in the case of Postgres,  `count`, `avg`, `min`, `max`, `sum` and so on. You can give it to `Repo.aggregate()` to invoke those underlying Database functions.   
```elixir
Repo.aggregate(table, :count, :id)
Repo.aggregate(table, :avg, :id)
Repo.aggregate(table, :min, :id)
Repo.aggregate(table, :max, :id)
Repo.aggregate(table, :sum, :id)
```    
    
If you feel the need to call them often you can define convenience functions which wrap these aggregate functions in your Repo module `lib/music_db/repo.ex`, to save some key strokes as follows:      
```elixir
defmodule MusicDB.Repo do
  ...
  def count(table), do: aggregate(table, :count, :id)
  def avg(table),   do: aggregate(table, :avg, :id)
  def min(table),   do: aggregate(table, :min, :id)
  def max(table),   do: aggregate(table, :max, :id)
  def sum(table),   do: aggregate(table, :sum, :id)
end

# Now you can call like this
Repo.count("albums")
```     
    
Another useful customisation is adding an implementation of the `init` callback. Which runs when Ecto first initialise and allow you to add or override configuration parameters. For example in case of loading a database connection URL from an environment varaible.  
```elixir
def init(_, opts) do
  {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
end
```   
     
# Query the Database   
You may have seen queries written with Ecto schemas rather than with the raw table names. Schemas (`Ecto.Schema`) aren’t necessary for writing queries (`Ecto.Query`) in Ecto (in fact, they sometimes get in the way).  

Query module uses Elixir macros to create a DSL which feels lot like Elixir. You can see below SQL query vs Ecto Query with keywork syntax.   
```sql
SELECT t.id, t.title, a.title
  FROM tracks t
  JOIN albums a ON t.album_id = a.id
  WHERE t.duration > 900;
```         
```elixir
query = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  where: t.duration > 900,
  select: [t.id, t.title, a.title]
```     
    
**Ecto provide two ways to compose queries. In above example we have 'keyword syntax' and below is 'macro syntax', however we will carry on with 'keyword syntax'.**    

```elixir
query = "tracks"
  |> join(:inner, [t], a in "albums", on: t.album_id == a.id)
  |> where([t, a], t.duration > 900)
  |> select([t, a], [t.id, t.title, a.title])
```        
    
### Keyword syntax to Query the Database     
Typing `query = from "artists", select: [:name]` in the iex will create the Ecto.Query struct (i.e. `#Ecto.Query<from a0 in "artists", select: [:name]>`). But the database hasn't been touched. when it's time to run the Query. Ecto will convert the data structure into a SQL statement for us.    
```elixir
query = from "artists", select: [:name]
#=> #Ecto.Query<from a in "artists", select: [:name]>

Ecto.Adapters.SQL.to_sql(:all, Repo, query)
#=> {"SELECT a0.\"name\" FROM \"artists\" AS a0", []}
```   
    
### to_sql()    
Item reperesenting the Repo function `:all` can be `:delete_all` or `:update_all`     

> You can also call the `to_sql` function directly as follows: 
> `Repo.to_sql(:all, query)`    

**to_sql()** can also be useful to debug the underlying SQL statement when queries produce unexpected results.   
    
### select:    
To finally run the query we will use `Repo.all(query)`     
```elixir
query = from "artists", select: [:name]
Repo.all(query)
#=> [%{name: "Miles Davis"}, %{name: "Bill Evans"},
#=> %{name: "Bobby Hutcherson"}]
```   
   
Preceding example is a shorthand version of. However as you can tell `from` is a function defined in the `Ecto.Query` module but it's not!. **`from` is a macro** 
```elixir
query = Ecto.Query.from("artists", select: [:name])
```   
   
> `from` only have one required paramter which table name `query = from "artists"`. However running this `Repo.all(query)` will give us an error and you might thing `select` is also required But it's not.   
> We will see how to omit `select` completely when we use Schema.     
    
If you are using prefixed in your database, you can also specify them in your query 
```elixir
query = from "artists", prefix: "public", select: [:name]
```     
   
> Above option behaves differently depending on the database you’re using. For PostgreSQL, this value refers to the schema where the table is located, and defaults to `public`. For MySQL, the value refers to the name of the database, and defaults to the value you specified in your Repo configuration.    
    
### where:    
We can filter the result with `where:` clause.  
```elixir
q = from "artists", where: [name: "Bill Evans"], select: [:id, :name]
Repo.all(q)
#=> [%{id: 2, name: "Bill Evans"}]
```    
    
### Passing dynamic input values into query (Protecting against SQL injection)    
Below example **wont work** even though it is valid elixir.   
```elixir
artist_name = "Bill Evans"
q = from "artists", where: [name: artist_name], select: [:id, :name]
```    
    
We need to alert the macro that we are using an expression that needs evaluating by adding **^**    
```elixir
artist_name = "Bill Evans"
q = from "artists", where: [:name, ^artist_name], select: [:id, :name]
```    
If you have complex expression you can wrap it in parentheses like this `^("Bill" <> "Evans")`   
   
Pin operator **^** performs a critical job to protect you from SQL injection attack. You can verify this by using `to_sql()` as follows:
```elixir
artist_name = "Bill Evans"
q = from "artists", where: [name: ^artist_name], select: [:id, :name]
Ecto.Adapters.SQL.to_sql(:all, Repo, q)
#=> {"SELECT a0.\"id\", a0.\"name\" FROM \"artists\" 
#=>    AS a0 WHERE (a0.\"name\" = $1)", ["Bill Evans"]} 
```
As shown above pin operator become paramterised value as `"name" = $1`    
    
### Dynamic input value and their Types   
Providing wrong type, for example, `where: [id: ^artist_id]` has **id** as a string `artist_id = "1"` will cause an error. Hence we need to instruct Ecto to make the type conversion for us, using **Ecto type function, type()**, as follows.
```elixir
artist_id = "1"
q = from "artists", where: [id: type(^artist_id, :integer)], select: [:name]
Repo.all(q)
```    
     
### Query Bindings     
You may wonder if you can use equality inside `where: [name == "Bill Evans"]`. However you cannot as Ecto doesn't know if `name` is variable, funcion or macro defined elsewhere.     

Hence we need a way to tell Ecto that `name` is a column in our `"artists"` table. which we can do this with `Query binding`. It works a lot like table aliases in SQL and effectively gives you a varaible for referring to your table throughout your query.    
```elixir 
q = from a in "artists", where: a.name == "Bill Evans", select: [:id, :name] 
```     

### Query Expression    
Ecto provides long [list](https://hexdocs.pm/ecto/Ecto.Query.API.html) of functions that you can use with `where` and other query keywords. Blow are few examples.
```elixir
# like statements
q = from a in "artists", where: like(a.name, "Miles%"), select: [:id, :name]

# checking for null
q = from a in "artists", where: is_nil(a.name), select: [:id, :name]

# checking for not null
q = from a in "artists", where: not is_nil(a.name), select: [:id, :name]

# date comparison - this finds artists added more than 1 year ago
q = from a in "artists", where: a.inserted_at < ago(1, "year"), select: [:id, :name]
```             
    
### Inserting Raw SQL     
The `fragment` function allows you to include raw SQL that get inserted verbatim into the query.   
```elixir
q = from a in "artists", 
  where: fragment("lower(?)", a.name) == "miles davis", 
  select: [:id, :name]
Ecto.Adapters.SQL.to_sql(:all, Repo, q)
#=> {"SELECT a0.\"id\", a0.\"name\" FROM \"artists\" AS a0
#=>    WHERE (lower(a0.\"name\") = 'miles davis')", []}
```    
    
You can even extend Ecto's query API by adding your own macro. if you think you will be using often as follows:    
```elixir
defmacro lower(arg) do
  quote do: fragment("lower(?)", unquote(arg))
end

# Now query can be rewritten like this:
q = from a in "artists", 
    where: lower(a.name) == "miles davis",
    select: [:id, :name]
```    
    
## Queries 

### union (like SQL Union)
As SQL provides the UNION operator which can also be performed by Ecto by adding the `union:` option to our queries.   
For this to work, the two queires need to have result sets with the same **column names** and **data type**.    
```elixir
tracks_query = from t in "tracks", select: t.title
union_query = from a in "albums", select: a.title, union: ^tracks_query

Repo.all(union_query)
```    
    
### union_all (like SQL Union All)   
With `union` the database will filter the results so that they only contain unique rows. If you are certain that your results wont contain duplicated (or you dont care if they do). then you can also use `union_all` to generate a more efficient query.  
```elixir
tracks_query = from t in "tracks", select: t.title
union_all_query = from a in "albums", select: a.title, union_all: ^tracks_query

Repo.all(union_all_query)
```      
     
### intersect
Ecto also support `INTERSECT` and `EXCEPT`. You can use `intersect:` to get a list of album titles that are also track titles  
```elixir
trackes_query = from t in "tracks", select: t.title
instersect_query = from a in "albums", select: a.title, intersect: ^tracks_query

Repo.all(trackes_query)
```   
      
### except      
And we can use `except:` to get a list of album titles that are not also track titles:   
```elixir
tracks_query = from t in "tracks", select: t.title
except_query = from a in "albums", select: a.title, except: ^tracks_query
```    
    
### order_by (asc and desc or nulls order)    
```elixir
q = from a in "artists", select: [a.name], order_by: a.name
Repo.all(q)

q = from a in "artists", select: [a.name], order_by: [desc: a.name]
Repo.all(q)

q = from t in "tracks", select: [t.album_id, t.title, t.index],
  order_by: [t.album_id, t.index]
Repo.all(q)

q = from t in "tracks", select: [t.album_id, t.title, t.index],
  order_by: [desc: t.album_id, asc: t.index]
Repo.all(q)

q = from t in "tracks", select: [t.album_id, t.title, t.index],
  order_by: [t.index, t.album_id]
Repo.all(q)

q = from t in "tracks", select: [t.album_id, t.title, t.index],
  order_by: [desc: t.album_id, asc_nulls_first: t.index]
Repo.all(q)
```      
     
### group_by and having 
```elixir
q = from t in "tracks", select: [t.album_id, sum(t.duration)],  # one row for each album
  group_by: t.album_id
Repo.all(q)

q = from t in "tracks", select: [t.album_id, sum(t.duration)],
  group_by: t.album_id,
  having: sum(t.duration) > 3600
Repo.all(q)
```    
    
### join (by default inner_join)
```elixir
q = from t in "tracks", join: a in "albums", on: t.album_id == a.id

q = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  where: t.duration > 900,
  select: [a.title, t.title]
Repo.all(q)

q = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  where: t.duration > 900,
  select: %{album: a.title, track: t.title}
Repo.all(q)

q = from t in "tracks", prefix: "public",
  join: a in "albums", prefix: "private",
  on: t.album_id == a.id, where: t.duration > 900,
  select: %{album: a.title, track: t.title}

q = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  join: ar in "artists", on: a.artist_id == ar.id,
  where: t.duration > 900,
  select: %{album: a.title, track: t.title, artist: ar.name}
Repo.all(q)
```      
    
### left_join, right_join, cross_join, and full_join
Also available  
    
    
### Multiple joins  
Elixir’s keyword lists (i.e. `join: value, on: value`) allow you to specify the same keyword more than once. so adding more joins is simply a matter of adding more `join:` and `on:` options.   
```elixir
q = from t in "tracks",
  join: a in "albums", on: t.album_id == a.id,
  join: ar in "artists", on: a.artist_id == ar.id,
  where: t.duration > 900,
  select: %{album: a.title, track: t.title, artist: ar.name}
Repo.all(q)
```     
     
### Composing queries from queries     
If we take a look at `from` and `in` in `q = from a in "albums"` we always provided string (i.e. table name like "albums" or "tracks" etc.) on the right side of `in`. However the `in` expression is actually looking for something broader than that. It is looking for any data type that has implemented the `Ecto.Queryable` protocol. This protocol specifies only one function that needs to be implemented named `to_query`. Apart from using string "albums" etc. Ecto also allows us to give it `Ecto.Query` struct. It means **in** can also accept another **query** <ins>not just a string</ins>.
```elixir
albums_by_miles = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis"  

album_query = from a in albums_by_miles, select: a.title
miles_albums = Repo.all(album_query)

track_query = from a in albums_by_miles,
  join: t in "tracks", on: a.id == t.album_id,
  select: t.title

miles_tracks = Repo.all(track_query)
```         

### Named bindings     
To create named binding. You use the `as:` keyword. You can add this to the `from` call, or to any of the `join` options.    
```elixir
albums_by_miles = from a in "albums", as: :albums,
  join: ar in "artists", as: :artists,
  on: a.artist_id == ar.id, where: ar.name == "Miles Davis"
```   
> The `as:` needs to come immediately after `from` and `join`: and you must use atoms for binding names— **strings are not allowed**. `as: "albums"` ❌ `as: :albums` ✔️ This won’t work:      
```elixir
albums_by_miles = from a in "albums", as: "albums",
  join: ar in "artists", as: "artists",
  on: a.artist_id == ar.id, where: ar.name == "Miles Davis"
#=> ** (Ecto.Query.CompileError) `as` must be a compile time atom...
```    

Now to use the named binding in another query. You add the name to the beginning of the `from` call. we also provide shorter name as `a` to `albums`. `a` is only available inside `album_query` however we can reuse `albums` anywhere we reuse the query (i.e. `album_query`):   
```elixir
album_query = from [albums: a] in albums_by_miles, select: a.title

album_query = from [artists: ar, albums: a] in albums_by_miles,
  select: [a.title, ar.name]
```   
> In **named binding** i.e. `[artists: ar, albums: a]` <ins>artists</ins> comes first eventhough it appears second in our original. This can work (As we can specify the bindings in any order) however not with **positional binding**    
    
> use **has_named_binding?(albums_by_miles, :albums)** to find out if a given query has a <ins>named binding</ins>. 
```elixir
albums_by_miles = from a in "albums", as: :albums,
  join: ar in "artists", as: :artists,
  on: a.artist_id == ar.id, where: ar.name == "Miles Davis"
has_named_binding?(albums_by_miles, :albums)
#=> true
```   
> Only use named binding if your query contains joins across several tables. Dont use it for couple of bindings
      
      
     
### Composing queries from functions    
```elixir
def albums_by_artist(artist_name) do
  from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == ^artist_name
end
albums_by_dim = albums_by_artist("Dim Hutcherson")

def by_artist(query, artist_name) do
  from a in query,
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == ^artist_name
end
albums_by_dim = by_artist("albums", "Dim Hutcherson")

def with_tracks_longer_than(query, duration) do
  from a in query,
  join: t in "tracks", on: t.album_id == a.id,
  where: t.duration > ^duration,
  distinct: true
end   

# Now we can combine. However this query is not complete without `select` 
q =
  "albums"
  |> by_artist("Miles Davis")
  |> with_tracks_longer_than(720)  

def title_only(query) do
  from a in query, select: a.title
end
q =
  "albums"
  |> by_artist("Miles Davis")
  |> with_tracks_longer_than(720)
  |> title_only
Repo.all(q)
```     
     

### Combining queries with or_where  
By default, Ecto combines `where` clause with `AND`. Following code snippet demonstrate this fact.    
```elixir
albums_by_miles = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis"

q = from [a,ar] in albums_by_miles,
  where: ar.name == "Bobby Hutcherson",
  select: a.title

Repo.to_sql(:all, q)
#=> {"SELECT a0.\"title\" FROM \"albums\" AS a0
#=> INNER JOIN \"artists\" AS a1
#=> ON a0.\"artist_id\" = a1.\"id\"
#=> WHERE (a1.\"name\" = 'Miles Davis')
#=> AND (a1.\"name\" = 'Bobby Hutcherson')", []}
```     
   
What if we wanted to get the albums that were either by Miles Davis `or` Bobby Hutcherson. We can use `or` macro supplied by the query API.  
```elixir
q = from a in "albums",
  join: ar in "artists", on: a.artist_id == ar.id,
  where: ar.name == "Miles Davis" or ar.name == "Bobby Hutcherson",
  select: %{artist: ar.name, album: a.title}
```   
    
what if we want to extend `albums_by_miles` to include Bobby Hutcherson (i.e. not <ins>miles **AND** bobby</ins> but <ins>miles **OR** bobby</ins>). we can then use `or_where`   
```elixir
q = from [a,ar] in albums_by_miles, or_where: ar.name == "Bobby Hutcherson",
  select: %{artist: ar.name, album: a.title}
Repo.all(q)
#=> [%{album: "Kind Of Blue", artist: "Miles Davis"},
#=> %{album: "Cookin' At The Plugged Nickel", artist: "Miles Davis"},
#=> %{album: "Live At Montreaux", artist: "Bobby Hutcherson"}]
```     
    
### using delete, and update with queries   
We only read the data with queries so far. We can also use update or delete with queries. Earlier we updated the timestamps in the `artists` table with the following code:    
```elixir
Repo.update_all("artists", set: [updated_at: DateTime.utc_now])
```    
We passed the string `"artists"`. However if you inspect the `update_all` it expects `Ecto.Queryable`. This means <ins>you can also pass it a query</ins>.   
Lets update the title of `"tracks"` assuming it has a spelling error.     
```elixir
q = from t in "tracks", where: t.title == "Autum Leaves"
Repo.update_all(q, set: [title: "Autumn Leaves"])

# More elixir way we can write like this
from(t in "tracks", where: t.title == "Autum Leaves")
|> Repo.update_all(set: [title: "Autumn Leaves"]) 

# Delete record
from(t in "tracks", where: t.title == "Autum Leaves")
|> Repo.delete_all
```    
    
> [!IMPORTANT]
> insert_all and delete_all functions for inserting and deleting data provided by Ecto so we can perform these actions **without schemas**.    
    
> Look at the documentation of `Ecto.Query` module to see all the <ins>keywords</ins> available and `Ecto.Query.API` to see all the <ins>utility function</ins> availables.       
    
> **Limitation** of `Ecto.Query` API is **1.** using `select` clause. if we are using the same data type often which most apps do, this could get old in a hurry **2.**  Also we have to typecast dynamic values `where: [id: type(^artist_id, :integer)],` in our queries. Fortuntely Schema can help us with both of these problems.    
    
> [!IMPORTANT]    
> So far we have used `Ecto.Query` without using `Ecto.Schema` to read/update/delete. Hence we didn't need the Schema modules which is defined in `lib/music/db/*` as `MusicDB.Band`, `MusicDB.Genre`, `MusicDB.Log`, `MusicDB.Artist` etc  
    

# Schema   
Functional programs have a set of data structures that form the backbone of the codebase.    
     
In our APP `Ecto.Schema` module can help us to map `artists`, `albums`, `tracks` tables to those data structures. You create mapping with elegant, concise DSL, then use <ins>associations</ins> to connect related structures together.     
    
We will look into <ins>how to integrate our schemas into queries</ins>, and <ins>convert some queries wrote earlier into schema-based queries</ins>. And also <ins>when to avoid using schemas altogther</ins>. And <ins>how to use associations to build relationships between database</ins>.   
    
> To find out the skeleton of Schema inside iex run the following:  
```bash
$ MusicDB.Track.__schema__(:dump)  # MusicDB.Track.__schema__(:index) # cause an error and find out parameters beside :dump

#=> %{
#=>   id: {:id, :id, :always},
#=>   index: {:index, :integer, :always},
#=>   title: {:title, :string, :always},
#=>   duration: {:duration, :integer, :always},
#=>   inserted_at: {:inserted_at, :naive_datetime, :always},
#=>   album_id: {:album_id, :id, :always},
#=>   number_of_plays: {:number_of_plays, :integer, :always},
#=>   updated_at: {:updated_at, :naive_datetime, :always}
#=>  }
```  

> If the primary key of our `tracks` table was called `track_id`, we could specify that in our schema like this:
```elixir
field :track_id, :id, primary_key: true      
```   
This uses the `:id` type to indicate that it is an integer-based primary key. We could also add the `:autogenerate` option to tell Ecto that the database will be generating this value for us. The field function has a number of other options available that can alter the field definitions. [Ecto's documentation](https://hexdocs.pm/ecto/Ecto.Schema.html#field/3)    
    
### Ecto's Data Types    
| Ecto Type | Elixir Type |
|:-------------|:-------------|
| :id   | integer |
| :binary_id | binary |
| :integer | integer |
| :float | float |
| :boolean | boolean |
| :string | UTF-8 encoded string |
| :binary | binary |
| {:array, inner_type} | list |   
| :map | map |     
| {:map, inner_type} | map |     
| :decimal | Decimal |     
| :date | Date |     
| :time | Time |     
| :naive_datetime | NaiveDateTime |     
| :utc_datetime | DateTime |          
     
The `naive_datetime` type is a datetime value that has no associated time zone information.    
If you use `utc_datetime` the value must be a DateTime struct with its time zone set to UTC.  
To create your own type you can read the [Ecto.Type](https://hexdocs.pm/ecto/Ecto.Type.html)    

As we previously saw in the example of `artist_id = "1"`. Where we had to typecast string into integet in where clause:    
```elixir
artist_id = "1"
  q = from "artists", where: [id: type(^artist_id, :integer)],
  select: [:name]
Repo.all(q)
#=> [%{name: "Miles Davis"}]
```       
And we also had to use `select:` caluse to specify the columns we needed in the result.   
**Schema can help us with both of these issues.** as it automatically typecast as well as return all the columns without using select caluse as follows:   
```elixir
alias MusicDB.Track
track_id = "1"
q = from Track, where: [id: ^track_id]
```
The return result using schema will be `%Track{}` struct instead of getting back the list or map.   
We can still use `select:` option however any fields we didn't specify in the *select* will be set to *nil*    
    
### Inserting with Schemas     
```elixir
Repo.insert_all("artists", [[name: "John Coltrane"]])
#=> {1, nil}

Repo.insert(%Artist{name: "John Coltrane"})
#=> {:ok, %MusicDB.Artist{__meta__: #Ecto.Schema.Metadata<:loaded, "artists">,
#=> id: 4, name: "John Coltrane", ...} 

Repo.insert_all(Artist, [[name: "John Coltrane"]])
#=> {1, nil}
```  
    
### Deleting with Schemas     
```elixir
Repo.delete_all("tracks")

from(t in "tracks", where: t.title == "Autum Leaves")
|> Repo.delete_all

track = Repo.get_by(Track, title: "The Moontrane")
Repo.delete(track)
#=> {:ok, %MusicDB.Track{__meta__: #Ecto.Schema.Metadata<:deleted, "tracks">,
#=> id: 28, title: "The Moontrane", ...}
```    
    
### Updating with Schemas     
Just like `Repo.insert` and `Repo.delete`, **There's also `Repo.update` function available However it uses changeset rather than schema structs to perform update** In fact the `insert` and `delete` functions <ins>returns changeset if the operation fails</ins>    

## Associations     
In Ecto we use associations to model the relationships between table. (i.e. one-to-many, one-to-one, belongs-to, many-to-many)    

### One-to-Many and One-to-One Association     
```elixir
schema "albums" do
  field :title, :string
  field :release_data, :date

  has_many :tracks, MusicDB.Track
end
```    
`has_many` call states that `%Album{}` schema will have a field called tracks. which consist of zero or more instances of the `%Track{}`. In this association, the `%Album{}` is **parent** record and `%Track{}` are the **child** records. For this to work Ecto will look for `album_id` in tracks table to connect it to albums.    

> [!NOTE]
> If tracks table uses `album_number` for example rather than default `album_id` for the foreign key then we could create the association like this:    
```elixir
has_many :tracks, MusicDB.Track, foreign_key: :album_number
```     
Ecto also provided **has_one** association which works exactly like `has_many` but limits the number of associated records to <ins>zero or one</ins>.    

### Belongs-to Associations    
Most of the time you will want your association to work in both directions. As you previously refer to tracks from an album record `has_many :track, MusicDB.Track`. Similarly you would want to refer to an album from track. Hence we will use **belongs_to** associations as the <ins>reverse of `has_many` and `has_one`</ins>             
```elixir
schema "tracks" do
  field :title, :string

  belongs_to :album, MusicDB.Album
end
```      
Again, Ecto will assume tracks table will have a field named `album_id`. However if the field has different name than a default then we can use `foreign_key:` option to specify it.
But we have another association being child in one-to-many with artists. We can set this up by adding `belongs_to` call in the `%Album{}` schema and a `has_many` call in `%Artist{}` schema as follows:    
```elixir
# in album.ex
schema "albums" do

  has_many :tracks, MusicDB.Track
  belongs_to :artist, MusicDB.Artist
end

# in artist.ex
schema "artists" do

  has_many :albums, MusicDB.Album
end
```           
The `%Album{}` schema now has associations in two directions: it `has_many` **tracks**, and it `belongs_t` **artist**.   
    
> [!NOTE]  
> `belongs_to` goes on the schema with the foreign key. for example, **tracks** has the foreign key `album_id`
> and opposite (i.e. **albums**) gets `has_many`.  
> Similarly, **albums** has the foreign key `artist_id` so it gets `belongs_to` and **artists** table gets a `has_many` for albums.      

### Nested Associations    
So far we added a `has_many` association from *artists* to *albums* and another `has_many` from *albums* to *tracks* which can look something like this:    
<img src="./images/entity_relationship2.png" alt="Entity Relationship">   
    
You may want to refer to **tracks** directly from **artists** without having to go through the **albums**. This is called a **nested association**   
   
To create nested association we will add another has_many call to the *artists* but this time we'll ass the `through:` option.   
```elixir
schema "artists" do

  has_many :albums, MusicDB.Album
  has_many :tracks, through: [:albums, :tracks]
end
```   
The `through:` option takes a list `[:albums, :tracks]` representing the steps to get from the current schema to the schema we want to associate with. Ecto first read `[:albums, ..]` and also the association `has_many :albums ...` defined in previous line. Ecto will look in that schema to find the next item, tracks. This nesting can go as deep as you need but be carefull as more than two or three levels most likely to get messy.     
Now, we can refer to an artist's `%Track{}` records directly from the `%Artist{}` record without having to go through the albums.    

> [!IMPORTANT]   
> **belongs_to** is not supported for nested association.      
     
### Many-to-Many Associations    
These relationships are not as straightforward as belongs-to relationships because you need an extra table to implement them.     
    
Example is genre and albums. Each album has many genre and each genre has many albums.      
    
Traditional way to model this relationship is to create extra table that maps the relationships between the two other tables. This is called a **join table** and look something like this:    
<img src="./images/many-to-many.png" alt="many to many relationship diagram">    

Here, the `albums_genres` table exists solely to hold the associations between albums and genres. It creates the link by holding two foreign keys, one for each table.   
Setting up the association is similar to setting up a `has_many through:` association. The critical component is the `join_through` option.
```elixir
schema "albums" do
  
  many_to_many :genres, MusicDB.Genre, join_though: MusicDB.AlbumGenre
end

schema "genres" do

  many_to_many :albums, MusicDB.Album, join_though: MusicDB.AlbumGenre
end

schema "albums_genres" do

  belongs_to :albums, MusicDB.Album
  belongs_to :genres, MusicDB.Genre
end
```   
Once this sets up, `albums` and `genres` can refer to each other without going through the `albums_genres` schema.    
   
> It is possible to tighten it up further. As <ins>we don't need to create schema</ins> for `albums_genres` table for many-to-many association to work.   
> We <ins>just need to create a table for `albums_genres`</ins> and refer to the table name in the `join_though` option    
> **Many-to-many can also be used for polymorphic associations**. 
   
```elixir
schema "albums" do
  
  many_to_many :genres, MusicDB.Genre, join_though: MusicDB.AlbumGenre
end

schema "genres" do

  many_to_many :albums, MusicDB.Album, join_though: MusicDB.AlbumGenre
end
```   
   
If you are planning to use any other fields (timestamps, or metadata etc.) beside foreign keys in your join table. Then you have to create the schema like we did previously and map the fields you are interested in:    
```elixir
schema "albums_genres" do
  field :meta_data, :map

  belongs_to :albums, MusicDB.Album
  belongs_to :genres, MusicDB.Genre
end
```   
    
### Working with Associations    
If we want to get tracks for particular album, you may incline to do the following:    
```elixir
album = Repo.get_by(Album, title: "Kind Of Blue")

album.tracks
#Ecto.Association.NotLoaded<association :tracks is not loaded>
```    
This feature is called **lazy loading** which often database libraries do. Libraries checks to see if the associated records have been loaded, when you try to refer to them. To fetch the associated records by default, by the library, can lead to performance problems as the database grows. Hence you have to explicitly load the association.   
This is also called **N+1** Query problem. Because you need **1** query to fetch the parent record (i.e. `albums`) and **N** more queries to fetch the child records (i.e. `tracks`).  
   
Ecto provides you the option for loading associated records by adding `preload` option in your query.   
``` elixir
albums = Repo.all(from a in Album, preload: :tracks)

# if you already loaded parent records and want to fetch the associations
albums = 
  Album
  |> Repo.all
  |> Repo.preload(:tracks)
```   
In both cases as shown above, you get all the album records having its associated tracks. And both cases, <ins>only two database queries</ins> are executed: **1** to fetch all the albums and **2** to fetch all the tracks.   
    
> The `preload` statements can handle the nested associations using keyword list syntax and you would get a rather large dataset
```elixir
Repo.all(from a in Artist, preload: [albums: :tracks])
```    
   
If you want to grab parent records and child records together in <ins>one query</ins>, you can use `preload` in combination with `join`. **This approach reduces the number of queries sent to the database**. But increase the amount of data that is sent back:    
```elixir
q = from a in Album,
  join: t in assoc(a, :tracks),
  where: t.title == "Freddie Freeloader",
  preload: [tracks: t]
```   
The use of `Ecto.assoc/2` function is to specify that we want to `join` on the `:tracks`, association we defined in our Album schema. By adding the reference to the *query binding* t in the `preload` option, we’re telling Ecto to load the album and track records in the same query.    

### Optimising Associations with Embedded Schemas     
Although Ecto protect us against N+1 queries, where our code is make huge number of queries even in simple operations. Even then fetching associated records always requires an extra round-trip to database. There may be situation you want to avoid it. In case, you always want your associated records to load along with parents. Or optimise the speed in preformance-critical situations. In those cases Ecto provides **embedded schemas**.   
In embedded schemas, associated records are stored in a single database column along with the rest of the parent record's values. When you load the parent record, the child records come right along with it. The implementation is database dependent.    
- As in **PostgreSQL**, Ecto uses <ins>jsonb</ins> column type to store the records as an array of key/value pairs      
- and in **MySQL**, Ecto converts the records into <ins>JSON string</ins> and stores them as a text.     
Therefore the end result is the same: the embedded records are loaded into the appropriate Elixir structs and available ins a single query without having to call `preload`.  

### Deleting records with Associations    
What should happen to child records (tracks) when a parent record (albums) is deleted? Ecto provide `on_delete:` however the exact implementation vary on the database.     
> `has_many`, `has_one`, and `many_to_many` functions all support `on_delete` options and `on_delete` can have one of three options. `:nothing`, `:nilify_all` (all child records will have parent record's foreign key to null), and `:delete_all` (delete all of the child records along with the parent record).   
     
### Using schemas to Seed a database.     
Once you’ve set up schemas for your tables, inserting new records, even records with nested associations.   

> You don't have to insert one record (i.e. `Artist`) and get the id of new record and then create the album record with `artist_id` set to the `id` of the new artist. You can insert the two records at the sametime thanks to Ecto.     
```elixir
Repo.insert(
  %Artist{
    name: "John Coltrane", 
    albums: [
      %Album{
        title: "A Love Supreme"
      } 
    ]
  } 
)

# Similarly, we can do same with deeply nested association.
Repo.insert(
  %Artist{
    name: "John Coltrane", 
    albums: [
      %Album{
        title: "A Love Supreme", 
        tracks: [
          %Track{title: "Part 1: Acknowledgement", index: 1}, 
          %Track{title: "Part 2: Resolution", index: 2}, 
          %Track{title: "Part 3: Pursuance", index: 3}, 
          %Track{title: "Part 4: Psalm", index: 4},
        ],
        genres: [
          %Genre{name: "spiritual jazz"},
        ] 
      }
    ] 
  }
)
```         
    
# Changeset   
Changeset manage the update process by breaking into three distinct steps: **casting**, **filtering**, **validating the user input** and then sending the input to the database and capture the result.       
```elixir
import Ecto.Changeset
params = %{name: "Gene Harris"}

changeset = 
  %Artist{}
  |> cast(params, [:name])
  |> validate_required([:name])

case Repo.insert(changeset) do
  {:ok, artist} -> IO.puts("Recrod for #{artist.name} was created")
  {:error, changeset} -> IO.inspect(changeset.errors)
end    
```      
     
> [!SUMMARY]      
To use **changeset without schema**; you have to create changeset with `cast` function and provide it a map of `table_map = %{column1: :type, column2: :type}` as follows:   
```elixir
table_map = %{column1: :type, column2: :type}
params = %{"column1" => "value", "column2" => "value"}   

changeset =
  {%{}, table_map}
  |> cast(params, Map.key(table_map))
  |> validate_some()
  |> some_constraint()
  |> Repo.
```
> We can run **validation** after changeset created. Other validation functions are named as **validate_[role]\()** i.e. `validate_required`, `validate_format`, `validate_number`, or `validate_length` etc. You can also create your custom validation function with the help of `validate_change(chngset, :column, fn column -> end)`. validation runs and errors are generated <ins>before</ins> data make a trip to database (<ins>**Repo** hasn't been run yet</ins>). Changeset struct has field `chngset.valid?` to check the finall results.    

> **Constraint** can run after validation. They are named as **_constraint()** i.e. `unique_constraint`, `foreign_key_constraint`. Constraint often governed by database. Hence constraint runs and errors are generated <ins>after</ins> data make a trip to database(<ins>afer running **Repo**</ins>).     

> To **run validation and constraint all at once** (for better user experience so to give end-users collections of all the errors output at once (i.e. validation errors and constraint errors), use **unsafe_validate_unique()**.     

> **Capture errors** once you already ran Repo and use `{:error, changeset} ->` body in the `case Repo.insert(chngset) do`. 

> To **update internal Data**, We use `change(chngset, column: value)` function to update new record (<ins>without association</ins>)     

> To **update external Data** (coming from spreadsheet, user form data etc), we use `cast(empt_struct{}, params, [:column1, column2])` function to update new record (<ins>without association</ins>)      

> To **update/delete internal** data <ins>with association</ins> as well as <ins>single record</ins>; we use `build_assoc(%Schema1{..}, :tbl2, tbl2_column1: "value")`        

> To **update/delete internal** data <ins>with association</ins> And <ins>collection of records</ins>; we use `put_assoc(chngset, :tbl2, [%Schema2{column: "value"}])`. You can also use map `[%{column, "value"}]` or list, `[[column: "value"]]`.     

> All the **functions which add association** to schemas (`has_many`, `belongs_to` etc) all take an optional argument called **:on_replace** which can be set to one of five different values:  
**:raise** default behaviour. if you dont provide values.     
**:mark_as_invalid** you will get changeset error instead of crash     
**:nilify** foreign key of the associated record will set to `nil`.        
**:update** can only be used with `has_on` and `belongs_to`      
**:delete** delete any child records currently associated with parent           

> To **create from external Data** data <ins>with association</ins> we use `cast_assoc(chngset, tbl2)`. We first run `cast` and then `cast_assoc`. **You must have changeset/2 function defined in tbl2 schama file**.        
    
### Creating Changesets using Internal Data    
If the data is internal to the application (that you are generating the data yourself in your application code). you can create a changeset using the `Ecto.Changeset.change`.      
> Don't forget to `import` which makes all the function in `Ecto.Changeset` available in our code.    
```elixir
import Ecto.Changeset

artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
changeset = change(artist, name: "Robert Hutcherson")
```    
We added the data we would like to change as an optional argument to the `change` function. At this point, `changeset` is just a data structure in the memory. No communication with database has taken place until Repo is involved. Before we commit the changes with `Repo.update(changeset)` we can take a peek at the changes with `changeset.changes`. Here's the full code.    
```elixir
import Ecto.Changeset

artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
changeset = change(artist, name: "Robert Hutcherson")

# only to peek
changeset.changes

# commit to database
Repo.update(changeset)
```   
We can also add more changes to changeset through `change` function which is already been created.   
```elixir
changeset = change(changeset, birth_date: ~D[1941-01-27]) 
```     
     
> It's also posible to add both changes to a single `change` call:
```elixir
artist = Repo.get_by(Artist, name: "Bobby Hutcherson")
changeset = change(artist, name: "Robert Hutcherson", birth_date: ~D[1947-01-27])
```    
In either case, calling `changes` will now show both of the values that we are updating: 
```elixir
changeset.changes
#=> %{birth_date: ~D[1941-01-27], name: "Robert Hutcherson"}
```     
    
### Creating Changesets using External Data       
As data come from external world we need to take extra care. Hence we will use `cast` function which play a simillar role to `change`, as it take raw data and return `Changeset`, However its got few extra features to make sure you are getting only the data you want.   

`cast` takes three paramters:     
     
1. A data structure represents the record you want to apply your changes to, 
    - this could be new schema struct (i.e. `%Artist{}`), 
    - or a schema fetched from the database 
    - or another changeset      

2. Second argument is a map containing raw data that you want to apply.    

3. Third argument is a list of parameters that your will allow to be added to the changeset.     

Here is how we could create a changeset for a new `Artist` record using user-supplied parameters (`param` variable represent values supplied by the user).     
    
```elixir
params = %{"name" => "Charlie Parker", 
           "birth_date" => "1920-08-29",
           "instrument" => "alto sax"
          }  
changeset = cast(%Artist{}, params, [:name, :birth_date])
changeset.changes
#=> %{birth_date: ~D[1920-08-29], name: "Charlie Parker"}
```    
When you see the results, we gave `instrument` as a `params` but it didn't come in result as not allowed values. Secondly, the call to cast converted the birth_date value from the string `"1920-08-29"` to an Elixir Date struct `~D[1920-08-29]`. As the name suggests, cast will perform type casting when turning the raw input into a changeset. By default cast function will treat the empty string "" as nil when creating the changeset. But in other times you want irelavent values to be nill i.e. (working in Spreadsheet). Sometime instead of empty cell, you get can string "NULL".    
```elixir
params = %{"name" => "Charlie Parker", "birth_date" => "NULL"} changeset = cast(%Artist{}, params, [:name, :birth_date],
            empty_values: ["", "NULL"]) 
changeset.changes
#=> %{name: "Charlie Parker"}
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

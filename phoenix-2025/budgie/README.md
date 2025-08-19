## Budgie     
```bash
$ mix phx.new --binary-id budgie     # type `Y` enter
$ mix setup
$ iex -S mix phx.server
$ mix phx.gen.auth Accounts User users --hashing-lib argon2 # liveview based auth, type `Y`
$ mix deps.get
$ mix ecto.migrate

# add `name` field in user schema `field :name, :string`
$ mix ecto.gen.migration add_user_name
```     

Below doesn't work hence alternative library which is {:argon2id_elixir, "~> 1.1"}, is used developed in Rust instead of Old C library in [`:argon2_elixir`](https://hexdocs.pm/argon2_elixir/1.2.0/Argon2.html). Below is the functions available in both. 
    
**argon2_elixir**   
```elixir
Argon2.hash_pwd_salt(password, opts \\ [])
Argon2.verify_pass(password, stored_hash)

Argon2.no_user_verify(opts \\ [])
Argon2.verify_hash(stored_hash, password, opts \\ [])
Argon2.gen_salt(salt_len \\ 16)
```    
   
**argon2id_elixir**  
```elixir 
Argon2.hash_password("secure_password123")  
Argon2.verify_password("secure_password123", hash) 
```      

> [!NOTE]    
> If you use [`argon2id_elixir`](https://hexdocs.pm/argon2id_elixir/Argon2.html) library which doesn't have equavalent of `no_user_verify()`, Which is a dummy verify function to help prevent user enumeration. It is intended to make it more difficult for any potential attacker to find valid usernames by using timing attacks. 
> You can write in Rust  



- Install **make** on windows in order to use `{:argon2_elixir, "~> 3.0"},`     
- Install **make** by running `winget install ezwinports.make` and restarting the powershell. (No need to install Chocolatey). Alternatively check MinGW at `C:\MinGW\bin` has `make.exe` in the <ins>environmental varaible</ins>.      
- Install <ins>Microsoft visual studio community 2022</ins> and <ins>build tools</ins> and also following link in your <ins>environmental varaible</ins>
```bash
C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\%YOUR_VERSION%\bin\Hostx64\x64
```       
- Also ensure above link physcial directory contain `nmake.exe` file   
- Install `https://www.msys2.org/` go to  `C:\msys64` and run `ucrt64.exe` and use **ucrt64.exe** shell. 
- Now go to `C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build` (to check if its proper path) and **run** `cmd \K C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat x64`  in your elixir project folder.    
- Finally run `mix deps.compile`

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

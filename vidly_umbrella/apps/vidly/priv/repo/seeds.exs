# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Vidly.Repo.insert!(%Vidly.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Vidly.Multimedia

for category <- ~w(Action Drama Romance Comedy Mystery Thriller AutoBiography) do
  Multimedia.create_category!(category)
end

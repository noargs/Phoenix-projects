alias MusicDB.{
  Repo,
  Artist,
  Album,
  Track,
  Genre,
  Log,
  AlbumWithEmbeds,
  ArtistEmbed,
  TrackEmbed,
  Note
}

import_if_available Ecto.Query
import_if_available Ecto.Changeset
import_if_available Ecto.Adapters.SQL   # use vanila `SQL.query(Repo, "select * from artists")`

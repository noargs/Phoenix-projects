ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Products.Repo, :manual)

Mox.defmock(Products.MockViesService, for: Products.ViesService)
Application.put_env(:products, :vies_service, Products.MockViesService)

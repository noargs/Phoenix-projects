defmodule Vidly.Multimedia.Permalink do
  @moduledoc """
  Sometime, the basic type information in our schemas
  isn't enough. In those cases, we would like to
  improve our schemas with types that have a knowledge
  of Ecto.

  For example, we might want to associate some behaviour
  to our id fields.

  A custom type allows us to do just that.

  Vidly.Multimedia.Permalink is a custom type defined
  according to the Ecto.Type behaviour. It expects us
  to define four functions:

    type: Returns the underlying Ecto type. In this case
          we are building on top of :id

    cast: Called when external data is passed into Ecto.
          It's invoked when values in queries are
          interpolated or also by the cast function in
          changeset

    dump: Invoked when data is sent to the database

    load: Invoked when data is loaded from the database.
  """
  @behaviour Ecto.Type

  def type, do: :id

  def cast(binary) when is_binary(binary) do
    case Integer.parse(binary) do
      {int, _} when int > 0 -> {:ok, int}
      _ -> :error
    end
  end

  def cast(integer) when is_integer(integer) do
    {:ok, integer}
  end

  def cast(_) do
    :error
  end

  def dump(integer) when is_integer(integer) do
    {:ok, integer}
  end

  def load(integer) when is_integer(integer) do
    {:ok, integer}
  end

end

defimpl Phoenix.Param, for: Vidly.Multimedia.Video do
  @moduledoc """
  implementing "Phoenix.Param protocol" for
  "Vidly.Multimedia.Video" struct

  This protocol requires us to implement the
  "to_param" function which receives the video
  struct itself as an argument

  Our param.ex file serve as a home for other
  protocol implementations as we continue

  Elixir protocols can be implemented for any
  data structure, we can place our implementation
  in the same file as the video definition

  Elixir protocols are used to attain polymorphisms
  """


  def to_param(%{slug: slug, id: id}) do
    "#{id}-#{slug}"
  end

end

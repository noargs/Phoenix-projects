defmodule MusicDB.SearchEngine do
  def update!(item) do
    # search engine logic happens here...
    {:ok, item}
  end

  def update(item) do
    # search engine logic happens here...
    {:ok, item}
  end

  def update(_repo, changes, extra_argument) do
    # search engine logic happends here...
    {:ok, {changes, extra_argument}}
  end
end

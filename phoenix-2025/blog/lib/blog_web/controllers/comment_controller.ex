defmodule BlogWeb.CommentController do
  use BlogWeb, :controller

  alias Blog.MyBlog
  alias Blog.MyBlog.Comment

  def create(conn, %{"comment" => comment_params, "article_id" => article_id}) do
    case MyBlog.create_comment(Map.merge(comment_params, %{"article_id" => article_id})) do
      {:ok, comment} ->
        conn
        |> put_flash(:info, "Comment added!")
        |> redirect(to: ~p"/articles/#{comment.article_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def delete(conn, %{"article_id" => article_id, "id" => id}) do
    comment = MyBlog.get_comment_for_article!(article_id, id)
    {:ok, comment} = MyBlog.delete_comment(comment)

    conn
    |> put_flash(:info, "Comment deleted succefully")
    |> redirect(to: ~p"/articles/#{comment.article_id}")
  end
end

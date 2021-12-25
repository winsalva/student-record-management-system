defmodule AppWeb.SessionController do
  use AppWeb, :controller

  alias App.Query.User
  
  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"username" => username, "password" => password}) do
    if password == "" do
      conn
      |> put_flash(:error, "Password can't be empty!")
      |> render("new.html")
    else
      case User.get_username_and_password(username, password) do
        {:ok, user} ->
	  conn
	  |> put_session(:user_id, user.id)
	  |> put_session(:admin_id, nil)
	  |> configure_session(renew: true)
	  |> redirect(to: Routes.user_path(conn, :show, user.id))
	nil ->
	  conn
	  |> put_flash(:error, "Username and password combination cannot be found!")
	  |> render("new.html")
      end
    end
  end
end
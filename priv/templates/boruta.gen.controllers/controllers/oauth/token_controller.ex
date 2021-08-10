defmodule <%= web_module %>.Oauth.TokenController do
  @behaviour Boruta.Oauth.TokenApplication

  use <%= web_module %>, :controller

  alias Boruta.Oauth
  alias Boruta.Oauth.Error
  alias <%= web_module %>.OauthView
  alias Boruta.Oauth.TokenResponse

  def token(%Plug.Conn{} = conn, _params) do
    conn |> Oauth.token(__MODULE__)
  end

  @impl Boruta.Oauth.TokenApplication
  def token_success(conn, %TokenResponse{} = response) do
    conn
    |> put_view(OauthView)
    |> render("token.json", response: response)
  end

  @impl Boruta.Oauth.TokenApplication
  def token_error(conn, %Error{status: status, error: error, error_description: error_description}) do
    conn
    |> put_status(status)
    |> put_view(OauthView)
    |> render("error.json", error: error, error_description: error_description)
  end
end

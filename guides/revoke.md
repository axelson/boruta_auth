# Revoke tokens

As stated in OAuth 2.0 Token Revocation RFC [revocation](https://tools.ietf.org/html/rfc7009) provides a way to revoke tokens.

```
POST /revoke HTTP/1.1
Host: server.example.com
Content-Type: application/x-www-form-urlencoded
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW

token=45ghiukldjahdnhzdauz&token_type_hint=refresh_token

---

HTTP/1.1 200 OK
```

## Integration
### Code example

- lib/my_app_web/views/oauth_view.ex

```
defmodule MyAppWeb.OauthView do
  use MyAppWeb, :view

  def render("error.json", %{error: error, error_description: error_description}) do
    %{
      error: error,
      error_description: error_description
    }
  end
end
```
- lib/my_app_web/controllers/oauth_controller.ex

```
defmodule MyAppWeb.OauthController do
  @behaviour Boruta.Oauth.Application

  use MyAppWeb, :controller

  alias Boruta.Oauth
  alias Boruta.Oauth.Error
  alias MyAppWeb.OauthView

  def revoke(%Plug.Conn{} = conn, _params) do
    conn |> Oauth.revoke(__MODULE__)
  end

  @impl Boruta.Oauth.Application
  def revoke_success(%Plug.Conn{} = conn) do
    send_resp(conn, 200, "")
  end

  @impl Boruta.Oauth.Application
  def revoke_error(conn, %Error{
        status: status,
        error: error,
        error_description: error_description
      }) do
    conn
    |> put_status(status)
    |> put_view(OauthView)
    |> render("error.json", error: error, error_description: error_description)
  end
end
```

- lib/my_app_web/router.ex

```
defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/oauth", MyAppWeb do
    pipe_through :api

    post "/revoke", OauthController, :revoke
  end
end
```

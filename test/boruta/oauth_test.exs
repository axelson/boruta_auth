defmodule Boruta.OauthTest do
  @behaviour Boruta.Oauth.Application

  use ExUnit.Case
  use Phoenix.ConnTest
  use Boruta.DataCase

  import Boruta.Factory

  alias Boruta.Oauth
  alias Authable.Model.Token

  describe "token_request" do
    setup do
      user = insert(:user)
      client = insert(:client, user_id: user.id)
      {:ok, client: client}
    end

    test "returns an error without params" do
      assert Oauth.token(%{}, __MODULE__) == {
        :bad_request,
        %{
          error: "invalid_request",
          error_description: "Must provide query_params and body_params"
        }
      }
    end

    test "returns an error with empty params" do
      assert Oauth.token(%{query_params: %{}, body_params: %{}}, __MODULE__) == {
        :bad_request,
        %{
          error: "invalid_request",
          error_description: "Query params validation failed. Required property grant_type is missing at #"
        }
      }
    end

    test "returns an error with invalid grant_type" do
      assert Oauth.token(%{query_params: %{"grant_type" => "boom"}, body_params: %{}}, __MODULE__) == {
        :bad_request,
        %{
          error: "invalid_request",
          error_description: "Query params validation failed. #/grant_type do match required pattern /client_credentials/"
        }
      }
    end

    test "returns an error if `grant_type` is 'client_credentials' and schema is invalid" do
      assert Oauth.token(%{query_params: %{"grant_type" => "client_credentials"}, body_params: %{}}, __MODULE__) == {
        :bad_request,
        %{
          error: "invalid_request",
          error_description: "Body params validation failed. Required properties client_secret, client_id are missing at #"
        }
      }
    end

    test "returns an error if client_id/scret are invalid" do
      assert Oauth.token(
        %{query_params: %{"grant_type" => "client_credentials"}, body_params: %{"client_id" => "6a2f41a3-c54c-fce8-32d2-0324e1c32e22", "client_secret" => "client_secret"}},
        __MODULE__
      ) == {
        :error,
        %{invalid_client: "Invalid client id or secret."},
        :unauthorized
      }
    end

    test "returns a token if client_id/scret are valid", %{client: client} do
      with %Token{} = token <- Oauth.token(
        %{query_params: %{"grant_type" => "client_credentials"}, body_params: %{"client_id" => client.id, "client_secret" => client.secret}},
        __MODULE__
      ) do
        assert token
      else
        _ ->
          assert false
      end
    end
  end

  @impl Boruta.Oauth.Application
  def token_error(conn, error), do: error

  @impl Boruta.Oauth.Application
  def token_success(conn, token), do: token
end

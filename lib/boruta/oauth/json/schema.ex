defmodule Boruta.Oauth.Json.Schema do
  @moduledoc false
  alias ExJsonSchema.Schema

  def client_credentials do
    %{
      "type" => "object",
      "properties" => %{
        "grant_type" => %{"type" => "string", "pattern" => "client_credentials"},
        "client_id" => %{
          "type" => "string",
          "pattern" => "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
        },
        "client_secret" => %{"type" => "string"},
        "scope" => %{"type" => "string"},
      },
      "required" => ["grant_type", "client_id", "client_secret"]
    } |> Schema.resolve
  end

  def password do
    %{
      "type" => "object",
      "properties" => %{
        "grant_type" => %{"type" => "string", "pattern" => "password"},
        "client_id" => %{
          "type" => "string",
          "pattern" => "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
        },
        "client_secret" => %{"type" => "string"},
        "username" => %{"type" => "string"},
        "password" => %{"type" => "string"},
        "scope" => %{"type" => "string"},
      },
      "required" => ["grant_type", "client_id", "client_secret", "username", "password"]
    } |> Schema.resolve
  end

  def authorization_code do
    %{
      "type" => "object",
      "properties" => %{
        "grant_type" => %{"type" => "string", "pattern" => "authorization_code"},
        "client_id" => %{
          "type" => "string",
          "pattern" => "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
        },
        "code" => %{"type" => "string"},
        "redirect_uri" => %{"type" => "string"},
        "code_verifier" => %{"type" => "string"}
      },
      "required" => ["grant_type", "code", "redirect_uri"]
    } |> Schema.resolve
  end

  def token do
    %{
      "type" => "object",
      "properties" => %{
        "response_type" => %{"type" => "string", "pattern" => "token"},
        "client_id" => %{
          "type" => "string",
          "pattern" => "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
        },
        "state" => %{"type" => "string"},
        "nonce" => %{"type" => "string"},
        "redirect_uri" => %{"type" => "string"},
        "prompt" => %{"type" => "string"}
      },
      "required" => ["response_type", "client_id", "redirect_uri"]
    } |> Schema.resolve
  end

  def id_token do
    %{
      "type" => "object",
      "properties" => %{
        "response_type" => %{"type" => "string", "pattern" => "id_token"},
        "client_id" => %{
          "type" => "string",
          "pattern" => "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
        },
        "state" => %{"type" => "string"},
        "nonce" => %{"type" => "string"},
        "redirect_uri" => %{"type" => "string"}
      },
      "required" => ["response_type", "client_id", "redirect_uri"]
    } |> Schema.resolve
  end

  def refresh_token do
    %{
      "type" => "object",
      "properties" => %{
        "grant_type" => %{"type" => "string", "pattern" => "refresh_token"},
        "refresh_token" => %{"type" => "string"},
        "scope" => %{"type" => "string"}
      },
      "required" => ["grant_type", "refresh_token"]
    } |> Schema.resolve
  end

  def code do
    %{
      "type" => "object",
      "properties" => %{
        "response_type" => %{"type" => "string", "pattern" => "code"},
        "client_id" => %{
          "type" => "string",
          "pattern" => "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
        },
        "state" => %{"type" => "string"},
        "nonce" => %{"type" => "string"},
        "redirect_uri" => %{"type" => "string"},
        "prompt" => %{"type" => "string"},
        "code_challenge" => %{"type" => "string"},
        "code_challenge_method" => %{
          "type" => "string",
          "pattern" => "plain|S256"
        }
      },
      "required" => ["response_type", "client_id", "redirect_uri"]
    } |> Schema.resolve
  end

  def introspect do
    %{
      "type" => "object",
      "properties" => %{
        "client_id" => %{
          "type" => "string",
          "pattern" => "[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}"
        },
        "client_secret" => %{"type" => "string"},
        "token" => %{"type" => "string"},
      },
      "required" => ["client_id", "client_secret", "token"]
    } |> Schema.resolve
  end

  def revoke do
    %{
      "type" => "object",
      "properties" => %{
        "client_id" => %{"type" => "string"},
        "client_secret" => %{"type" => "string"},
        "token_type_hint" => %{"type" => "string", "pattern" => "^(access_token|refresh_token)$"},
        "token" => %{"type" => "string"}
      },
      "required" => ["client_id", "token"]
    } |> Schema.resolve
  end

  def grant_type do
    %{
      "type" => "object",
      "properties" => %{
        "grant_type" => %{"type" => "string", "pattern" => "^(client_credentials|password|authorization_code|refresh_token)$"},
      },
      "required" => ["grant_type"]
    } |> Schema.resolve
  end

  def response_type do
    %{
      "type" => "object",
      "properties" => %{
        "response_type" => %{"type" => "string", "pattern" => "^(token|code|id_token)$"},
      },
      "required" => ["response_type"]
    } |> Schema.resolve
  end
end

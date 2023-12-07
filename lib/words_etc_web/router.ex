defmodule WordsEtcWeb.Router do
  use WordsEtcWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {WordsEtcWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug WordsEtcWeb.Plugs.RequestLogger
  end

  scope "/.well-known/acme-challenge", WordsEtcWeb do
    pipe_through :browser

    get "/*path", AcmeChallengeController, :index
  end

  scope "/", WordsEtcWeb do
    pipe_through :browser

    get "/", PageController, :home
    post "/", PageController, :solve
    get "/privacy", PageController, :privacy
  end

  scope "/api/v1", WordsEtcWeb do
    pipe_through :api

    post "/solve", ApiController, :solve
  end
end

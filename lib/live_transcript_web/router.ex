defmodule LiveTranscriptWeb.Router do
  use LiveTranscriptWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Phoenix.LiveView.Flash
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveTranscriptWeb do
    pipe_through :browser

    scope "/test" do
      live "/counter", CounterLive
    end

    get "/", PageController, :index
    resources "/rooms", RoomController, only: [:new, :show, :create]
  end
end

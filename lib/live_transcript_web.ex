defmodule LiveTranscriptWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: LiveTranscriptWeb

      import Plug.Conn
      import LiveTranscriptWeb.Gettext
      alias LiveTranscriptWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/live_transcript_web/templates",
        namespace: LiveTranscriptWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import LiveTranscriptWeb.ErrorHelpers
      import LiveTranscriptWeb.Gettext
      alias LiveTranscriptWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import LiveTranscriptWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

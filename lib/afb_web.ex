defmodule AfbWeb do

  def controller do
    quote do
      use Phoenix.Controller, namespace: AfbWeb
      import Plug.Conn
      import AfbWeb.Router.Helpers
      import AfbWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/afb_web/templates",
        namespace: AfbWeb

      import Phoenix.Controller, only: [
        get_flash: 2,
        view_module: 1
      ]

      use Phoenix.HTML
      import AfbWeb.Router.Helpers
      import AfbWeb.ErrorHelpers
      import AfbWeb.Gettext

      def fmt_ndt(nil), do: "-"
      def fmt_ndt(n), do: Timex.format!(n, "%d %b %Y, %H:%M:%S UTC", :strftime)
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
      import AfbWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

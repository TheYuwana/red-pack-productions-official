defmodule RedPackProductions.Web.LayoutView do
  use RedPackProductions.Web, :view

  def get_current_url(conn) do
    Phoenix.Controller.current_url(conn)
  end
end

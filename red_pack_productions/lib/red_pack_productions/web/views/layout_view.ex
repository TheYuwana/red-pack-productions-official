defmodule RedPackProductionsWeb.LayoutView do
  use RedPackProductionsWeb, :view

  def get_current_url(conn) do
    Phoenix.Controller.current_url(conn)
  end

  def jsonfy(content) do
  	Poison.encode!(content)
  end
end

defmodule RedPackProductions.Web.MollieController do
  use RedPackProductions.Web, :controller

  # alias RedPackProductions.Mollie

  plug :put_layout, false

  def status_update(conn, %{"id" => _payment_id}) do
  	
  	conn
      |> put_status(200)
      |> render(%{ok: :ok})
  end

end
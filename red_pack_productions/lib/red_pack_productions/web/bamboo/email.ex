defmodule RedPackProductions.Email do

	use Bamboo.Phoenix, view: RedPackProductionsWeb.EmailView

	def reservation(details) do
		new_email()
		|> to("jmerrelaar@icloud.com")
		|> from("info@redpackproductions.com")
		|> subject("Someone requested a new reservation!")
		|> put_html_layout({RedPackProductionsWeb.EmailView, "reservation.html"})
		|> render(:reservation, details: details)
	end

	def order_confirmation(order) do
		new_email()
		|> to("jmerrelaar@icloud.com")
		# |> to("hope_industries@hotmail.com")
		|> from("info@redpackproductions.com")
		|> subject("New sample order!")
		|> put_html_layout({RedPackProductionsWeb.EmailView, "order_rpp.html"})
		|> render(:order_rpp, order: order)
	end

	def order_confirmation_client(order, client_email) do
		new_email()
		# |> to("jmerrelaar@icloud.com")
		|> to(client_email)
		|> from("info@redpackproductions.com")
		|> subject("Order received!")
		|> put_html_layout({RedPackProductionsWeb.EmailView, "order_client.html"})
		|> render(:order_client, order: order)
	end
end
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
end
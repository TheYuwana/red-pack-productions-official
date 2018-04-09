defmodule RedPackProductions.Email do

	use Bamboo.Phoenix, view: RedPackProductions.Web.EmailView

	def reservation(details) do
		new_email()
			|> to("jmerrelaar@icloud.com")
			|> cc("hope_industries@hotmail.com")
			|> from("-finfo@redpackproductions.com")
			|> subject("Someone requested a new reservation!")
			|> put_html_layout({RedPackProductions.Web.EmailView, "reservation.html"})
			|> render(:reservation, details: details)
	end

end
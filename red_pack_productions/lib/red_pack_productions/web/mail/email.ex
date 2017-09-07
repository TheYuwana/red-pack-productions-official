defmodule RedPackProductions.Email do

	import Bamboo.Email

	@template_root_path  "#{Path.dirname(__DIR__)}/templates/mail"

	def reservation(details) do
		new_email
			|> to("jmerrelaar@icloud.com")
			|> cc("hope_industries@hotmail.com")
			|> from("info@redpackproductions.com")
			|> subject("Someone requested a new reservation!")
			|> html_body(EEx.eval_file("#{@template_root_path}/html/reservation.html.eex", details: details))
			|> text_body(EEx.eval_file("#{@template_root_path}/plain/reservation.txt.eex", details: details))		
	end

end
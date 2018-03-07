defmodule RedPackProductions.Mollie do

	@api_key Application.get_env(:red_pack_productions, :mollie_api_key)
	@base_mollie "https://api.mollie.com/v1"
	@redirect_url "http://localhost:4003"
	#@webhook_url "http://localhost:4003/api/mollie/payment"
	@webhook_url "http://redpackproductions.com/api/resetcache"

	def get_all_payments() do
		payments = send_request("/payments")
	end

	def get_payment(id) do
		send_request("/payments/#{id}")
	end

	def sent_payment_request() do
		body = %{
			"amount": 1000.00,
			"description": "This is a test product",
			"details": "more details about the product",
			"redirectUrl": @redirect_url, # show ordered product or succesfull page
			"webhookUrl": @webhook_url # Where the payment status is sent to
		}
		post_request("/payments", body)
	end

	defp send_request(path) when is_binary(path) do
		url = "#{@base_mollie}#{path}"
		headers = [
			"Authorization": "Bearer #{@api_key}",
			"Accept": "Application/json; Charset=utf-8"
		]
		case HTTPoison.get(url, headers, []) do
			{:ok, response} ->
				response.body
			{:error, error} ->
				error
		end
		|> Poison.decode!
	end

	def post_request(path, body) when is_binary(path) and is_map(body) do
		body = body |> Poison.encode!
		url = "#{@base_mollie}#{path}"
		headers = ["Authorization": "Bearer #{@api_key}"]
		case HTTPoison.post(url, body, headers, []) do
			{:ok, response} ->
				response.body
			{:error, error} ->
				error
		end
		|> Poison.decode!
	end

end
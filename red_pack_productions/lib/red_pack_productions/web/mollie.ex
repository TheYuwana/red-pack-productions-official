defmodule RedPackProductions.Mollie do

	@base_mollie "https://api.mollie.com/v2"
	def get_api_key(), do: Application.get_env(:red_pack_productions, :mollie_api_key)
	def get_redirect_url(), do: Application.get_env(:red_pack_productions, :mollie_redirect_url)

	def get_payment(id) do
		send_request("/payments/#{id}")
	end

	def create_payment_request(total_price, order_id) do

		redirect_url = "#{get_redirect_url()}/shop/payment-loading"
		total_price = if String.contains?("#{total_price}", ".") do
			"#{total_price}"
		else
			"#{total_price}.00"
		end

		body = %{
			amount: %{
				currency: "EUR",
				value: total_price
			},
			description: "Red Pack Productions Samples",
			redirectUrl: redirect_url, # show ordered product or succesfull page
			metadata: %{
				order_id: order_id
			}
		}

		post_request("/payments", body)
	end

	# TODO - Handle succes responses that return errors
	defp send_request(path) when is_binary(path) do
		url = "#{@base_mollie}#{path}"
		headers = [
			"Authorization": "Bearer #{get_api_key()}",
			"Accept": "Application/json; Charset=utf-8"
		]
		case HTTPoison.get(url, headers, []) do
			{:ok, response} ->
				decoded = Poison.decode!(response.body)
				{:ok,  decoded}
			{:error, error} ->
				decoded = Poison.decode!(error)
				{:error, decoded}
		end
	end

	def post_request(path, body) when is_binary(path) and is_map(body) do
		body = body |> Poison.encode!
		url = "#{@base_mollie}#{path}"
		headers = [
			{"Authorization", "Bearer #{get_api_key()}"},
			{"Content-Type", "application/json"}
		]
		case HTTPoison.post(url, body, headers, []) do
			{:ok, response} ->
				decoded = Poison.decode!(response.body)
				{:ok,  decoded}
			{:error, error} ->
				decoded = Poison.decode!(error)
				{:error, decoded}
		end
	end

end
defmodule RedPackProductions.Mollie do

	@api_key Application.get_env(:red_pack_productions, :mollie_api_key)
	@base_mollie "https://api.mollie.com/v2"
	@redirect_url "http://localhost:4000/shop/payment-loading"
	#@webhook_url "http://localhost:4003/api/mollie/payment"

	def get_payment(id) do
		send_request("/payments/#{id}")
	end

	def create_payment_request() do
		body = %{
			amount: %{
					currency: "EUR",
					value: "100.00"
				},
			description: "someproductid",
			redirectUrl: @redirect_url # show ordered product or succesfull page
			# webhookUrl: @webhook_url # Where the payment status is sent to
		}
		post_request("/payments", body)
	end
	# response when order created
	# %{
	#   "_links" => %{
	#     "checkout" => %{
	#       "href" => "https://www.mollie.com/payscreen/select-method/rxjnGm7P44",
	#       "type" => "text/html"
	#     },
	#     "documentation" => %{
	#       "href" => "https://docs.mollie.com/reference/v2/payments-api/create-payment",
	#       "type" => "text/html"
	#     },
	#     "self" => %{
	#       "href" => "https://api.mollie.com/v2/payments/tr_rxjnGm7P44",
	#       "type" => "application/hal+json"
	#     }
	#   },
	#   "amount" => %{"currency" => "EUR", "value" => "100.00"},
	#   "createdAt" => "2018-10-10T20:45:51+00:00",
	#   "description" => "someproductid",
	#   "expiresAt" => "2018-10-10T21:00:51+00:00",
	#   "id" => "tr_rxjnGm7P44",
	#   "isCancelable" => false,
	#   "metadata" => nil,
	#   "method" => nil,
	#   "mode" => "test",
	#   "profileId" => "pfl_8dDMpnz6TT",
	#   "redirectUrl" => "http://localhost:4000/shop/confirmation",
	#   "resource" => "payment",
	#   "sequenceType" => "oneoff",
	#   "status" => "open"
	# }

	# User selects products
	# User checks out (create payment request) (Build redirect url with payment ID)
	# Use checkout url to to the payment page
	# User uses payment from mollie then goes to redirect url  with payment status
	# redirect to processing payment (3 seconds)
	# After 3 seconds call the redirect url with 
	# If success, thnka user and send mail to jon
	# If fail, try again or prompt user that somethign went wonr and retry whole order



	# TODO - Handle succes responses that return errors
	defp send_request(path) when is_binary(path) do
		url = "#{@base_mollie}#{path}"
		headers = [
			"Authorization": "Bearer #{@api_key}",
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
			{"Authorization", "Bearer #{@api_key}"},
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
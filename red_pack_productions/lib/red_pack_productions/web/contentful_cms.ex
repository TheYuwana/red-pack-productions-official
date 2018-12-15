defmodule RedPackProductions.ContentfulCms do

	@api_key Application.get_env(:red_pack_productions, :cf_cms_api_key)
	@base_url "https://api.contentful.com"
	@entry_url "/spaces/6t670ovmra8o/environments/master/entries"

	def get_api_key(), do: Application.get_env(:red_pack_productions, :cf_cms_api_key)

	# ====================================================
	# Get order
	# ====================================================
	def get_order(order_id) do
		path = "#{@entry_url}/#{order_id}"
		send_request(path)
	end

	# ====================================================
	# Request handelers
	# ====================================================
	def create_order(data) do
		path = "#{@entry_url}"
		
		{:ok, datetime} = Timex.format(Timex.now(), "{YYYY}-{M}-{D}T{h24}:{m}:{s}Z")

		body = %{
			"fields" => %{
				"mollieId" => %{
					"nl" => "coming soon"
				},
				# "orderDate" => %{
				# 	"nl" => datetime
				# },
				"consumerFirstName" => %{
					"nl" => data.first_name
				},
				"consumerLastName" => %{
					"nl" => data.last_name
				},
				"consumerEmail" => %{
					"nl" => data.email
				},
				"totalPrice" => %{
					"nl" => data.total_price
				},
				"details" => %{
					"nl" => data.details
				},
				"status" => %{
					"nl" => "pending payment"
				}
			}
		}
		headers = [
			{"Authorization", "Bearer #{get_api_key()}"},
			{"Content-Type", "application/json"},
			{"X-Contentful-Content-Type", "orders"}
		]
		post_request(path, body, headers)
	end

	# ====================================================
	# Update orders
	# ====================================================
	def update_order(mollie_id, order_id, mollie_status, data) do
		path = "#{@entry_url}/#{order_id}"
		body = %{
			"fields" => %{
				"mollieId" => %{
					"nl" => "#{mollie_id}"
				},
				"orderDate" => %{
					"nl" => data["fields"]["orderDate"]["nl"]
				},
				"consumerFirstName" => %{
					"nl" => data["fields"]["consumerFirstName"]["nl"]
				},
				"consumerLastName" => %{
					"nl" => data["fields"]["consumerLastName"]["nl"]
				},
				"consumerEmail" => %{
					"nl" => data["fields"]["consumerEmail"]["nl"]
				},
				"totalPrice" => %{
					"nl" => data["fields"]["totalPrice"]["nl"]
				},
				"details" => %{
					"nl" => data["fields"]["details"]["nl"]
				},
				"status" => %{
					"nl" => "#{mollie_status}"
				}
			}
		}
		headers = [
			{"Authorization", "Bearer #{get_api_key()}"},
			{"Content-Type", "application/json"},
			{"X-Contentful-Content-Type", "orders"},
			{"X-Contentful-Version", "#{data["sys"]["version"]}"}
		]
		put_request(path, body, headers)
	end

	def update_order_status(order_id, mollie_status) do
		path = "#{@entry_url}/#{order_id}"
		body = %{
			"fields" => %{
				"status" => %{
					"nl" => "#{mollie_status}"
				}
			}
		}
		headers = [
			{"Authorization", "Bearer #{get_api_key()}"},
			{"Content-Type", "application/json"},
			{"X-Contentful-Content-Type", "orders"}
		]
		put_request(path, body, headers)
	end

	def publish_order(order_id, version) do
		publish_url = "#{@entry_url}/#{order_id}/published"
		headers = [
			{"Authorization", "Bearer #{get_api_key()}"},
			{"X-Contentful-Version", version}
		]
		put_request(publish_url, %{}, headers)
	end

	# ====================================================
	# Request handelers
	# ====================================================

	# TODO - Handle succes responses that return errors
	defp send_request(path) do
		url = "#{@base_url}#{path}"
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

	def post_request(path, body, headers) do

		IO.puts "==== CONTENTFUL POST ===="
		IO.inspect body

		body = body |> Poison.encode!
		url = "#{@base_url}#{path}"

		IO.inspect url
		IO.inspect headers
		case HTTPoison.post(url, body, headers, []) do
			{:ok, response} ->
				decoded = Poison.decode!(response.body)
				{:ok,  decoded}
			{:error, error} ->
				decoded = Poison.decode!(error)
				{:error, decoded}
		end
	end

	def put_request(path, body, headers) do
		body = body |> Poison.encode!
		url = "#{@base_url}#{path}"
		case HTTPoison.put(url, body, headers, []) do
			{:ok, response} ->
				decoded = Poison.decode!(response.body)
				{:ok,  decoded}
			{:error, error} ->
				decoded = Poison.decode!(error)
				{:error, decoded}
		end
	end

end
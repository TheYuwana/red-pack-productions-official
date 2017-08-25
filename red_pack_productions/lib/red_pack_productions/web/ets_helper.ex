defmodule RedPackProductions.EtsHelper do

	@cache_name Application.get_env(:plug_ets_cache, :db_name)

	def test do
		@cache_name
	end

	def get_cache_keys do
		@cache_name
		 |> ConCache.ets
		 |> :ets.tab2list
		 |> Enum.map(fn({key, _}) -> key end)
	end

	def clear_all_cache do
		@cache_name
		 |> ConCache.ets
		 |> :ets.tab2list
		 |> Enum.each(fn({key, _}) -> ConCache.delete(@cache_name, key) end)
	end

	def clear_cache_by_key(key) do
		ConCache.delete(@cache_name, key)
	end

end
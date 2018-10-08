defmodule RedPackProductionsWeb.EmailView do
  use RedPackProductionsWeb, :view

  def parse_hours(details) do
  	if Map.has_key?(details, "hours") do
  		Enum.map_join(details["hours"], ", ", fn hour -> hour end)
  	else
  		""
  	end
  end

end
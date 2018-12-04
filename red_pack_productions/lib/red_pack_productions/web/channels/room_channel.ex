defmodule RedPackProductionsWeb.RoomChannel do
  use RedPackProductionsWeb, :channel

  # RedPackProductionsWeb.Endpoint.broadcast("room:123", "room:123:new_update", %{message: "new stuff"})

  def join(room_name, _params, socket) do

    # Checking room
    response = %{
      room: room_name,
    }

    {:ok, response, assign(socket, :room, "123")}
  end

  # def handle_in("message:add", %{"message" => content}, socket) do
  #   broadcast!(socket, "room:lobby:new_message", %{content: content})
  #   {:reply, :ok, socket}
  # end

  def terminate(_reason, socket) do
    {:ok, socket}
  end
end
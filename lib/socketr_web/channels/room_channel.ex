defmodule SocketrWeb.RoomChannel do
  use Phoenix.Channel
  alias SocketrWeb.Presence

  def join("room:lobby", _params, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast(socket, "new_msg", %{body: body, user_id: socket.assigns.user_id})
    {:noreply, socket}
  end

  def handle_in("mouse_move", %{"x" => x, "y" => y}, socket) do
    broadcast(socket, "mouse_move", %{
      x: x,
      y: y,
      user_id: socket.assigns.user_id,
      profile_pic: socket.assigns.profile_pic
    })

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    {:ok, _} =
      Presence.track(socket, socket.assigns.user_id, %{
        online_at: inspect(System.system_time(:second)),
        profile_pic: socket.assigns.profile_pic
      })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end

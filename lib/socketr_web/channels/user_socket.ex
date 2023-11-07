defmodule SocketrWeb.UserSocket do
  use Phoenix.Socket

  # A Socket handler
  #
  # It's possible to control the websocket connection and
  # assign values that can be accessed by your channel topics.

  ## Channels
  # Uncomment the following line to define a "room:*" topic
  # pointing to the `SocketrWeb.RoomChannel`:
  #
  channel "room:*", SocketrWeb.RoomChannel
  #
  # To create a channel file, use the mix task:
  #
  #     mix phx.gen.channel Room
  #
  # See the [`Channels guide`](https://hexdocs.pm/phoenix/channels.html)
  # for further details.

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error` or `{:error, term}`. To control the
  # response the client receives in that case, [define an error handler in the
  # websocket
  # configuration](https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#socket/3-websocket-configuration).
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(%{"id" => id}, socket, _info) do
    possible_imgs = [
      "https://avataaars.io/?avatarStyle=Circle&topType=ShortHairShortRound&accessoriesType=Wayfarers&hairColor=Blonde&facialHairType=Blank&facialHairColor=Red&clotheType=ShirtCrewNeck&clotheColor=PastelYellow&eyeType=Dizzy&eyebrowType=RaisedExcited&mouthType=Twinkle&skinColor=Pale",
      "https://avataaars.io/?avatarStyle=Circle&topType=ShortHairTheCaesar&accessoriesType=Wayfarers&hairColor=BrownDark&facialHairType=BeardLight&facialHairColor=Red&clotheType=ShirtScoopNeck&clotheColor=PastelRed&eyeType=Cry&eyebrowType=Angry&mouthType=Grimace&skinColor=DarkBrown",
      "https://avataaars.io/?avatarStyle=Circle&topType=LongHairNotTooLong&accessoriesType=Wayfarers&hairColor=PastelPink&facialHairType=Blank&facialHairColor=Brown&clotheType=CollarSweater&clotheColor=PastelGreen&eyeType=Default&eyebrowType=DefaultNatural&mouthType=Twinkle&skinColor=Light",
      "https://avataaars.io/?avatarStyle=Circle&topType=LongHairCurly&accessoriesType=Kurt&hairColor=Brown&facialHairType=Blank&facialHairColor=Brown&clotheType=ShirtCrewNeck&clotheColor=Gray01&eyeType=Surprised&eyebrowType=Angry&mouthType=Default&skinColor=Brown"
    ]

    profile_pic = Stream.cycle(possible_imgs) |> Enum.at(String.to_integer(id))
    IO.inspect(binding(), label: "user_socket.ex:47")
    {:ok, assign(socket, user_id: id, profile_pic: profile_pic)}
  end

  def connect(params, socket, _connect_info) do
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.SocketrWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(%{assigns: %{user_id: id}}), do: "user_socket:#{id}"
  def id(_socket), do: nil
end

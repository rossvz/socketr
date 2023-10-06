// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import { Socket, Presence } from "phoenix";

// get userId from localstorage or generate new random
let userId = localStorage.getItem("userId");

if (!userId) {
  userId = Math.round(Math.random() * 1000);
  localStorage.setItem("userId", userId);
}

// And connect to the path in "lib/socketr_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {
  params: { token: window.userToken, id: userId },
});

socket.connect();

let channel = socket.channel("room:lobby", {});
let presence = new Presence(channel);

// HTML MANIPULATION
let chatInput = document.querySelector("#chat-input");
let messagesContainer = document.querySelector("#messages");

chatInput.addEventListener("keypress", (event) => {
  if (event.key === "Enter") {
    channel.push("new_msg", { body: chatInput.value });
    chatInput.value = "";
  }
});

// add event listener for mouse moving
document.addEventListener("mousemove", (event) => {
  channel.push("mouse_move", { x: event.clientX, y: event.clientY });
});

channel.on("new_msg", (payload) => {
  let messageItem = document.createElement("p");
  const d = new Date();
  messageItem.innerText = `[${d.getHours()}:${d.getMinutes()}:${d.getSeconds()}] ${
    payload.user_id
  }: ${payload.body}`;
  messagesContainer.appendChild(messageItem);
});

function renderOnlineUsers(presence) {
  console.log("presence", presence);
  const userList = document.querySelector("#user-list");
  userList.innerHTML = "";
  presence.list((id, { metas: [first, ...rest] }) => {
    console.log(first);
    const img = document.createElement("img");
    img.style.width = "40px";
    img.style.height = "40px";
    img.src = first.profile_pic;
    userList.appendChild(img);
  });
}

presence.onSync(() => renderOnlineUsers(presence));

presence.onLeave((id, current, left) => {
  console.log("someone left", id);
  let profileImg = document.querySelector(`#img-${id}`);
  if (profileImg) document.body.removeChild(profileImg);
});

channel.on("mouse_move", (payload) => {
  if (payload.user_id === userId) {
    return;
  }
  let profileImg = document.querySelector(`#img-${payload.user_id}`);

  if (profileImg) {
    profileImg.style.left = `${payload.x}px`;
    profileImg.style.top = `${payload.y}px`;
    return;
  } else {
    profileImg = createProfileImg(payload);
    document.body.appendChild(profileImg);
  }
});

function createProfileImg(payload) {
  let profileImg = document.createElement("img");
  profileImg.src = payload.profile_pic;
  profileImg.id = `img-${payload.user_id}`;
  profileImg.style.position = "absolute";
  profileImg.style.left = `${payload.x}px`;
  profileImg.style.top = `${payload.y}px`;
  profileImg.style.width = "50px";
  profileImg.style.height = "50px";
  return profileImg;
}

channel
  .join()
  .receive("ok", (resp) => {
    console.log("Joined lobby successfully", resp);
    let userIdDiv = document.querySelector("#user-id");
    userIdDiv.innerText = `Your user id is ${userId}`;

    // let profileImg = document.querySelector(`#my-profile-pic`);
    // profileImg.src = resp.profile_pic;
  })
  .receive("error", (resp) => {
    console.log("Unable to join", resp);
  });

export default socket;

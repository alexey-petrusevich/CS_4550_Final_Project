import { Socket } from "phoenix";
import store from './store';

//TODO will need to be updated to just /socket when deploying to prod
let socket = new Socket("spotifyparty.morrisonineu.org/socket", { params: { token: "" } });
socket.connect();

let channel = null;
let playlist_cb = null;
let state = {playlists: {}};


export function channel_join(roomcode) {
  let channelname = "party:" + roomcode;
  channel = socket.channel(channelname, {});
  channel.join()
         .receive("ok", resp => {console.log("Successfully connected to channel", resp)})
         .receive("error", resp => {console.log("Unable to connect to channel", resp)});

  channel.on("view", update_playlists)
}

//---------------------PLAYLISTS------------------------

//connects the callback funtion with a useState hook
export function connect_cb(cb) {
  playlist_cb = cb;
}

//for updating the party's playlists through the callback hook
function update_playlists(pls) {
  if (playlist_cb) {
    state = pls;
    console.log("state", pls);
    console.log("state 2", state);
    playlist_cb(pls);
  }
}

export function get_playlists(host_id) {
  channel.push("get_playlists", {user_id: host_id})
           .receive("ok", update_playlists);
}

//------------------------SONGS----------------------------
export function set_songs(playlist_uri, party_id, user_id) {
  console.log("Setting songs", playlist_uri, party_id, user_id)
  channel.push("set_songs", {playlist_uri: playlist_uri,
                            party_id: party_id,
                            user_id: user_id})
            .receive("ok", resp => console.log("Set songs for party ", resp));
  return "successs";
}

//queues either a song or a request
export function queue_song(host_id, track, is_song, callback) {
  console.log("Setting song ", track.title, " to played status");
  console.log("is song?", is_song)
  channel.push("queue_song", {is_song: is_song, track_id: track.id, track_uri: track.track_uri, host_id: host_id})
      .receive("ok", resp => {
        callback(); //updates song view (removes played songs)
        let action = {
          type: 'success/set',
          data: resp,
        }
        store.dispatch(action);
      });
}

//-------------------------PARTIES---------------------------------
export function update_party_active(party_id, is_active) {
  console.log("Setting party ", party_id, " to be active ", is_active);
  channel.push("update_active", {party_id: party_id, is_active: is_active})
    .receive("ok", resp => console.log("Set party active"));
}

import { Socket } from "phoenix";
import store from './store';

//TODO will need to be updated to just /socket when deploying to prod
let socket = new Socket("ws://localhost:4000/socket", { params: { token: "" } });
socket.connect();

let channel = null;
let playlist_cb = null;

export function channel_join(roomcode, callback) {
  let channelname = "party:" + roomcode;
  channel = socket.channel(channelname, {});
  channel.join()
         .receive("ok", resp => {console.log("Successfully connected to channel ", roomcode)})
         .receive("error", resp => {console.log("Unable to connect to channel ", roomcode)});

  //channel.on("new_user", resp => {console.log(resp.body)});

  //listens for a song to be successfully queued
  channel.on("queued_song", resp => {
    if (resp.body === roomcode) {
      callback();
    }
  });

  //listens for a party to start
  channel.on("party_start", resp => {
    if (resp.body === roomcode) {
      callback();
    }
  });

  //listens for a party to end
  channel.on("party_end", resp => {
    let action = {
      type: 'success/set',
      data: "This party has been ended.",
    }
    store.dispatch(action);
    if (resp.body === roomcode) {
      callback();
    }
  });

  //listens for a new request to be made
  channel.on("new_request", resp => {
    if (resp.body === roomcode) {
      callback();
    }
  });

  //listens for a new vote to be made
  channel.on("new_vote", resp => {
    if (resp.body === roomcode) {
      callback();
    }
  });
}

//---------------------PLAYLISTS------------------------

//connects the callback funtion with a useState hook
export function connect_cb(cb) {
  playlist_cb = cb;
}

//for updating the party's playlists through the callback hook
function update_playlists(pls) {
  if (playlist_cb) {
    playlist_cb(pls);
  }
}

export function get_playlists(host_id) {
  channel.push("get_playlists", {user_id: host_id})
           .receive("ok", update_playlists);
}

//------------------------SONGS----------------------------
export function set_songs(playlist_uri, party_id, user_id) {
  channel.push("set_songs", {playlist_uri: playlist_uri,
                            party_id: party_id,
                            user_id: user_id})
          .receive("error", resp => {
            let action = {
              type: 'error/set',
              data: resp
            }
            store.dispatch(action);
          });
}

//queues either a song or a request, handles success or error message
export function queue_song(host_id, track, is_song, party_code, callback, party_id) {
  channel.push("queue_song", {is_song: is_song, track_id: track.id, track_uri: track.track_uri,
    host_id: host_id, party_code: party_code, party_id: party_id})
      .receive("error", resp => {
        let action = {
          type: 'error/set',
          data: resp
        }
        store.dispatch(action);
      });
}

//-------------------------PARTIES---------------------------------
export function update_party_active(party_id, is_active, party_code) {
  channel.push("update_active", {party_id: party_id, is_active: is_active, party_code: party_code})
      .receive("error", resp => {
        let action = {
          type: 'error/set',
          data: resp.error
        }
        store.dispatch(action);
      });
}

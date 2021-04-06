import store from './store';

//------------------------API----------------------------
export async function api_get(path) {
    let text = await fetch("http://localhost:4000/api/v1" + path, {});
    let resp = await text.json();
    return resp.data;
}

export async function api_post(path, data) {
    let req = {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify(data)
    };
    let text = await fetch("http://localhost:4000/api/v1" + path, req);
    let resp = await text.json();
    return resp;
}

//------------------------PARTIES----------------------------
export function get_parties() {
    api_get("/parties").then((data) => store.dispatch({
        type: 'parties/set',
        data: data,
    }));
    console.log("Getting parties from api.js")
}

export function get_party(id) {
  console.log("it's being called");
  let path = "/parties/" + id
  return api_get(path);
}

export function create_party(party) {
  return api_post("/parties", {party});
}

export function join_party(party_id, user_id) {
  return api_post("/parties/join", {"party_id": party_id, "user_id": user_id});
}

//------------------------USERS----------------------------
export function get_users() {
    api_get("/users").then((data) => store.dispatch({
        type: 'users/set',
        data: data,
    }));
}

export function get_user() {
    let path = "/users/" + id
    return api_get(path);
}

export function create_user(user) {
    return api_post("/users", {user});
}

//------------------------LOGIN----------------------------
export function api_login(username, password) {
    api_post("/session", {username, password}).then((data) => {
        console.log("login resp", data);
        if (data.session) {
            let action = {
                type: 'session/set',
                data: data.session,
            }
            store.dispatch(action);
        } else if (data.error) {
            let action = {
                type: 'error/set',
                data: data.error,
            }
            store.dispatch(action);
        }
    });
}


export function fetch_users() {
    api_get("/users").then((data) => {
        dispatchToStore("users/set", data);
    });
}


export function fetch_parties() {
    api_get("/parties").then((data) => {
        dispatchToStore("parties/set", data);
    });
}


function makeHeader(api_token) {
    return {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": api_token
    };
}


function dispatchToStore(type, data) {
    let action = {
        type: type,
        data: data
    };
    store.dispatch(action);
}


export function api_track_search(query, api_token) {
    let headers = makeHeader(api_token);
    api_get("/search/" + query, headers).then((data) => {
        dispatchToStore("track/search", data.result);
    });
}

/*
- Playback controls - API calls
- Retrieving/posting info to API - server-side calls
 */


// loads all playlists for authorized user (host)
export function api_list_playlists(user_id, api_token) {
    let headers = makeHeader(api_token);
    // TODO: replaced with calling serverside instead
    api_get("/users/" + user_id + "/playlists", headers).then((data) => {
        dispatchToStore("playlist/list_all", data);
    });
}


export function api_preload_playlist(playlist_id, api_token) {
    let headers = makeHeader(api_token);
    api_get("/playlists/" + playlist_id, headers).then((data) => {
        dispatchToStore("playlist/get", data.result);
    });
}


export function api_queue_track(track_uri, api_token) {
    let data = {
        uri: track_uri
    };
    let headers = makeHeader(api_token);
    api_post("/me/player/queue", data, headers).then((data) => {
        dispatchToStore("track/queue", data.result);
    });
}


export function load_defaults() {
    get_users();
    get_parties();
}

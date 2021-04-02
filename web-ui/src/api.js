import store from './store';


export async function api_get(path, headers = {}) {
    let text = await fetch("http://localhost:4000/api/v1" + path, {
        method: "GET",
        headers: headers
    });
    let resp = await text.json();
    return resp.data;
}

async function api_post(path, data, headers = {}) {
    let opts = {
        method: 'POST',
        headers: headers,
        body: JSON.stringify(data),
    };
    let text = await fetch(
        "http://localhost:4000/api/v1" + path, opts);
    return await text.json();
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


export function api_login(name, password) {
    api_post("/session", {name, password}).then((data) => {
        if (data.session) {
            dispatchToStore("session/set", data.session)
        } else if (data.error) {
            dispatchToStore("error/set", data.error)
        }
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


// loads all playlists for authorized user (host)
export function api_list_playlists(user_id, api_token) {
    let headers = makeHeader(api_token);
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
    fetch_users();
    fetch_parties(); // TODO: may not need this??
}

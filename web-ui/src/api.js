import store from './store';

//------------------------API----------------------------
export async function api_get(path) {
    let text = await fetch("http://localhost:4000/api/v1" + path, {});
    let resp = await text.json();
    console.log(resp.data);
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
}

export function get_party(id) {
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

//------------------------PLAYLIST----------------------------
export function get_playlists(host_id) {
  api_get("/playlist/" + host_id).then((resp) =>
    console.log(resp)
  );

}


//------------------------PLAYBACK----------------------------
export function playback(host_id, action) {
    api_post("/playback", {action, host_id});
}

export function queue_track(host_id, action, track_uri) {
  api_post("/playback", {action, host_id, track_uri});
}


export function load_defaults() {
    get_users();
    get_parties();
}

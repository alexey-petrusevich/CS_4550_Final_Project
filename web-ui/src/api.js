import store from './store';

//------------------------API----------------------------
export async function api_get(path) {
    let text = await fetch("http://localhost:4000/api/v1" + path, {});
    let resp = await text.json();
    return resp.data;
}

export async function api_post(path, data) {
  let req = {method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify(data)};
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

export function create_party(party) {
  return api_post("/parties", {party});
}

//------------------------USERS----------------------------
export function get_users() {
    api_get("/users").then((data) => store.dispatch({
        type: 'users/set',
        data: data,
    }));
}

//------------------------AUTH----------------------------
export function set_auth(auth) {
  return api_post("/auth", {auth});
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
      }
      else if (data.error) {
       let action = {
          type: 'error/set',
          data: data.error,
        }
        store.dispatch(action);
      }
    });
  }

export function load_defaults() {
    get_users();
    get_parties();
}

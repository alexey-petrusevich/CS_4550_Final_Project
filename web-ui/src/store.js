import { createStore, combineReducers } from 'redux';

export function get_user_id() {
  let session = localStorage.getItem("session");
  if (!session) {
    return null;
  }
  session = JSON.parse(session);
  return session.user_id;
}

//--------------------------SESSION--------------------------
function save_session(sess) {
  let session = Object.assign({}, sess, {time: Date.now()});
  localStorage.setItem("session", JSON.stringify(session));
}

//clears the session when a user logs out
function clear_session() {
  localStorage.removeItem("session");
}

//user session restore on page refresh (if still exists)
function restore_session() {
  let session = localStorage.getItem("session");
  if (!session) {
    return null;
  }
  session = JSON.parse(session);
  let age = Date.now() - session.time;
  let hour = 3600000; // one hour session expiration (in milliseconds)
  if (age < hour) {
    return session;
  }
  else {
    return null;
  }
}

// user session; initial state = current session (if active)
function session(state = restore_session(), action) {
  switch (action.type) {
    case 'session/set':
      save_session(action.data);
      return action.data;
    case 'session/clear':
      clear_session();
      return null;
    default:
      return state;
  }
}

//--------------------------USERS--------------------------
function users(state = [], action) {
    switch (action.type) {
    case 'users/set':
        return action.data;
    default:
        return state;
    }
}

//--------------------------PARTIES--------------------------
function parties(state = [], action) {
    switch (action.type) {
      case 'parties/set':
        return action.data;
      default:
        return state;
    }
}

//--------------------------ALERTS--------------------------
//error handlers for server responses
function error(state = null, action) {
    switch(action.type) {
      case 'session/set':
        return null;
      case 'clear/set':
        return null;
      case 'error/set':
        return action.data;
      default:
        return state;
    }
}

//success handles from server responses
function success(state = null, action) {
    switch(action.type) {
      case 'clear/set':
        return null;
      case 'session/clear':
        return null;
      case 'success/set':
        return action.data;
      default:
        return state;
    }
}

//success handles from server responses
function info(state = null, action) {
    switch(action.type) {
      case 'clear/set':
        return null;
      case 'session/clear':
        return null;
      case 'info/set':
        return action.data;
      default:
        return state;
    }
}

function root_reducer(state, action) {
    let reducer = combineReducers({
         users, parties, error, success, session, info
    });
    let state1 = reducer(state, action);
    console.log(state1)
    return state1;
}

let store = createStore(root_reducer);
export default store;

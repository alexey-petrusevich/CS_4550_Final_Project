import { connect } from 'react-redux';
import { useState } from 'react';
import { get_user_id } from '../store'
import OAuth2Login from 'react-simple-oauth2-login';

export const URL = "";
if (process.env.NODE_ENV === "prod") {
  URL = "http://spotifyparty.morrisonineu.org/api/v1/auth/callback";
} else {
  URL = "http://localhost:4000/api/v1/auth/callback";
}

function SpotifyAuth({callback}) {
  let [msg, setMsg] = useState("");

  // gets the id of the requesting user as state for the server
  // TODO get rid of
  let id = get_user_id()

  return (
    <div>
      <OAuth2Login
        authorizationUrl="https://accounts.spotify.com/authorize"
        responseType="code"
        clientId="b6c7bd84e4724169b21570019ea15078"
        redirectUri="http://spotifyparty.morrisonineu.org/api/v1/auth/callback" // Needs to be changed manually
        scope="user-modify-playback-state playlist-read-private user-read-playback-state"
        state={id}
        className="auth-button"
        buttonText="Link with Spotify"
        onRequest={() => setMsg("Awaiting authorization from Spotify")}
        onSuccess={() => {
          setMsg("Successfully linked with Spotify")
          callback(true)
        }}
        onFailure={() => {
          setMsg("Error linking your account with Spotify")
          callback(false)
        }}/>
      <br/>
      <p><i className="linked-msg">{ msg }</i></p>
    </div>
  );
}

function authprops() {
  return {};
}

export default connect(authprops)(SpotifyAuth);

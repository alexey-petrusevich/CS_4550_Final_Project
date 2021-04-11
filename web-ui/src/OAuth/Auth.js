import { connect } from 'react-redux';
import { useState } from 'react';
import { get_user_id } from '../store'
import OAuth2Login from 'react-simple-oauth2-login';

export const URL = process.env.NODE_ENV.trim() === "production" ? process.env.REACT_APP_PROD_URL : process.env.REACT_APP_DEV_SERVER_URL;

function SpotifyAuth({u_id, callback}) {
  let [msg, setMsg] = useState("");

  const redirect_uri = "http://" + URL + "/api/v1/auth/callback"

  return (
    <div>
      <OAuth2Login
        authorizationUrl="https://accounts.spotify.com/authorize"
        responseType="code"
        clientId="16d93cc5896d4cc58a6f5fa4d0a946e8"
        redirectUri={redirect_uri}
        scope="user-read-playback-state user-modify-playback-state playlist-read-private"
        state={u_id}
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

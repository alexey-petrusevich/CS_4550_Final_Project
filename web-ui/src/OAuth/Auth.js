import { Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { set_auth } from '../api';
import { get_user_id } from '../store'
import OAuth2Login from 'react-simple-oauth2-login';

function SpotifyAuth() {
  let [msg, setMsg] = useState("");

  function onSuccess ({ code }) {
    setMsg("Your party is linked with Spotify")
    set_auth({code: code, user_id: get_user_id()});
  }

  return (
    <div>
      <OAuth2Login
        authorizationUrl="https://accounts.spotify.com/authorize"
        responseType="code"
        clientId="b6c7bd84e4724169b21570019ea15078"
        redirectUri="http://localhost:3000/callback"
        scope="user-modify-playback-state playlist-read-private"
        buttonText="Link with Spotify"
        onRequest={() => setMsg("Awaiting authorization from Spotify")}
        onSuccess={onSuccess}
        onFailure={() => setMsg("Not linked with Spotify")}/>
      <p><i>{ msg }</i></p>
    </div>
  );
}

function authprops() {
  return {};
}

export default connect(authprops)(SpotifyAuth);

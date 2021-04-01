import { Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import OAuth2Login from 'react-simple-oauth2-login';

function SpotifyAuth() {

  //--------------------------SPOTIFY AUTH FLOW-------------------------
  //authenticates the host's Spotify account
  function authenticate() {
    console.log("auth");
  }


  return (
    <div>
      <Form onSubmit={authenticate}>
        <Button variant="primary" type="submit">
          Link With Spotify
        </Button>
      </Form>
    </div>
  );
}

function authprops() {
  return {};
}

export default connect(authprops)(SpotifyAuth);

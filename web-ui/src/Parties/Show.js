import { Row, Col, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useLocation } from 'react-router-dom';

//import NewRequest from "../Requests/New";

//--------------------------SPOTIFY AUTH FLOW-------------------------
//authenticates the host's Spotify account
function authenticate() {
  console.log("auth");
}

//determines if the account has been successfully linked yet
function SLON({session}) {
  //auth token will be part of
  if (session.auth_token) {
    return <p><i>Spotify account linked</i></p>;
  }
  else {
      return (
        <Form onSubmit={authenticate}>
          <Button variant="primary" type="submit">
            Link With Spotify
          </Button>
        </Form>
      );
  }
}

const SpotifyLinkedOrNot = connect(
  ({session}) => ({session}))(SLON);
//------------------------------------------------------------------

function ShowParty({parties}) {

  //determines what party to display based on the path
  const location = useLocation();
  let party_number = location.pathname.split("/")[2];
  let party = parties[party_number - 1];
  localStorage.setItem("party_id", party.id);

  //determines the role of this user
  let username = localStorage.getItem("session").username;
  if (true) {
    return (
      <Row>
        <Col>
          <h2>{party.roomname}</h2>
          <p><b>Description: </b>{party.description}</p>
          <p><i>You are the host</i></p>
          <SpotifyLinkedOrNot />

          <h3>List of Songs</h3>
          <p><i>List of songs to choose from for voting</i></p>

          <h3>Voting</h3>
          <p><i>Reults of most recent or current round of voting</i></p>

          <h3>Requests</h3>
          <p><i>Attendee requests</i></p>


        </Col>
      </Row>
    );


  } else {
    return (
      <Row>
        <Col>
          <h2>{party.roomname}</h2>
          <p><b>Description: </b>{party.description}</p>
          <p><i>You are an attendee</i></p>

          <h3>Currently Playing</h3>
          <p><i>Give feedback on the current playing song</i></p>

          <h3>Voting</h3>
          <p><i>Cast your votes for the next few songs to be played</i></p>

          <h3>Request a Song</h3>
          <p><i>Request a new song by specifying a title and artist</i></p>


        </Col>
      </Row>
    );
  }


}

export default connect(({parties, session}) => ({parties, session}))(ShowParty);

import { Row, Col, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useLocation } from 'react-router-dom';
import { get_parties } from '../api';
import SpotifyAuth from "../OAuth/Auth";

//import NewRequest from "../Requests/New";

//------------------------------------------------------------------

function ShowParty({parties, session}) {

  console.log("parties", parties)

  if (parties.length === 0) {
    console.log("no parties");
    parties = get_parties()
  }
  console.log(parties)

  //determines what party to display based on the path
  const location = useLocation();
  let party_number = location.pathname.split("/")[2];
  let party = parties[party_number - 1];
  //localStorage.setItem("party_id", party.id);

  //determines the role of this user
  let username = session.username
  let hostname = party.host.username;
  if (username === hostname) {
    return (
      <Row>
        <Col>
          <h2>{party.name}</h2>
          <p><b>Description: </b>{party.description}</p>
          <p><b>Attendee access code: </b>{party.roomcode}</p>
          <p><i>You are the host</i></p>
          <SpotifyAuth />

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
          <h2>{party.name}</h2>
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
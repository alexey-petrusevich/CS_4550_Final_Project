import { Row, Col, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { get_party } from '../api';
import SpotifyAuth from "../OAuth/Auth";
import ShowSongs from "../Songs/Show";

//playback control images
import play from "../images/play.png";
import pause from "../images/pause.png";
import skip from "../images/skip.png";

//play, pause, skip playback controls
function PlaybackControls() {
  return (
    <Row className="playback-controls">
      <button className="playback-btn"><img src={play}
                   alt="Play"
                   className="playback-img"
                   onClick={() => console.log("Play song")} />
      </button>
      <button className="playback-btn"><img src={pause}
                   alt="Play"
                   className="playback-img"
                   onClick={() => console.log("Play song")} />
      </button>
      <button className="playback-btn"><img src={skip}
                   alt="Play"
                   className="playback-img"
                   onClick={() => console.log("Play song")} />
      </button>
    </Row>
  )
}


function ShowParty({session}) {
  const [party, setParty] = useState({name: "", roomcode: "",
      description: "", songs: [], host: {username: "N/A"}});

  //loads the party with the id given by the route path
  let { id } = useParams();
  useEffect(() => {
    get_party(id).then((p) => setParty(p))
  },[id]);

  let username = session.username
  let hostname = party.host.username;
  if (username === hostname) {
    return (
      <Row>
        <Col>
          <PlaybackControls />
          <h2>{party.name}</h2>
          <p><b>Description: </b>{party.description}</p>
          <p><b>Attendee access code: </b>{party.roomcode}</p>
          <p><i>You are the host</i></p>
          <SpotifyAuth />
          <div className="component-spacing"></div>
          <h3>Queue</h3>
          <p><i>List of queued songs</i></p>
          <div className="component-spacing"></div>
          <h3>List of Songs</h3>
          <p><i>List of songs to choose from for voting</i></p>
          <ShowSongs songs={party.songs}/>
          <div className="component-spacing"></div>
          <h3>Voting</h3>
          <p><i>Reults of most recent or current round of voting</i></p>
          <div className="component-spacing"></div>
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
          <div className="component-spacing"></div>
          <h3>Currently Playing</h3>
          <p><i>Give feedback on the current playing song</i></p>
          <div className="component-spacing"></div>
          <h3>Voting</h3>
          <p><i>Cast your votes for the next few songs to be played</i></p>
          <div className="component-spacing"></div>
          <h3>Request a Song</h3>
          <p><i>Request a new song by specifying a title and artist</i></p>
        </Col>
      </Row>
    );
  }


}

export default connect(({session}) => ({session}))(ShowParty);

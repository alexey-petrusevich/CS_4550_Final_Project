import { Row, Col, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import { get_party } from '../api';
import SpotifyAuth from "../OAuth/Auth";

//playback control images
import play from "../images/play.png";
import pause from "../images/pause.png";
import skip from "../images/skip.png";


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


function ShowParty({ parties, session }) {

  // if (parties.length === 0) {
  //   console.log("no parties");
  //   await get_party("1");
  // }
  // console.log("After party data get");
  //
  // //determines what party to display based on the path
  const location = useLocation();
  let party_number = location.pathname.split("/")[2];
  let party = parties[party_number - 1];

  //determines the role of this user
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

export default connect(({parties, session}) => ({parties, session}))(ShowParty);

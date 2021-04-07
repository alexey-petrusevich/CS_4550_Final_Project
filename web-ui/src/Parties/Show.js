import { Row, Col, Form, Button,ListGroup } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { get_party, playback } from '../api';
import SpotifyAuth from "../OAuth/Auth";
import ShowSongs from "../Songs/Show";
import { connect_cb, channel_join, get_playlists } from "../Channels/socket";

//playback control images
import play from "../images/play.png";
import pause from "../images/pause.png";
import skip from "../images/skip.png";

//play, pause, skip playback controls
function PlaybackControls({host_id}) {
  return (
    <Row className="playback-controls">
      <button className="playback-btn"><img src={play}
                   alt="Play"
                   className="playback-img"
                   onClick={() => playback(host_id, "play")} />
      </button>
      <button className="playback-btn"><img src={pause}
                   alt="Play"
                   className="playback-img"
                   onClick={() => playback(host_id, "pause")} />
      </button>
      <button className="playback-btn"><img src={skip}
                   alt="Play"
                   className="playback-img"
                   onClick={() => playback(host_id, "skip")} />
      </button>
    </Row>
  )
}

function PlaylistControls({host_id}) {
  const [state, setState] = useState({playlists: []});
  useEffect(() => {
    connect_cb(setState);
  });

  function select_playlists(uri) {
    console.log("Selected playlist ", uri);
  }

  let playlists = state.playlists.map((pl) => (
    <ListGroup.Item action onClick={() => select_playlists(pl.playlist_uri)}>
      <p><b>{pl.playlist_title}</b> <i className="tracks">{pl.num_tracks} songs</i></p>
    </ListGroup.Item>
  ));

  return (
    <div>
      <h3>Select A Playlist</h3>
      <i>Choose one of your recent playlists for this party.</i>
      <ListGroup>
        { playlists }
      </ListGroup>
      <div className="component-spacing"></div>
    </div>
  )
}


function ShowParty({session}) {
  const [party, setParty] = useState({name: "", roomcode: "",
      description: "", songs: [], host: {username: "N/A"}});

  //loads the party with the id given by the route path, joins the channel
  let { id } = useParams();
  useEffect(() => {
    get_party(id).then((p) => setParty(p));
  },[id]);

  //join the channel for this party
  channel_join(party.roomcode)

  function on_return() {
    console.log("returned");
    get_playlists(party.host.id);
  }

  let username = session.username
  let hostname = party.host.username;
  if (username === hostname) {
    return (
      <Row>
        <Col>
          <PlaybackControls host_id={party.host.id}/>
          <h2>{party.name}</h2>
          <p><b>Description: </b>{party.description}</p>
          <p><b>Attendee access code: </b>{party.roomcode}</p>
          <p><i>You are the host</i></p>
          <SpotifyAuth callback={on_return}/>
          <div className="component-spacing"></div>
          <PlaylistControls host_id={party.host.id}/>
          <h3>List of Songs</h3>
          <p><i>List of songs to choose from for voting</i></p>
          <ShowSongs songs={party.songs} user_id={party.host.id}/>
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

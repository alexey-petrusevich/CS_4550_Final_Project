import { Row, Col, Form, Button, Dropdown, Jumbotron, Image } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState, useEffect } from 'react';
import { useLocation, useHistory, useParams } from 'react-router-dom';
import { get_party, get_parties, playback } from '../api';
import SpotifyAuth from "../OAuth/Auth";
import ShowSongs from "../Songs/Show";
import { connect_cb, channel_join, get_playlists, set_songs, update_party_active } from "../socket";

import concert from "../images/concert.jpg";

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

//Playlist selection controls
function PlaylistControls({host_id, party_id}) {
  const [playlist, setPlaylist] = useState("Not yet selected")

  const [state, setState] = useState({playlists: []});
  useEffect(() => {
    connect_cb(setState);
  });

  //sends the selected playlist through the channel to populate
  //the party's songs
  function select_playlist(plist) {
    setPlaylist(plist.playlist_title);
    set_songs(plist.playlist_uri, party_id, host_id);
  }

  let playlists = state.playlists.map((pl) => (
    <Dropdown.Item onSelect={() => select_playlist(pl)}>
      <p><b>{pl.playlist_title}</b> <i className="tracks">{pl.num_tracks} songs</i></p>
    </Dropdown.Item>
  ));

  return (
    <div>
      <Dropdown className="dropdown">
        <Dropdown.Toggle className="dropdown-button">Choose A Playlist</Dropdown.Toggle>
        <Dropdown.Menu>
          { playlists }
        </Dropdown.Menu>
      </Dropdown>
      <p className="linked-msg"><b>Selected playlist: </b><i>{playlist}</i></p>
    </div>
  )
}

function ShowParty({session}) {
  let history = useHistory();
  const [party, setParty] = useState({name: "", roomcode: "",
      description: "", songs: [], is_active: false, host: {username: "N/A"}});
  const [authed, setAuthed] = useState(false);

  //loads the party with the id given by the route path
  let { id } = useParams();
  useEffect(() => {
    get_party(id).then((p) => setParty(p));
  },[id]);

  //join the channel for this party
  channel_join(party.roomcode)

  // updates the party state
  function update() {
    get_party(id).then((p) => setParty(p));
  }

  // switches a party between inactive and active; or sets it to
  // active if it is null
  function toggle_active() {
    if (party.is_active) {
      history.push("/dashboard");
      update_party_active(party.id, false);
    } else {
      update_party_active(party.id, true);
    }
    update();
  }

  // gets user's playlists on return from OAuth2
  function on_return(success) {
    if (success) {
      setAuthed(true);
      get_playlists(party.host.id);
    }
  }

  let username = session.username
  let hostname = party.host.username;
  if (username === hostname) {
    return (
      <Row>
        <Col>
          <Jumbotron className="jumbotron">
            <Image className="header-image" src={concert} rounded />
            {party.is_active &&
              <Button className="party-status" variant="danger" onClick={() =>
                toggle_active()}>
                End Party
              </Button>
            }
            <h2>{party.name}</h2>
            <p><b>Description: </b>{party.description}</p>
            <p><b>Attendee access code: </b>{party.roomcode}</p>
            <p><i>You are the host</i></p>
            {party.is_active == false &&
              <p><b><i>This party has been ended</i></b></p>
            }
            {party.is_active == null &&
              <div>
                <SpotifyAuth callback={on_return}/>
                {authed && party.songs.length == 0 &&
                  <div>
                    <PlaylistControls host_id={party.host.id} party_id={party.id}/>
                    <Button className="party-status" variant="success" onClick={() =>
                      toggle_active()}>
                      Start Party
                    </Button>
                  </div>
                }
              </div>
            }
            {party.is_active &&
              <PlaybackControls host_id={party.host.id}/>
            }
          </Jumbotron>
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

import { Row, Col, Button, Dropdown, Jumbotron, Image } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState, useEffect, useCallback } from 'react';
import { useParams } from 'react-router-dom';
import { get_party, playback } from '../api';
import SpotifyAuth from "../OAuth/Auth";
import ShowSongs from "../Songs/Show";
import RequestsNew from "../Requests/New";
import ShowRequests from "../Requests/Show";
import { connect_cb, channel_join, get_playlists, set_songs, update_party_active } from "../socket";

//jumbotron image
import concert from "../images/concert.jpg";
//playback control images
import play from "../images/play.png";
import pause from "../images/pause.png";
import skip from "../images/skip.png";

//play, pause, skip playback controls
function PlaybackControls({party_id, host_id}) {
  return (
    <Row className="playback-controls">
      <button className="playback-btn"><img src={play}
                   alt="Play"
                   className="playback-img"
                   onClick={() => playback(host_id, "play", party_id)} />
      </button>
      <button className="playback-btn"><img src={pause}
                   alt="Play"
                   className="playback-img"
                   onClick={() => playback(host_id, "pause", party_id)} />
      </button>
      <button className="playback-btn"><img src={skip}
                   alt="Play"
                   className="playback-img"
                   onClick={() => playback(host_id, "skip", party_id)} />
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
  },[]);

  //sends the selected playlist through the channel to populate
  //the party's songs
  function select_playlist(plist) {
    setPlaylist(plist.playlist_title);
    set_songs(plist.playlist_uri, party_id, host_id);
  }

  let playlists = state.playlists.map((pl, index) => (
    <Dropdown.Item key={index} onSelect={() => select_playlist(pl)}>
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

function PartyBody({is_host, party, update, user_id}) {

  if (is_host) {
    if (party.is_active) {
      return (
        <div>
          <h3>Requests</h3>
          <p><i>Song requests from your attendees that you can add to your Spotify queue.</i></p>
          <ShowRequests party={party} cb={update} />
          <div className="component-spacing"></div>
          <h3>List of Songs</h3>
          <p><i>Songs from your selected playlist that attendees can vote on and you can add to your Spotify queue.</i></p>
          <ShowSongs party={party} cb={update} is_host={true}/>
        </div>
      );
    } else if (party.is_active == null) {
      return (
        <div>
          <p>Please login with Spotify to start your party!</p>
        </div>
      );
    } else {
      return (
        <div>
          <h3>Played Songs</h3>
          <p><i>Here's what songs were played during your party.</i></p>
          <ShowSongs party={party} />
          <div className="component-spacing"></div>
          <h3>Requested Songs</h3>
          <p><i>Here's what songs your attendees requested you play.</i></p>
          <ShowRequests party={party} />
        </div>
      );
    }
  } else { //attendee
    if (party.is_active) {
      return (
        <div>
          <h3>Request A Song</h3>
          <p><i>Submit a request to the host and they might add it to the party queue!</i></p>
          <RequestsNew party_id={party.id} party_code={party.roomcode}/>
          <div className="component-spacing"></div>
          <h3>List of Songs</h3>
          <p><i>Songs from the host's selected playlist that you can vote on to help get them played!</i></p>
          <ShowSongs party={party} user_id={user_id} cb={update} is_host={is_host}/>
        </div>
      )
    } else if (party.is_active == null) {
      return (
        <div>
          <p>Waiting for the host to start this party...</p>
        </div>
      );
    } else {
      return (
        <div>
          <h3>Played Songs</h3>
          <p><i>Here's what songs the host played during this party.</i></p>
          <ShowSongs party={party} cb={update} />
          <div className="component-spacing"></div>
          <h3>Your Requested Songs</h3>
          <p><i>Here's what songs you requested the host play.</i></p>
          <ShowRequests party={party} user_id={user_id} />
        </div>
      );
    }
  }
}

function ShowParty({session}) {
  const [party, setParty] = useState({name: "", roomcode: "",
      description: "", songs: [], requests: [], is_active: false, host: {username: "N/A"}});
  const [authed, setAuthed] = useState(false);


    //loads the party with the id given by the route path
    let { id } = useParams();

  // updates the party state
  const update = useCallback(
    () => {
      get_party(id).then((p) => setParty(p));
    },
    [id],
  );

  useEffect(() => {
    get_party(id).then((p) => {
      setParty(p);
      channel_join(p.roomcode, update);
    });
    //join the channel for this party

  },[id, update]);

  // switches a party between inactive and active; or sets it to
  // active if it is null
  function toggle_active() {
    if (party.is_active) {
      update_party_active(party.id, false, party.roomcode);
    } else {
      update_party_active(party.id, true, party.roomcode);
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
            <div className="party-info">
              <h2>{party.name}</h2>
              <p><b>Description: </b>{party.description}</p>
              <p><b>Attendee access code: </b>{party.roomcode}</p>
              <p><i>You are the host</i></p>
              {party.is_active === false &&
                <p><b><i>This party has ended</i></b></p>
              }
              {party.is_active === null &&
                <div>
                  <SpotifyAuth u_id={party.host.id} callback={on_return}/>
                  {authed  &&
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
                <PlaybackControls party_id={party.id} host_id={party.host.id}/>
              }
            </div>
          </Jumbotron>
          <div style={{'paddingBottom':'30px'}}>
          <PartyBody is_host={true} party={party} update={update} />
          </div>
        </Col>
      </Row>
    );
    //attendee
  } else {
    return (
      <Row>
        <Col>
          <Jumbotron className="jumbotron">
            <Image className="header-image" src={concert} rounded />
            <h2>{party.name}</h2>
            <p><b>Description: </b>{party.description}</p>
            <p><i>You are an attendee</i></p>
            {party.is_active === false &&
              <p><b><i>This party has ended</i></b></p>
            }
          </Jumbotron>
          <div style={{'paddingBottom':'30px'}}>
          <PartyBody is_host={false} party={party} update={update} user_id={session.user_id} />
          </div>
        </Col>
      </Row>
    );
  }
}

export default connect(({session}) => ({session}))(ShowParty);

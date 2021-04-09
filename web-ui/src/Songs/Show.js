import { Row, Col, Form, Button, Card } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { queue_track } from '../api.js';
import { queue_song } from '../socket.js';

// import thumbs_up from "../images/thumbsup.png";
// import thumbs_down from "../images/thumbsdown.png";

function Voting() {
  return (
    <Row className= "voting-buttons">
      <button className="vote-btn"><img
                   alt="Up"
                   className="vote-img"
                   onClick={() => console.log("Up vote")} />
      </button>
      <button className="vote-btn"><img
                   alt="Down"
                   className="vote-img"
                   onClick={console.log("Down vote")} />
      </button>
    </Row>
  )
}

// displays song cards
// includes 'Add To Queue' button if the party is active
function SongDisplay({song, host_id, active, is_host, callback}) {
    return (
        <Col md="3">
          <Card className="song-card">
            <Card.Title>{song.title}</Card.Title>
            <Card.Text>
              By {song.artist}<br />
            </Card.Text>
            { active && is_host &&
              <Button variant="primary" onClick={() => {
                //queue_track(host_id, "queue", song.track_uri);
                console.log("Updating song to be played")
                queue_song(host_id, song, true, callback);
                }}>
                Add To Queue
              </Button>
            }
            <Voting />
          </Card>
        </Col>
    );
}

//shows songs associated with the party and it's active state
//i.e. shows un-played songs from the selected playlists if the party
//is active and shows played songs if the party has ended
export default function ShowSongs({party, cb, is_host}) {
  console.log("Unfiltered songs", party.songs);
    let displaySongs = party.songs.filter((s) => !s.played == party.is_active)
    console.log("Filtered songs", displaySongs);
    let song_cards = displaySongs.map((song) => (
      <SongDisplay song={song} host_id={party.host.id} is_host={is_host} active={party.is_active} callback={cb} key={song.id} />
    ));
    return (
      <Row>
        {song_cards}
      </Row>
    );
}

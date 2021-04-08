import { Row, Col, Form, Button, Card } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { queue_track } from '../api.js';
import { set_song_played } from '../socket.js';

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


function SongDisplay({song, host_id, callback}) {
    return (
        <Col md="3">
          <Card className="song-card">
            <Card.Title>{song.title}</Card.Title>
            <Card.Text>
              By {song.artist}<br />
            </Card.Text>
            <Button variant="primary" onClick={() => {
              queue_track(host_id, "queue", song.track_uri);
              set_song_played(song.id, callback);
            }}>
              Add To Queue
            </Button>
            <Voting />
          </Card>
        </Col>
    );
}

export default function ShowSongs({songs, user_id, cb, active_party}) {
  console.log("Unfiltered songs", songs);
    let displaySongs = songs.filter((s) => !s.played == active_party)
    console.log("Filtered songs", displaySongs);
    let song_cards = displaySongs.map((song) => (
      <SongDisplay song={song} host_id={user_id} callback={cb} key={song.id} />
    ));
    return (
      <Row>
        {song_cards}
      </Row>
    );
}

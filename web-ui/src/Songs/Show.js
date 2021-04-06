import { Row, Col, Form, Button, Card } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { queue_track, get_playlists } from '../api.js';

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


function SongDisplay({song, host_id}) {
  console.log(song);
  return (
    <Col md="3">
      <Card className="song-card">
        <Card.Title>{song.title}</Card.Title>
        <Card.Text>
          By {song.artist}<br />
        </Card.Text>
        <Button variant="primary" onClick={() =>
          queue_track(host_id, "queue", song.track_uri)}>
          Add To Queue
        </Button>
        <Button variant="primary" onClick={() =>
          get_playlists(host_id)}>
          Get Playlists
        </Button>
        <Voting />
      </Card>
    </Col>
  );
}

export default function ShowSongs({songs, user_id}) {
  console.log(songs);
    let song_cards = songs.map((song) => (
      <SongDisplay song={song} host_id={user_id} key={song.id} />
    ));

    return (
      <Row>
        {song_cards}
      </Row>
    );
}

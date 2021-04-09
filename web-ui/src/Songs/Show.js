import { Row, Col, Form, Button, Card } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { queue_track, user_vote } from '../api.js';
import { queue_song } from '../socket.js';

import thumbs_up from "../images/thumbs_up.png";
import thumbs_down from "../images/thumbs_down.png";

function Voting({count, song_id, user_id, cb}) {

  function submit_vote(value, callback) {
    user_vote({song_id: song_id, user_id: user_id, value: value})
      .then((resp) => {
        callback()
      });
  }

  return (
    <Row className="voting-buttons">
      <Col>
        <button className="vote-btn vote-up"><img src={thumbs_up}
                     alt="Up"
                     className="vote-img"
                     onClick={() => {
                       console.log("Up vote from ", user_id, " for song ", song_id)
                       submit_vote(1, cb);

                     }} />
        </button>
      </Col>
      <Col>
        <p className="votes">Votes: { count }</p>
      </Col>
      <Col>
        <button className="vote-btn vote-down"><img src={thumbs_down}
                     alt="Down"
                     className="vote-img"
                     onClick={() => {
                       console.log("Down vote", -1);
                       submit_vote(-1, cb);
                     }} />
        </button>
      </Col>
    </Row>
  )
}

// displays song cards
// includes 'Add To Queue' button if the party is active
function SongDisplay({song, host_id, active, is_host, user_id, callback}) {
  const [count, setCount] = useState(0);

  //updates the value of the count after new votes are received (after the callback)
  useEffect(() => {
    let vote_total = 0;
    song.votes.map((vote) => { vote_total += vote.value });
    setCount(vote_total);
  });

  return (
    <Col md="3">
      <Card className="song-card">
        <Card.Title>{song.title}</Card.Title>
        <Card.Text>
          By {song.artist}<br />
        </Card.Text>
        { active && is_host &&
          <div>
            <Card.Text>Votes: {count}</Card.Text>
            <Button variant="primary" onClick={() => {
              //queue_track(host_id, "queue", song.track_uri);
              console.log("Updating song to be played")
              queue_song(host_id, song, true, callback);
              }}>
              Add To Queue
            </Button>
          </div>
        }
        { active && !is_host &&
          <Voting count={count} song_id={song.id} user_id={user_id} cb={callback}/>
        }
      </Card>
    </Col>
  );
}

//shows songs associated with the party and it's active state
//i.e. shows un-played songs from the selected playlists if the party
//is active and shows played songs if the party has ended
export default function ShowSongs({party, cb, user_id, is_host}) {
  console.log("Unfiltered songs", party.songs);
    let displaySongs = party.songs.filter((s) => !s.played == party.is_active)
    console.log("Filtered songs", displaySongs);
    let song_cards = displaySongs.map((song) => (
      <SongDisplay song={song} host_id={party.host.id} user_id={user_id} is_host={is_host} active={party.is_active} callback={cb} key={song.id} />
    ));
    return (
      <Row>
        {song_cards}
      </Row>
    );
}

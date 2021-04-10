import { Row, Col, Button, Card } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { user_vote } from '../api.js';
import { queue_song } from '../socket.js';

import thumbs_up from "../images/thumbs_up.png";
import thumbs_down from "../images/thumbs_down.png";

function Voting({count, song_id, user_id, party_code, cb}) {

  function submit_vote(value, callback) {
    user_vote({song_id: song_id, user_id: user_id, value: value, party_code: party_code});
  }

  return (
    <Row className="voting-buttons">
      <Col>
        <button className="vote-btn vote-up"><img src={thumbs_up}
                alt="Up" className="vote-img"
                onClick={() => {
                  submit_vote(1, cb);
                }} />
        </button>
      </Col>
      <Col>
        <p className="votes">Votes: { count }</p>
      </Col>
      <Col>
        <button className="vote-btn vote-down"><img src={thumbs_down}
                alt="Down" className="vote-img"
                onClick={() => {
                  submit_vote(-1, cb);
                }} />
        </button>
      </Col>
    </Row>
  )
}

// displays song cards
// includes 'Add To Queue' button if the party is active
function SongDisplay({song, party, host_id, active, is_host, user_id, callback}) {
  const [count, setCount] = useState(0);

  //updates the value of the count after new votes are received (after the callback)
  useEffect(() => {
    let vote_total = 0;
    song.votes.map((vote) => { vote_total += vote.value });
    setCount(vote_total);
  }, [song.votes]);

  return (
    <Col sm="3" style={{ 'paddingBottom':'20px' }}>
      <Card className="song-card">
        <Card.Title className="song-title"><strong>{song.title}</strong></Card.Title>
        <Card.Text>
          By {song.artist}<br />
        </Card.Text>
        { active && is_host &&
          <Row className="song-action-row">
            <Button className="queue-button" variant="primary" onClick={() => {
              queue_song(host_id, song, true, party.roomcode, callback, party.id);
              }}>
              Add To Queue
            </Button>
            <Card.Text className="vote-display">Votes: {count}</Card.Text>
          </Row>
        }
        { active && !is_host &&
          <Voting count={count} party_code={party.roomcode} song_id={song.id} user_id={user_id} cb={callback}/>
        }
      </Card>
    </Col>
  );
}

//shows songs associated with the party and it's active state
//i.e. shows un-played songs from the selected playlists if the party
//is active and shows played songs if the party has ended
export default function ShowSongs({party, cb, user_id, is_host}) {
    let displaySongs = party.songs.filter((s) => !s.played === party.is_active)
    let song_cards = displaySongs.map((song) => (
      <SongDisplay song={song} host_id={party.host.id} user_id={user_id}
       is_host={is_host} active={party.is_active} callback={cb}
       party={party} key={song.id} />
    ));
    return (
      <Row>
        {song_cards}
      </Row>
    );
}

import { Row, Col, Form, Button, Card } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { queue_track } from '../api.js';
import { set_song_played } from '../socket.js';

function RequestCard({request, party_id}) {

  // queue_track(host_id, "queue", song.track_uri);
  // set_song_played(song.id, callback);




  function submit() {

  }

  return (
    <Col md="3">
      <Card className="song-card">
        <Card.Title>{request.title}</Card.Title>
        <Card.Text>
          <p>By {request.artist} </p>
          <p>Requested By {request.user.username}</p>
        </Card.Text>
        <Button variant="primary" onClick={() => {
          console.log("Queueing song ", request.track_uri);
        }}>
          Add To Queue
        </Button>
      </Card>
    </Col>
  );
}

export default function ShowRequests({requests, party_id}) {
  let request_cards = requests.map((request) => (
    <RequestCard request={request} party_id={party_id} key={request.id} />
  ));
  return (
    <Row>
      {request_cards}
    </Row>
  );
}

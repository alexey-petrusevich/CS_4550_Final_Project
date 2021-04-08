import { Row, Col, Form, Button, Card } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { queue_track } from '../api.js';
import { set_song_played } from '../socket.js';

function RequestCard({request, party_active, party_id}) {

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
        {party_active &&
          <Button variant="primary" onClick={() => {
            console.log("Queueing song ", request.track_uri);
          }}>
            Add To Queue
          </Button>
        }
      </Card>
    </Col>
  );
}

//displays the requests of the given party
export default function ShowRequests({party, user_id}) {
  let request_cards;
  //determines what requests to show
  //if a user_id is given, only dislpay their requests
  if (user_id) {
    let filtered_requests = party.requests.filter((req) => req.user.id == user_id)
    request_cards = filtered_requests.map((request) => (
      <RequestCard request={request} party_id={party.id} party_active={party.is_active} key={request.id} />
    ));

  } else {
    request_cards = party.requests.map((request) => (
      <RequestCard request={request} party_id={party.id} party_active={party.is_active} key={request.id} />
    ));
  }
  return (
    <Row>
      {request_cards}
    </Row>
  );
}

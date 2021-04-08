import { Row, Col, Form, Button, Card } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { useLocation, useParams } from 'react-router-dom';
import { queue_track } from '../api.js';
import { set_song_played } from '../socket.js';

function RequestCard({request, party_id}) {

  function submit() {

  }

  return (
    <Card className="request-card">
      <Card.Text>
        <Col sm={3}>
          <p><b>Song Title: </b>{request.title}</p>
        </Col>
        <Col sm={3}>
          <p><b>Song Artist: </b>{request.artist}</p>
        </Col>
        <Col sm={3}>
          <p><i>Requested By: </i>{request.user.username}</p>
        </Col>
        <Col sm={2}>
          <Button variant="primary" type="submit">
            Add To Queue
          </Button>
        </Col>
      </Card.Text>
    </Card>
  );
}

export default function ShowRequests({requests, party_id}) {
  let party_requests = requests.filter((rqs) => rqs.party.id === party_id)
  console.log("Filtered songs", party_requests);
  let request_cards = party_requests.map((request) => (
    <RequestCard request={request} party_id={party_id} key={request.id} />
  ));
  return (
    <Row>
      {request_cards}
    </Row>
  );
}

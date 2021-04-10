import { Row, Col, Button, Card } from 'react-bootstrap';
import { queue_song } from '../socket.js';

function RequestCard({request, party, update}) {

  // queue_track(host_id, "queue", song.track_uri);
  // set_song_played(song.id, callback);

  return (
    <Col md="3">
      <Card className="request-card-song">
        <Card.Title><strong>{request.title}</strong></Card.Title>
        <Card.Text>
          <p>By {request.artist} </p>
          {!party.is_active && !request.played &&
              <p>Requested By {request.user.username}</p>
          }
          {!party.is_active && request.played &&
              <p>Requested By {request.user.username}<strong className="request-success"><i>PLAYED</i></strong></p>
          }
        </Card.Text>
        {party.is_active &&
          <Button variant="primary" onClick={() => {
              queue_song(party.host.id, request, false, party.roomcode, update, party.id);
          }}>
            Add To Queue
          </Button>
        }
      </Card>
    </Col>
  );
}

//displays the requests of the given party
export default function ShowRequests({party, user_id, cb}) {
  let request_cards;
  //determines what requests to show
  //if a user_id is given, only display their requests
  if (user_id) {
    let filtered_requests = party.requests.filter((req) => req.user.id === user_id)
    request_cards = filtered_requests.map((request) => (
      <RequestCard request={request} party={party} key={request.id} />
    ));

  } else if (party.is_active) {
    let filtered_requests = party.requests.filter((req) => !req.played);
    request_cards = filtered_requests.map((request) => (
      <RequestCard request={request} party={party} key={request.id} update={cb}/>
    ));
  } else {
    request_cards = party.requests.map((request) => (
      <RequestCard request={request} party={party} key={request.id}/>
    ));
  }
  return (
    <Row>
      {request_cards}
    </Row>
  );
}

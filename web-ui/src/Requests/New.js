import { Col, Form, Button, Card } from 'react-bootstrap';
import { useState } from 'react';
import { create_request } from '../api';
import { get_user_id } from '../store'

export default function RequestsNew({party_id, party_code}) {
  let [request, setRequest] = useState({});

  function submit(ev) {
    ev.preventDefault();
    //sets the user_id of the request to the current user
    request.user_id = get_user_id();
    request.party_id = party_id;
    request.party_code = party_code;
    create_request(request);
    setRequest({title: "", artist: ""});
  }

  function updateTitle(ev) {
    let p1 = Object.assign({}, request);
    p1["title"] = ev.target.value;
    setRequest(p1);
  }

  function updateArtist(ev) {
    let p1 = Object.assign({}, request);
    p1["artist"] = ev.target.value;
    setRequest(p1);
  }

  return (
      <Card className="request-card">
        <Form className="request-form" onSubmit={submit}>
          <Form.Row>
            <Col sm={6}>
              <Form.Control onChange={updateTitle}
                            placeholder="Song title"
                            value={"" || request.title} />
            </Col>
            <Col sm={5}>
              <Form.Control onChange={updateArtist}
                            placeholder="Artist name"
                            value={"" || request.artist} />
            </Col>
            <Col sm={1}>
              <Button variant="primary" type="submit">
                Request
              </Button>
            </Col>
          </Form.Row>
        </Form>
      </Card>
  );
}

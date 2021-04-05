import { Row, Col, Form, Button } from 'react-bootstrap';
import { useState } from 'react';
import { useHistory } from 'react-router-dom';
import { create_party, get_parties } from '../api';
import { get_user_id } from '../store'
import SpotifyAuth from "../OAuth/Auth";

export default function PartiesNew() {
  let history = useHistory();
  let [party, setParty] = useState({});

  function submit(ev) {
    ev.preventDefault();
    //sets the host_id to the current user
    party.host_id = get_user_id();
    create_party(party).then((resp) => {
      if (resp["errors"]) {
        console.log("errors", resp.errors);
      }
      else {
        get_parties();
        history.push("/parties/" + resp.data.id);
      }
    });
  }

  function updateName(ev) {
    let p1 = Object.assign({}, party);
    p1["name"] = ev.target.value;
    setParty(p1);
  }

  function updateCode(ev) {
    let p1 = Object.assign({}, party);
    p1["roomcode"] = ev.target.value;
    setParty(p1);
  }

  function updateDesc(ev) {
    let p1 = Object.assign({}, party);
    p1["description"] = ev.target.value;
    setParty(p1);
  }

  return (
    <Row>
      <Col>
        <h2>Start A New Party</h2>
        <Form onSubmit={submit}>
          <Form.Group>
            <Form.Label>Party Name</Form.Label>
            <Form.Control rows={1}
                          onChange={updateName}
                          value={"" || party.roomname} />
          </Form.Group>
          <Form.Group>
            <Form.Label>Description</Form.Label>
            <Form.Control as="textarea"
                          rows={2}
                          onChange={updateDesc}
                          value={"" || party.description} />
          </Form.Group>
          <Button variant="primary" type="submit">
            Create Party
          </Button>
        </Form>
      </Col>
    </Row>
  );
}

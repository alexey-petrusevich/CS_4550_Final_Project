import { Button, Form } from 'react-bootstrap';
import { useState } from 'react';
import { useHistory } from 'react-router-dom';
import { connect } from 'react-redux';
import { join_party, get_parties } from '../api.js';

function JoinParty({parties, session}) {
  let history = useHistory();
  const [roomcode, setRoomcode] = useState("");

  function submit() {
    if (session) {
      let user_id = session.user_id;
      let party = parties.filter( (party) => roomcode === party.roomcode);
      let party_id = party[0].id;
      join_party(party_id, user_id);
      get_parties();
      history.push("/parties/" + party_id);
    }
  }

  return (
      <Form onSubmit={submit}>
        <Form.Group>
          <Form.Control rows={1}
                        onChange={(ev) => setRoomcode(ev.target.value)}
                        value={roomcode}
                        placeholder="Enter a room code"/>
        </Form.Group>
        <Button className="btn-join" variant="primary" type="submit">
          Join
        </Button>
      </Form>
    );
  }

export default connect(({parties, session}) => ({parties, session}))(JoinParty);

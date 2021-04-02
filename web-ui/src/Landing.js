import { Row, Col, Card, Button, Form } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
import { useState } from 'react';
import { useHistory } from 'react-router-dom';

function Landing() {
  const history = useHistory();
  let [roomcode, setRoomcode] = useState("");
  let [joinform, setJoinForm] = useState();

  function updateRoomcode(ev) {
    console.log(ev.target.value)
    setRoomcode();
  }

  function submit() {

  }

  function joinParty() {
    console.log("Join party")
    setJoinForm(
      <Form onSubmit={submit}>
        <Form.Group>
          <Form.Control rows={1}
                        onChange={(ev) => updateRoomcode(ev)}
                        value={roomcode}
                        placeholder="Enter a room code"/>
        </Form.Group>
      </Form>
    );
  }

  function startParty() {
    history.push("/parties/new");
  }

  return (
    <div className="landing-page">
      <br/>
      <br/>
      <p className="welcome"><i>WELCOME TO THE PARTY</i></p>
      <div className="home-buttons">
        <Col>
          <Button className="home-button" onClick={joinParty}>Join a party</Button>
          <Button className="home-button" onClick={startParty}>Start a party</Button>
        </Col>
        {joinform}
      </div>
    </div>
  );
}

function landingprops() {
  return {};
}

export default connect(landingprops)(Landing);

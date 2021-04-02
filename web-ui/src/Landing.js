import { Row, Col, Card, Button, Form } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
import { useState } from 'react';
import { useHistory } from 'react-router-dom';
import { get_parties } from './api.js';

import PartiesNew from "./Parties/New";

//landing page when users first access our site
function Landing(session, parties) {
  console.log("session", session.session);
  const history = useHistory();
  const [joinform, setJoinform] = useState(false);
  const [startform, setStartform] = useState(false);
  const [roomcode, setRoomcode] = useState("");
  const [no_session_msg, setMsg] = useState("");


  // clears forms for when the session is not active
  function clearForms() {
    setStartform(false);
    setJoinform(false);
  }

  function joinParty() {
    if (session.session) {
      setStartform(false);
      setJoinform(true);
      setMsg("");
    } else {
      clearForms();
      setMsg("You must be logged in to do that.");
    }
  }

  function startParty() {
    if (session.session) {
      setJoinform(false);
      setStartform(true);
      setMsg("");
    } else {
      clearForms();
      setMsg("You must be logged in to do that.");
    }
  }

  function submit() {
    if (session.session) {

      get_parties();
      console.log("parties", parties);
      let last_party = parties[parties.length - 1];
      console.log("most recent party", last_party);
      history.push("/parties/" + last_party.id);
    } else {
      clearForms();
      setMsg("You must be logged in to do that.");
    }


  }

  return (
    <div className="landing-page">
      <br/>
      <br/>
      <p className="welcome"><i>WELCOME TO THE PARTY</i></p>
      <div>
        <div>
          <div className="home-buttons">
            <Col>
              <Button className="home-button" onClick={joinParty}>Join a party</Button>
              <Button className="home-button" onClick={startParty}>Start a party</Button>
            </Col>
          </div>
          <div>
            <p className="error-msg"><i>{ no_session_msg }</i></p>
          </div>
          <div className="landing-join">
            {joinform && (
                <Form onSubmit={submit}>
                  <Form.Group>
                    <Form.Control rows={1}
                                  onChange={(ev) => setRoomcode(ev.target.value)}
                                  value={roomcode}
                                  placeholder="Enter a room code"/>
                  </Form.Group>
                </Form>
            )}
          </div>
          <div className="landing-start">
            {startform && (
              <div className="start-form-landing">
                <PartiesNew />
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default connect(({session, parties}) => ({session, parties}))(Landing);

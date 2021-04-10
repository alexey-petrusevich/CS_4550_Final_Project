import { Col, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import store from './store';

import PartiesNew from "./Parties/New";
import JoinParty from "./Parties/Join";

//landing page when users first access our site
function Landing({session, parties}) {
  const [joinform, setJoinform] = useState(false);
  const [startform, setStartform] = useState(false);

  // clears forms for when the session is not active
  function clearForms() {
    setStartform(false);
    setJoinform(false);
  }

  function joinParty() {
    if (session) {
      setStartform(false);
      setJoinform(true);
    } else {
      clearForms();
      let action = {
        type: 'error/set',
        data: "You must login or register to do that.",
      }
      store.dispatch(action);
    }
  }

  function startParty() {
    if (session) {
      setJoinform(false);
      setStartform(true);
    } else {
      clearForms();
      let action = {
        type: 'error/set',
        data: "You must login or register to do that.",
      }
      store.dispatch(action);
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
          <div className="landing-join">
            {joinform && (
                <JoinParty />
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

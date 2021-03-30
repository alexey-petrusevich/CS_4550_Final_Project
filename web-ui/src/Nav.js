import { Nav, Row, Col, Form, Button, Alert } from 'react-bootstrap';
import { NavLink } from 'react-router-dom';
import { connect } from 'react-redux';
import { useState } from 'react';
import { api_login } from './api';
import { Link } from 'react-router-dom';
import store from './store';

function LoginForm() {
    const [name, setName] = useState("");
    const [pass, setPass] = useState("");
  
    function on_submit(ev) {
      ev.preventDefault();
      api_login(name, pass);
    }
  
    return (
      <Form onSubmit={on_submit} inline>
        <Form.Control name="name"
                      type="text"
                      onChange={(ev) => setName(ev.target.value)}
                      value={name} />
        <Form.Control name="password"
                      type="password"
                      onChange={(ev) => setPass(ev.target.value)}
                      value={pass} />
        <Button variant="primary" type="submit">
          Login
        </Button>
      </Form>
    );
  }
  
let SessionInfo = connect()(({session, dispatch}) => {
    function logout() {
        dispatch({type: 'session/clear'});
    }
    return (
        <p>
        Logged in as {session.name} &nbsp;
        <Button onClick={logout}>Logout</Button>
        </p>
    );
});

function LOI({session}) {
    if (session) {
        return <SessionInfo session={session} />;
    }   
    else {
        return <LoginForm />;
    }
}
  
const LoginOrInfo = connect(({session}) => ({session}))(LOI);

export default function AppNav() {
  return (
    <div>
      <Row>
        <Col>
          <Nav variant="pills">
            <Link to="/parties">Parties</Link>
          </Nav>
        </Col>
        <Col>
          <LoginOrInfo />
        </Col>
      </Row>
    </div>
  );
}
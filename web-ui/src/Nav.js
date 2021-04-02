import { Nav, Row, Col, Form, Button, Alert } from 'react-bootstrap';
import { NavLink, useHistory } from 'react-router-dom';
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
      <Col className="login" lg={7}>
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
      </Col>
    );
  }

let SessionInfo = connect()(({session, dispatch}) => {
    const history = useHistory();

    //handles logging out by clearing the session
    function logout(ev) {
        ev.preventDefault();
        dispatch({type: 'session/clear'});
        history.push("/");
    }

    return (
      <Col className="login" md={{ span: 4, offset: 4 }}>
        <p>
        Logged in as {session.username} &nbsp;
        <Button className="logout" onClick={logout}>Logout</Button>
        </p>
      </Col>
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

function AppNav({error}) {
  let error_banner = null;

  //displays any errors returned by the server
  if (error) {
    error_banner = (
      <Row>
        <Col>
          <Alert variant="danger">{error}</Alert>
        </Col>
      </Row>
    );
  }

  return (
    <div className="nav-bar">
      <Row>
        <Col>
          <Nav variant="pills">
            <Link to="/parties/1">Parties</Link>
          </Nav>
        </Col>
        <LoginOrInfo />
      </Row>
      {error_banner}
    </div>
  );
}

export default connect(({error}) => ({error}))(AppNav);

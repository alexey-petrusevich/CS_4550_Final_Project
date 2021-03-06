import { Nav, Row, Col, Form, Button, Alert } from 'react-bootstrap';
import { NavLink, useHistory } from 'react-router-dom';
import { connect } from 'react-redux';
import { useState } from 'react';
import { api_login } from './api';
import { Link } from 'react-router-dom';
import store from './store';

function LoginForm() {
    const history = useHistory();
    const [name, setName] = useState("");
    const [pass, setPass] = useState("");

    function on_submit(ev) {
      ev.preventDefault();
      api_login(name, pass);
      history.push("/");
    }

    return (
      <Form className="login" onSubmit={on_submit} inline>
        <Form.Row>
          <Col>
            <Form.Control name="name"
                          type="text"
                          onChange={(ev) => setName(ev.target.value)}
                          placeholder="Username"
                          value={name} />
          </Col>
          <Col>
            <Form.Control name="password"
                          type="password"
                          onChange={(ev) => setPass(ev.target.value)}
                          placeholder="Password"
                          value={pass} />
          </Col>
          <Col>
            <Button variant="primary" type="submit">
              Login
            </Button>
          </Col>
          <Col>
            <Nav variant="pills" className="register">
              <Link to="/users/new">Register</Link>
            </Nav>
          </Col>
        </Form.Row>
      </Form>
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
      <Col className="login" md={{ span: 3, offset: 0 }}>
        <p>
          Logged in as {session.name} &nbsp;
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

function AppNav({session}) {
  let dash_link = null;
  let prof_link = null;
  let users_link = null;

  if (session) {
    dash_link = (
      <Link className="nav" to="/dashboard">Dashboard</Link>
    )
    prof_link = (
      <Link className="nav"to={{pathname: `/users/` + session.user_id}}>My Profile</Link>
    )
    users_link = (
      <Link className="nav" to="/users">Other Users</Link>
    )
  }

  return (
    <div className="nav-bar">
      <Row>
      <Col>
        <Nav variant="pills">
          <Link className="nav" to="/">Home</Link>
          { dash_link }
          { prof_link }
          { users_link }
        </Nav>
      </Col>
        <LoginOrInfo />
      </Row>
    </div>
  );
}

export default connect(({session}) => ({session}))(AppNav);

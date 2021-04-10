import { Nav, Row, Col, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { api_login } from './api';
import { Link } from 'react-router-dom';
import { useHistory } from 'react-router-dom';

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
      <Col className="login" lg={7}>
        <Form onSubmit={on_submit} inline>
          <Form.Control name="name"
                        type="text"
                        onChange={(ev) => setName(ev.target.value)}
                        placeholder="Username"
                        value={name} />
          <Form.Control name="password"
                        type="password"
                        onChange={(ev) => setPass(ev.target.value)}
                        placeholder="Password"
                        value={pass} />
          <Button variant="primary" type="submit">
            Login
          </Button>
          <Nav variant="pills" className="register">
            <Link to="/users/new">Register</Link>
          </Nav>
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

function AppNav({session}) {
  let dash_link = null;
  let prof_link = null;

  if (session) {
    dash_link = (
      <Link className="nav" to="/dashboard">Dashboard</Link>
    )
    prof_link = (
      <Link to={{pathname: `/users/` + session.user_id}}>Profile</Link>
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
        </Nav>
      </Col>
        <LoginOrInfo />
      </Row>
    </div>
  );
}

export default connect(({session}) => ({session}))(AppNav);

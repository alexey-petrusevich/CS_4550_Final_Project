import { Col, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react'
import { useHistory } from 'react-router-dom';
import pick from 'lodash/pick';

import { create_user } from '../api';

function NewUser() {
  let history = useHistory();
  const [user, setUser] = useState({name: "", pass1: "", pass2: ""});

  function check_email(email) {
    // from w3resource.com
    if (/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/.test(email)) {
      return "";
    }
    return "Invalid email address.";
  }

  function check_pass(p1, p2) {
    if (p1 !== p2) {
      return "Passwords don't match.";
    }

    if (p1.length < 8) {
      return "Password is too short.";
    }

    return "";
  }

  function update(field, ev) {
    let u1 = Object.assign({}, user);
    u1[field] = ev.target.value;
    u1.password = u1.pass1;
    u1.pass_msg = check_pass(u1.pass1, u1.pass2);
    u1.email_msg = check_email(u1.email);
    setUser(u1);
  }

  function onSubmit(ev) {
    ev.preventDefault();
    //get rid of the extra password and pass_msg entry
    let data = pick(user, ['name', 'username', 'email', 'password']);
    create_user(data);
    setTimeout(function(){history.push("/");}, 2000);
  }

  return (
    <div>
      <h2>Create an Account</h2>
      <Form onSubmit={onSubmit}>
        <Form.Row>
          <Form.Group as={Col}>
            <Form.Label>Enter Your Name</Form.Label>
            <Form.Control type="text"
                          onChange={(ev) => update("name", ev)}
                          value={user.name || ""} />
          </Form.Group>
          <Form.Group as={Col}>
            <Form.Label>Select A Username</Form.Label>
            <Form.Control type="text"
                          onChange={(ev) => update("username", ev)}
                          value={user.username || ""} />
          </Form.Group>
        </Form.Row>

        <Form.Group>
          <Form.Label><div>Enter Your Email <i className="form-msg">{user.email_msg}</i></div></Form.Label>
          <Form.Control type="text"
                        onChange={(ev) => update("email", ev)}
                        value={user.email || ""} />
        </Form.Group>
        <Form.Row>
          <Form.Group as={Col}>
            <Form.Label>Create A Password</Form.Label>
            <Form.Control type="password"
                          onChange={(ev) => update("pass1", ev)}
                          value={user.pass1 || ""} />

          </Form.Group>
          <Form.Group as={Col}>
            <Form.Label><div>Confirm Password <i className="form-msg">{user.pass_msg}</i></div></Form.Label>
            <Form.Control type="password"
                          onChange={(ev) => update("pass2", ev)}
                          value={user.pass2 || ""} />
          </Form.Group>
        </Form.Row>
        <Button variant="primary"
                type="submit"
                disabled={user.pass_msg !== "" || user.email_msg !== ""}>
          Register
        </Button>
      </Form>
    </div>
  );
}

function state2props() {
  return {};
}

export default connect(state2props)(NewUser);

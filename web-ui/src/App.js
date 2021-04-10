import { Container } from 'react-bootstrap';
import { Switch, Route } from 'react-router-dom';
import { Row, Col, Alert } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useEffect } from 'react';
import store from './store';

import "./App.scss";

import Nav from "./Nav";
import Landing from "./Landing";
import PartiesNew from "./Parties/New";
import ShowParty from "./Parties/Show";
import NewUser from "./Users/New";
import EditUser from "./Users/Edit";
import UsersList from "./Users/List";
import UserProfile from "./Users/Profile";
import Dashboard from "./Dashboard";

//displays any alerts returned by the server
//dismissable and timeout after 3.2 seconds
function AlertBanner({error, success}) {
  let alert_banner = null;

 useEffect(() => {
   const alert_timer = setTimeout(() => {
     clear_alert();
   }, 3200)

   return () => {
     clearTimeout(alert_timer)
   }
 }, []);

  //clears the alert from the store (for dissapearing or closing out)
  function clear_alert() {
    let action = {
        type: 'clear/set',
        data: "",
    }
    store.dispatch(action);
  }

  if (error) {
    return (
      <Row>
        <Col>
          <Alert variant="danger" onClose={() => clear_alert()} dismissible>
            {error}
          </Alert>
        </Col>
      </Row>
    );
  }

  //displays success banner
  if (success) {
    return (
      <Row>
        <Col>
          <Alert variant="success" onClose={() => clear_alert()} dismissible>
            {success}
          </Alert>
        </Col>
      </Row>
    );
  }
}

//Our App Components
function App({error, success}) {
  return (
    <Container className="app-background">
      {(success || error) && <AlertBanner error={error} success={success}/>}
      <Nav />
      <Switch>
        <Route path="/" exact>
          <Landing />
        </Route>
        <Route path="/parties/new" exact>
          <PartiesNew />
        </Route>
        <Route path="/parties/:id" component={ShowParty} exact />
        <Route path="/users/new" exact>
          <NewUser />
        </Route>
        <Route path="/users/edit/:id" exact>
          <EditUser />
        </Route>
        <Route path="/users/:id" exact>
          <UserProfile />
        </Route>
        <Route path="/users" exact>
          <UsersList />
        </Route>
        <Route path="/dashboard" exact>
          <Dashboard />
        </Route>
      </Switch>
    </Container>
  );
}

export default connect(({error, success}) => ({error, success}))(App);

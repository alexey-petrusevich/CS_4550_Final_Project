import { Container } from 'react-bootstrap';
import { Switch, Route } from 'react-router-dom';

import "./App.scss";

import Nav from "./Nav";
import Landing from "./Landing";
import PartiesNew from "./Parties/New";
import ShowParty from "./Parties/Show";
import NewUser from "./Users/New";
import Dashboard from "./Dashboard";

function App() {
  return (
    <Container className="app-background">
      <Nav />
      <Switch>
        <Route path="/" exact>
          <Landing />
        </Route>
        <Route path="/parties/new" exact>
          <PartiesNew />
        </Route>
        <Route path="/parties/:id">
          <ShowParty />
        </Route>
        <Route path="/users/new" exact>
          <NewUser />
        </Route>
        <Route path="/dashboard" exact>
          <Dashboard />
        </Route>
      </Switch>
    </Container>
  );
}

export default App;

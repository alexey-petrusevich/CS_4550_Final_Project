import { Container } from 'react-bootstrap';
import { Switch, Route } from 'react-router-dom';

import "./App.scss";

import Nav from "./Nav";
import PartiesSingle from "./Parties/Single";

function App() {
  return (
    <Container>
      <Nav />
      <Switch>
        <Route path="/parties/:partyId?">
          <PartiesSingle />
        </Route>
      </Switch>
    </Container>
  );
}

export default App;
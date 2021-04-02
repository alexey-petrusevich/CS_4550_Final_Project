import { Container } from 'react-bootstrap';
import { Switch, Route } from 'react-router-dom';

import "./App.scss";

import Nav from "./Nav";
import Landing from "./Landing";
import PartiesSingle from "./Parties/Single";
import PartiesNew from "./Parties/New";
import ShowParty from "./Parties/Show";

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
      </Switch>
    </Container>
  );
}

export default App;

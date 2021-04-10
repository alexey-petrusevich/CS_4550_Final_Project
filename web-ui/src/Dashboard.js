import { Row, Col, Card, Button } from 'react-bootstrap';
import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
import { get_user, get_user_with_cb } from './api';
import { useHistory } from 'react-router-dom';
import UserStats from './UserStats';
import RGL, { WidthProvider } from "react-grid-layout";

const ReactGridLayout = WidthProvider(RGL);

function PartyInfo({party}) {
  // var event_path = "/parties/" + party.id
  return (
    <Col md="6" style={{ 'paddingBottom':'20px' }}>
      <Card className="party-card">
        <Card.Title><strong>{party.name}</strong></Card.Title>
        <Card.Text>
          <i>Hosted by {party.host.name}</i><br />
          {party.description}
        </Card.Text>
        <Link to={{pathname: `/parties/` + party.id}}>
          <Button variant="primary">View Party</Button>
        </Link>
      </Card>
    </Col>
  );
}

function Dashboard({parties, session}) {
  const [user, setUser] = useState({danceability: "", energy: "", id: "", impact_score: "", loudness: "", password_hash: "", top_artists: [], top_genres: [], username: "", valence: ""});
      
  let user_id = session.user_id;

  useEffect(() => {
    get_user(user_id).then((p) => setUser(p));
  },[user_id]);

  console.log(user);

  let history = useHistory();

  let hostedParties = parties.filter( (party) => session && session.user_id === party.host.id);

  let host_cards = hostedParties.map((party) => (
    <PartyInfo party={party} key={party.id} />
  ));

  let attendedParties = parties.filter( (party) => session && party.attendees && party.attendees.includes(session.user_id));

  let party_cards = attendedParties.map((party) => (
    <PartyInfo party={party} key={party.id} />
  ));

  let new_party_link = (
    <Link to="/parties/new">
      <Button className="dash-button">New Party</Button>
    </Link>
  )

  return (
    <div>
      <h2 style={{ 'paddingLeft':'10px', 'paddingTop':'15px'}}>Dashboard</h2>
      <ReactGridLayout
            rowHeight={200}
            className="layout"
            isDraggable={false}
            isResizeable={false}
        >
        <div key="1" data-grid={{ x: 0, y: 0, w: 6.5, h: 0.2, static: true }}>
          <h3>Parties You've Hosted{ new_party_link }</h3>
        </div>
        <div className="card-container" key="2" data-grid={{ x: 0, y: 0.2, w: 6.5, h: 1.1, static: true }}>
          <div><Row>{host_cards}</Row></div>
        </div>
        <div style={{ 'paddingLeft':'8px' }} key="3" data-grid={{ x: 7, y: 0, w: 5, h: 0.2, static: true }}>
          <h3>Your Stats</h3>
        </div>
        <div key="4" data-grid={{ x: 7, y: 0.2, w: 5, h: 4, static: true }}>
          <div style={{ 'paddingLeft':'10px' }}>{ UserStats(user, 2) }</div>
        </div>
        <div key="5" data-grid={{ x: 0, y: 1.3, w: 6.5, h: 0.2, static: true }}>
          <h3>Parties You've Attended</h3>
        </div>
        <div className="card-container" key="6" data-grid={{ x: 0, y: 1.5, w: 6.5, h: 1.1, static: true }}>
          <Row>{party_cards}</Row>
        </div>
      </ReactGridLayout>
    </div>
  );
}

export default connect(({parties, session}) => ({parties, session}))(Dashboard);

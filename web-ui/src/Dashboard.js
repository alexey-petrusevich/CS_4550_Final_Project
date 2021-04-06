import { Row, Col, Card, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';
import { useHistory } from 'react-router-dom';


function PartyInfo({party}) {
  // var event_path = "/parties/" + party.id
  return (
    <Col md="3">
      <Card className="party-card">
        <Card.Title>{party.name}</Card.Title>
        <Card.Text>
          Hosted by {party.host.username}<br />
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
      <h2>Dashboard</h2>
      <div>
        <h3>Parties You've Hosted { new_party_link }</h3>
        <Row>{host_cards}</Row>
      </div>
      <div className="component-spacing"></div>
      <div>
        <h3>Parties You've Attended</h3>
        <Row>{party_cards}</Row>
      </div>
      <div className="component-spacing"></div>
      <div>
          <h3>User Stats</h3>
      </div>
    </div>
  );
}

export default connect(({parties, session}) => ({parties, session}))(Dashboard);

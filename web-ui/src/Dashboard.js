import { Row, Col, Card, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';


function PartyInfo({party}) {
  // var event_path = "/parties/" + party.id
  return (
    <Col md="3">
      <Card>
        <Card.Title>{party.roomname}</Card.Title>
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

    //How are we archiving parties and letting them be seen on the dashboard
  let pastParties = parties.filter( (party) => session && session.user_id === party.user_id);

  let party_cards = pastParties.map((party) => (
    <PartyInfo party={party} key={party.id} />
  ));

  let new_party_link = null;
  if (session) {
    new_party_link = (
      <p><Link to="/parties/new">New Event</Link></p>
    )
  }

  return (
    <div>
      <h2>Dashboard</h2>
      <div>
        <h3>Parties</h3>
        { new_party_link }
        <Row>{party_cards}</Row>
      </div>
      <div>
          <h3>User Stats</h3>

      </div>
    </div>
  );
}

export default connect(({parties, session}) => ({parties, session}))(Dashboard);

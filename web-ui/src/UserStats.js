import { Row, Col, Card, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

function Party({party}) {
  return (
    <Col md="3">
      <Card>
          <Card.Title>
              <Link to={{pathname: `/party/` + party.id}}>{party.roomname}</Link>
          </Card.Title>
          <Card.Text>
              Hosted by: {party.host}
          </Card.Text>
      </Card>
    </Col>
  );
}

const 

function UserStats({parties, session}, user) {

  let pastParties = parties.filter( (party) => session && session.user_id === party.user_id);
  // let 

  let party_cards = pastParties.map((party) => (
    <Party party={party} key={party.id} />
  ));

  return (
    <div>
      <h3>Top Listens</h3>
      <h3>Top Artists</h3>
      <h3>Top Genres</h3>
      <h3>Top Styles</h3>
      <h3>Impact Score</h3>
    </div>
  );
}

export default connect(({parties, session}) => ({parties, session}))(UserStats);

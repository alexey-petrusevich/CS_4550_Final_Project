import { Row, Col, Card, Button } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import { connect } from 'react-redux';

function UserStats({parties, session}) {

  let pastParties = parties.filter( (party) => session && session.user_id === party.user_id);

  let party_cards = pastParties.map((party) => (
    <Event party={party} key={party.id} />
  ));

  return (
    <div>
    </div>
  );
}

export default connect(({parties, session}) => ({parties, session}))(UserStats);

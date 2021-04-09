import { Row, Col, Card, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState, useEffect } from 'react';
import { useLocation } from 'react-router-dom';
import { useHistory } from 'react-router-dom';
import store from '../store';
import { Link } from 'react-router-dom';
import { get_user } from '../api';
import UserStats from '../UserStats';

function ArrayLength(array) {
    return array.length;
}

function PartyCard({party}) {
    return (
      <Col md="3" sm="6">
        <Card className="profile-party-card">
            <Card.Title>
                <Link to={{pathname: `/parties/` + party.id}}>{party.name}</Link>
            </Card.Title>
            <Card.Text>
                Hosted by: {party.host.username}<br/>
                Attendees: { party.attendees.length }
                <Link to={{pathname: `/parties/` + party.id}}>
                    <Button variant="primary">View Party</Button>
                </Link>
            </Card.Text>
        </Card>
      </Col>
    );
}

function UsersProfile({parties, session}) {

    const [user, setUser] = useState({danceability: "", energy: "", id: "", impact_score: "", loudness: "", password_hash: "", top_artists: [], top_genres: [], username: "", valence: ""});
    const location = useLocation();
    let user_id = location.pathname.split("/")[2];
    
    useEffect(() => {
        get_user(user_id).then((p) => setUser(p));
    },[user_id]);

    let attendedParties = parties.filter( (party) => session && party.attendees && (party.attendees.includes(session.user_id) || party.host.id == session.user_id));

    let party_cards = attendedParties.map((party) => (
        <PartyCard party={party} key={party.id} />
    ));

    let session_name = session.username;
    let profile_name = user.username;

    if (session_name === profile_name) {
        return (
            <div className="profile-page">
                <h1>{user.username}'s Profile</h1>
                <h3 style={{ 'paddingTop':'30px' }}>Recent Parties</h3>
                <Row style={{ ' width':'150px' }}>{party_cards}</Row>
                <h3 style={{ 'paddingTop':'30px' }}>Stats</h3> 
                <div>{ UserStats(user) }</div>
            </div>
        );
    } else {
        return (
            <div className="profile-page">
                <ul>
                    {/* <li><strong>{user.friends.length} Friends</strong></li> */}
                    {/* <li><strong>{user.parties.length} Parties</strong></li> */}
                </ul>

                <h3 style={{ 'paddingTop':'40px' }}>Recent parties</h3>
                <Row style={{ ' width':'150px' }}>{party_cards}</Row>

                <div>{ UserStats(user) }</div>
            </div>
        );
    }
}

export default connect(({parties, session}) => ({parties, session}))(UsersProfile);

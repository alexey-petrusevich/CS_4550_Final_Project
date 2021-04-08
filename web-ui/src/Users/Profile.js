import { Row, Col, Card, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { useLocation } from 'react-router-dom';
import { useHistory } from 'react-router-dom';
import store from '../store';
import { Link } from 'react-router-dom';
import { get_user } from '../api';
import UserStats from '../UserStats';

function ArrayLength(array) {
    return array.length;
}

function Party({party}) {
    return (
      <Col md="3">
        <Card>
            <Card.Title>
                <Link to={{pathname: `/parties/` + party.id}}>{party.name}</Link>
            </Card.Title>
            <Card.Text>
                Hosted by: {party.host.username}
                Attendees: { ArrayLength(party.attendees) }
            </Card.Text>
        </Card>
      </Col>
    );
}

// SONGS SCHEMA ------------------------------------------------------------
// field :artist, :string
// field :title, :string
// field :genre, :string
// field :track_uri, :string
// field :energy, :float
// field :danceability, :float
// field :loudness, :float
// field :valence, :float
// field :played, :boolean
// has_many :votes, Server.Votes.Vote
// belongs_to :party, Server.Parties.Party

function UsersProfile({parties, users, session}) {

    console.log("in UsersProfile");
    const location = useLocation();
    let user_id = location.pathname.split("/")[2];
    let user = users[user_id - 1];

    console.log("User ID = " + user_id);
    console.log("user: " + JSON.stringify(user));

    // let path_name = window.location.pathname;
    // let user_id = path_name.substring(path_name.lastIndexOf("/") + 1);
    // get user somehow

    // let currUser = parties.filter( (party) => partyId === party.id.toString());
    // console.log("currParty = " + currParty);

    let attendedParties = parties.filter( (party) => session && party.attendees && (party.attendees.includes(session.user_id) || party.host.id == session.user_id));

    let party_cards = attendedParties.map((party) => (
        <Party party={party} key={party.id} />
    ));

    let session_name = session.username;
    let profile_name = user.username;

    if (session_name === profile_name) {
        return (
            <div>
                <ul>
                    {/* <li><strong>{user.friends.length} Friends</strong></li> */}
                    {/* <li><strong>{user.parties.length} Parties</strong></li> */}
                </ul>

                <h3 style={{ 'paddingTop':'40px' }}>Recent Parties</h3>
                <Row style={{ ' width':'150px' }}>{party_cards}</Row>

                <div>{ UserStats(user) }</div>
            </div>
        );
    } else {
        return (
            <div>
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

export default connect(({parties, users, session}) => ({parties, users, session}))(UsersProfile);

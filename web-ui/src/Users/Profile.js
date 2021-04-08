import { Row, Col, Card, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { useLocation } from 'react-router-dom';
import { useHistory } from 'react-router-dom';
import store from '../store';
import { Link } from 'react-router-dom';
import { get_user } from '../api';
import { UserStats } from '../UserStats';

// function Party({party}) {
//     return (
//       <Col md="3">
//         <Card>
//             <Card.Title>
//                 <Link to={{pathname: `/party/` + party.id}}>{party.roomname}</Link>
//             </Card.Title>
//             <Card.Text>
//                 Hosted by: {party.host}
//             </Card.Text>
//         </Card>
//       </Col>
//     );
// }

// USERS SCHEMA
// password : str
// username : str
// -> has many Parties
// -> has many Requests
// -> has many Votes
// -> has many Friends

function UsersProfile({parties, users, session}) {

    console.log("in UsersProfile");
    const location = useLocation();
    let user_id = location.pathname.split("/")[2];
    let user = users[user_id - 1];
    // let user = get_user(user_id);

    console.log("User ID = " + user_id);
    console.log("user: " + JSON.stringify(user));
    // let path_name = window.location.pathname;
    // let user_id = path_name.substring(path_name.lastIndexOf("/") + 1);
    // get user somehow

    // let currUser = parties.filter( (party) => partyId === party.id.toString());
    // console.log("currParty = " + currParty);

    // let party_cards = parties.map((party) => (
    //     <Party party={party} key={party.id} />
    // ));

    return (
        <div>
            <h1>{user.username}</h1>
            <ul>
                {/* <li><strong>{user.friends.length} Friends</strong></li> */}
                {/* <li><strong>{user.parties.length} Parties</strong></li> */}
            </ul>

            <h3 style={{ 'paddingTop':'40px' }}>Recent parties</h3>

            {/* <Row style={{ ' width':'150px' }}>{party_cards}</Row> */}

            <div>{ UserStats(user) }</div>
        </div>
    );
}

export default connect(({parties, users, session}) => ({parties, users, session}))(UsersProfile);
import { Row, Col, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';
import store from '../store';

function UsersList({users, session}) {

    let otherUsers = users.filter( (user) => session && user.id != session.user_id);
    let rows = otherUsers.map((user) => (
        <tr key={user.id}>
            <td>{user.name}</td>
            <td>{user.username}</td>
            <td>
            <Button className="view-user-btn" variant="secondary" size="sm" >
                <Link style={{'color':'white'}} to={{pathname: `/users/` + user.id}}>View Profile</Link>
            </Button>
            </td>
        </tr>
    ));

    if (session != null) {
        return (
            <div style={{'color':'white', 'paddingLeft':'1.4%'}} >
            <Row>
                <Col>
                <h2 style={{'paddingTop':'3%'}} >Users</h2>
                <p>
                </p>
                <table className="table table-dark table-striped" style={{'color':'white'}}>
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>UserTag</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    { rows }
                    </tbody>
                </table>
                </Col>
            </Row>
            </div>
        );
    }
    else {
        return (
            <div>
            <h3>Please Log In.</h3>
            </div>
        );
    }
}

function state2props({users, session}) {
    return { users, session };
}

export default connect(state2props)(UsersList);

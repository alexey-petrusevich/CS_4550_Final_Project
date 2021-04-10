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

function UsersProfile({parties, session}) {

    const [user, setUser] = useState({danceability: "", energy: "", id: "", impact_score: "", loudness: "", password_hash: "", top_artists: [], top_genres: [], username: "", valence: ""});
    const location = useLocation();
    let history = useHistory();
    let user_id = location.pathname.split("/")[2];

    useEffect(() => {
        get_user(user_id).then((p) => setUser(p));
    },[user_id]);

    let hostedCount = parties.filter( (party) => session && party.host.id == session.user_id).length;
    let attendedCount = parties.filter( (party) => session && party.attendees && party.attendees.includes(session.user_id)).length;

    let profile_name = user.username;

    // makes sure there is an active session
    let session_name;
    if (session) {
      session_name = session.username;
    } else {
      let action = {
        type: 'error/set',
        data: "Please login to view user profiles.",
      }
      store.dispatch(action);
      history.push("/");
    }

    if (session_name === profile_name) {
        return (
            <div className="profile-page">
                <h1 style={{ 'paddingTop':'30px', 'paddingLeft':'1.5%', 'color':'#DFDFDF'}}><strong>Your Profile</strong></h1>
                <h3 style={{ 'paddingTop':'5x', 'paddingLeft':'1.5%', 'color':'#AEDFB3' }}>UserTag: {user.username}</h3>
                <h4 style={{ 'paddingTop':'20px', 'paddingLeft':'1.5%'}}>Hosted Parties: {hostedCount}</h4>
                <h4 style={{ 'paddingTop':'5px', 'paddingLeft':'1.5%' }}>Attended Parties: {attendedCount}</h4>
                <h2 style={{ 'paddingTop':'30px', 'paddingLeft':'1.5%', 'color':'#DFDFDF' }}><strong>Your Stats</strong></h2>
                <div style={{ 'paddingLeft':'0.7%' }}>{ UserStats(user, 1) }</div>
            </div>
        );
    } else {
        return (
            <div className="profile-page">
                <h1 style={{ 'paddingTop':'30px', 'paddingLeft':'1.5%', 'color':'#DFDFDF'}}><strong>{user.name}'s Profile</strong></h1>
                <h3 style={{ 'paddingTop':'5x', 'paddingLeft':'1.5%', 'color':'#AEDFB3' }}>UserTag: {user.username}</h3>
                <h4 style={{ 'paddingTop':'20px', 'paddingLeft':'1.5%'}}>Hosted Parties: {hostedCount}</h4>
                <h4 style={{ 'paddingTop':'5px', 'paddingLeft':'1.5%' }}>Attended Parties: {attendedCount}</h4>
                <h2 style={{ 'paddingTop':'30px', 'paddingLeft':'1.5%', 'color':'#DFDFDF' }}><strong>{user.name}'s Stats</strong></h2>
                <div style={{ 'paddingLeft':'0.7%' }}>{ UserStats(user, 1) }</div>
            </div>
        );
    }
}

export default connect(({parties, session}) => ({parties, session}))(UsersProfile);

import { Row, Col, Card, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react';
import { useHistory } from 'react-router-dom';
import store from '../store';
import { create_party, create_parties } from '../api';

//how do we handle making and holding queued songs?

function PartiesSingle({parties, votes, requests, session}) {

    let path_name = window.location.pathname;
    let partyId = path_name.substring(path_name.lastIndexOf("/") + 1);
    let currParty = parties.filter( (party) => partyId === party.id.toString());

    console.log("currParty = " + currParty);

    // const invs = votes;
    let partyVotes = votes.filter( (vote) => partyId === vote.user.id.toString());
    console.log(partyVotes);

    return (
        <div>
            <h1>Show Party #{currParty.id}</h1>
            <ul>
                <li><strong>Room: </strong>{currParty.roomname}</li>
                <li><strong>Desc: </strong>{currParty.description}</li>
                <li>
                    <strong>Created By:</strong>
                    {currParty.host}
                </li>
            </ul>

            <h3 style={{ 'paddingTop':'40px' }}>Party Response Link: </h3>

            <h3 style={{ 'paddingTop':'40px' }}>Votes</h3>
            <table className="table table-striped">
                <thead>
                    <tr>
                    <th>Song</th>
                    <th>Upvotes</th>
                    <th>Downvotes</th>
                    </tr>
                </thead>
                <tbody>
                    {partyVotes.map((vote) => (
                        <tr>
                            <td>{vote.song.title}</td>
                            <td>{vote.upvotes}</td>
                            <td>{vote.downvotes}</td>
                        </tr>
                    ))}
                </tbody>
            </table>
        </div>
    );
}

export default connect(({parties, votes, requests, session}) => ({parties, votes, requests, session}))(PartiesSingle);

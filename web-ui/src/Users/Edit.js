import { Row, Col, Form, Button } from 'react-bootstrap';
import { connect } from 'react-redux';
import { useState } from 'react'
import { useHistory } from 'react-router-dom';
import store from '../store';
import { update_user } from '../api';

// function findInvitationById(invitations, id) {
//     for (var i = 0; i < invitations.length; i++) {
//         if (invitations[i].id.toString() === id) {
//             return invitations[i];
//         }
//     }
//     return null;
// }

// function InvitationsEdit(invitationToEdit) {
//   //console.log("session = " + JSON.stringify(session))
//   console.log("invitation = " + JSON.stringify(invitationToEdit.invitation))

//   let history = useHistory();
//   const [invitation, setInvitation] = useState(invitationToEdit.invitation);

//   console.log("invitation = " + JSON.stringify(invitation))

//   function submit(ev) {
//     ev.preventDefault();
//     update_invitation(invitation).then((resp) => {
//       if (resp["errors"]) {
//         console.log("errors", resp.errors);
//       }
//       else {
//         history.push("/");
//         fetch_invitations();
//       }
//     });
//   }

//   function updateResponse(ev) {
//     let i1 = Object.assign({}, invitation);
//     i1["response"] = ev.target.value;
//     setInvitation(i1);
//   }

//   let event = invitation.event;

// // Note: File input can't be a controlled input.
//   return (
//     <Row>
//       <Col>
//         <h2>Edit Invitation Response</h2>
//         <Form onSubmit={submit}>
//           <Form.Group>
//             <Form.Label>Event Name</Form.Label>
//             <Form.Label>{event.title}</Form.Label>
//           </Form.Group>
//           <Form.Group>
//             <Form.Label>Event Date</Form.Label>
//             <Form.Label>{event.date}</Form.Label>
//           </Form.Group>
//           <Form.Group>
//             <Form.Label>User Email</Form.Label>
//             <Form.Label>{invitation.email}</Form.Label>
//           </Form.Group>
//           <Form.Group>
//             <Form.Label></Form.Label>
//             <Form.Control as="select"
//                           onChange={updateResponse}
//                           value={invitation.response}>
//               <option value="yes">Yes</option>
//               <option value="maybe">Maybe</option>
//               <option value="no">No</option>
//             </Form.Control>
//           </Form.Group>
//           <Button variant="primary" type="submit">
//             Update Response
//           </Button>
//         </Form>
//       </Col>
//     </Row>
//   );
// }

// function mapStateToProps(state, ownProps) {
//   let invitation = {email: '', response: '', user_id: '', event_id: ''};
//   let path_name = window.location.pathname;
//   let invitationId = path_name.substring(path_name.lastIndexOf("/") + 1);
//   if (invitationId && state.invitations.length > 0) {
//     invitation = findInvitationById(state.invitations, invitationId);
//   }
//   return {invitation: invitation};
// }

function EditUser() {
    return (
        <div></div>
    );
}

function state2props() {
    return {};
  }
  
export default connect(state2props)(EditUser);
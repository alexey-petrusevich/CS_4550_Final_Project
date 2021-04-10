---------------------------------------------------------------------
# Written Report

## The Team
Our team consists of Aliaksei Petrusevich, Benjamin Ockert, Austin
Kim, and Iain Morrison.

## The Deployment
Our deployed app can be found at https://spotifyparty.morrisonineu.org, and our source
code can be found at:
https://github.com/alexey-petrusevich/CS_4550_Final_Project. Our app
is currently deployed and working as it should. The individual work
that each member has done on the project is as follows:

### Aliaksei Petrusevich

### Benjamin Ockert

### Austin Kim

### Iain Morrison


## The App

The project we have chosen to develop for this assignment is something
we have titled "Spotify Party". When public health protocols allow, a
user can host an in-person party with their friends and act as the
"DJ" by using our app. When the host starts a party, they will be able
to see their 10 most recent Spotify playlists and choose which one
will be the playlist for their party. The attendees at the party will
then be able to vote for which songs from that playlist they want to
hear next.

### Realtime Behavior

While using the app, users will be able to interact with the "DJ" in
real time through voting and requesting songs. When the host starts a
round of voting, the songs in that round will appear in the views of
the attendee. For each song, they will have an up-vote and a down-vote
button as well as an up-vote and a down-vote count. When they vote on
a song, the count will be updated in real time across the browsers of
all users in the session. For requesting songs, when an attendee
requests a song title, the request will show up immediately in the
view of the DJ/host, who will then be able to take action. The current
song being played will also show up across all views, and will be
updated automatically when a song is skipped or a song ends and a new
song begins.

### Playback and Requests

At any point the "DJ", or host, can play, pause, or skip the currently
playing song utilizing buttons on their view of the party. When a song
is skipped, the next song in the queue is to be played. The queue is
determined by the votes from the other, non-host, attendees of the
party, with the song most-voted being first in the queue.

In addition to storing users, we are storing event history. Attendees
of a party session will be able to look back on their past events and
see what songs were played, in what order they were played, and how
many votes each song had. This will be useful to all users if and when
they want to make a playlist for their own hosted party. We are also
storing what actions users took, either up-voting or down-voting and
this will be used for the various stats we are visualizing.

Voting for a song requires the attendees to look at the list of songs
from the host's given playlist, each with an up-vote button and a
down-vote button. The attendees can click these buttons to update the
overall score of each song. This score value is what determines the
order in which songs are added to the queue. This allows the attendees
to choose what songs are going to be played next in a given party,
based on the overall playlist that the host has chosen before the
party began.

### Complex Feature
On any given user's "User Page" we are visualizing a variety of user
statistics. These statistics are generated based on what votes the
given user gives songs that come up in the queue during parties. These
statistics come from the songs' data on Spotify, and are pulled using
the Spotify API and visualized by our app. The statistics being shown
are top genres, top songs, an impact score based on how many up-voted
songs by the user actually go through to the party, and other
statistics that Spotify keeps track of, including "danceability",
"valence", "energy", and "loudness".

### To-do list for write-up (remove before submission)
- Individual group member's work (above)
- More detail about voting
- Information about how playback is implemented
- The complex part about our app and why
- Most significant challenge and how we resolved it
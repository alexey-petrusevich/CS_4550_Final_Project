# Project Proposal

## The Team

Our team consists of Aliaksei Petrusevich, Benjamin Ockert, Austin
Kim, and Iain Morrison.

## The Idea

The project we propose for this assignment is something we have titled
"Spotify Party". When public health protocols allow, a user can host
an in-person party with their friends and act as the "DJ" by using our
app. When the host starts a party, they will be able to see their 10
most recent Spotify playlists and choose which one will be the
playlist for their party. The attendees at the party will then be able
to vote for which songs from that playlist they want to hear next.
They will also have the ability to request specific songs be played
that may otherwise not be on the host's playlist. For voting, rounds
will consist of 5 songs, from which the top 3 will be chosen and added
to the queue. This is so attendees don't have to be on their devices
during every song.

This idea for this app came to us based on what we wish the DJ at a
prom or wedding could do. Some DJs don't accept requests or any type
of guest input at parties and instead play from their predetermined
list of songs. Others are open to requests but then have the difficult
decision of determining if the requested song is something that
everyone on the dance floor would like, or if it is a song that only
the requester would like. Our app takes care of this dilemma and
allows guests at a party to provide input to the DJ on what they think
of the current song what they want the next songs to be.

At a minimum, our application will communicate directly with Spotify,
so the host can plug any device with the Spotify app and their account
into a speaker and our app will control playback. However, based on
the outcomes of our experiments, we are hoping to embed Spotify's
playback engine directly into the browser of the party host, such that
the DJ can directly control playback through Spotify's embedded
playback UI.

Finally, we plan to style our app in two different ways. Since
attendees of a party likely don't have their laptops with them, we
will style the party attendee UI to support viewing through a mobile
browser. On the other hand, the view of the DJ/host will be designed
for a laptop browser, with the idea that they will be on their laptop
managing the rounds of voting and requests during the party session.

### API

We will be using Spotify's Web API for this project. This provides us
the endpoints for everything we are planning to do, including user
account authorization of our app, pulling user data such as profile
information and user playlists with their corresponding tracks, and
controlling the playback on their accounts, allowing us to play,
pause, skip, and modify the queue.

For the authorization flow, Spotify has a number of useful scopes that
we are able to post with the authorization code request in order to
take certain actions on behalf of the user, if they authorize our app.
In particular, the following scopes will be useful:

- ```user-read-private``` allows us to view user's account details;
this will be used to pull data such as username and email during the
authorization process; we can also use this scope for searching for
a track on Spotify when a user requests a specific song
- ```playlist-read-private``` allows us to read the track information,
display the initial list of playlists to start a party session with,
and then also display the tracks of the playlist during live voting
- ```user-modify-playback-state``` allows us to take actions on the
user's playback state; we will use this to add the top-voted songs
to the queue as well as skip to the next track if the votes suggest
we should do so
- ```user-read-currently-playing``` allows us to see
what track is currently playing on the user's account; we may use
this to verify that actions such as skipping tracks are successful,
and we will use it to display the current song being played across
the views of all users

### Realtime Behavior

While using the app, users will be able to interact with the "DJ" in
realtime through voting and requesting songs. When the host starts a
round of voting, the songs in that round will appear in the views of
the attendee. For each song, they will have an up-vote and a down-vote
button as well as an up-vote and a down-vote count. When they vote on
a song, the count will be updated in realtime across the browsers of
all users in the session. For requesting songs, when an attendee
requests a song title, the request will show up immediately in the
view of the DJ/host, who will then be able to take action. The current
song being played will also show up across all views, and will be
updated automatically when a song is skipped or a song ends and a new
song begins.

### Persistent State

In addition to storing users, we will be storing event history.
Attendees of a party session will be able to look back on their past
events and see what songs were played, in what order they were played,
and how many votes each song had. This will be useful to all users if
and when they want to make a playlist for their own hosted party. We
will also be storing user actions, specifically voting and what genre
of songs a user either up-voted or down-voted. This will be used for
one of the neat things we plan to do:

### Something "Neat"

For something neat, we plan to provide detailed user statistics based
on their responses to songs during party sessions. Using the above
mentioned persistent state, we plan to provide a list of a user's top
genres and top artists. This will require implementing an algorithm
that analyzes the genres and artists of songs that they requested,
up-voted, and down-voted. Another neat thing we are experimenting with
is playback directly through the browser rather than controlling
playback through the Spotify app on a different device that the user
is logged in to.

## Experiments

### Experiment 1: Testing the Spotify API

We conducted several experiments on the Spotify Web API endpoints.

#### Experiment 1a: Authorization Flow and Retrieving User Data

For this experiment, we created an app with a UI to test the
authorization flow that a user of our app would go through when
they start a party room. We tested that we could redirect the user
to Spotify's authorization page with specific scopes (discussed above)
and then receive a authorization code through the callback in return.

We also tested getting different user data by including the access
token in the headers of our get requests. Specifically, we tested the
endpoints for getting user profile data (username and email) and
user's private playlist data (both available playlist names as well
as the titles and ids within each playlist).

From this experiment, we learned a few things:
    - We learned that the Implicit Grant flow for the Spotify Web API
    would not allow us to get the access token in the form we needed.
    That flow gave us the token directly through the callback uri, but
    after a # (i.e. ```/callback/#access_token=...```), so it could
    not be sent to the server. This led us to using the Authorization
    Code flow, which does send the server a code which we can then
    exchange for the access token.
    - Second, we learned that songs, artists, playlists, and users all
    have unique IDs which are used in the request urls to target
    each resource. We tested extracting the ID for each available
    playlist and then including the ID in the request to the playlist
    endpoint for getting playlist track data

#### Experiment 1b: Controlling Playback and Queue - Alex

### Experiment 2: In-browser Playback - Austin

## Users

### Intended Users

We intend for our app to be used by college students who host social
events in their dorms and/or apartments when it is safe to do so. Our
app will add a collaborative element to the music selection of each
party and will ensure that everyone at the party has a say in what
music will be played, whether for dancing or just for casually sitting
around hanging out. Hosts will benefit from not having the pressure of
choosing the music for the entire night, and attendees will have the
benefit of being able to listen and/or dance to their favorite songs.

An additional use case would be for actual DJs. DJs of homecomings,
proms, graduation parties, and even weddings, could use this app as a
tool to form their music choices throughout the evening. At the
beginning of an event, they could load there pre-made playlist into
Spotify and then start an app session with that playlist. They then
could announce to the party's guests that at anytime throughout the
evening, guests can access the app to provide input on the music they
want to hear. If a DJ knows what the next songs they want to play are
but they are unsure of the order, they can start a round of voting
with the selected songs to determine what order to play them in.
Similarly, if the DJ receives a song request from an attendee and
isn't sure if other guests would like to hear that song as well, they
can add the requested song to a round of voting. Finally, based on
voting results from past events they have either hosted or attended,
they can be better informed on what songs are widely popular when
making the playlists for their next events.

## User Stories

Types of users:
- host (party organizer and/or DJ)
- attendees (non-host party guests)

#### Hosts

Bob is throwing a party and will be acting as the DJ. He wants to make
sure everyone gets to hear songs that they like so they have a fun
time.

- Bob creates an account with a username and a password
    - Bob creates a new "party room" with a room name
    - He authenticates the app with Spotify and then selects which one
    of his Spotify playlists he would like to play to start the event
- When the party starts, the playlist starts playing from the
beginning
    - Bob wants input on the next set of songs to be played, so he
    selects 5 songs from the list to be voted on
    - He starts the voting round, which will last for 1 minute
    - After the round of voting, the top 3 of the 5 songs will
    automatically be added to the queue
    - After those songs are played, if there are no other rounds of
    voting, the playlist continues playing from where it left off
    before the voting
- Later, an attendee sends in a song request
    - Bob likes the song and knows, from previous events, that it will
    be a crowd favorite, so he adds the song directly to the queue
- A second attendee sends in a different song request
    - Bob doesn't know this song and wants to get guest input, so he
    adds it to the next round of voting
- During a song later in the evening, Bob notices that it has several
down-votes from attendees
    - Bob chooses to skip to the next song
- The event ends and Bob can see a summary of the songs that were
played, their artists, how long they were played for, and their total
up/down votes

#### Attendees

Alice is attending an event hosted by Bob.

- Alice creates an account with a username and a password
- She is given a room name by Bob, which she uses to join the party
room
- When the party states, Alice loves the first song that is being
played, so she up-votes the song to give the DJ feedback
- Later, Bob tells everyone he is going to open a round of voting for
the next few songs
    - Alice up-votes 3 of the 5 songs that she likes, down-votes one
    of the songs that she does not want to hear, and has no preference
    on the 5th song
- Alice then wants to dance to her all time favorite song
    - She sends in a song request to Bob with the song title and
    artist
- After the party, Alice views her profile
    - she sees the event she just attended as well as her other past
    events
    - she clicks on an event and sees the list of all songs that were
    played (title and artist) as well as the voting result for each
    song
    - back on her main profile page, she sees the top genres and
    artists that she has been up-voting across her different parties
- Alice then wants to start her own party
    - She enters a room name and shares it with her guests
    - She authenticates the app with her Spotify account and selects
    a playlist
    - *User story continues in the 'Hosts' story*



---

# Adding New Songs to the Queue

Working with queues is performed in the same way as the requests for the rest of Spotify API. The caller must provide
the URI of the track being added to the queue along with the bearer token (obtained through OAuth 2.0) added as a header to
the post request sent to Spotify.

# Track URI

Each track on Spotify follows the same format:

`spotify:track:<track_hash>`

Example:

`spotify:track:6REbwUNlppTfcnV4d4ZoZi`

Track URI has to be added as a query parameter with the key “uri”:
`uri: spotify:track:6REbwUNlppTfcnV4d4ZoZi`

Return value of the call is JSON with 204 code.

# Device ID

Device ID can be added as another parameter. If not supplied, the active device is targeted by the call.

# Endpoint URL

Endpoint URL:
https://api.spotify.com/v1/me/player/queue

# Other Queue Actions

More documentation about using this and relevant API calls:

https://developer.spotify.com/documentation/web-api/reference/#endpoint-add-to-queue

https://developer.spotify.com/documentation/web-api/reference/

https://developer.spotify.com/console/post-queue/

https://developer.spotify.com/console/

# Experiment

The main goal of running this experiment is to test whether Spotify API is working as documented
on Spotify Developers website.

In order to test this API, a new test file was added that conducts three actions:

1. Add a new track to the queue
2. Skip to the next track
3. Get the track URI of the track currently playing, and check if it is the same as the one added to the queue in step 1

The test can be run by invoking while in the root project directory:

`mix test test/spotify_party_test.exs`

Source code of the test:

```elixir
test "Add New Track To Queue" do
  resp = SpotifyParty.add_track_to_queue()
  resp = SpotifyParty.next_track()
  Process.sleep(1000)
  data = SpotifyParty.get_current_track()
  track_uri = SpotifyParty.get_track_uri(data)
  assert track_uri == SpotifyParty.default_track_uri()
end
```

The test successfully passes - the URI of the new track is the same as URI of the track passed.
This can also be confirmed by having Spotify running - the test changes the track to the one specified in the code.
Likewise, adding calling `SpotifyParty.add_track_to_queue()` changes the queue of the player (desktop app).


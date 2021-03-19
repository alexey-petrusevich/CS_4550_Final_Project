# Project Proposal

## The Team

Our team consists of Alexey Petrusevich, Benjamin Ockert, Austin Kim, and Iain Morrison. 

## The Idea

The project we propose for this assignment is something we have titled "Spotify Party". When public health protocols allow, a user can host an in-person party with their friends and act as the "DJ" by using our app. When the host starts a party, they will be able to see their 10 most recent Spotify playlists and choose which one will be the playlist for their party. The attendees at the party will then be able to vote for which songs from that playlist they want to hear next. They will also have the ability to request specific songs be played that may otherwise not be on the host's playlist.  

This idea for this app came to us based on what we wish the DJ at a prom or wedding could do. Some DJs don't accept requests or any type of guest input at parties and instead play from their pre-determined list of songs. Others are open to requests but then have the difficult decision of determining if the requested song is something that everyone on the dance floor would like, or if it is a song that only the requester would like. Our app takes care of this dilemma and allows guests at a party to provide input to the DJ on what they want the next songs to be. 

### API





### Realtime Behavior

### Persistent State

In addition to storing users, we will be storing event history. Attendees of a party session will be able to look back on their past events and see what songs were played, in what order they were played, and how many votes each song had. This will be useful to all users if and when they want to make a playlist for their own hosted party. 

### Something "Neat"

## Experiments

### Experiment 1: Testing the Spotify API

#### Experiment 1a: Authorization Flow and Retrieving User Data
- Ben

#### Experiment 1b: Controlling Playback
- Alex

### Experiment 2: In-browser Playback
- Austin

## Users

### Intended Users

### User Stories 











Idea: Live voting on music at a party through Spotify

API: Spotify API
Realtime: Voting
State: History of sessions; users can look back on past events and see what songs were played; queue 
Something neat: Playing music directly through the browser

## User Stories

- User1 creates an account 
    - username (and password?)
- User1 creates a "room"
    - automatically becomes host
    - Host starts the party
        - the playlist starts playing shuffled, voting is disabled to start
        - the host can enable/disable user voting at any time
        - when voting is enabled, then: 
    - Experiment: using user's credentials, get the song data from a user's preexisting Spotify playlist
        - Choose x random songs and send to attendees for a vote
        - Top y songs get added to the queue
        - During the yth song, choose another x songs from the playlist and send a new vote
    - when a new request is made, host can either automatically add the song to the queue or add it to the next round of voting 
    - host can see current song votes and choose to skip to the next song
        - Experiment: try and view the current queue, otherwise maintain a table with the initial playlist order and make updates based on user voting so we can display the queue for the host 
- User 2 creates an account
    - joins the "room" with a room name and password
    - can vote for as many songs as they want in an active voting round
    - can request a specific song to be played/added to the next round of voting
    - can also vote on the current song being played (love, like, dislike)
    - can view past parties they've been to
    - View profile:
        - basic user info
        - Based on how they voted, display top genres and artists
- User 3 creates an account
    - starts a new room, can occur simultaneously


Experiment 1: pulling playlist data and playing/pausing/skipping through the browser - Ben
Experiment 2: pulling queue data, updating queue data - Alex
Experiment 3: playing through the browser with an iframe, etc. - Austin

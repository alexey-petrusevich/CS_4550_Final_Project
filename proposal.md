# Project Proposal

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

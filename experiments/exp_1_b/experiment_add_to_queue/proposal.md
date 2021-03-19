# Project Proposal

Idea: Live voting on music at a party through Spotify

API: Spotify API Realtime: Voting State: History of sessions; users can look back on past events and see what songs were
played; queue Something neat: Playing music directly through the browser

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
    - when a new request is made, host can either automatically add the song to the queue or add it to the next round of
      voting
    - host can see current song votes and choose to skip to the next song
        - Experiment: try and view the current queue, otherwise maintain a table with the initial playlist order and
          make updates based on user voting so we can display the queue for the host
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

Experiment 1: pulling playlist data and playing/pausing/skipping through the browser - Ben Experiment 2: pulling queue
data, updating queue data - Alex Experiment 3: playing through the browser with an iframe, etc. - Austin


---

# Adding New Songs to the Queue (Alex)

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
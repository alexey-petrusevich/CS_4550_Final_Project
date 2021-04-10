# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Eventapp.Repo.insert!(%Eventapp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Server.Repo
alias Server.Songs.Song
alias Server.Users.User
alias Server.Parties.Party
alias Server.Votes.Vote
alias Server.Requests.Request
alias Server.AuthTokens.AuthToken

pass_hash = Argon2.hash_pwd_salt("password")

iain = Repo.insert!(%User{username: "Iain", name: "Iain Morrison", email: "morrison.i@northeastern.edu", password_hash: pass_hash, impact_score: 0})
austin = Repo.insert!(%User{username: "Austin", name: "Austin Kim", email: "kim.a@northeastern.edu", password_hash: pass_hash, impact_score: 250})
alex = Repo.insert!(%User{username: "Alex", name: "Alex Petrusevich", email: "petrusevich.a@northeastern.edu", password_hash: pass_hash, impact_score: 314})
benjamin = Repo.insert!(%User{username: "Ben", name: "Ben Ockert", email: "ockert.b@northeastern.edu", password_hash: pass_hash, impact_score: 25})
partyMan = Repo.insert!(%User{username: "partyMan", name: "Party Man", email: "party@northeastern.edu", password_hash: pass_hash, impact_score: 600})
sam = Repo.insert!(%User{username: "Sam", name: "Sam Smith", email: "sam@northeastern.edu", password_hash: pass_hash, impact_score: 3918})

party1 = Repo.insert!(%Party{name: "Trevor's Birthday", roomcode: "1234", description: "Celebrate Trevor's birthday", host_id: benjamin.id, is_active: false})
party2 = Repo.insert!(%Party{name: "Senior Prom", roomcode: "0985", description: "Prom for the Class of 2021", attendees: [1, 3], host_id: austin.id, is_active: false})
party3 = Repo.insert!(%Party{name: "Sam's Kickback", roomcode: "7203", description: "Chilling with Sam over the weekend", attendees: [1, 4], host_id: iain.id, is_active: false})
party4 = Repo.insert!(%Party{name: "Sam's Kickback2", roomcode: "7205", description: "Chilling with Sam over the weekend", attendees: [2], host_id: iain.id, is_active: false})
party5 = Repo.insert!(%Party{name: "Aus Party 1", roomcode: "1010", description: "Another Party", attendees: [1, 4], host_id: austin.id, is_active: false})
party6 = Repo.insert!(%Party{name: "Aus Party 2", roomcode: "1011", description: "Another Party", attendees: [1, 4], host_id: austin.id, is_active: false})
party7 = Repo.insert!(%Party{name: "Aus Party 3", roomcode: "1012", description: "Another Party", attendees: [1, 4], host_id: austin.id, is_active: false})
party8 = Repo.insert!(%Party{name: "Aus Party 4", roomcode: "1013", description: "Another Party", attendees: [1, 4], host_id: austin.id, is_active: false})
party9 = Repo.insert!(%Party{name: "Aus Party 5", roomcode: "1014", description: "Another Party", attendees: [1, 4], host_id: austin.id, is_active: false})
party10 = Repo.insert!(%Party{name: "Party 1", roomcode: "1015", description: "Another Party", attendees: [1, 2, 3, 4], host_id: partyMan.id})
party11 = Repo.insert!(%Party{name: "Party 2", roomcode: "1016", description: "Another Party", attendees: [1, 2, 3, 4], host_id: partyMan.id})
party12 = Repo.insert!(%Party{name: "Party 3", roomcode: "1017", description: "Another Party", attendees: [2], host_id: partyMan.id})
party13 = Repo.insert!(%Party{name: "Party 4", roomcode: "1018", description: "Another Party", attendees: [2], host_id: partyMan.id})
party14 = Repo.insert!(%Party{name: "Party 5", roomcode: "1019", description: "Another Party", attendees: [2], host_id: partyMan.id})

song1 = Repo.insert!(%Song{artist: "Faye Webster", genre: "art pop", title: "Kingston", track_uri: "spotify:track:0EDQwboQDmswDRn58wcslg", party_id: party1.id, played: false, energy: 0.344, danceability: 0.73, loudness: -9.541, valence: 0.543})
song2 = Repo.insert!(%Song{artist: "Athletic Progression", genre: "aarhus indie", title: "WHITE CRAYON", track_uri: "spotify:track:2XXfb3FToGrAOZKGJ1Nwhj", party_id: party1.id, played: false, energy: 0.45, danceability: 0.417, loudness: -12.49, valence: 0.177})
song3 = Repo.insert!(%Song{artist: "Mac Miller", genre: "hip hop", title: "Floating", track_uri: "spotify:track:7BCzMKLKQwVSLtZcDGJTJt", party_id: party1.id, played: false, energy: 0.391, danceability: 0.505, loudness: -11.599, valence: 0.543})
song4 = Repo.insert!(%Song{artist: "Kanye West", genre: "chicago rap", title: "No More Parties In LA", track_uri: "spotify:track:0zLClc0emc6qUeV1p5nc99", party_id: party1.id, played: false, energy: 0.921, danceability: 0.508, loudness: -1.644, valence: 0.681})
song5 = Repo.insert!(%Song{artist: "Journey", genre: "album rock", title: "Don't Stop Believing", track_uri: "spotify:track:4bHsxqR3GMrXTxEPLuK5ue", party_id: party1.id, played: false, energy: 0.748, danceability: 0.5, loudness: -9.072, valence: 0.514})
song6 = Repo.insert!(%Song{artist: "Dua Lipa", genre: "dance pop", title: "Don't Start Now", track_uri: "spotify:track:6WrI0LAC5M1Rw2MnX2ZvEg", party_id: party1.id, played: true, energy: 0.793, danceability: 0.794, loudness: -4.521, valence: 0.677})

song7 = Repo.insert!(%Song{artist: "SZA", genre: "pop", title: "Go Gina", track_uri: "spotify:track:6Vmow8PuUaU7W1T2WWLZk2", party_id: party2.id, played: false, energy: 0.606, danceability: 0.603, loudness: -6.634, valence: 0.462})
song8 = Repo.insert!(%Song{artist: "2Pac", genre: "g funk", title: "Better Dayz", track_uri: "spotify:track:5dRCujBQZQq6dlkCaGDMV0", party_id: party2.id, played: false, energy: 0.735, danceability: 0.752, loudness: -3.851, valence: 0.635})
song9 = Repo.insert!(%Song{artist: "Frank Ocean", genre: "alternative r&b", title: "Provider", track_uri: "spotify:track:6R6ihJhRbgu7JxJKIbW57w", party_id: party2.id, played: false, energy: 0.325, danceability: 0.654, loudness: -11.925, valence: 0.39})
song10 = Repo.insert!(%Song{artist: "Frank Ocean", genre: "alternative r&b", title: "Biking (Solo)", track_uri: "spotify:track:6gtNiLJNLBcV0P6Juenstp", party_id: party2.id, played: false, energy: 0.548, danceability: 0.64, loudness: -6.965, valence: 0.181})
song11 = Repo.insert!(%Song{artist: "Kanye West", genre: "chicago rap", title: "Violent Crimes", track_uri: "spotify:track:3s7MCdXyWmwjdcWh7GWXas", party_id: party2.id, played: false, energy: 0.419, danceability: 0.669, loudness: -6.724, valence: 0.0397})
song12 = Repo.insert!(%Song{artist: "A$AP Rocky", genre: "east coast hip hop", title: "Sundress", track_uri: "spotify:track:2aPTvyE09vUCRwVvj0I8WK", party_id: party2.id, played: false, energy: 0.707, danceability: 0.721, loudness: -6.364, valence: 0.743})
song13 = Repo.insert!(%Song{artist: "BROCKHAMPTON", genre: "boy band", title: "BLEACH", track_uri: "spotify:track:0dWOFwdXrbBUYqD9DLsoyK", party_id: party2.id, played: true, energy: 0.657, danceability: 0.595, loudness: -6.498, valence: 0.718})
song14 = Repo.insert!(%Song{artist: "Brent Faiyaz", genre: "dmv rap", title: "Show U Off", track_uri: "spotify:track:00selpxxljfn9n5Pf4K3VR", party_id: party2.id, played: true, energy: 0.405, danceability: 0.583, loudness: -11.295, valence: 0.549})
song15 = Repo.insert!(%Song{artist: "JAY-Z", genre: "east coast hip hop", title: "4:44", track_uri: "spotify:track:1gT5TGwbkkkUliNzHRIGi1", party_id: party2.id, played: true, energy: 0.852, danceability: 0.261, loudness: -4.965, valence: 0.431})

request1 = Repo.insert!(%Request{title: "Piano Man", artist: "Billy Joel", track_uri: "spotify:track:70C4NyhjD5OZUMzvWZ3njJ", played: false, party_id: party1.id, user_id: iain.id})
request2 = Repo.insert!(%Request{title: "Herman's Habit", artist: "La La Land", track_uri: "spotify:track:4f6PUDRYJI51UrZy0jDAxD", played: false, party_id: party1.id, user_id: iain.id})

vote1 = Repo.insert!(%Vote{value: 1, song_id: 1, user_id: 1});
vote2 = Repo.insert!(%Vote{value: 1, song_id: 1, user_id: 2});
vote3 = Repo.insert!(%Vote{value: -1, song_id: 1, user_id: 3});

token = Repo.insert!(%AuthToken{token: "asgniunbiueiui324891827u984", user_id: benjamin.id})

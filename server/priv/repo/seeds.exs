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
alias Server.PartiesSongs.PartySong
alias Server.AuthTokens.AuthToken

pass_hash = Argon2.hash_pwd_salt("password")

iain = Repo.insert!(%User{username: "Iain", password_hash: pass_hash, impact_score: 0})
austin = Repo.insert!(%User{username: "Austin", password_hash: pass_hash, impact_score: 500})
alex = Repo.insert!(%User{username: "Alex", password_hash: pass_hash, impact_score: 314})
benjamin = Repo.insert!(%User{username: "Ben", password_hash: pass_hash, impact_score: 25})

party = Repo.insert!(%Party{name: "Trevor's Birthday", roomcode: "1234", description: "Celebrate Trevor's birthday", host_id: benjamin.id})
party2 = Repo.insert!(%Party{name: "Phi Delt Formal", roomcode: "0985", description: "Annual Phi Delta Theta formal dance with Chi Omega", attendees: [1, 4], host_id: austin.id})

song1 = Repo.insert!(%Song{artist: "Faye Webster", genre: "", title: "Kingston", track_uri: "0EDQwboQDmswDRn58wcslg"})
song2 = Repo.insert!(%Song{artist: "Athletic Progression", genre: "", title: "WHITE CRAYON", track_uri: "2XXfb3FToGrAOZKGJ1Nwhj"})

IO.puts(song1.id)
IO.puts(party.id)

party1song1 = Repo.insert!(%PartySong{song_id: song1.id, party_id: party.id})
party1song2 = Repo.insert!(%PartySong{song_id: song2.id, party_id: party.id})

token = Repo.insert!(%AuthToken{token: "asgniunbiueiui324891827u984", user_id: benjamin.id})

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

pass_hash = Argon2.hash_pwd_salt("password")

iain = Repo.insert!(%User{username: "Iain", password_hash: pass_hash})
austin = Repo.insert!(%User{username: "Austin", password_hash: pass_hash})
alex = Repo.insert!(%User{username: "Alex", password_hash: pass_hash})
benjamin = Repo.insert!(%User{username: "Ben", password_hash: pass_hash})

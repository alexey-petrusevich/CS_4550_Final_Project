defmodule SpotifyTest do
  use ExUnit.Case
  import SpotifyAPITest

  # tests getting a list of popular genres through the Basic Authorization flow
  test "get genres" do
    token = SpotifyAPITest.authenticate
    assert Enum.member?(SpotifyAPITest.get_genres(token), "Hip Hop")
  end

  # tests getting the playlists and playlist info of the user
  test "get playlists" do
    assert SpotifyAPITest.get_user_playlists == [
              %{id: "7viu8TkY6QqHPs7DxYa9qV", name: "TestPlaylist2"},
              %{id: "7yJLRMRTAt2t3BYfTKKzTk", name: "TestPlaylist1"}
            ]
    assert SpotifyAPITest.get_playlist_songs("7yJLRMRTAt2t3BYfTKKzTk") == [
              %{id: "7Cuk8jsPPoNYQWXK9XRFvG", title: "September"}
            ]
  end

  # tests getting the user name of the user
  test "get user info" do
    assert SpotifyAPITest.get_user_name == "cs4550"
  end
end

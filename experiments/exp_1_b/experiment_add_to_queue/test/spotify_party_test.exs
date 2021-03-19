defmodule SpotifyParty.SpotifyPartyTest do
  use ExUnit.Case


  test "Add New Track To Queue" do
    # add track to queue
    SpotifyParty.add_track_to_queue()
    SpotifyParty.next_track()
    Process.sleep(1000)
    data = SpotifyParty.get_current_track()
    track_uri = SpotifyParty.get_track_uri(data)
    assert track_uri == SpotifyParty.default_track_uri()
  end
end

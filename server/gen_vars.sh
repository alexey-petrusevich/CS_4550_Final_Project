#!/bin/bash

# run . ./gen-vars.sh (with the period) before running dev or deploy!

# dev environment url (without the http:// or any added path like api/v1)
export REACT_APP_DEV_CLIENT_URL=localhost:3000
export REACT_APP_DEV_SERVER_URL=localhost:4000

# prod environment url (without the http:// or any added path like api/v1)
export REACT_APP_PROD_URL=spotifyparty.benockert.site

env | grep REACT_APP

# do not change unless you reset secret on our Spotify for Devs app page
export SPOTIFY_CLIENT_ID=b6c7bd84e4724169b21570019ea15078
export SPOTIFY_CLIENT_SECRET=d3acd431a7a44f739e3a4b2b184bb4fd

# for deploying
export SECRET_KEY_BASE=$(cd ./server && mix phx.gen.secret)
export DATABASE_URL=ecto://spotify:Sp0t!fY123@localhost/spotifyparty_dev

echo "***NOTE: this script does not config the prod endpoint; manually update the url in ./config/prod.exs if you are deploying."

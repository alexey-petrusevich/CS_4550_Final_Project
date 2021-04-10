#!/bin/bash

# run . ./gen-vars.sh (with the period) before running dev or deploy!

# dev environment url (without the http:// or any added path like api/v1)
export REACT_APP_DEV_CLIENT_URL=localhost:3000
export REACT_APP_DEV_SERVER_URL=localhost:4000

# prod environment url (without the http:// or any added path like api/v1)
export REACT_APP_PROD_URL=spotifyparty.quickjohnny.art

env | grep REACT_APP

# do not change unless you reset secret on our Spotify for Devs app page
export SPOTIFY_CLIENT_ID=16d93cc5896d4cc58a6f5fa4d0a946e8
export SPOTIFY_CLIENT_SECRET=4d5f059a1eea4ef8985c0eea24afffda

# for deploying
export SECRET_KEY_BASE=$(cd ./server && mix phx.gen.secret)
export DATABASE_URL=ecto://spotify:spotifyparty@localhost/spotifyparty_dev

echo "***NOTE: this script does not config the prod endpoint; manually update the url in ./config/prod.exs if you are deploying."

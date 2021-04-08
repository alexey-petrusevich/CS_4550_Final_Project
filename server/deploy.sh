#!/bin/bash

# export SECRET_KEY_BASE=W68eso5YQOlbtvSNUR50N/HDWj6IaEhAwMR3LtzuBEQAefwYVbX84bvoTA7XtiGi
export MIX_ENV=prod
export PORT=4810
# export NODEBIN=`pwd`/assets/node_modules/.bin
# export PATH="$PATH:$NODEBIN"

echo "Building..."

mix deps.get --only prod
mix compile

#(cd assets && npm install)
#(cd assets && webpack --mode production)
#mix phx.digest

mix ecto.reset
echo "Generating release..."
mix release

#echo "Stopping old copy of app, if any..."
#_build/prod/rel/practice/bin/practice stop || true

echo "Deploy successful..."
echo "Run start.sh to start your server"
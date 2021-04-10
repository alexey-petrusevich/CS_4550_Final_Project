#!/bin/bash

export MIX_ENV=prod
export PORT=4810

CFGD=$(readlink -f ~/.config/server)

if [ ! -e "$CFGD/base" ]; then
    echo "run deploy first"
    exit 1
fi

DB_PASS=$(cat "$CFGD/db_pass")
export DATABASE_URL=ecto://spotifyparty:$DB_PASS@localhost/spotifyparty_prod

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

_build/prod/rel/spotifyparty/bin/server start

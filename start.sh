#!/bin/bash

export SECRET_KEY_BASE
export MIX_ENV=prod
export PORT=4810

echo "Stopping old copy of app, if any..."

# Replace 'practice' with proper app name
_build/prod/rel/server/bin/server stop || true

echo "Starting app..."

# Replace 'practice' with proper app name
_build/prod/rel/server/bin/server start                                
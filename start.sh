#!/bin/bash

export SECRET_KEY_BASE=W68eso5YQOlbtvSNUR50N/HDWj6IaEhAwMR3LtzuBEQAefwYVbX84bvoTA7XtiGi
export MIX_ENV=prod
export PORT=4801

echo "Stopping old copy of app, if any..."

# Replace with proper directory
_build/prod/rel/practice/bin/practice stop || true

echo "Starting app..."

# Replace with proper directory
_build/prod/rel/practice/bin/practice start

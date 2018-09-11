#!/bin/bash
# Usage: bash ./empty-all-keys.sh
redis-cli keys '*' | xargs redis-cli del
# will gets number of deleted keys.

#!/bin/bash
cd /application/red_pack_productions \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix clean \
  && mix deps.clean --all \
  && mix deps.get

cd /application/red_pack_productions/assets \
  && npm install \
  && brunch build

cd /application/red_pack_productions \
  && mix compile

cd /application/red_pack_productions \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix clean \
  && mix deps.unlock --all \
  && mix deps.clean --all \
  && mix deps.get

cd /application/red_pack_productions/assets \
  && npm install \
  && /usr/bin/node node_modules/brunch/bin/brunch build

cd /application/red_pack_productions \
  && mix compile \
  && mix phx.digest default \
  && mix phx.server
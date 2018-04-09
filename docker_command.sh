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
  && PORT=4000 MAIL_SERVER=smtp.hostnet.nl MAIL_PORT=587 MAIL_USER=info@redpackproductions.com MAIL_PASS=6f7c8_X MOLLIE_API_KEY=test_K3rbWpHyQdTMkyarTszGq3Wbj2PRNd iex -S mix phx.server
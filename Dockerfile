FROM registry.gitlab.com/weareyipyip/phoenixbuild/image:latest
MAINTAINER Jonathan van Putten <hope_industries@hotmail.com>


ADD . /application

ARG PORT=4000
ENV PORT ${PORT}

ARG MIX_ENV=dev
ENV MIX_ENV ${MIX_ENV}

WORKDIR /application/red_pack_productions

RUN mix local.hex --force \
  && mix local.rebar --force \
  && mix clean \
  && mix deps.unlock --all \
  && mix deps.clean --all \
  && mix deps.get

RUN cd assets \
  && npm install \
  && /usr/bin/node node_modules/brunch/bin/brunch build

RUN mix compile
RUN mix phx.digest

CMD ["mix", "phx.server"]
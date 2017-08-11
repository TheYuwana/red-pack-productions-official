FROM registry.gitlab.com/weareyipyip/phoenixbuild/image:latest
MAINTAINER Jonathan van Putten <hope_industries@hotmail.com>
ARG MIX_ENV=dev

ADD . /application



WORKDIR /application/red_pack_productions

ENV MIX_ENV=$MIX_ENV

RUN mix local.hex --force
RUN mix local.rebar --force
RUN mix deps.unlock --all
RUN mix deps.clean --all
RUN mix deps.get
RUN mix clean

RUN cd assets && npm install
RUN cd assets && /usr/bin/node node_modules/brunch/bin/brunch build

RUN mix compile
RUN mix phx.digest

CMD ["mix", "phx.server"]
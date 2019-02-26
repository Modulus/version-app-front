FROM node:8.15-alpine as builder

RUN mkdir -p mkdir -p /usr/local/lib/node_modules/create-elm-app/node_modules/elmi-to-json/unpacked_bin
RUN npm install -g elm -unsafe-perm=true && mkdir js

COPY elm.json ./elm.json
COPY src src

RUN elm make src/Main.elm --output js/main.js




FROM nginx:1.15.8-alpine 

RUN mkdir /usr/share/nginx/html/js

COPY index.html /usr/share/nginx/html

COPY --from=builder /js/main.js /usr/share/nginx/html/js

EXPOSE 80 443
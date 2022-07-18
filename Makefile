format:
	elm-format --yes src

build:
	elm make src/Main.elm --output app.js

build-debug:
	elm make --debug src/Main.elm --output app.js

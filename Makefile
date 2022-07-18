format:
	elm-format --yes src
build:
	elm make src/Main.elm --output app.js

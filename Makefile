format:
	elm-format --yes src

lint:
	elm-analyse

build:
	elm make --debug src/Main.elm --output app.js

build-release:
	elm make src/Main.elm --output app.js


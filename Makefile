format:
	elm-format --yes src tests

lint:
	elm-analyse

test:
	elm-test

build:
	elm make --debug src/Main.elm --output public/app.js

build-release:
	elm make src/Main.elm --output public/app.js


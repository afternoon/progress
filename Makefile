app_name := progress
client_main := client/main.coffee
client_src := $(wildcard client/*.coffee)
release := app/www/$(app_name).js

.PHONY: all lint run clean

all: $(release)

run: $(release)
	./app/bin/progress

$(release): $(client_src) lint
	./node_modules/.bin/browserify --transform coffeeify $(client_main) > $(release)

lint:
	find {app,client} -name '*.coffee' | xargs coffeelint

clean:
	rm -rf $(release)

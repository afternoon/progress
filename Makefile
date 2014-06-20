app_name := progress
client_main := client/main.coffee
client_src := $(wildcard client/*.coffee)
release := app/www/$(app_name).js

.PHONY: all lint release run clean

all: lint release

lint:
	find {app,client} -name '*.coffee' | xargs coffeelint

$(release): $(client_src)
	./node_modules/.bin/browserify --transform coffeeify $(client_main) > $(release)

release: $(release)

run: release
	./app/bin/progress

clean:
	rm -rf $(release)

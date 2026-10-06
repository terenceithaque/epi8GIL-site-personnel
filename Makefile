PAGES_SRC := $(wildcard input/*.html)
PAGES := $(subst input/,public/, $(PAGES_SRC))
ASSETS_SRC := ./styles.css

.PHONY: all clean


$(PAGES): layout/before.html layout/after.html

$(ASSETS): public

public:
	mkdir public

public/%.html: input/%.html
	./building/build.sh $<>@

clean:
	$(rm - rf public/*)



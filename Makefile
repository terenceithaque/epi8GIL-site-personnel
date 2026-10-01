PAGES_SRC := $(wildcard input/*.html)
PAGES := $(subst input/,output/, $(PAGES_SRC))
ASSETS_SRC := ./styles.css

.PHONY: all clean


$(PAGES): layout/before.html layout/after.html

$(ASSETS): output

public:
	mkdir output

public/%.html: input/%.html
	./building/build.sh $<>@

clean:
	$(rm - rf output/*)



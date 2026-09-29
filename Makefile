PAGES_SRC := $(wildcard input/*.html)
PAGES := $(subst input/,output/,$(PAGES_SRC))
ASSETS_SRC := ./styles.css
ASSETS := $(subst assets/,output/,$(ASSETS_SRC))

all:$(PAGES)
all: output layout/before.html layout/after.html

$(PAGES): layout/before.html layout/after.html

$(ASSETS): output

output:
        mkdir output

output/%.html: input/%.html
        ./building/build.sh $<> $@



output/%: asets/%
        cp $< $@

clean:
        rm -rf output/*

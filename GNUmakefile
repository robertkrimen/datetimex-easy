.PHONY: all test time clean distclean dist build distcheck upload distupload

all: test

build: Build
	./$<

dist distclean test tardist: Build
	./Build $@

Build: Build.PL
	perl $<

clean: distclean

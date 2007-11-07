.PHONY: all test time clean distclean dist distcheck upload distupload

all: test

dist distclean test tardist: Makefile
	make -f $< $@

Makefile: Makefile.PL
	perl $<

clean: distclean

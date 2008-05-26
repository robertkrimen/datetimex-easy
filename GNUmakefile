.PHONY: all test time clean distclean dist distcheck upload distupload

all: test

dist:
	rm -rf inc META.yaml
	perl Makefile.PL
	$(MAKE) -f Makefile dist

distclean tardist: Makefile
	$(MAKE) -f $< $@

test: Makefile
	TEST_RELEASE=1 $(MAKE) -f $< $@

Makefile: Makefile.PL
	perl $<

clean: distclean

reset: clean
	perl Makefile.PL
	$(MAKE) test

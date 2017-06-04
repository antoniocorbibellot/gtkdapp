
PACKAGE=gtkdapp

all: gtkdapp

gtkdapp:
	@echo '[7m[1m'Building app.'[0m'
	@dub build -q

run: gtkdapp
	bin/gtkdapp

clean:
	@rm -rf $$(find . -name "*.o" -o -name "*~" -o -name "__*")
	@rm -rf bin doc* data/*.gresource

dist: clean
	@(pushd .. >/dev/null; \
      tar cfz $(PACKAGE)-`date +"%Y.%m.%d"`.tgz \
        $(PACKAGE)/dub* \
	    $(PACKAGE)/Makefile \
	    $(PACKAGE)/source \
	    $(PACKAGE)/data ; \
	    mv $(PACKAGE)-`date +"%Y.%m.%d"`.tgz $(PACKAGE); \
     )

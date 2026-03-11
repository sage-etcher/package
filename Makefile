
PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
LIBDIR ?= $(PREFIX)/lib
ETCDIR ?= /etc
VARDIR ?= /var

SQLITE3_LIBS   ?= `pkgconf --libs sqlite3`
SQLITE3_CFLAGS ?= `pkgconf --cflags sqlite3`

EXTRA_CFLAGS  := $(DEBUG_FLAGS) $(SQLITE3_CFLAGS)
EXTRA_LDFLAGS := $(DEBUG_FLAGS) $(SQLITE3_LIBS)

build: package_query package.conf

clean:
	rm -f package_query.o
	rm -f package_query
	rm -f package.conf
	rm -f .tmp.package.conf

install:
	install -d -m 755 $(DESTDIR)/$(ETCDIR)/package/
	install -d -m 755 $(DESTDIR)/$(BINDIR)/
	install -d -m 755 $(DESTDIR)/$(LIBDIR)/
	install -m 644 package.conf                 $(DESTDIR)/$(ETCDIR)/package/
	install -m 755 package_query                $(DESTDIR)/$(BINDIR)/
	install -m 755 scripts/package_check        $(DESTDIR)/$(BINDIR)/
	install -m 755 scripts/package_init         $(DESTDIR)/$(BINDIR)/
	install -m 755 scripts/package_install      $(DESTDIR)/$(BINDIR)/
	install -m 755 scripts/package_list         $(DESTDIR)/$(BINDIR)/
	install -m 755 scripts/package_files        $(DESTDIR)/$(BINDIR)/
	install -m 755 scripts/package_uninstall    $(DESTDIR)/$(BINDIR)/
	install -m 755 scripts/package_whatprovides $(DESTDIR)/$(BINDIR)/
	install -m 644 scripts/libpackage.sh        $(DESTDIR)/$(LIBDIR)/

uninstall:
	rm -f $(DESTDIR)/$(ETCDIR)/package/package.conf
	rm -f $(DESTDIR)/$(BINDIR)/package_query
	rm -f $(DESTDIR)/$(BINDIR)/package_check
	rm -f $(DESTDIR)/$(BINDIR)/package_init
	rm -f $(DESTDIR)/$(BINDIR)/package_install
	rm -f $(DESTDIR)/$(BINDIR)/package_list
	rm -f $(DESTDIR)/$(BINDIR)/package_files
	rm -f $(DESTDIR)/$(BINDIR)/package_uninstall
	rm -f $(DESTDIR)/$(BINDIR)/package_whatprovides
	rm -f $(DESTDIR)/$(LIBDIR)/libpackage.sh
	rmdir $(DESTDIR)/$(ETCDIR)/package/

package_query: package_query.o
	$(CC) -o $@ $< $(EXTRA_LDFLAGS) $(LDFLAGS)

package_query.o: src/package_query.c
	$(CC) -c -o $@ $< $(EXTRA_CFLAGS) $(CFLAGS)

package.conf: resources/package.conf.in
	cp $< .tmp.$@
	sed -i "s,@BINDIR@,$(BINDIR),g" .tmp.$@
	sed -i "s,@LIBDIR@,$(LIBDIR),g" .tmp.$@
	sed -i "s,@ETCDIR@,$(ETCDIR),g" .tmp.$@
	sed -i "s,@VARDIR@,$(VARDIR),g" .tmp.$@
	mv .tmp.$@ $@

# vim: noet
# end of file

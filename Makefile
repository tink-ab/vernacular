PREFIX := /usr/local
LIBDIR := $(PREFIX)/lib
BINDIR := $(PREFIX)/bin

INSTALL_FILES = \
	Mono.Cecil.dll \
	Mono.Cecil.Mdb.dll \
	Mono.Cecil.Pdb.dll \
	Vernacular.Catalog.dll \
	Vernacular.Potato.dll \
	Vernacular.exe

NUNIT_CONSOLE = /Library/Frameworks/Mono.framework/Versions/Current/lib/mono/4.0/nunit-console.exe

all: vernacular

vernacular:
	msbuild Vernacular.sln /t:Vernacular_Tool

clean:
	find . -type d -name bin -or -name obj -maxdepth 2 -exec echo rm -rf {} \; -exec rm -rf {} \;

test: clean vernacular
	mono --debug $(NUNIT_CONSOLE) -labels -nologo Vernacular.Test/bin/Debug/Vernacular.Test.dll

install:
	mkdir -p "$(LIBDIR)/vernacular"
	mkdir -p "$(BINDIR)"
	for file in $(INSTALL_FILES); do \
		install -m 0755 "Vernacular.Tool/bin/Debug/$$file" "$(LIBDIR)/vernacular"; \
	done
	sed 's|@libdir@|$(LIBDIR)|' < vernacular.in > "$(BINDIR)/vernacular"
	chmod 0755 "$(BINDIR)/vernacular"

.PHONY: all vernacular test install clean

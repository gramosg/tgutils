UTILS := tgrecv tgsend tgserver

doc: $(addprefix doc/man1/,$(addsuffix .1.bz2,${UTILS}))

clean:
	rm -rf doc/man1

.PHONY: doc clean


# https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html
.SECONDEXPANSION:
%.1.bz2: $$(notdir $$*)
	@mkdir -p $(dir $*)
	doc/pod2man.pl $(notdir $*) $*.1
	bzip2 -f $*.1

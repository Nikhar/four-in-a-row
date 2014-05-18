bin_PROGRAMS = four-in-a-row

four_in_a_row_SOURCES = main.h     \
                main.c     \
                gfx.h      \
                gfx.c      \
                prefs.h    \
                prefs.c    \
                theme.c    \
                theme.h    \
                games-controls.c \
                games-controls.h \
                games-gridframe.c \
                games-gridframe.h \
                games-stock.c \
                games-stock.h \
                rules.h \
		playgame.vala \
		ai.vala

four_in_a_row_CPPFLAGS = \
	-I$(top_srcdir) \
	$(AM_CPPFLAGS)

four_in_a_row_CFLAGS = \
		       $(AM_CFLAGS) \
	-DDATA_DIRECTORY=\"$(datadir)/four-in-a-row\" \
	-DSOUND_DIRECTORY=\"$(datadir)/four-in-a-row/sounds\" \
	-DLOCALEDIR=\"$(datadir)/locale\" \
	-DICON_THEME_DIRECTORY="\"$(datadir)/icons\"" \
	$(FOUR_IN_A_ROW_CFLAGS)

four_in_a_row_LDADD = \
	$(FOUR_IN_A_ROW_LIBS)
	-lz

four_in_a_row_VALAFLAGS = \
			  $(AM_VALAFLAGS) \
	--pkg glib-2.0 \
	--pkg gio-2.0 \
	--pkg posix \
	--header=playgame.h

EXTRA_DIST = playgame.h

-include $(top_srcdir)/git.mk

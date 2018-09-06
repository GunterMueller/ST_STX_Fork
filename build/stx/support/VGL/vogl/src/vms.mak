#
# Make the vogl library.
#
# Below are our defaults for compliers etc. These are set in the
# main Makefile.
#

LIBNAME=libvgl

DOBJ = X11

HDRS =	vogl.h

OBJS =	arcs.$(O) attr.$(O) buffer.$(O) clip.$(O) curves.$(O) draw.$(O) drivers.$(O) \
	viewing.$(O) viewp.$(O) mapping.$(O) matrix.$(O) move.$(O) objects.$(O) patches.$(O) \
	points.$(O) polygons.$(O) rect.$(O) tensor.$(O) text.$(O) newtokens.$(O) trans.$(O) \
	scale.$(O) getgp.$(O) valloc.$(O) pref.$(O) vcalls.$(O) lines.$(O) \
	queue.$(O)

theLib:: $(LIBNAME).olb
	$(MAKE) objs
	$(MAKE) driver
	write sys$output "classlibrary $(LIBNAME).olb made."
	cop vogl.h [$(TOP).include]
	write sys$output "vogl.h installed in include."

driver: $(DOBJ).$(O)

$(DOBJ).$(O): $(DOBJ).c
	$(MAKE) $(DOBJ).$(O)

$(DOBJ).c: [-.drivers]$(DOBJ).c
	cop [-.drivers]$(DOBJ).c *

$(LIBNAME).olb:
	write sys$output "creating initial $(LIBNAME).olb ..."
	lib/cre $(LIBNAME).olb

objs:	$(OBJS)

clean::
	del *.$(O);*
	del $(DOBJ).c;*

clobber::
	del *.$(O);*

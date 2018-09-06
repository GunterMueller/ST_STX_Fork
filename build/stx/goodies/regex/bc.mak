# $Header: /cvs/stx/stx/goodies/regex/bc.mak,v 1.15 2013-05-28 10:32:23 cg Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_regex.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# Notice, that the name bc.mak is historical (from times, when only borland c was supported).
# This file contains make rules for the win32 platform using either borland-bcc or visual-c.
# It shares common definitions with the unix-make in Make.spec.
# The bc.mak supports the following targets:
#    bmake         - compile all st-files to a classLib (dll)
#    bmake clean   - clean all temp files
#    bmake clobber - clean all
#
# Historic Note:
#  this used to contain only rules to make with borland
#    (called via bmake, by "make.exe -f bc.mak")
#  this has changed; it is now also possible to build using microsoft visual c
#    (called via vcmake, by "make.exe -f bc.mak -DUSEVC")
#
TOP=..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_regex
RESFILES=regex.$(RES)


# see stdHeader_nt for LIBREGEX_BASE
LIB_BASE_LD_ARG=-b:$(LIBREGEX_BASE)


LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all prerequisite packages for this package
prereq:
	pushd ..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "





clean::
	del *.$(CSUFFIX)

# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)RxCharSetParser.$(O) RxCharSetParser.$(H): RxCharSetParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxMatchOptimizer.$(O) RxMatchOptimizer.$(H): RxMatchOptimizer.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxMatcher.$(O) RxMatcher.$(H): RxMatcher.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxParser.$(O) RxParser.$(H): RxParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxmLink.$(O) RxmLink.$(H): RxmLink.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxmTerminator.$(O) RxmTerminator.$(H): RxmTerminator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsNode.$(O) RxsNode.$(H): RxsNode.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_regex.$(O) stx_goodies_regex.$(H): stx_goodies_regex.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxmBranch.$(O) RxmBranch.$(H): RxmBranch.st $(INCLUDE_TOP)\stx\goodies\regex\RxmLink.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxmMarker.$(O) RxmMarker.$(H): RxmMarker.st $(INCLUDE_TOP)\stx\goodies\regex\RxmLink.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxmPredicate.$(O) RxmPredicate.$(H): RxmPredicate.st $(INCLUDE_TOP)\stx\goodies\regex\RxmLink.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Regex__RxmRepetition.$(O) Regex__RxmRepetition.$(H): Regex__RxmRepetition.st $(INCLUDE_TOP)\stx\goodies\regex\RxmLink.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxmSpecial.$(O) RxmSpecial.$(H): RxmSpecial.st $(INCLUDE_TOP)\stx\goodies\regex\RxmLink.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxmSubstring.$(O) RxmSubstring.$(H): RxmSubstring.st $(INCLUDE_TOP)\stx\goodies\regex\RxmLink.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsBranch.$(O) RxsBranch.$(H): RxsBranch.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsCharClass.$(O) RxsCharClass.$(H): RxsCharClass.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsCharSet.$(O) RxsCharSet.$(H): RxsCharSet.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsCharacter.$(O) RxsCharacter.$(H): RxsCharacter.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsContextCondition.$(O) RxsContextCondition.$(H): RxsContextCondition.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsEpsilon.$(O) RxsEpsilon.$(H): RxsEpsilon.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsMessagePredicate.$(O) RxsMessagePredicate.$(H): RxsMessagePredicate.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsPiece.$(O) RxsPiece.$(H): RxsPiece.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsPredicate.$(O) RxsPredicate.$(H): RxsPredicate.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsRange.$(O) RxsRange.$(H): RxsRange.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsRegex.$(O) RxsRegex.$(H): RxsRegex.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)RxsSpecial.$(O) RxsSpecial.$(H): RxsSpecial.st $(INCLUDE_TOP)\stx\goodies\regex\RxsNode.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

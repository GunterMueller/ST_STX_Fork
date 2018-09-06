#------------------ start of rules/stdRules ---------------------
#
# $Header: /cvs/stx/stx/rules/stdRules,v 1.439 2017-02-21 17:10:56 cg Exp $
#
# MIMEType: application/x-make
#
# Notice: on systems where make does not support the include
# directive, this file is included as a whole into the generated
# Makefile, and the following comment applies:
#   these rules come from $(TOP)/rules/stdRules - do not change
#   anything below, the changes will be lost when Makefiles are
#   recreated.
# If the make command does support include, this file is
# referenced to by the generated Makefile with an include directive.
#
# Do not blame me about the complexity here - nowadays, I would use
# configure. But I am happy to have a setup which runs on all those wierd
# machines and have other things to do ...
#
# these rules enable the Makefiles to:
#
#     make mf                   -- recreate the makefile after a definition change
#
#     make Makefiles            -- recursively walk down and (re)create Makefiles
#
#     make depend               -- extract dependencies from ST sourcefiles
#                                  and replace BEGINMAKEDEPEND..ENDMAKEDEPEND
#                                  in Makefile
#
#     make check                -- syntax check all ST-files
#
#     make <Class>.check        -- check syntax of an individual ST-file
#
#     make debug                -- compile without -O / -g instead
#
#     make objs                 -- compile to all .o-files
#
#     make obj                  -- make a prelinked obj-library file
#
#     make clobber              -- remove all that can be reconstructed
#
#     make clean                -- remove all .o-files, but leave libraries and executables
#
#     make cleanjunk            -- clean junk (intermediate) files
#
#     make notes                -- for stc-developpers only
#                                  output notes about internal actions
#
#     make warnings             -- for stc-developpers only
#                                  output warning messages
#
#     make abbrev.stc           -- process local ST-files and collect
#                                  classname-to-filename abbreviations in
#                                  a local abbrev.stc file
#
#     make updAbbrev            -- merge all local abbreviations into the
#                                  global abbrev.stc file (in include/)
#
#     make rmLocalAbbrevs       -- remove all local abbreviations from the
#                                  global abbrev.stc file (in include/)
#
#     make collectAbbrev        -- recursively process all ST-files and collect
#                                  className-to-fileName abbreviations
#                                  in $(INCLUDE)/abbrev.stc
#                                  (i.e. a recursive updAbbrev)
#
# ---- internal rules
#
#     make newobj               -- make a prelinked obj-library file
#                                  including a classlibrary init-function
#
#     make sharedobj            -- make a prelinked shared obj-library file
#                                  including a classlibrary init-function


# controls if a 'lib' subdirectory is to be made
# when linking against shared objects
NO_LINK_LIBDIR="yes"


# redefinableAll: Makefile $(ALL_TARGET) postMake
redefinableAll: $(ALL_TARGET) postMake

postMake::

#
# notice: the rule below used to be the Makefile rule;
# however, since gmake automatically executes this rule upon entry,
# this may lead to trouble, if you are on an NFS mounted file system,
# and the machines times are not completely in sync (i.e. withing a second).
# To avoid endless make recursion, this rule is now called 'mf'
#

MAKEFILE=makefile
#MAKEFILE=makefile.gen
RELEASE=`cat $(TOP)/RELEASE`
MF=mf

.PHONY: $(MF) $(MF)_2 additionalMakefiles

#
# creates a Makefile from Make.proto, rules and configuration
#
$(MF): Make.proto $(RULEDIR)/stdHeader $(RULEDIR)/stdHeader2 $(RULEDIR)/stdRules \
		     $(CONFDIR)/COMMON/defines \
		     $(CONFDIR)/vendorConf \
		     $(CONFDIR)/myConf
	@-echo "making $(MAKEFILE) for $(CONF) $(CONF_PACKS) ..."
	@$(MAKE) additionalMakefiles
	@$(MAKE) $(MF)_2

additionalMakefiles::

$(MF)_2:
	@-rm -f $(MAKEFILE).bak
	@-mv $(MAKEFILE) $(MAKEFILE).bak
	@echo '#' > $(MAKEFILE)
	@echo '# DO NOT EDIT ' >> $(MAKEFILE)
	@echo '# automagically generated from Make.proto (by make mf)' >> $(MAKEFILE)
	@echo "#" >> $(MAKEFILE)
	@-if [ "$(MAKE_INCLUDE)" != "" ]; then \
	    echo "$(MAKE_INCLUDE) $(TOP)/rules/stdHeader" >>$(MAKEFILE); \
	else \
	    cat $(RULEDIR)/stdHeader >> $(MAKEFILE) ; \
	    echo "$(MAKEFILE):: $(TOP)/rules/stdHeader" >>$(MAKEFILE); \
	fi
	@-if [ -r $(CONFDIR)/COMMON/defines ]; then \
	  if [ "$(MAKE_INCLUDE)" != "" ]; then \
	    echo "$(MAKE_INCLUDE) $(TOP)/configurations/COMMON/defines" >> $(MAKEFILE); \
	  else \
	    cat $(CONFDIR)/COMMON/defines >> $(MAKEFILE); \
	    echo "$(MAKEFILE):: $(CONFDIR)/COMMON/defines" >>$(MAKEFILE); \
	  fi ;\
	fi
	@-if [ -r $(CONFDIR)/vendorConf ]; then \
	  if [ "$(MAKE_INCLUDE)" != "" ]; then \
	    echo "$(MAKE_INCLUDE) $(TOP)/configurations/vendorConf" >> $(MAKEFILE); \
	  else \
	    cat $(CONFDIR)/vendorConf >> $(MAKEFILE); \
	  fi ; \
	fi
	@-if [ -r $(CONFDIR)/myTools ]; then \
	  if [ "$(MAKE_INCLUDE)" != "" ]; then \
	    echo "$(MAKE_INCLUDE) $(TOP)/configurations/myTools" >> $(MAKEFILE); \
	  else \
	    cat $(CONFDIR)/myTools >> $(MAKEFILE); \
	  fi ;\
	else \
	  if [ "$(CONF_TOOLS)" != "" ]; then \
	    if [ -r $(CONFDIR)/COMMON/$(CONF_TOOLS) ]; then \
	      cat $(CONFDIR)/COMMON/$(CONF_TOOLS) >>$(MAKEFILE) ; \
	    fi ; \
	  fi ;\
	fi
	@-if [ "$(MAKE_INCLUDE)" != "" ]; then \
	  echo "$(MAKE_INCLUDE) $(TOP)/configurations/myConf"  >> $(MAKEFILE); \
	else \
	  cat $(CONFDIR)/myConf  >>$(MAKEFILE); \
	fi
	@-if [ -r $(CONFDIR)/myPack ]; then \
	  if [ "$(MAKE_INCLUDE)" != "" ]; then \
	    echo "$(MAKE_INCLUDE) $(TOP)/configurations/myPack" >> $(MAKEFILE); \
	  else \
	    cat $(CONFDIR)/myPack >> $(MAKEFILE); \
	    echo "$(MAKEFILE):: $(CONFDIR)/myPack" >>$(MAKEFILE); \
	  fi ;\
	else \
	    if [ "$(CONF_PACKS)" != "" ]; then \
		if [ -r $(CONFDIR)/PACKS/$(CONF_PACKS) ]; then \
		    cat $(CONFDIR)/PACKS/$(CONF_PACKS) >>$(MAKEFILE) ; \
		fi ;\
	    fi ;\
	fi
	@-if [ "$(MAKE_INCLUDE)" != "" ]; then \
	  echo "$(MAKE_INCLUDE) $(TOP)/rules/stdHeader2" >>$(MAKEFILE); \
	else \
	  cat $(RULEDIR)/stdHeader2         >>$(MAKEFILE); \
	  echo "$(MAKEFILE):: $(RULEDIR)/stdHeader2" >>$(MAKEFILE); \
	fi
	@-if [ -r Make.spec ]; then                    \
	  if [ "$(MAKE_INCLUDE)" != "" ]; then \
	    echo "$(MAKE_INCLUDE) Make.spec"  >> $(MAKEFILE); \
	  else \
	    cat Make.spec  >>$(MAKEFILE); \
	  fi; \
	fi
	@-if [ $$TOP"x" != "x" ]; then \
	    echo "TOP="$$TOP  >>$(MAKEFILE); \
	    sed '/^TOP=/d' < Make.proto > Make.proto.edit; \
	    cat Make.proto.edit >>$(MAKEFILE); \
	else \
	    if [ $(TOPOVERWRITE)"x" != "x" ]; then \
		echo "TOP="$(TOP) >>$(MAKEFILE);  \
		sed '/^TOP=/d' < Make.proto > Make.proto.edit; \
		cat Make.proto.edit >>$(MAKEFILE); \
	    else \
		if [ "$(MAKE_INCLUDE)" != "" ]; then \
		    echo $(MAKE_INCLUDE) Make.proto >>$(MAKEFILE); \
		else \
		    cat Make.proto >>$(MAKEFILE); \
		    echo "$(MAKEFILE):: Make.proto" >>$(MAKEFILE); \
		fi ;\
	    fi ;\
	fi
	@echo ""                           >>$(MAKEFILE)
	@echo "BASE_CONF="$(CONF)               >>$(MAKEFILE)
	@echo "BASE_CONF_VENDOR="$(CONF_VENDOR) >>$(MAKEFILE)
	@echo "CONF_PACKS="$(CONF_PACKS)   >>$(MAKEFILE)
	@echo "CONF_TOOLS="$(CONF_TOOLS)   >>$(MAKEFILE)
	@-if [ $$TOP"x" != "x" ]; then                  \
	    echo "TOP="$$TOP              >>$(MAKEFILE);        \
	    echo "TOPOVERWRITE="$$TOP     >>$(MAKEFILE);        \
	    echo "STC="stc                >>$(MAKEFILE);   \
	    echo "INCLUDE="$(INCLUDE)     >>$(MAKEFILE);        \
	    echo "INCLUDE_OUT="$(INCLUDE_OUT) >>$(MAKEFILE); \
	else                                            \
	    if [ $(TOPOVERWRITE)"x" != "x" ]; then      \
		echo "TOP="$(TOP)          >>$(MAKEFILE);  \
		echo "TOPOVERWRITE="$(TOP) >>$(MAKEFILE);  \
		echo "STC="stc             >>$(MAKEFILE);  \
		echo "INCLUDE="$(INCLUDE)  >>$(MAKEFILE);       \
		echo "INCLUDE_OUT="$(INCLUDE_OUT) >>$(MAKEFILE); \
	    fi;                                          \
	fi
	@echo ""                           >>$(MAKEFILE)
	@-if [ "$(MAKE_INCLUDE)" != "" ]; then \
	  echo "$(MAKE_INCLUDE) $(TOP)/rules/stdRules" >> $(MAKEFILE); \
	else \
	  cat $(RULEDIR)/stdRules           >>$(MAKEFILE); \
	  echo "$(MAKEFILE):: $(RULEDIR)/stdRules" >>$(MAKEFILE); \
	fi
	@-if [ "$(TOUCH)" != "echo" ]; then \
	    $(TOUCH) $(MAKEFILE); \
	fi
	@if [ "$(OTHER_MAKE_FILES)" != "" ]; then \
	    $(MAKE) $(OTHER_MAKE_FILES); \
	fi
# No longer -- dependencies, abbrev and libInit.stc
# are created by smalltalk!
#
#       @$(MAKE) depend MAKEFILE=$(MAKEFILE)
#       @-if [ "$(MAKE_NT_MAKEFILES)" = "yes" ]; then \
#           $(MAKE) nt.mak; \
#           $(MAKE) bmake.bat; \
#       fi
#       @-if [ "$(MAKE_VMS_MAKEFILES)" = "yes" ]; then \
#           $(MAKE) vms.mak; \
#       fi
#       @-if [ "$(SUPPRESS_LOCAL_ABBREVS)" = "" ]; then \
#           $(MAKE) updateAbbrev; \
#       fi
	#cp $(TOP)/rules/samples/Makefile .

#
# unconditionally makes a new makefile
# o$lete.
#
makeMakefile:
	@echo "making $(MAKEFILE) for $(CONF) $(CONF_PACKS) ..."
	@echo "1b"
	@-rm -f $(MAKEFILE).bak
	@-mv $(MAKEFILE) $(MAKEFILE).bak
	@cat $(RULEDIR)/stdHeader       >$(MAKEFILE)
	@-if [ -r $(CONFDIR)/COMMON/defines ]; then \
	    cat $(CONFDIR)/COMMON/defines >> $(MAKEFILE); \
	fi
	@-if [ -r $(CONFDIR)/vendorConf ]; then \
	    cat $(CONFDIR)/vendorConf >> $(MAKEFILE); \
	fi
	@-if [ -r $(CONFDIR)/myTools ]; then \
	    cat $(CONFDIR)/myTools >> $(MAKEFILE); \
	fi
	@cat $(CONFDIR)/myConf  >>$(MAKEFILE)
	@-if [ -r $(CONFDIR)/myPack ]; then \
	    cat $(CONFDIR)/myPack >> $(MAKEFILE); \
	else \
	    if [ "$(CONF_PACKS)" != "" ]; then \
		if [ -r $(CONFDIR)/PACKS/$(CONF_PACKS) ]; then \
		    cat $(CONFDIR)/PACKS/$(CONF_PACKS) >>$(MAKEFILE) ; \
		fi; \
	    fi; \
	fi
	@cat $(RULEDIR)/stdHeader2         >>$(MAKEFILE)
	@-if [ -r Make.spec ]; then                    \
	    cat Make.spec                 >>$(MAKEFILE); \
	fi
	@cat Make.proto                    >>$(MAKEFILE)
	@echo ""                           >>$(MAKEFILE)
	@echo "BASE_CONF="$(CONF)               >>$(MAKEFILE)
	@echo "BASE_CONF_VENDOR="$(CONF_VENDOR) >>$(MAKEFILE)
	@echo "CONF_PACKS="$(CONF_PACKS)   >>$(MAKEFILE)
	@echo "CONF_TOOLS="$(CONF_TOOLS)   >>$(MAKEFILE)
	@-if [ $$TOP"x" != "x" ]; then \
	    echo "TOP="$$TOP          >>$(MAKEFILE);    \
	    echo "TOPOVERWRITE="$$TOP >>$(MAKEFILE);    \
	    echo "STC="stc            >>$(MAKEFILE);       \
	    echo "INCLUDE="$(INCLUDE)   >>$(MAKEFILE);  \
	    echo "INCLUDE_OUT="$(INCLUDE_OUT) >>$(MAKEFILE); \
	else                                            \
	    if [ $(TOPOVERWRITE)"x" != "x" ]; then      \
		echo "TOP="$(TOP)          >>$(MAKEFILE);       \
		echo "TOPOVERWRITE="$(TOP) >>$(MAKEFILE);  \
		echo "STC="stc             >>$(MAKEFILE);  \
		echo "INCLUDE="$(INCLUDE)   >>$(MAKEFILE); \
		echo "INCLUDE_OUT="$(INCLUDE_OUT) >>$(MAKEFILE); \
	    fi;                                          \
	fi
	@echo ""                           >>$(MAKEFILE)
	@cat $(RULEDIR)/stdRules         >>$(MAKEFILE)
	@-if [ "$(TOUCH)" != "echo" ]; then \
	    $(TOUCH) $(MAKEFILE); \
	fi
	@if [ "$(OTHER_MAKE_FILES)" != "" ]; then \
	    $(MAKE) $(OTHER_MAKE_FILES);          \
	fi
# No longer -- dependencies, abbrev and libInit.stc
# are created by smalltalk!
#
#        @-if [ "$(SUPPRESS_DEPEND)" = "" ]; then    \
#            $(MAKE) depend MAKEFILE=$(MAKEFILE); \
#        fi
#        @-if [ "$(MAKE_NT_MAKEFILES)" = "yes" ]; then \
#            $(MAKE) nt.mak;    \
#            $(MAKE) bmake.bat; \
#        fi
#        @-if [ "$(MAKE_VMS_MAKEFILES)" = "yes" ]; then \
#            $(MAKE) vms.mak;   \
#        fi
#        @-if [ "$(SUPPRESS_LOCAL_ABBREVS)" = "" ]; then \
#            $(MAKE) updateAbbrev; \
#        fi

#
# same, without make depend
#
qmakeMakefile:
	$(MAKE) makeMakefile SUPPRESS_DEPEND=y MAKEFILE=$(MAKEFILE)

#
# same - lazy of typing
#
qmf:    qmakeMakefile

# $(MAKEFILE): Make.proto
#       $(MAKE) mf

#
# recursively goes down SUBDIRS and creates Makefiles
#
Makefiles:: checkForSTC
	@echo "making Makefiles for $(CONF) $(CONF_PACKS) ..."
	@$(MAKE) Makefiles_2

Makefiles_2:
	@-if [ "$(ALLSUBDIRS)"x != x ]; then         \
	  $(MAKE) subMakefiles MAKEFILE=$(MAKEFILE); \
	fi

checkForSTC:
	@-if [ ! -f $(STC) ]; then \
	  (cd $(TOP)/stc && $(MAKE)); \
	fi

#
# same without make depend
#
qMakefiles::
	@-if [ "$(ALLSUBDIRS)"x != x ]; then                            \
	  $(MAKE) subMakefiles SUPPRESS_DEPEND=y MAKEFILE=$(MAKEFILE);  \
	fi

subMakefiles::
	@-for i in $(ALLSUBDIRS); do \
	  if [ -d $$i ]; then \
	   if [ -f $$i/Make.proto ]; then \
	     $(MAKE) subMakefile SUBDIR=$$i ; \
	   else \
	     echo "*** oops no Make.proto in directory $$i ?? (non fatal)"; \
	   fi; \
	  else \
	    echo "*** oops where is directory $$i ?? in "`pwd`" (non fatal)"; \
	  fi; \
	done

subMakefile::
	$(RULEDIR)/stmkmf --cd $(SUBDIR)

#
# sorry - the -nt operator is not available on most shells ... shame to them
#

# CHECKMAKEFILEISUPTODATE=checkMakefileIsUpToDate

checkMakefileIsUpToDate:
	@-if [ Make.proto -nt $(MAKEFILE) ]; then  \
	   $(MAKE) mf;                         \
	fi


#
# cross-make of makefiles & config files
# for systems with poor make/sed/awk etc. support
#
# bmake.bat:
#         @echo "mkdir objbc" > bmake.bat
#         @echo "make.exe -N -f nt.mak %1 %2" >> bmake.bat

bmake.bat:
	@echo "make.exe -N -f nt.mak %1 %2" >> bmake.bat

nt.mak: Make.proto $(TOP)/rules/stdRules
	@$(MAKE) SYSDEP_OBJS="$(WIN32_OBJS)" do_nt.mak

NT_ADDITIONAL_DEFS::
	@echo "#"
	@echo "# additional defines"
	@echo "#"

NT_ADDITIONAL_RULES::
	@echo "#"
	@echo "# additional rules"
	@echo "#"

do_nt.mak:
	@echo "making nt.mak from Make.proto ..."
	@echo '#' > nt_mak
	@echo '# DO NOT EDIT ' >> nt_mak
	@echo '# automagically generated from Make.proto (by make nt.mak)' >> nt_mak
	@echo "#" >> nt_mak
	@echo -n "TOP=" >> nt_mak
	@echo $(TOP) | sed -e 's:/:\\:g' >> nt_mak
	@echo "#" >> nt_mak
	@echo '!INCLUDE $$(TOP)\rules\'$(STDHEADER_NT) >> nt_mak
	@echo "#" >> nt_mak
	@-if [ "$(LIBNAME)" != "" ]; then \
	    echo "MODULE="$(MODULE) >> nt_mak; \
	    echo "MODULE_DIR="$(MODULE_DIR) >> nt_mak; \
	    echo "PACKAGE=$$"'('MODULE')'":$$"'('MODULE_DIR')' >> nt_mak; \
	    echo "LIBNAME="$(LIBNAME) >> nt_mak; \
	    if [ "$(NM_LIB_BASE)" != "" ]; then \
		echo "LIB_BASE=$$"'('$(NM_LIB_BASE)')' >> nt_mak; \
		echo '!ifdef USEBC' >> nt_mak; \
		echo "LIB_BASE_LD_ARG=-b:$$"'('$(NM_LIB_BASE)')' >> nt_mak; \
		echo '!endif' >> nt_mak; \
	    fi; \
	    echo LOCALINCLUDES='"'$(LOCALINCLUDES)'"' | sed -e 's:/:\\:g'  >> nt_mak; \
	    echo 'CLOCAL_INCL=$$(LOCALINCLUDES)' >>nt_mak; \
	    echo STCOPT='"'$(STCOPT)'"' >> nt_mak; \
	    echo 'STCLOCALOPT=-package=$$(PACKAGE) $$(COMMONSYMBOLS) $$(SEPINITCODE) $$(RELOCINSTVARS) -varPrefix=$$(LIBNAME) $$(LOCALINCLUDES)' >> nt_mak; \
	    echo '#STCLOCALOPT="'$(STCLOCALOPT)'"' >> nt_mak; \
	    echo >> nt_mak; \
	    echo 'ALL: $(NT_ADDITIONAL_ALL_TARGETS) $$(LIBDIR)\$$(LIBNAME).lib $$(BINDIR)\$$(LIBNAME).dll' >>nt_mak; \
	    echo >> nt_mak; \
	fi
	@$(MAKE) NT_ADDITIONAL_DEFS >> nt_mak
	@echo >> nt_mak
	@echo 'OBJS=\' >> nt_mak
	@for i in $(OBJS); do \
	  BASE=`basename $$i .$(O)`; \
	  W32BASE=`basename $$i .$(O)`_win32; \
	  W32ST=`basename $$i .$(O)`_win32.st; \
	  if [ -f $$W32ST ]; then \
	    BASE=$$W32BASE; \
	  fi; \
	  if [ "$$BASE" != "XWorkstation" ]; then \
	    if [ "$$BASE" != "GLXWorkstation" ]; then \
	      if [ "$$BASE" != "WinWorkstation" ]; then \
		echo '  $$(OUTDIR)'$$BASE'.$$(O)'" \\" >> nt_mak; \
	      fi; \
	    fi; \
	  fi; \
	done
	@echo >> nt_mak
	@echo >> nt_mak
	@echo '!INCLUDE $$(TOP)\rules\'$(STDRULES_NT) >> nt_mak
	@echo >> nt_mak
	@$(MAKE) NT_ADDITIONAL_RULES >> nt_mak
	@echo >> nt_mak
	@echo "# BEGINMAKEDEPEND --- do not remove this line; make depend needs it" >> nt_mak
	@for i in $(OBJS); do \
	  BASE=`basename $$i .$(O)`; \
	  W32BASE=`basename $$i .$(O)`_win32; \
	  W32ST=`basename $$i .$(O)`_win32.st; \
	  if [ -f $$W32ST ]; then \
	    BASE=$$W32BASE; \
	  fi; \
	  if [ "$$BASE" != "XWorkstation" ]; then \
	    if [ "$$BASE" != "GLXWorkstation" ]; then \
	      if [ "$$BASE" != "WinWorkstation" ]; then \
		echo '$$(OUTDIR)'$$BASE'.$$(O): '$$BASE'.st' >> nt_mak; \
	      fi; \
	    fi; \
	  fi; \
	done
	@echo "# ENDMAKEDEPEND --- do not remove this line" >> nt_mak
	@-if [ -f nt.mak ]; then \
	    mv nt.mak nt.mak.bak; \
	fi
	@$(MAKE) stDepend MAKEFILE=nt_mak
	@mv nt_mak nt.mak

nt.def: $(MAKEFILE) $(TOP)/rules/stdRules
	@echo "making nt.def from Make.proto ..."
	@echo 'LIBRARY '$(LIBNAME) > nt_def
	@echo 'CODE EXECUTE READ SHARED' >> nt_def
	@echo 'DATA READ WRITE' >> nt_def
	@echo 'SECTIONS' >> nt_def
	@echo '    INITCODE    READ EXECUTE SHARED' >> nt_def
	@echo '    INITDATA    READ WRITE' >> nt_def
	@echo '    RODATA      READ SHARED' >> nt_def
	@echo 'EXPORTS ' >> nt_def
	@echo '    _'$(LIBNAME)'_Init' >> nt_def
	@-mv nt.def nt.def.bak
	@mv nt_def nt.def

bc.def: $(MAKEFILE) $(TOP)/rules/stdRules
	@echo "making bc.def from Make.proto ..."
	@echo 'LIBRARY '$(LIBNAME) > bc_def
	@echo 'CODE PRELOAD MOVEABLE DISCARDABLE' >> bc_def
	@echo 'SEGMENTS' >> bc_def
	@echo '   INITCODE    PRELOAD DISCARDABLE' >> bc_def
	@echo 'EXPORTS ' >> bc_def
	@echo '    _'$(LIBNAME)'_Init   @1' >> bc_def
	@-mv bc.def bc.def.bak
	@mv bc_def bc.def

vms.mak: $(MAKEFILE) $(TOP)/rules/stdRules
	@$(MAKE) SYSDEP_OBJS="$(VMS_OBJS)" do_vms.mak

do_vms.mak:
	@echo "making vms.mak from Make.proto ..."
	@echo '#' > vms_mak
	@echo '# DO NOT EDIT ' >> vms_mak
	@echo '# automagically  generated from Make.proto (by make vms.mak)' >> vms_mak
	@echo "#" >> vms_mak
	@echo "TOP="$(TOP) >> vms_mak
#       @echo '!INCLUDE $$(TOP)\rules\stdHeader_vms' >> vms_mak
	@echo "LIBNAME="$(LIBNAME) >> vms_mak
#       @grep $(GREP_ARGS) "LIB_BASE=" Make.proto >> vms_mak
	@echo STCOPT='"'$(STCOPT)'"' >> vms_mak
	@echo 'STCLOCALOPT=-package=$$(MODULE):$$(MODULE_DIR) $$(COMMONSYMBOLS) $$(SEPINITCODE) $$(RELOCINSTVARS) -varPrefix=$$(LIBNAME)' >> vms_mak
	@echo 'ALL: $$(LIBDIR)\$$(LIBNAME).olb' >>vms_mak
	@echo >>vms_mak
	@echo 'OBJS=\' >> vms_mak
	@for i in $(OBJS); do \
	  BASE=`basename $$i .$(O)`; \
	  echo '  $$(OUTDIR)'$$BASE'.$$(O)'" \\" >> vms_mak; \
	done
	@echo >> vms_mak
	@echo >> vms_mak
	@echo 'theLib:: $$(LIBNAME).olb' >> vms_mak
	@echo 'Xwrite sys$$output "making class objects ..."' | tr X "\\011" >> vms_mak
	@echo 'X$$(MAKE) objs' | tr X "\\011" >> vms_mak
	@echo 'X$$(MAKE) libinit' | tr X "\\011" >> vms_mak
	@echo 'Xwrite sys$$output "classlibrary $$(LIBNAME).olb made."' | tr X "\\011" >> vms_mak
	@echo >> vms_mak
	@echo '$$(LIBNAME).olb:' >> vms_mak
	@echo 'Xwrite sys$$output "creating initial $$(LIBNAME).olb ..."' | tr X "\\011" >> vms_mak
	@echo 'Xlib/cre $$(LIBNAME).olb' | tr X "\\011" >> vms_mak
	@echo >> vms_mak
	@echo 'objs:  $$(OBJS1)' >> vms_mak
	@echo >> vms_mak
	@echo >> vms_mak
	@echo >> vms_mak
	@echo '# BEGINMAKEDEPEND' >> vms_mak
	@for i in $(OBJS); do \
	  BASE=`basename $$i .$(O)`; \
	  echo '$$(OUTDIR)'$$BASE'.$$(O): '$$BASE'.st' >> vms_mak; \
	done
	@echo '# ENDMAKEDEPEND' >> vms_mak
	@-mv vms.mak vms.mak.bak
	@$(MAKE) stDepend MAKEFILE=vms_mak
	@mv vms_mak vms.mak

# libInit.cc is now in CVS - do not overwrite!
#
#libInit.cc: Make.proto Make.spec $(MAKEFILE) $(TOP)/rules/stdRules
libInit.cc:
	$(MAKE) doLibInit.cc SYSDEP_OBJS=

doLibInit.cc:
	@echo "making libInit.cc from Make.proto ..."
	@echo '/*' > libInit_cc
	@echo ' * DO NOT EDIT ' >> libInit_cc
	@echo ' * automagically generated from Make.proto (by make libInit.cc)' >> libInit_cc
	@echo ' */' >> libInit_cc
	@echo '#define __INDIRECTVMINITCALLS__' >> libInit_cc
	@echo '#include <stc.h>' >> libInit_cc
	@echo '#define INIT_TEXT_SECT /* as nothing */' >> libInit_cc
	@echo '#ifdef WIN32' >> libInit_cc
	@echo '# pragma codeseg INITCODE "INITCODE"' >> libInit_cc
	@echo '#else /* not WIN32 */' >> libInit_cc
	@echo '# if defined(__GNUC__) && !defined(NO_SECTION_ATTRIBUTES)' >> libInit_cc
	@echo '#  if (__GNUC__  == 2 && __GNUC_MINOR__ >= 7) || __GNUC__ > 2' >> libInit_cc
	@echo '#   undef INIT_TEXT_SECT' >> libInit_cc
	@echo '#   define INIT_TEXT_SECT __attribute__((section(".stxitext")))' >> libInit_cc
	@echo '#  endif' >> libInit_cc
	@echo '# endif /* not GNUC */' >> libInit_cc
	@echo '#endif /* not WIN32 */' >> libInit_cc
	@echo '#ifdef INIT_TEXT_SECT' >> libInit_cc
	@echo 'extern void _'$(LIBNAME)'_Init() INIT_TEXT_SECT;' >> libInit_cc
	@echo '#endif' >> libInit_cc
	@echo 'void _'$(LIBNAME)'_Init(pass, __pRT__, snd)' >> libInit_cc
	@echo 'OBJ snd; struct __vmData__ *__pRT__; {' >> libInit_cc
	@echo '__BEGIN_PACKAGE2__("'$(LIBNAME)'", _'$(LIBNAME)'_Init, "'$(PACKAGE)'");' >> libInit_cc
	@for i in $(OBJS); do \
	  BASE=`basename $$i .$(O)`; \
	  if [ "$$BASE" = "XWorkstation" ]; then \
	      echo "#ifdef WANT_XWorkstation" >> libInit_cc; \
	  fi; \
	  if [ "$$BASE" = "GLXWorkstation" ]; then \
	      echo "#ifdef WANT_GLXWorkstation" >> libInit_cc; \
	  fi; \
	  if [ "$$BASE" = "WinWorkstation" ]; then \
	      echo "#ifdef WANT_WinWorkstation" >> libInit_cc; \
	  fi; \
	  CLASS=`$(STC) -extractCInit $$BASE.st`; \
	  echo "_"$$CLASS'_Init(pass,__pRT__,snd);' >> libInit_cc; \
	  if [ "$$BASE" = "XWorkstation"  ]; then \
	      echo "#endif" >> libInit_cc; \
	  fi; \
	  if [ "$$BASE" = "GLXWorkstation"  ]; then \
	      echo "#endif" >> libInit_cc; \
	  fi; \
	  if [ "$$BASE" = "WinWorkstation"  ]; then \
	      echo "#endif" >> libInit_cc; \
	  fi; \
	done
	@if [ "$(WIN32_OBJS)" != "" ]; then \
	    $(MAKE) libInit_xxx xxx_OBJS="$(WIN32_OBJS)" xxx_define=WIN32; \
	fi
	@if [ "$(VMS_OBJS)" != "" ]; then \
	    $(MAKE) libInit_xxx xxx_OBJS="$(VMS_OBJS)" xxx_define=VMS; \
	fi
	@if [ "$(UNIX_OBJS)" != "" ]; then \
	    $(MAKE) libInit_xxx xxx_OBJS="$(UNIX_OBJS)" xxx_define=UNIX; \
	fi
	@if [ "$(MACOS_OBJS)" != "" ]; then \
	    $(MAKE) libInit_xxx xxx_OBJS="$(MACOS_OBJS)" xxx_define=MACOS; \
	fi
	@if [ "$(OS2_OBJS)" != "" ]; then \
	    $(MAKE) libInit_xxx xxx_OBJS="$(OS2_OBJS)" xxx_define=OS2; \
	fi
	@if [ "$(BEOS_OBJS)" != "" ]; then \
	    $(MAKE) libInit_xxx xxx_OBJS="$(BEOS_OBJS)" xxx_define=BEOS; \
	fi
	@echo '__END_PACKAGE__();' >> libInit_cc
	@echo '}' >> libInit_cc
	@-if [ -f libInit.cc ]; then \
	    mv libInit.cc libInit.cc.bak; \
	fi
	@mv libInit_cc libInit.cc

libInit_xxx:
	@echo "#ifdef "$(xxx_define) >> libInit_cc
	@for i in $(xxx_OBJS); do \
	  BASE=`basename $$i .$(O)`; \
	  if [ -f $$BASE.st ]; then \
	    CLASS=`$(STC) -extractCInit $$BASE.st`; \
	    echo "_"$$CLASS'_Init(pass,__pRT__,snd);' >> libInit_cc; \
	  else \
	    echo "skipped missing classFile: "$$BASE.st; \
	  fi \
	done
	@echo "#endif" >> libInit_cc

#
# check:
#    quick ST-syntax check over all st-files
#
check::
	@-if [ "*.st" != '\*.st' ]; then  \
	  for i in *.st; do               \
	    echo checking $$i ...;        \
	    $(STC) -check $(STCFLAGS) $(STC_MSGFORMAT) $$i;\
	  done;                           \
	fi
	@-if [ "$(SUBDIRS)"x != x ]; then \
	  for i in $(SUBDIRS)" "; do      \
	    if [ -d $$i ]; then           \
	      echo "checking in $$i";     \
	      (cd $$i && $(MAKE) check );  \
	    fi;                           \
	  done;                           \
	fi

#
# debug - make with -g instead of -O
#
debug:
	$(MAKE) OPT="-g $(OPT)" LIBRUN_OPT="-g $(LIBRUN_OPT)" STCOPT="$(STCOPT)"

cfiles:
	  for i in ""*.st""; do                          \
	    $(MAKE) $$(echo $$i | sed "s/\.st/\.c/1"); \
	  done;                                          \

#
# notes:
#    output notes on st-code (for compiler writer only)
#
notes::
	@-if [ "*.st" != '\*.st' ]; then                 \
	  for i in ""*.st""; do                          \
	    echo notes on $$i ...;                       \
	    $(STC) -check +notice +hint $(STCFLAGS) $(STC_MSGFORMAT) $$i; \
	  done;                                          \
	fi
	@-if [ "$(SUBDIRS)"x != x ]; then  \
	  for i in $(SUBDIRS)" "; do       \
	    if [ -d $$i ]; then            \
	      echo "notes in $$i";         \
	      (cd $$i && $(MAKE) notes );   \
	    fi;                            \
	  done;                            \
	fi

#
# warnings:
#    output warning on st-code (for compiler writer only)
#
warnings::
	@-if [ "*.st" != '\*.st' ]; then                 \
	  for i in ""*.st""; do                          \
	    echo warnings on $$i ...;                       \
	    $(STC) -check +hint $(STCFLAGS) $(STC_MSGFORMAT) $$i; \
	  done;                                          \
	fi
	@-if [ "$(SUBDIRS)"x != x ]; then  \
	  for i in $(SUBDIRS)" "; do       \
	    if [ -d $$i ]; then            \
	      echo "warnings in $$i";         \
	      (cd $$i && $(MAKE) warnings );   \
	    fi;                            \
	  done;                            \
	fi

#
# hints:
#    output hints on st-code (mostly for compiler writer)
#
hints::
	@-for i in *.st; do                           \
	    echo hints on $$i ...;                    \
	    $(STC) -check +hint $(STCFLAGS) $(STC_MSGFORMAT) $$i;      \
	done

#
# fullcheck:
#    outputs notice + hints
#
fullcheck::
	@-if [ "*.st" != '\*.st' ]; then                 \
	  for i in *.st; do                              \
	    echo checking $$i ...;                       \
	    $(STC) -check $(STCFLAGS) $(STC_MSGFORMAT) +notice +hint $$i; \
	  done;                                          \
	fi
	@-if [ "$(SUBDIRS)"x != x ]; then    \
	  for i in $(SUBDIRS)" "; do         \
	    if [ -d $$i ]; then              \
	      echo "check in $$i";           \
	      (cd $$i && $(MAKE) fullcheck ); \
	    fi;                              \
	  done;                              \
	fi

#
# defaultMakefile
# create an initial Make.proto.
# use as: make -f <some-existing-makefile> Make.proto
#

Make.spec:
	@-if [ -r Make.spec ]; then         \
	    echo "Make.spec exists";        \
	    exit 1;                          \
	fi
	@echo -n '# $$Header' > Make.spec
	@echo '$$' >> Make.spec
	@echo "#" >> Make.spec
	@echo "# --- Automatically created Make.spec" >> Make.spec
	@echo >> Make.spec
	@echo "TOP="$(TOP) >> Make.spec
	@echo "SUBDIRS=" >> Make.spec
	@echo >> Make.spec
	@echo >> Make.spec
	@echo "# ***************************** modify the next line ***" >> Make.spec
	@echo "LIBNAME=libprivate" >> Make.spec
	@echo >> Make.spec
	@echo >> Make.spec
	@echo "EXTRA_TARGTES=" >> Make.spec
	@echo >> Make.spec
	@echo -n "OBJS= " >> Make.spec
	@-if [ "*.st" != '\*.st' ]; then                        \
	  for i in ""*.st""; do                                 \
	    echo " \\" >> Make.spec;                           \
	    echo -n "   " $$(OUTDIR)`basename $$i .st`.'$$(O)' >> Make.spec; \
	  done;                                                 \
	fi
	@echo >> Make.spec
	@echo >> Make.spec


Make.proto:
	@-if [ -r Make.proto ]; then         \
	    echo "Make.proto exists";        \
	    exit 1;                          \
	fi
	@echo -n '# $$Header' > Make.proto
	@echo '$$' >> Make.proto
	@echo "#" >> Make.proto
	@echo "# --- Automatically created Make.proto" >> Make.proto
	@echo >> Make.proto
	@echo "# ***************************** modify the next line ***" >> Make.proto
	@echo "STCLOCALOPT='-Pprivate-classes-(module:directory)'" >> Make.proto
	@echo "STCOPT=$(LIBBASIC2_STCOPT)" >> Make.proto
	@echo >> Make.proto
	@echo >> Make.proto
	@echo "all:: classLibRule $(EXTRA_TARGETS)" >> Make.proto
	@echo >> Make.proto
	@echo "cleanjunk::" >> Make.proto
	@echo >> Make.proto
	@echo "clean::" >> Make.proto
	@echo " -rm -f *.H" >> Make.proto
	@echo >> Make.proto
	@echo "clobber::" >> Make.proto
	@echo " -rm -f *.o" >> Make.proto
	@echo >> Make.proto
	@echo "# BEGINMAKEDEPEND --- do not remove this line; make depend needs it" >> Make.proto
	@echo "# ENDMAKEDEPEND --- do not remove this line" >> Make.proto


#
# collectAbbrev
# recursively work thru subdirectories and collect abbreviations
# into $(INCLUDE)/abbrev.stc for classname-to-filename translations
#
#
collectAbbrev::
	@-$(MAKE) abbrev.stc
	@-if [ "$(SUPPRESS_LOCAL_ABBREVS)" = "" ]; then \
	    $(MAKE) updateAbbrev; \
	fi
	@-if [ "$(ALLSUBDIRS)"x != x ]; then \
	    $(MAKE) collectSubdirAbbrev;     \
	fi

collectSubdirAbbrev::
	@-for i in $(ALLSUBDIRS); do         \
	    if [ -d $$i ]; then              \
	      if [ -f $$i/Make.proto ]; then \
		if [ -f $$i/$(MAKEFILE) ]; then            \
		  echo "collect abbreviations in $$i";  \
		  if [ "$(NOSUBAUTOLOAD)" = "1" ]; then \
		      (cd $$i && $(MAKE) collectAbbrev NOSUBAUTOLOAD=1 NOAUTOLOAD=1 ); \
		  else                                  \
		      (cd $$i && $(MAKE) collectAbbrev);     \
		  fi;                        \
		fi                           \
	      fi                             \
	    fi;                              \
	done

UNCRITICAL:
	$(MAKE) $(SPACEOPT_O_RULE) STFILE=$(NAME) STCOPT="$(STCOPT) $(UNCRITICALOPT)" CLASSLIB_CC="$(CLASSLIB_CC)" CLASSLIB_OPT="$(CLASSLIB_OPT)" CC="$(CLASSLIB_CC)" OPT="$(OPT)"

$(UNCRITICALOBJS):
	@$(MAKE) UNCRITICAL CC="$(CLASSLIB_CC)" OPT="$(OPT)" CLASSLIB_CC="$(CLASSLIB_CC)" CLASSLIB_OPT="$(CLASSLIB_OPT)" NAME=$*

AUTOLOADED:
	@-if [ -f i_$(NAME).o ]; then \
	    echo "assuming stubObject i_$(NAME).o is up-to-date"; \
	else \
	    $(MAKE) $(SPACEOPT_O_RULE) STFILE=$(NAME) STCOPT="$(STCOPT)" FORCEAUTOLOAD="+autoload -sepInitCode" CLASSLIB_CC="$(CLASSLIB_CC)" CLASSLIB_OPT="$(CLASSLIB_OPT)" OPT="$(OPT)" CC="$(CLASSLIB_CC)"; \
	fi

$(AUTOLOADEDOBJS):
	@$(MAKE) AUTOLOADED CLASSLIB_CC="$(CLASSLIB_CC)" CLASSLIB_OPT="$(CLASSLIB_OPT)" CC="$(CC)" OPT="$(OPT)" NAME=$*

#
# objs:
#    generate all .o-files
#

subDirObjsIfBeforeObjs:
	@-if [ "$(SUBDIRS_AFTER_OBJS)" = "" ]; then \
	    $(MAKE) subDirObjsIfPresent; \
	fi

subDirObjsIfAfterObjs:
	@-if [ "$(SUBDIRS_AFTER_OBJS)" != "" ]; then \
	    $(MAKE) subDirObjsIfPresent; \
	fi

subDirObjsIfPresent:
	@-if [ "$(OBJ_SUBDIRS)" != "" ]; then \
	    $(MAKE) subDirObjs;           \
	fi

subDirObjs::
	@-for i in $(OBJ_SUBDIRS); do         \
	    if [ -d $$i ]; then           \
	      echo "making obj in $$i ...";\
	      (cd $$i && $(MAKE) CC="$(CC)" OPT="$(OPT)" obj );   \
	    fi;                           \
	done

objs:: pre_objs pre_local_objs $(OBJS) post_local_objs

pre_objs::

pre_local_objs::
	@$(MAKE) subDirObjsIfBeforeObjs

post_local_objs::
	@$(MAKE) subDirObjsIfAfterObjs

clsFiles:: pre_cls subDirClassFiles
	@test  "$(CLS)" = "" || $(MAKE) cls_files

cls_files:: $(CLS)

#
# The makefile in SUBDIR may not have been built yet...
#
subDirClassFiles::
	@-if [ "$(SUBDIRS)" != "" ]; then \
	    $(MAKE) subDirClassFilesPresent;    \
	fi

subDirClassFilesPresent::
	@for i in $(SUBDIRS); do \
	    if [ -d "$$i" ]; then \
		echo "making cls-files in $$i ..."; \
		(cd $$i && $(MAKE) makefile && $(MAKE) clsFiles) || exit $? ;  \
	    fi;  \
	done

pre_cls::

# systems which support hiding symbols from libs,
# may add the following lines in the config-file:
#
# PRE_LD_ACTION=createHiddenSymFile
# POST_LD_ACTION=removeHiddenSymFile


emptyRule:
	@true

createHiddenSymFile: hiddenSyms.stc
	@-echo > /dev/null

removeHiddenSymFile:
	@-rm -f hiddenSyms.stc


#
# make without optimizer ...
#
nonopt:
	$(MAKE) OPT=


#
# those two are no longer needed
#
CLASSLIST_OR_EMPTY=

#
# rule to build a class Library
#
lib: classLibRule

classLibRule: clsFiles $(LOCAL_EXTRA_TARGETS) $(OBJTARGET) registerClassLib

#
# create a symbolic link to the shared library in the projects/smalltalk/packages
# folder. This folder can later be scanned quickly and presented in the Launcher's
# load package menu item.
#
REGISTERED_PACKAGES_DIR=$(TOP)/projects/smalltalk/packages

registerClassLib: $(REGISTERED_PACKAGES_DIR)
	@echo "registering $(MODULE):$(MODULE_DIR)/$(LIBNAME) in $(REGISTERED_PACKAGES_DIR)"
	rm -f $(REGISTERED_PACKAGES_DIR)/$(LIBNAME)$(SONAME)
	echo "lib ../../../../$(MODULE)/$(MODULE_DIR)/$(LIBNAME)$(SONAME)" > $(REGISTERED_PACKAGES_DIR)/$(LIBNAME)$(SONAME)

$(REGISTERED_PACKAGES_DIR):
	@mkdir $(REGISTERED_PACKAGES_DIR)

registerApplication:
	@-if [ "$(APPNAME)"x != ""x ]; then \
	    echo "registering $(MODULE):$(MODULE_DIR)/$(APPNAME) in $(REGISTERED_PACKAGES_DIR)";  \
	    rm -f $(REGISTERED_PACKAGES_DIR)/$(APPNAME); \
	    echo "app ../../../../$(MODULE)/$(MODULE_PATH)/$(APPNAME)" > $(REGISTERED_PACKAGES_DIR)/$(APPNAME); \
	fi

#
# rule to build a program (application)
#
progRule:
	@-if [ "$(PROGS)"x != ""x ]; then \
	  for i in $(PROGS)" "; do        \
	    echo "making $$i";            \
	    $(MAKE) PROGTARGET$(TARGET_RULE_EXTENSION) PROG=$$i; \
	  done;                           \
	fi

#
# one of the two below is performed by the $(OBJTARGET) target;
# create a library for either static or dynamic linking
# (this is controlled by the TARGET_EXTENSION, set in an architecture specific config file)
#

obj::    obj$(TARGET_RULE_EXTENSION)

obj_shared: newobj $(LIBNAME)$(SONAME)


obj_shared_stub:
	@-if [ -f $(STUBLIBNAME)$(OBJNAME) ]; then \
	  echo "making shared stub object $(STUBLIBNAME)$(SONAME)"; \
	  $(MAKE) $(STUBLIBNAME)$(SONAME); \
	else \
	  echo " ** $(STUBLIBNAME)$(SONAME) not made - no $(STUBLIBNAME)$(OBJNAME)"; \
	fi

obj_static: newobj

static_obj:
	$(MAKE) newobj LINKOBJRULE=newobj_staticLink

#
# newobj:
#    generate all .o-files, pre-link them into one big lib.o file
#    create a lib-init function and include it in library
#

newobj_prelink::
	@true "nothing done here"

newobj_postlink::
	@true "nothing done here"

newobj: objs $(LINKOBJS)
	@if [ "$(NEWOBJ_SUBDIRS)"x != x ]; then \
	  for i in "$(NEWOBJ_SUBDIRS)"; do \
	    if [ -d $$i ]; then \
	      echo "making newobj in $$i"; \
	      (cd $$i && $(MAKE) newobj); \
	    fi; \
	  done; \
	fi
	@if [ "$(LIBNAME)" != "" ]; then \
	  if [ "$(LINKOBJS)" != "" ]; then \
	      echo "making init code ..." && \
	      $(MAKE) LINKOBJS="$(LINKOBJS)" LIBNAME=$(LIBNAME) \
	      	$(PRE_LD_ACTION) \
	      	newobj_prelink \
	      	$(LINKOBJRULE) \
	      	newobj_postlink \
	      	$(POST_LD_ACTION); \
	  else \
	    echo " ** $(LIBNAME)$(OBJNAME) not made - no object files (LINKOBJS=) defined";   \
	  fi \
	else \
	  echo " ** no library name (LIBNAME=) defined"; \
	fi
	@if [ "$(STUBLIBNAME)" != "" ]; then \
	  $(MAKE) stubobj STUBLIBNAME=$(STUBLIBNAME) LIBNAME=$(LIBNAME); \
	fi

stubobj:
	@echo "making stubobj ..."
	@echo "making stub init code ..."
	@$(MAKE) $(STUBLIBNAME)Stub.o STUBLIBNAME=$(STUBLIBNAME) LIBNAME=$(LIBNAME)
	@rm -f $(STUBLIBNAME)$(OBJNAME)
	@$(MAKE) stub_link LIBNAME=$(LIBNAME)
	@chmod -x,+w $(STUBLIBNAME)$(OBJNAME)
	@rm -f $(STUBLIBNAME)Stub.o $(STUBLIBNAME)Stub.c

newobj_link:: $(LIBNAME)$(OBJNAME)

$(LIBNAME)$(OBJNAME): $(LIBNAME)Init.o $(LINKOBJS)
	@echo "linking class object ..."
	$(CLASSLIB_LD) $(LD_REL_FLAG) $(LD_OBJ_FLAGS) $^ $(LD_OBJ_LIBS) $(LD_REL_OBJ_LIBS) -o $@

$(LIBNAME).$(SO): $(LIBNAME)$(OBJNAME)
	@echo "linking class library ..."
	$(LD) -shared $(LDFLAGS) -o $@ $< $(LOCAL_SHARED_LIBS) $(EXTRA_SHARED_LIBS)
	$(OBJCOPY) --only-keep-debug $@ $@.debug
	$(CHMOD) ugo-x $@.debug
	$(STRIP) --strip-debug --strip-unneeded $@
	$(OBJCOPY) --add-gnu-debuglink="$@.debug" $@

newobj_staticLink::
	@echo "linking static classLib object ..."
	@$(CLASSLIB_LD) $(LD_REL_FLAG) $(LD_OBJ_FLAGS) \
	    $(LIBNAME)Init.o $(LINKOBJS) $(LD_OBJ_LIBS) $(LD_REL_OBJ_LIBS) -o $(LIBNAME).$(O)

newobj_linkSep::
	@-echo "linking sepInit class object ..."
	@-echo $(CLASSLIB_LD) $(LD_REL_FLAG) $(LD_OBJ_FLAGS) \
	    $(LIBNAME)Init.o `$(TOP)/rules/i_list $(LINKOBJS)` $(LINKOBJS) $(LD_OBJ_LIBS) $(LD_REL_OBJ_LIBS) -o $(LIBNAME)$(OBJNAME)
	@$(CLASSLIB_LD) $(LD_REL_FLAG) $(LD_OBJ_FLAGS) \
	    $(LIBNAME)Init.o `$(TOP)/rules/i_list $(LINKOBJS)` $(LINKOBJS) $(LD_OBJ_LIBS) $(LD_REL_OBJ_LIBS) -o $(LIBNAME)$(OBJNAME)

newobj_link_sepInitCode::
	@-if [ "$(SEPINITCODE)" != "" ]; then   \
	    $(MAKE) newobj_linkSep LINKOBJS="$(LINKOBJS)" LIBNAME=$(LIBNAME);                     \
	else                                    \
	    echo "** oops - sepInit rule but no +sepInit specified (non fatal)"; \
	    $(MAKE) newobj_link LINKOBJS="$(LINKOBJS)" LIBNAME=$(LIBNAME);                        \
	fi

stub_link::
	@-echo "linking stub class object ..."
	@-echo $(CLASSLIB_LD) $(LD_REL_FLAG) $(LD_OBJ_FLAGS) $(STUBLIBNAME)Stub.o $(LINKOBJS) -o $(STUBLIBNAME)$(OBJNAME)
	@$(CLASSLIB_LD) $(LD_REL_FLAG) $(LD_OBJ_FLAGS) $(STUBLIBNAME)Stub.o $(LINKOBJS) -o $(STUBLIBNAME)$(OBJNAME)

iobjs:
	echo "making sepInit objs ..."
	@-if [ "$(OBJS)"x != x ]; then \
	  for i in $(OBJS); do         \
	      $(MAKE) i_$$i ;          \
	  done;                        \
	fi

#
# to force creation of a shared object, even if not defined in config
#
sharedobj: newobj
	@echo "making shared object $(LIBNAME)$(SONAME)"
	$(MAKE) $(LIBNAME)$(SONAME)

#
# objstrip:
#     like make obj, but strip debug syms
#
objstrip::
	@if [ "$(OBJ_SUBDIRS)"x != x ]; then               \
	  for i in $(OBJ_SUBDIRS)" "; do                    \
	    if [ -d $$i ]; then                         \
	      echo "making obj in $$i";                 \
	      (cd $$i && $(MAKE) obj );                  \
	    fi;                                         \
	  done;                                         \
	fi
	@if [ "$(LIBNAME)" != "" ]; then                \
	  $(MAKE) objs &&                               \
	  echo $(CLASSLIB_LD) $(LD_REL_FLAG) $(LD_STRIP_FLAG) $(LD_OBJ_FLAGS) $(LINKOBJS) -o $(LIBNAME)$(OBJNAME) && \
	  rm -f $(LIBNAME)$(OBJNAME) &&                 \
	  $(CLASSLIB_LD) $(LD_REL_FLAG) $(LD_STRIP_FLAG) $(LD_OBJ_FLAGS) $(LINKOBJS) -o $(LIBNAME)$(OBJNAME) && \
	  chmod -x,+w $(LIBNAME)$(OBJNAME);                \
	fi

# cleanjunk:
#    remove all temporary stuff
#
cleanjunk::
	@echo cleaning junk
	@echo no -rm -f .dependencies
	@-rm -f nohup.out out .errors *.bak core .dir.*.old *.old *~ Make.log
	@-rm -f bitmaps/*.bak bitmaps/*~
	@-rm -f resources/*.bak resources/*~ resources/*.old
	@echo no $(MAKE) cleanLIBjunk
	@-if [ "$(ALLSUBDIRS)" != "" ]; then \
	  $(MAKE) cleanjunkALLSUBDIRS; \
	fi
	@-if [ "$(CLEANSUBDIRS)" != "" ]; then \
	  $(MAKE) cleanjunkCLEANSUBDIRS; \
	fi

cleanLIBjunk:
	@-if [ "$(LIBNAME)"x != x ]; then \
	    rm -f $(LIBNAME)Init.[co] $(STUBLIBNAME)Stub.[co]; \
	    if [ -f $(LIBNAME).so ]; then \
		    rm -f $(LIBNAME).o; \
	    fi; \
	fi

cleanjunkALLSUBDIRS::
	@-for i in $(ALLSUBDIRS); do \
	    if [ -d $$i ]; then \
	      if [ -f $$i/Make.proto ]; then \
		if [ -f $$i/$(MAKEFILE) ]; then \
		  echo "cleaning junk in $$i ..."; \
		  (cd $$i && $(MAKE) cleanjunk ); \
		fi \
	      fi \
	    fi; \
	done

cleanjunkCLEANSUBDIRS::
	@-for i in $(CLEANSUBDIRS); do \
	    if [ -d $$i ]; then \
	      if [ -f $$i/Make.proto ]; then \
		if [ -f $$i/$(MAKEFILE) ]; then \
		  echo "cleaning junk in $$i ...";\
		  (cd $$i && $(MAKE) cleanjunk ); \
		fi \
	      fi \
	    fi; \
	done

#
# clean:
#    remove all that is not needed to run/link
#

clean::
	@echo cleaning
	@-rm -f err out *.bak core .dir.*.old *.old *~ *.H ttt* i_[A-Z]*.[cso]
	@-rm -f .dependencies
	@-if [ "$(LIBNAME)"x != x ]; then \
	    rm -f $(LIBNAME)Init.[co] $(STUBLIBNAME)Stub.[co]; \
	    if [ -f $(LIBNAME).so ]; then \
		    rm -f $(LIBNAME).o; \
	    fi; \
	fi
	@-rm -f bitmaps/*.bak bitmaps/*~
	@-rm -f resources/*.bak resources/*~ resources/*.old
	@-if [ "$(ALLSUBDIRS)"x != x ]; then \
	  $(MAKE) cleanALLSUBDIRS; \
	fi
	@-if [ "$(CLEANSUBDIRS)"x != x ]; then \
	  $(MAKE) cleanCLEANSUBDIRS; \
	fi

cleanALLSUBDIRS::
	@-for i in $(ALLSUBDIRS); do \
	    if [ -d $$i ]; then \
	      if [ -f $$i/Make.proto ]; then \
		  echo "cleaning $$i ..."; \
		  (cd $$i && $(MAKE) clean); \
	      fi; \
	    fi; \
	done

cleanCLEANSUBDIRS::
	@-for i in $(CLEANSUBDIRS); do \
	    if [ -d $$i ]; then \
	      if [ -f $$i/Make.proto ]; then \
		  echo "cleaning $$i ..."; \
		  (cd $$i && $(MAKE) clean); \
	      fi; \
	    fi; \
	done

#
# clobber:
#    remove all that can be regenerated
#
CLOBBERED_OBJS=*.o

clobber::
	@-rm -f err out *.bak core .dir.*.old *.old *~ $(CLOBBERED_OBJS) \
	       *.H *.so *.obj obj \
	       liblist.stc \
	       .listOfSTfiles* .dependencies
	@rm -f *.a $(PROGS) $(TESTPROGS)
	@-if [ "$(LIBNAME)"x != x ]; then \
	    rm -f $(LIBNAME)Init.[co] $(STUBLIBNAME)Stub.[co] $(LIBNAME)zip; \
	fi
	@-rm -f bitmaps/*.bak bitmaps/*~
	@-rm -f resources/*.bak resources/*~ resources/*.old
	@-if [ "$(ALLSUBDIRS)"x != x ]; then \
	  $(MAKE) clobberALLSUBDIRS;         \
	fi
	@-if [ "$(CLEANSUBDIRS)"x != x ]; then \
	  $(MAKE) clobberCLEANSUBDIRS;         \
	fi

clobberALLSUBDIRS::
	@-for i in $(ALLSUBDIRS); do      \
	    if [ -d $$i ]; then           \
	      echo "clobbering $$i ...";  \
	      (cd $$i && $(MAKE) clobber); \
	    fi;                           \
	done

clobberCLEANSUBDIRS::
	@-for i in $(CLEANSUBDIRS); do    \
	    if [ -d $$i ]; then           \
	      echo "clobbering $$i ...";  \
	      (cd $$i && $(MAKE) clobber); \
	    fi;                           \
	done

#
# distClean:
#    cleanup for distribution
#
distClean:: clobber
	@-if [ "$(ALLSUBDIRS)"x != x ]; then \
	  $(MAKE) distCleanALLSUBDIRS;       \
	fi
	@-if [ "$(CLEANSUBDIRS)"x != x ]; then \
	  $(MAKE) distCleanCLEANSUBDIRS;       \
	fi

distCleanALLSUBDIRS::
	@-for i in $(ALLSUBDIRS); do        \
	    if [ -d $$i ]; then             \
	      if [ -f $$i/$(MAKEFILE) ]; then  \
		echo "distClean  $$i ...";  \
		(cd $$i && $(MAKE) distClean); \
	      fi;                           \
	    fi;                             \
	done

distCleanCLEANSUBDIRS::
	@-for i in $(CLEANSUBDIRS); do      \
	    if [ -d $$i ]; then             \
	      if [ -f $$i/$(MAKEFILE) ]; then  \
		echo "distClean $$i ...";   \
		(cd $$i && $(MAKE) distClean); \
	      fi;                           \
	    fi;                             \
	done
#
# copy all relevant files to $(DELIVERDIR)/full
#
preDeliverFull::

postDeliverFull::

deliverFull::
	@if [ "$(RELDIR)" = "" ]; then  \
	    echo "no RELDIR defined";   \
	    exit 1;                     \
	fi
	@if [ "$(DELIVERDIR)" = "" ]; then      \
	    echo "no DELIVERDIR defined";       \
	    exit 1;                             \
	fi
	-$(MAKE) preDeliverFull RELDIR=$(RELDIR) DELIVERDIR=$(DELIVERDIR)
	-$(MAKE) deliverFullLocal RELDIR=$(RELDIR) DELIVERDIR=$(DELIVERDIR)
	@-if [ "$(ALLSUBDIRS)"x != x ]; then            \
	  $(MAKE) deliverFullALLSUBDIRS RELDIR=$(RELDIR) DELIVERDIR=$(DELIVERDIR);              \
	fi
	@-if [ "$(DELIVERSUBDIRS)"x != x ]; then        \
	  $(MAKE) deliverFullDELIVERSUBDIRS RELDIR=$(RELDIR) DELIVERDIR=$(DELIVERDIR);          \
	fi
	$(MAKE) postDeliverFull RELDIR=$(RELDIR) DELIVERDIR=$(DELIVERDIR)

deliverFullLocal::
	@if [ "$(RELDIR)" = "" ]; then  \
	    echo "no RELDIR defined";   \
	    exit 1;                     \
	fi
	@if [ "$(DELIVERDIR)" = "" ]; then \
	    echo "no DELIVERDIR defined";  \
	    exit 1;                        \
	fi
	@test -d $(DELIVERDIR) || mkdir $(DELIVERDIR)
	@test -d $(DELIVERDIR)/$(RELDIR) || mkdir $(DELIVERDIR)/$(RELDIR)
	@-if [ "$(DELIVERSOURCES)" != "" ]; then \
	    (tar cf - $(DELIVERSOURCES) | (cd $(DELIVERDIR)/$(RELDIR) && tar xvf -)); \
	fi
	@-if [ "$(DELIVERMISC)" != "" ]; then \
	    (tar cf - $(DELIVERMISC) | (cd $(DELIVERDIR)/$(RELDIR) && tar xvf -)); \
	fi
	@-if [ "$(DELIVERBINARIES)" != "" ]; then \
	    (tar cf - $(DELIVERBINARIES) | (cd $(DELIVERDIR)/$(RELDIR) && tar xvf -)); \
	fi

deliverFullALLSUBDIRS::
	@-for i in $(ALLSUBDIRS); do                    \
	    if [ -d $$i ]; then                         \
		echo "deliver files in $$i ...";        \
		(cd $$i && $(MAKE) deliverFull RELDIR=$(RELDIR)/$$i DELIVERDIR=$(DELIVERDIR));           \
	    fi;                                         \
	done

deliverFullDELIVERSUBDIRS::
	@-for i in $(DELIVERSUBDIRS); do                \
	    if [ -d $$i ]; then                         \
		echo "deliver files in $$i ...";        \
		(cd $$i && $(MAKE) deliverFull RELDIR=$(RELDIR)/$$i DELIVERDIR=$(DELIVERDIR));           \
	    fi;                                         \
	done

#
# remake:
#    a clean followed my make
#
remake:
	$(MAKE) clean
	$(MAKE)

#
# update: first get any changed versions from cvs,
# then make all here.
#
update:
	@-if [ -d CVS ]; then \
	    cvs update; \
	    $(MAKE) mf; \
	    $(MAKE) Makefiles; \
	    $(MAKE) $(UPDATETARGET); \
	else \
	    echo "no CVS directory"; \
	fi

pre_all::

#
# all:
#    make what is appropriate here (library or application)
#
all::   pre_all
	@-if [ "$(SUBDIRS)"x != ""x ]; then \
	  $(MAKE) allSubDirs;               \
	fi

# full:
#    in addition to all, this also builds support stuff needed
#    by some subsystems using ant and possibly other tools.
#    for now, this is libjava only
full::   all

allSubDirs:
	@-for i in $(SUBDIRS); do     \
	  if [ -d $$i ]; then         \
	    $(MAKE) subDirMake SUBDIR=$$i; \
	  else                        \
	    echo "*** oops where is directory $$i ?? in "`pwd`" (non fatal)"; \
	  fi;                         \
	done

subDirMake:
	@-if [ -f $(SUBDIR)/$(MAKEFILE) ] ; then \
	    true; \
	else \
	    $(MAKE) subMakefile SUBDIR=$(SUBDIR); \
	fi
	@-echo "********************************"
	@-echo "making all in $(SUBDIR)"
	@-echo "********************************"
	@-cd $(SUBDIR) && $(MAKE) all

allLibs::
	@-if [ "$(LIBNAME)"x != ""x ]; then \
	  $(MAKE) lib;               \
	fi
	@-if [ "$(SUBDIRS)"x != ""x ]; then \
	  $(MAKE) allSubDirLibs;               \
	fi

allSubDirLibs:
	@-for i in $(SUBDIRS); do     \
	  if [ -d $$i ]; then         \
	    $(MAKE) subDirLibsMake SUBDIR=$$i; \
	  else                        \
	    echo "*** oops where is directory $$i ?? in "`pwd`" (non fatal)"; \
	  fi;                         \
	done

subDirLibsMake:
	@-if [ -f $(SUBDIR)/$(MAKEFILE) ] ; then \
	    true; \
	else \
	    $(MAKE) subMakefile SUBDIR=$(SUBDIR); \
	fi
	@-echo "********************************"
	@-echo "making libs in $(SUBDIR)"
	@-echo "********************************"
	@-cd $(SUBDIR) && $(MAKE) allLibs

APPLICATION:
	    @-rm -f main.o modulList.stc modulList.c modulList.o
	    $(MAKE) main.o \
		STARTUP_CLASS="$(STARTUP_CLASS)" \
		STARTUP_SELECTOR="$(STARTUP_SELECTOR)" \
		MAIN_DEFINES="$(MAIN_DEFINES)"
	    @-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	    $(MAKE) linkTarget \
		LIBLIST="$(LIBLIST)" \
		LIBOBJS="$(LIBOBJS)" \
		LINK_LIBOBJS="$(LINK_LIBOBJS)" \
		TARGET=$(TARGET) \
		ADDITIONAL_CLASSES="$(APPLICATION_CLASSES)" \
		ADDITIONAL_OBJS="$(APPLICATION_OBJS)" \
		ADDITIONAL_LINK_OBJS="$(APPLICATION_LINK_OBJS)"
	    @-rm -f main.o modulList.stc modulList.c modulList.o

#
# a standAlone target without graphical user interface
#
NON_GUI_APPLICATION:
	    @-rm -f main.o modulList.stc modulList.c modulList.o
	    $(MAKE) main.o \
		STARTUP_CLASS="$(STARTUP_CLASS)" \
		STARTUP_SELECTOR="$(STARTUP_SELECTOR)" \
		MAIN_DEFINES="$(MAIN_DEFINES)"
	    @-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	    $(MAKE) linkTarget \
		LIBLIST="$(APPLICATION_LIBLIST)" \
		LIBOBJS="$(APPLICATION_LIBOBJS)" \
		LINK_LIBOBJS="$(APPLICATION_LINK_LIBOBJS)" \
		TARGET=$(TARGET) \
		ADDITIONAL_CLASSES="$(APPLICATION_CLASSES)" \
		ADDITIONAL_OBJS="$(APPLICATION_OBJS)" \
		ADDITIONAL_LINK_OBJS="$(APPLICATION_LINK_OBJS)"
	    @-rm -f main.o modulList.stc modulList.c modulList.o

xNON_GUI_APPLICATION:
	    @-rm -f main.o modulList.stc modulList.c modulList.o
	    $(MAKE) main.o \
		STARTUP_CLASS="$(STARTUP_CLASS)" \
		STARTUP_SELECTOR="$(STARTUP_SELECTOR)" \
		MAIN_DEFINES="$(MAIN_DEFINES)"
	    @-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	    $(MAKE) linkTarget \
		LIBLIST="$(MINI_LIST) libstx_libbasic2 libstx_libboss $(APPLICATION_LIBLIST)" \
		LIBOBJS="$(MINI_LIB) $(LIBBASIC2) $(LIBBOSS) $(APPLICATION_LIBOBJS)" \
		LINK_LIBOBJS="$(LINK_MINI_LIB) $(LINK_LIBBASIC2) $(LINK_LIBBOSS) $(APPLICATION_LINK_LIBOBJS)" \
		TARGET=$(TARGET) \
		ADDITIONAL_CLASSES="$(APPLICATION_CLASSES)" \
		ADDITIONAL_OBJS="$(APPLICATION_OBJS)" \
		ADDITIONAL_LINK_OBJS="$(APPLICATION_LINK_OBJS)"
	    @-rm -f main.o modulList.stc modulList.c modulList.o

#
# a minimum standAlone target without graphical user interface
# (only links libbasic - no compiler etc.)
#
BARE_NON_GUI_APPLICATION:
	    @-rm -f main.o modulList.stc modulList.c modulList.o
	    $(MAKE) main.o \
		STARTUP_CLASS="$(STARTUP_CLASS)" \
		STARTUP_SELECTOR="$(STARTUP_SELECTOR)" \
		MAIN_DEFINES="$(MAIN_DEFINES)"
	    @-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	    $(MAKE) linkTarget \
		LIBLIST="$(BARE_LIST) $(APPLICATION_LIBLIST)" \
		LIBOBJS="$(BARE_LIB) $(APPLICATION_LIBOBJS)" \
		LINK_LIBOBJS="$(LINK_BARE_LIB) $(APPLICATION_LINK_LIBOBJS)" \
		TARGET=$(TARGET) \
		ADDITIONAL_CLASSES="$(APPLICATION_CLASSES)" \
		ADDITIONAL_OBJS="$(APPLICATION_OBJS)" \
		ADDITIONAL_LINK_OBJS="$(APPLICATION_LINK_OBJS)"
	    @-rm -f main.o modulList.stc modulList.c modulList.o

#
# with graphical user interface
#
BARE_GUI_APPLICATION:
	@-rm -f main.o modulList.stc modulList.c modulList.o
	$(MAKE) main.o \
	    STARTUP_CLASS="$(STARTUP_CLASS)" \
	    STARTUP_SELECTOR="$(STARTUP_SELECTOR)" \
	    MAIN_DEFINES="$(MAIN_DEFINES)"
	@-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	$(MAKE) linkTarget \
	    LIBLIST="$(EXTRA_UI_CLASSES) $(APPLICATION_LIBLIST)" \
	    LIBOBJS="$(EXTRA_UI_OBJ) $(APPLICATION_LIBOBJS)" \
	    LINK_LIBOBJS="$(EXTRA_LINK_UI_OBJ) $(APPLICATION_LINK_LIBOBJS)" \
	    TARGET=$(TARGET) \
	    ADDITIONAL_CLASSES="$(APPLICATION_CLASSES)" \
	    ADDITIONAL_OBJS="$(APPLICATION_OBJS)" \
	    ADDITIONAL_LINK_OBJS="$(APPLICATION_LINK_OBJS)"
	@-rm -f main.o modulList.stc modulList.c modulList.o

#
# with tool libraries
#
GUI_APPLICATION:
	@echo making GUI_APPLICATION...
	@echo EXTRA_UI_CLASSES=$(EXTRA_UI_CLASSES)
	@echo EXTRA_UI_OBJ=$(EXTRA_UI_OBJ)
	@echo EXTRA_LINK_UI_OBJ=$(EXTRA_LINK_UI_OBJ)
	@-rm -f main.o modulList.stc modulList.c modulList.o
	$(MAKE) main.o \
	    STARTUP_CLASS="$(STARTUP_CLASS)" \
	    STARTUP_SELECTOR="$(STARTUP_SELECTOR)" \
	    MAIN_DEFINES="$(MAIN_DEFINES)"
	@-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	$(MAKE) linkTarget \
	    LIBLIST="$(EXTRA_UI_CLASSES) $(APPLICATION_LIBLIST)" \
	    LIBOBJS="$(EXTRA_UI_OBJ) $(APPLICATION_LIBOBJS)" \
	    LINK_LIBOBJS="$(EXTRA_LINK_UI_OBJ) $(APPLICATION_LINK_LIBOBJS)" \
	    TARGET=$(TARGET) \
	    ADDITIONAL_CLASSES="$(APPLICATION_CLASSES)" \
	    ADDITIONAL_OBJS="$(APPLICATION_OBJS)" \
	    ADDITIONAL_LINK_OBJS="$(APPLICATION_LINK_OBJS)"
	@-rm -f main.o modulList.stc modulList.c modulList.o
	@$(MAKE) registerClassLib

#
# a program target
# needs: CLASSLIBRARIES,
#        STARTUP_SELECTOR, STARTUP_CLASS
#        LIBOBJS
#
PROGTARGET_shared::
	    @-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	    @-echo "Making PROGTARGET_shared ..."
	    $(MAKE) linkTarget                      \
		    LIBOBJS="$(LIBOBJS_SHARED)" \
		    ADDITIONAL_OBJS="$(ADDITIONAL_OBJS)"    \
		    ADDITIONAL_CLASSES="$(ADDITIONAL_CLASSES)"    \
		    ADDITIONAL_LIBS="$(ADDITIONAL_LIBS)"    \
		    EXTRA_LIBS="$(EXTRA_LIBS)" \
		    LINK_LIBRUN="$(LINK_LIBRUN)" \
		    LIBRUN=$(LIBRUN)

PROGTARGET_static:
	    @-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	    @-echo "Making PROGTARGET_static ..."
	    $(MAKE) linkTarget                      \
		    LIBOBJS="$(STATIC_LIBOBJS)" \
		    LINK_LIBOBJS="$(STATIC_LIBOBJS)" \
		    ADDITIONAL_OBJS="$(STATIC_ADDITIONAL_OBJS)"    \
		    ADDITIONAL_CLASSES="$(ADDITIONAL_CLASSES)"    \
		    ADDITIONAL_LIBS="$(ADDITIONAL_LIBS)"    \
		    EXTRA_LIBS="$(STATIC_EXTRA_LIBS)" \
		    EXTRA_UI_OBJ="$(STATIC_EXTRA_UI_OBJ)" \
		    LINK_LIBRUN="$(LIBRUN)" \
		    LIBRUN="$(LIBRUN)"

PROGTARGET_fullstatic:
	    @-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	    @-echo "Making PROGTARGET_fullstatic ..."
	    $(MAKE) linkTarget                      \
		    LIBOBJS="$(STATIC_LIBOBJS)" \
		    LINK_LIBOBJS="$(STATIC_LIBOBJS)" \
		    ADDITIONAL_OBJS="$(STATIC_ADDITIONAL_OBJS)"    \
		    ADDITIONAL_CLASSES="$(ADDITIONAL_CLASSES)"    \
		    ADDITIONAL_LIBS="$(ADDITIONAL_LIBS)"    \
		    LINK_LIBRUN="$(LIBRUN)" \
		    LIBRUN="$(LIBRUN)" \
		    MATHLIB="$(STATIC_MATHLIB)" \
		    EXTRA_LIBS="$(STATIC_EXTRA_LIBS)" \
		    EXTRA_UI_OBJ="$(STATIC_EXTRA_UI_OBJ)" \
		    SYSLIBS="$(STATIC_SYSLIBS)"

PROGTARGET::
	    @-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	    @-echo "Making PROGTARGET_shared ..."
	    $(MAKE) linkTarget                      \
		    LIBOBJS="$(LIBOBJS_SHARED)" \
		    ADDITIONAL_OBJS="$(ADDITIONAL_OBJS)"    \
		    ADDITIONAL_CLASSES="$(ADDITIONAL_CLASSES)"    \
		    ADDITIONAL_LIBS="$(ADDITIONAL_LIBS)"    \
		    EXTRA_LIBS="$(EXTRA_LIBS)" \
		    LINK_LIBRUN="$(LINK_LIBRUN)" \
		    LIBRUN=$(LIBRUN)

nullRebaseRule:
	    @-echo "No rebase done for this architecture/configuration"

linkTarget: main.$(O) $(LIBOBJS) checkSymbolsInLibrunAreUpToDate $(LIBRUN) $(EXTRA_OBJ)
	    @-echo "Making modulList (PACK = " $(CONF_PACKS) ") ..."
	    @-echo "LIBLIST=" $(LIBLIST)
	    @-echo "ADDITIONAL_CLASSES=" $(ADDITIONAL_CLASSES)
	    $(MAKE) modulList.$(O) \
		    LIBS="$(LIBOBJS)" \
		    LIBLIST="$(LIBLIST)" \
		    ADDITIONAL_CLASSES="$(ADDITIONAL_CLASSES)"
	    @-echo "OPTIONAL_SHARED_LIBS=" $(OPTIONAL_SHARED_LIBS)
	    @-echo "linking ..."
	    $(MAKE) linkLibs LINK_LIBDIR="$(LINK_LIBDIR)" LINK_LIBOBJS="$(LINK_LIBOBJS)" LIBOBJS="$(LIBOBJS)"
	    $(MAKE) $(rebaseLibsRule) LINK_LIBRUN="$(LINK_LIBRUN)" LINK_LIBOBJS="$(LINK_LIBOBJS)" LINK_ADDITIONAL_OBJS="$(LINK_ADDITIONAL_OBJS)"
	    $(LD) $(ST_LDFLAG) $(LDFLAGS) -o $(TARGET)$(EXE) \
		  $(CRT0) modulList.$(O) main.$(O) \
		  $(OPTIONAL_SHARED_LIBS) \
		  $(LINK_LIBOBJS) $(LINK_ADDITIONAL_OBJS) \
		  $(LINK_LIBRUN) \
		  $(ADDITIONAL_LIBS) $(MATHLIB) $(EXTRA_LIBS) $(SYSLIBS) $(CRTN)
	    @if [ "$(POST_LD)" != "" ]; then \
		echo $(POST_LD) $(TARGET)$(EXE); \
		$(POST_LD) $(TARGET)$(EXE); \
	    fi
	    @if [ "$(POST_LD2)" != "" ]; then \
		echo $(POST_LD2) $(TARGET)$(EXE); \
		$(POST_LD2) $(TARGET)$(EXE); \
	    fi

# a pure C library
cLibRule:
	@-echo "linking ..."
	$(LD) $(ST_LDFLAG) $(LDFLAGS) -shared -o $(CLIB)$(SONAME) \
	      $(CRT0) \
	      $(OPTIONAL_SHARED_LIB_PATH) \
	      $(COBJS) $(LINK_ADDITIONAL_OBJS) \
	      $(ADDITIONAL_LIBS) $(MATHLIB) $(EXTRA_LIBS) $(SYSLIBS) $(CRTN)

checkSymbolsInLibrunAreUpToDate:
	if [ -f $(LIBRUNDIR)/symbolAddress.h.timestamp ]; then \
	    $(MAKE) reallyCheckSymbolsInLibrunAreUpToDate; \
	fi

reallyCheckSymbolsInLibrunAreUpToDate: $(LIBRUNDIR)/symbolAddress.h.timestamp

$(LIBRUNDIR)/symbolAddress.h.timestamp: $(INCLUDE)/symbols.stc $(LIBRUNDIR)/symbols.h
	@-echo "Making librun for changed symbolList..."
	cd $(LIBRUNDIR); $(MAKE)

#
# install:
#     make all then install
#

install:: checkTargetPresent
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "making install in `pwd` ..."; \
	fi
	@$(MAKE) qinstall installSubdirsIf RELEASE=$(RELEASE)

verboseInstall::
	@$(MAKE) install VERBOSE=yes

installHere:: checkTargetPresent
	@$(MAKE) qinstall RELEASE=$(RELEASE)

installLocal:: checkTargetPresent
	@if [ "$(SILENT)"x = "x" ]; then \
	    echo "making installLocal in `pwd` ..."; \
	fi
	@$(MAKE) qinstall installSubdirsIf INSTALLBASE=$(TOP)/build

installHereLocal:: checkTargetPresent
	@$(MAKE) qinstall INSTALLBASE=$(TOP)/build

installBinOnly::
	@$(MAKE) qinstall installSubdirsIf RELEASE=$(RELEASE) SUPPRESS_INSTALL_SRC="yes"

#
# generate a self-extracting archive
#
installerFile::
	@if [ "$(INSTALLED_DIR)"x != ""x ]; then \
	     $(MAKE) createInstallerFile \
		    INSTALLED_DIR=$(INSTALLED_DIR) \
		    INSTALL_FILE=inst_$(MODULE)-`$(TOP)/support/check/config.guess`.sh; \
	else \
	  if [ "$(MODULE)"x = ""x ]; then \
	     $(MAKE) createInstallerFile \
		    INSTALLED_DIR=$(INSTALLBASE)/$(RELEASE) \
		    INSTALL_FILE=inst_STX$(RELEASE)-`$(TOP)/support/check/config.guess`.sh; \
	  else \
	     $(MAKE) createInstallerFile \
		    INSTALLED_DIR=$(INSTALLBASE)/$(RELEASE)/packages/$(MODULE) \
		    INSTALL_FILE=inst_$(MODULE)-`$(TOP)/support/check/config.guess`.sh; \
	  fi \
	fi

createInstallerFile::
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "Generating tar-file for "$(INSTALLED_DIR)"..."; \
	fi
	@( \
	  here=`pwd` ; \
	  cd / ; \
	  tar cf $$here/installFile.tar $(INSTALLED_DIR) \
	 )
	@if [ "$(COMPRESSOR)"x != "x" ]; then \
	    if [ "$(VERBOSE)"x != "x" ]; then \
		echo $(COMPRESSOR)"-ing tar-file..."; \
	    fi; \
	    $(COMPRESSOR) installFile.tar; \
	fi
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "Generating self extracting shell-command-file ..."; \
	fi
	@$(TOP)/support/mk-selfinstall \
	    --outfile=$(INSTALL_FILE) \
	    --type=$(COMPRESSED_FILETYPE) \
	    --installDirMsg="$(INSTALLED_DIR)"\
	    installFile.tar.*
	@rm installFile.tar.*

checkTargetPresent::

#$(INSTALLTOP_DIR)/bin:: $(INSTALLTOP_DIR)
#        @test -d $@ || mkdir $@
#
#$(INSTALLTOP_DIR)/lib:: $(INSTALLTOP_DIR)
#        @test -d $@ || mkdir $@
#
#$(INSTALLLIB_DIR)/lib:: $(INSTALLLIB_DIR)
#        @test -d $@ || mkdir $@
#
$(INSTALLLIB_DIR)/bitmaps:: $(INSTALLLIB_DIR)
	@test -d $@ || mkdir $@

$(INSTALLLIB_DIR)/fonts:: $(INSTALLLIB_DIR)
	test -d $(INSTALLLIB_DIR)/fonts || mkdir $(INSTALLLIB_DIR)/fonts

$(INSTALLLIB_DIR)/resources:: $(INSTALLLIB_DIR)
	@test -d $@ || mkdir $@

$(INSTALLLIB_DIR)/source:: $(INSTALLLIB_DIR)
	@test -d $@ || mkdir $@

$(INSTALLBASE)::
	@test -d $@ || mkdir $@

$(INSTALLBASE)/bin:: $(INSTALLBASE)
	@test -d $@ || mkdir $@

$(INSTALLBASE)/lib:: $(INSTALLBASE)
	@test -d $@ || mkdir $@

$(INSTALLBASE)/lib/lib:: $(INSTALLBASE)/lib
	@test -d $@ || mkdir $@

$(INSTALLBASE)/lib/bitmaps:: $(INSTALLBASE)/lib
	@test -d $@ || mkdir $@

$(INSTALLBASE)/packages:: $(INSTALLBASE)
	@test -d $@ || mkdir $@

$(INSTALLBASE)/packages/$(MODULE):: $(INSTALLBASE)/packages
	@test -d $@ || mkdir $@

$(INSTALLBASE)/packages/$(MODULE)/$(MODULE_DIR):: $(INSTALLBASE)/packages/$(MODULE)
	@case "$(MODULE_DIR)" in           \
	    "")                            \
		;;                         \
	    */*)                           \
		( md=`dirname $(MODULE_DIR)`; $(MAKE) installDir MODULE_DIR=$$md ); \
		;;                        \
	esac
	@test -d $@ || mkdir $@

installDir:     $(INSTALLBASE)/packages/$(MODULE)/$(MODULE_DIR)

#
# qinstall: (quick install)
#     install only - assumes make all was done previously
#
qinstall:: installAux installProgsIf installLibsIf installSources

installProgsIf::
	@-if [ "$(INSTALLPROGS)"x != x ]; then          \
	  $(MAKE) installProgs; \
	fi

installProgs:: $(INSTALLBIN_DIR)
	@-for i in $(INSTALLPROGS); do \
	  if [ "$(VERBOSE)"x != "x" ]; then \
	      echo "installing program: "$$i"..."; \
	  fi; \
	  $(INSTALL_BIN_CMD) $$i $(INSTALLBIN_DIR); \
	done

installLibsIf::
	@-if [ "$(LIBNAME)" != "" ]; then \
	  $(MAKE) installLibs; \
	fi
	@-if [ "$(INSTALLED_LOAD_SCRIPTS)"x != ""x ]; then \
	  $(MAKE) installLoadScripts; \
	fi
	@-if [ -f $(LIBNAME).prj ]; then \
	  $(MAKE) installPrjFile; \
	fi

installLibs::
	@-if [ -f $(LIBNAME)$(SONAME) ]; then \
	  $(MAKE) installSharedLib; \
	else \
	  if [ -f $(LIBNAME)$(OBJNAME) ]; then \
	    $(MAKE) installStaticLib; \
	  fi \
	fi
	@-if [ -f $(LIBNAME).zip ]; then \
	  $(MAKE) installZippedClassFile; \
	fi

installSharedLib:: $(INSTALLLIB_DIR)
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing dynamic library: "$(LIBNAME)$(SONAME)" in "$(INSTALLLIB_DIR)" ..."; \
	fi
	$(INSTALL_LIB_CMD) $(LIBNAME)$(SONAME) $(INSTALLLIB_DIR)
	@-if [ "$(THIS_IS_A_BASE_LIBRARY)"x != ""x ]; then  \
	  if [ "$(MODULE)"x != ""x ]; then  \
	    if [ "$(MODULE_DIR)"x != ""x ]; then  \
	      if [ "$(INSTALLLIB_DIR)" = "$(INSTALLBASE)/packages/$(MODULE)/$(MODULE_DIR)" ]; then \
		if [ "$(INSTALLBASE)/lib" != "$(INSTALLLIB_DIR)" ]; then \
		  $(MAKE) installSharedLibSymbolicLink;\
		fi \
	      fi \
	    fi \
	  fi \
	fi

installSharedLibSymbolicLink:: $(INSTALLBASE)/lib/lib
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "generating symbolic link to shared object in $(INSTALLBASE)/lib/lib ..."; \
	fi
	@cd $(INSTALLBASE)/lib/lib && $(LNS) -f ../../packages/$(MODULE)/$(MODULE_DIR)/$(LIBNAME)$(SONAME) .

installStaticLib:: $(INSTALLLIB_DIR)
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing static library: "$(LIBNAME)$(OBJNAME)" in "$(INSTALLLIB_DIR)" ..."; \
	fi
	$(INSTALL_LIB_CMD) $(LIBNAME)$(OBJNAME) $(INSTALLLIB_DIR)

installZippedClassFile:: $(INSTALLLIB_DIR)
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing zip package: "$(LIBNAME).zip" in "$(INSTALLLIB_DIR)" ..."; \
	fi
	$(INSTALL_AUX_CMD) $(LIBNAME).zip $(INSTALLLIB_DIR)

installPrjFile:: $(INSTALLLIB_DIR)
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing prj file: "$(LIBNAME).prj" in "$(INSTALLLIB_DIR)" ..."; \
	fi
	$(INSTALL_AUX_CMD) $(LIBNAME).prj $(INSTALLLIB_DIR)

installLoadScript:: $(INSTALLLIB_DIR)
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing "$(LOAD_SCRIPT)" in "$(INSTALLLIB_DIR)" ..."; \
	fi
	$(INSTALL_AUX_CMD) $(LOAD_SCRIPT) $(INSTALLLIB_DIR)

installLoadScripts::
	@-for i in $(INSTALLED_LOAD_SCRIPTS); do \
	  if [ -f $$i ]; then \
	     $(MAKE) installLoadScript LOAD_SCRIPT=$$i; \
	  fi \
	done

installSources:: installSTSourceIf

installSTSourceIf::
	@-if [ "$(MODULE)"x != ""x ]; then  \
	  if [ "$(MODULE_DIR)"x != ""x ]; then  \
	    if [ "$(SUPPRESS_INSTALL_SRC)"x = ""x ]; then  \
	      if [ "*.st" != '\*.st' ]; then  \
		if ( zip -h >/dev/null ) ; then \
		  $(MAKE) installSTZipSource;        \
		else \
		  $(MAKE) installSTSource;        \
		fi \
	      fi \
	    fi \
	  fi \
	fi

installSTSource:: $(INSTALLLIB_DIR)/source
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing sources in $(INSTALLLIB_DIR)/source..."; \
	fi
	@-for i in *.st; do \
	  $(INSTALL_AUX_CMD) $$i $(INSTALLLIB_DIR)/source;\
	done

#
# only store (i.e. do not compress);
# ZipArchive cannot deflate/uncompress right now.
#
installSTZipSource:: $(INSTALLLIB_DIR)
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing zipped sources in $(INSTALLLIB_DIR)/source.zip..."; \
	fi
	@zip -0 /tmp/source.zip *.st > /dev/null
	@-rm -f $(INSTALLLIB_DIR)/source.zip
	@mv /tmp/source.zip $(INSTALLLIB_DIR)/source.zip
	@chmod 0644 $(INSTALLLIB_DIR)/source.zip

installSubdirsIf::
	@-if [ "$(INSTALL_SUBDIRS)" != "" ]; then          \
	  $(MAKE) installSubDirs; \
	fi

installSubDirs::
	@-for i in $(INSTALL_SUBDIRS); do          \
	  if [ -d $$i ]; then              \
	    if [ -f $$i/$(MAKEFILE) ]; then \
	      (cd $$i && $(MAKE) install  INSTALLBASE=$(INSTALLBASE)); \
	    fi;                            \
	  fi;                              \
	done

installLocalSubdirsIf::
	@-if [ "$(INSTALL_SUBDIRS)" != "" ]; then          \
	  $(MAKE) installLocalSubDirs;                 \
	fi

installLocalSubDirs::
	@-for i in $(INSTALL_SUBDIRS); do          \
	  if [ -d $$i ]; then              \
	    if [ -f $$i/$(MAKEFILE) ]; then \
	      (cd $$i && $(MAKE) installLocal); \
	    fi;                            \
	  fi;                              \
	done

installAux:: installAbbrevIf installBitmapsIf installResourcesIf

installAbbrevIf::
	@-if [ -f abbrev.stc ]; then \
	  if [ "$(MODULE)"x != ""x ]; then  \
	    if [ "$(MODULE_DIR)"x != ""x ]; then  \
	      $(MAKE) installAbbrev; \
	    fi \
	  fi \
	fi

installAbbrev:: $(INSTALLTOP_DIR)
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing abbrev.stc..."; \
	fi
	@$(MAKE) abbrev.stc
	cp abbrev.stc $(INSTALLTOP_DIR)

installBitmapsIf::
	@-if [ -d bitmaps ]; then \
	  if [ "$(SUPPRESS_INSTALL_BITMAPS)"x = "x" ]; then \
	    $(MAKE) installBitmaps; \
	  fi \
	fi

installBitmaps:: $(INSTALLBITMAPSLIB_DIR)
	@-if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing bitmaps..."; \
	fi
	-tar cf - bitmaps | (cd $(INSTALLBITMAPSLIB_DIR) && tar xf -)
	@-find $(INSTALLBITMAPSLIB_DIR)/bitmaps -name 'CVS' -exec rm -rf {} \;            2>/dev/null
	@-find $(INSTALLBITMAPSLIB_DIR)/bitmaps -name 'not_delivered' -exec rm -rf {} \;  2>/dev/null

installFonts:: $(INSTALLLIB_DIR)/fonts
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing fonts..."; \
	fi
	-(tar cf - fonts | (cd $(INSTALLLIB_DIR) ; tar xf -))
	@-find $(INSTALLLIB_DIR)/fonts -name 'CVS' -exec rm -rf {} \;              2>/dev/null
	@-find $(INSTALLLIB_DIR)/fonts -name 'not_delivered' -exec rm -rf {} \;    2>/dev/null

installResourcesIf::
	@-if [ -d resources ]; then \
	  if [ "$(SUPPRESS_INSTALL_RESOURCES)"x = "x" ]; then \
	    $(MAKE) installResources; \
	  fi \
	fi

installResources:: $(INSTALLLIB_DIR)/resources
	@if [ "$(VERBOSE)"x != "x" ]; then \
	    echo "installing resources..."; \
	fi
	-tar cf - resources | (cd $(INSTALLLIB_DIR) && tar xf -)
	@-find $(INSTALLLIB_DIR)/resources -name 'CVS' -exec rm -rf {} \;            2>/dev/null
	@-find $(INSTALLLIB_DIR)/resources -name 'not_delivered' -exec rm -rf {} \;  2>/dev/null

#
# rule to make an archive
#
$(LIB):     pre_lib $(DEPOBJS) $(DEPAUXOBJS) $(LIB_HELPER)
	-cp $(LIB) $(LIB).sav
	rm -f $(LIB)
	$(AR) $(AR_LIB_FLAG) $(LIB) $(AR_OBJS)
	-$(RANLIB) $(LIB)

pre_lib::

CONF_STRING="$(CONF):$(CONF_PACKS)"

#
# rule to make a main (either in smalltalk or application)
# main.o depends on Makefile, to be recompiled when the configuration
# changes (used to be in libbasic/Smalltalk.st)
#
# Now always rebuild main.o, to get the newest build number/date

#main.o::  $(MAIN) $(INCLUDE)/stc.h $(MAKEFILE)
main.o::
	  $(MAIN_CC) -o main.o -c $(MAIN_CFLAGS) $(MAIN_DEFINES) \
		-DSTARTUP_CLASS="\"$(STARTUP_CLASS)\"" \
		-DSTARTUP_SELECTOR="\"$(STARTUP_SELECTOR)\"" \
		-DCONFIGURATION_STRING="\"$(CONF_STRING)\"" \
		-DBUILD_DATE="\"`date '+%Y-%m-%d %R %Z'`\"" \
		-DBUILD_NUMBER="\"${BUILD_NUMBER}\"" \
		-I$(INCLUDE) -I. $(MAIN)

#
# liblist.stc:
#    automatic generate a liblist.stc - libinfo file from all OBJ files
#
liblist.stc:: Make.proto Make.spec
	@-if [ "*.st" != '\*.st' ]; then                \
	  if [ "$(LIBNAME)" != "" ]; then               \
	    echo "";                                    \
	    echo "generating libinfo liblist.stc ...";  \
	    echo "";                                    \
	    if [ -f liblist.stc ]; then                 \
		rm -f liblist.stc;                      \
	    fi;                                         \
	    for i in ""*.st"" ; do                      \
	      NAME=`basename $$i .st`;                  \
	      if [ -f "$$NAME".o ]; then                \
	       CLASS=`$(STC) -extractClass $$i`;        \
	       if [ "$$CLASS" != "" ]; then             \
		 echo "  adding "$$i;                   \
		 echo $$CLASS" "$(LIBNAME) >> liblist.stc;       \
	       fi;                                      \
	      fi;                                       \
	    done;                                       \
	    $(MAKE) patchLiblist;                       \
	  fi;                                           \
	fi


forceAbbrev::
	@-$(MAKE) saveAbbrev
	@-$(MAKE) abbrev.stc

saveAbbrev:
	@-if [ -f abbrev.stc ]; then \
	  rm -f abbrev.stc.bak ;     \
	  mv abbrev.stc abbrev.stc.bak ; \
	fi

#
# abbrev.stc:
#    generate an abbrev.stc - abbreviation file
#    from all .st files found here; leave as is, if no change
#
abbrev.stc:: Make.proto Make.spec $(TOP)/rules/rightstr .listOfSTfiles
	@-if [ "`echo *.st`" != "*.st" ]; then \
	  echo "generating abbrev.stc in "$(MODULE_DIR)"..."; \
	  LC_COLLATE=POSIX; export LC_COLLATE; \
	  $(MAKE) genAbbrev; \
	  if [ "$(TOUCH)" != "echo" ]; then   \
	    $(TOUCH) abbrev.stc; \
	  fi; \
	  if [ -f abbrev.stc.bak ]; then \
	    if (cmp abbrev.stc.bak abbrev.stc >/dev/null); then  \
	      echo "  abbrev.stc unchanged";  \
	      mv abbrev.stc.bak abbrev.stc;   \
	    else \
	      echo "  abbrev has changed";    \
	    fi \
	  fi \
	else \
	  echo "  no st-files -> no abbrevs"; \
	fi

#
# unconditionally generate a local abbrev.stc file
#
genAbbrev::
	@rm -f abbrev.stc
	echo RELNAME=`$(RULEDIR)/relname $(TOP) $(DIRNAME) $(RIGHTSTR)`
	@RELNAME=`$(RULEDIR)/relname $(TOP) $(DIRNAME) $(RIGHTSTR)`
	@for i in *.st ; do              \
	  case $$i in                   \
	    m_*)                        \
	      echo "  ** skipping "$$i; \
	      ;;                        \
	    *_win32.st)                 \
	      echo "  ** skipping win32 specific file in abbrev: "$$i;\
	      ;;                        \
	    *_vms.st)                   \
	      echo "  ** skipping vms specific file in abbrev: "$$i; \
	      ;;                        \
	    *_macos.st)                 \
	      echo "  ** skipping mac specific file in abbrev: "$$i; \
	      ;;                        \
	    *_beos.st)                 \
	      echo "  ** skipping be specific file in abbrev: "$$i; \
	      ;;                        \
	    *_os2.st)                 \
	      echo "  ** skipping os2 specific file in abbrev: "$$i; \
	      ;;                        \
	    *_unix.st)                 \
	      echo "  ** skipping unix specific file in abbrev: "$$i; \
	      ;;                        \
	    *)                          \
	      if [ "$(VERBOSE)" != "" ]; then \
		echo "  processing "$$i;\
	      fi;                       \
	      CLASS=`$(STC) -extractClass $$i 2>/dev/null`; \
	      if [ "$(PACKAGE)" != "" ]; then \
		PACKAGE=$(PACKAGE);     \
	      else                      \
		echo "Cannot figure out the package of $$i when generating abbrev.stc in "`pwd`; \
		exit 1;                 \
		PACKAGE=unknown;        \
	      fi;                       \
	      if [ "$(NOAUTOLOAD)" = "1" ]; then \
		if [ "$$CLASS" != "" ]; then  \
		  NAME=`basename $$i .st`;    \
		  if [ "$$CLASS" != "$$NAME" ]; then \
		    echo "  warning: className ~= fileName: "$$NAME".st" > /dev/null; \
		  fi; \
		  echo $$CLASS" "$$NAME" "$$PACKAGE  >> abbrev.stc; \
		  echo "  added " $$CLASS" -> "$$NAME >/dev/null;   \
		else                    \
		  echo "  ** ignore "$$i" in abbrevs (no valid class source ?)"; \
		fi;                     \
	      else                      \
		NCIVARS=`$(STC) -extractNumClassInstvars $$i  2>/dev/null`; \
		CAT=`$(STC) -extractCategory $$i  2>/dev/null`; \
		if [ "$$CLASS" != "" ]; then  \
		  NAME=`basename $$i .st`;    \
		  if [ "$$CLASS" != "$$NAME" ]; then \
		    echo "  warning: className ~= fileName: "$$NAME".st" > /dev/null; \
		  fi; \
		  echo $$CLASS" "$$NAME" "$$PACKAGE $$CAT $$NCIVARS>> abbrev.stc; \
		  echo "  added " $$CLASS" -> "$$NAME >/dev/null; \
		else    \
		  echo "  ** ignore "$$i" in abbrevs (no valid class source ?)"; \
		fi;     \
	      fi;       \
	      ;;        \
	  esac;       \
	done
	@sort < abbrev.stc | uniq > abbrev.stc.sorted
	@mv abbrev.stc.sorted abbrev.stc

$(TOP)/rules/rightstr:
	@-if [ "$(CONF)" = "NT/cygwin32-bc" ]; then \
	    (cd $(TOP)/rules && $(CC) -c rightstr.c); \
	    (cd $(TOP)/rules && $(CC) rightstr.$(O)); \
	else \
	    (cd $(TOP)/rules && $(CC) -o rightstr rightstr.c); \
	fi


#
# recursively walk down, updating abbrev file
#
updAbbrev:
	@$(MAKE) updLocalAbbrev
	@-if [ "$(ALLSUBDIRS)x" != "x" ]; then            \
	    $(MAKE) updSubdirAbbrev;                    \
	fi

updSubdirAbbrev::
	@-for i in $(ALLSUBDIRS); do                    \
	    if [ -d $$i ]; then                         \
	      if [ -f $$i/Make.proto ]; then            \
		if [ -f $$i/$(MAKEFILE) ]; then         \
		  echo "update abbreviations in $$i";   \
		  if [ "$(NOSUBAUTOLOAD)" = "1" ]; then \
		      (cd $$i && $(MAKE) updAbbrev NOSUBAUTOLOAD=1 NOAUTOLOAD=1 ); \
		  else                                  \
		      (cd $$i && $(MAKE) updAbbrev);     \
		  fi;                                   \
		fi                                      \
	      fi                                        \
	    fi;                                         \
	done


.listOfSTfiles: .
	@-if [ -r .listOfSTfiles ]; then                        \
	    ls *.st > .listOfSTfiles.new;                       \
	    if cmp .listOfSTfiles .listOfSTfiles.new; then      \
		rm -f .listOfSTfiles.new;                       \
	    else                                                \
		rm -f .listOfSTfiles;                           \
		mv .listOfSTfiles.new .listOfSTfiles;           \
	    fi;                                                 \
	else                                                    \
	    ls *.st > .listOfSTfiles;                           \
	fi


modulList.o: modulList.c
	$(CC) -c $(CFLAGS) -I$(INCLUDE) modulList.c
	@-echo "done with modulList.o"

modulList.c: modulList.stc
	@$(MAKE) $(CLASSLISTEDITRULE) CLASSLIST=modulList
	@-echo "done with modulList.c"

modulList.stc: $(MAKEFILE)
	@-rm -f modulList.stc modulList.c
	@$(MAKE) GENERICLIST CLASSLIST=modulList                \
		 ADDITIONAL_CLASSES="$(ADDITIONAL_CLASSES)"     \
		 LIBLIST="$(LIBLIST)"                           \
		 CLASSLIBRARIES="                               \
			$(LIBLIST)                              \
			$(OTHERLIBRARIES)                       \
		 "                                              \
		 CLASSLISTS="                                   \
			$(EXTRACLASSLISTS)                      \
			$(CLIENTCLASSLISTS)                     \
		 "

#
# edit a modulList.c file from a modulList.stc file
#
classListEdit:
	@echo "making $(CLASSLIST).c from $(CLASSLIST).stc"
	@echo "#include <stcIntern.h>" > $(CLASSLIST).c
	@echo "typedef void (*vf)();" >> $(CLASSLIST).c
	@sed '/^$$/d' < $(CLASSLIST).stc > $(CLASSLIST).tmp1
	@sed 's/ $$//' < $(CLASSLIST).tmp1 > $(CLASSLIST).tmp2
	@sed 's/ $$//' < $(CLASSLIST).tmp2 > $(CLASSLIST).tmp1
	@sed 's/^/extern void _/' < $(CLASSLIST).tmp1 > $(CLASSLIST).tmp2
	@sed -e '/[A-Za-z]/s/$$/_Init();/' -e 's/::/__/' < $(CLASSLIST).tmp2 >> $(CLASSLIST).c
	@echo "static vf modules[] = {" >> $(CLASSLIST).c
	@sed 's/^/_/' < $(CLASSLIST).tmp1 > $(CLASSLIST).tmp2
	@sed 's/::/__/' < $(CLASSLIST).tmp2 > $(CLASSLIST).tmp1
	@sed 's/$$/_Init,/' < $(CLASSLIST).tmp1 >> $(CLASSLIST).c
	@echo "(vf)0" >> $(CLASSLIST).c
	@echo "};" >> $(CLASSLIST).c
	@echo "vf *__modules__ = modules;" >> $(CLASSLIST).c
	@-rm -f $(CLASSLIST).tmp1 $(CLASSLIST).tmp2
	@-echo "done with classListEdit"

#
# generate a classList.stc/modulList.stc
# from LIBLIST, CLASSLISTS and EXTRA_CLASSES
# requires CLASSLIST to be set
#
GENERICLIST:   $(CLASSLISTS)
	    @echo "making $(CLASSLIST)"
	    @-rm -f $(CLASSLIST)
	    @-if [ "$(LIBLIST)" != "" ]; then                   \
		echo "   included class libraries:";            \
		$(MAKE) addNamesToList NAMES="$(LIBLIST)"; \
	     fi
	    @-if [ "$(CLASSLISTS)" = "" ]; then                 \
	      echo "(ignore any following syntax error ...)" >/dev/null;        \
	     fi
	    @-if [ "$(CLASSLISTS)" != "" ]; then                \
		echo "   included individual classes:";         \
		for i in "$(CLASSLISTS)"; do                    \
		    echo "     $$i";                            \
		done;                                           \
		cat $(CLASSLISTS) >> $(CLASSLIST).stc;          \
	     fi
	    @-if [ "$(ADDITIONAL_CLASSES)" != "" ]; then        \
		echo "   included additional (user) classes:";  \
		for i in $(ADDITIONAL_CLASSES); do              \
		    echo "     $$i" | sed 's/_/_137/g';         \
		    echo $$i | sed 's/_/_137/g'   >> $(CLASSLIST).stc;  \
		done; \
	    fi
	    @echo

addNamesToList:
	@-for i in $(NAMES); do \
	    echo "     $$i";    \
	    echo $$i    >> $(CLASSLIST).stc; \
	done

#
# generate a libXXXInit.c file from classList/modulList.stc
#
$(LIBNAME)Init.o: libInit.cc Make.proto Make.spec
	$(CC) $(CFLAGS) -x c -c $< -o $@

ntLibInit.c: $(LIBNAME)Init.c
	mv $(LIBNAME)Init.c ntLibInit.c


#
# generate a zip file containing the sources.
#
$(LIBNAME).zip:
	zip -0 $(LIBNAME).zip *.st

#
# generate an export file for AIX sharedlibrary building
#
#old$(LIBNAME).exp: $(CLASSLIST).stc
#        @-if [ -f $(CLASSLIST).stc ]; then \
#            echo "making export file $(LIBNAME).exp from $(CLASSLIST).stc"; \
#            echo "#! /usr/local/lib/smalltalk/lib/$(LIBNAME).so" > $(LIBNAME).exp; \
#            sed '/^$$/d' < $(CLASSLIST).stc > $(LIBNAME).tmp1; \
#            sed 's/ $$//' < $(LIBNAME).tmp1 > $(LIBNAME).tmp2; \
#            sed 's/ $$//' < $(LIBNAME).tmp2 > $(LIBNAME).tmp1; \
#            sed 's/^/_/' < $(LIBNAME).tmp1 > $(LIBNAME).tmp2; \
#            sed 's/::/__/' < $(LIBNAME).tmp2 > $(LIBNAME).tmp1; \
#            sed '/[A-Za-z]/s/$$/_Init/' < $(LIBNAME).tmp1 >> $(LIBNAME).exp ;\
#            rm -f $(LIBNAME).tmp1 $(LIBNAME).tmp2; \
#            echo "done with $(LIBNAME).exp"; \
#        else \
#            echo "skip making of $(LIBNAME).exp - no classList"; \
#        fi

$(LIBNAME).exp: $(LIB)
	@-echo "making export file $(LIBNAME).exp"
	@-echo "#! /usr/local/lib/smalltalk/lib/$(LIBNAME).so" > $(LIBNAME).exp
	@-echo "_"$(LIBNAME)"_Init" >> $(LIBNAME).exp

#
# generate a file containing symbols to be hidden in
# a classlib. Use for classLibs which are to be loaded completely
#
hiddenSyms.stc: $(CLASSLIST).stc
	@echo "making list of hidden syms ..."
	@sed '/^$$/d' < $(CLASSLIST).stc > hiddenSyms.tmp1
	@sed 's/ $$//' < hiddenSyms.tmp1 > hiddenSyms.tmp2
	@sed 's/ $$//' < hiddenSyms.tmp2 > hiddenSyms.tmp1
	@sed 's/^/_/' < hiddenSyms.tmp1 > hiddenSyms.tmp2
	@sed 's/::/__/' < hiddenSyms.tmp2 > hiddenSyms.tmp1
	@sed '/[A-Za-z]/s/$$/_Init/' < hiddenSyms.tmp1 > hiddenSyms.stc
	@rm -f hiddenSyms.tmp1 hiddenSyms.tmp2
	@-echo "done with hiddenSyms.stc"

#depend:
#       @-if grep "xx"STDEPEND $(MAKEFILE); then           \
#           sed '/"xx"STDEPEND/, $$ d' < $(MAKEFILE) > mf.tmp;     \
#           echo "# xx""STDEPENDxx" >> mf.tmp   ;       \
#           echo mv mf.tmp $(MAKEFILE);                    \
#       fi
#
allDepend:
	@-$(MAKE) depend
	@-if [ "$(SUBDIRS)"x != x ]; then \
	  for i in $(SUBDIRS)" "; do      \
	    if [ -d $$i ]; then           \
	      (cd $$i && $(MAKE) depend);  \
	    fi;                           \
	  done;                           \
	fi

depend:
	@-if grep "^# BEGINMAKEDEPEND" Make.proto > /dev/null; then \
	    if [ -f $(TOP)/stc/stc ]; then                          \
		$(MAKE) STC=$(STC) stDepend;                        \
	    else                                                    \
		if ($(STC) --version 2>/dev/null); then             \
		    $(MAKE) STC=$(STC) stDepend;                    \
		else                                                \
		    echo "**** oops, no stc ("$(STC)"). Cannot make dependencies"; \
		fi                                                  \
	    fi                                                      \
	fi

.dependencies:
	@-echo "  extracting dependencies ..."
	@-for i in *.st ; do                    \
	    if [ -f `basename $$i .st`_win32.st ]; then \
	      echo "  skipping $$i in dependencies"; \
	    else \
	      echo "  extracting dependencies for $$i ..." >/dev/null; \
	      $(STC) $(LOCALINCLUDES) -I$(INCLUDE) -I. -makeDepend $$i >> .dependencies 2>/dev/null; \
	      rslt=$$?; \
	      if [ $$rslt != 0 ]; then \
		echo "    *** superclass not compiled / no valid class source in "$$i" ? [exitCode="$$rslt"]" >/dev/null; \
	      fi \
	    fi \
	done

stDepend::
	@-rm -f .dependencies
	@$(MAKE) .dependencies
	@-sed 's/^\(.\)/$$(OUTDIR)\1/' < .dependencies > ttt1
	@-sed 's/\.H/\.$$(H)/g' < ttt1 > .dependencies
	@-for i in *.st ; do                    \
	  echo "genAbbrev:: $$i" >> .dependencies; \
	done
	@-sed '1,/^# BEGINMAKEDEPEND/w ttt1' < $(MAKEFILE) > /dev/null
	@-sed '/^# ENDMAKEDEPEND/,$$w ttt2' < $(MAKEFILE) > /dev/null
	@-cat ttt1              > $(MAKEFILE).new
	@-if grep "^# BEGINMAKEDEPEND" ttt1 > /dev/null; then \
	    echo "found BEGIN line" > /dev/null; \
	else \
	    echo "# BEGINMAKEDEPEND --- do not remove this line; make depend needs it" >> $(MAKEFILE).new; \
	fi
	@-cat .dependencies     >> $(MAKEFILE).new
	@-if grep "^# ENDMAKEDEPEND" ttt2 > /dev/null; then \
	    echo "found END line" > /dev/null; \
	else \
	    echo "# ENDMAKEDEPEND --- do not remove this line" >> $(MAKEFILE).new; \
	fi
	@-cat ttt2              >> $(MAKEFILE).new
	@-rm -f ttt1 ttt2
	@-rm -f $(MAKEFILE)
	@-rm -f .dependencies
	@-mv $(MAKEFILE).new $(MAKEFILE)

showDepend:: abbrev.stc
	@-for i in *.st ; do \
	    $(STC) $(LOCALINCLUDES) -I$(INCLUDE) -I. -makeDepend $$i; \
	done

unlink:
	@-for i in * ; do                       \
	  if [ -h $i ]; then                    \
	    echo $i;                            \
	    cp $i $i.X; mv $i.X $i;             \
	  fi;                                   \
	done

#
# create symbolic links for all used libraries in the LINK_LIBDIR
# directory. Req'd for sharedLib links.
#
mkLinkLibDir:
	@test -d $(LINK_LIBDIR) || mkdir $(LINK_LIBDIR)

linkLibsDir:
	@-if [ "$(LINK_LIBDIR)" = "" ]; then                            \
	    if [ "$(NO_LINK_LIBDIR)" != "yes" ]; then                   \
		test -d lib || mkdir lib;                               \
	    fi                                                          \
	else                                                            \
	    $(MAKE) mkLinkLibDir LINK_LIBDIR="$(LINK_LIBDIR)";          \
	fi

linkLibs:
	@if [ "$(LINK_LIBOBJS)" != "$(LIBOBJS)" ]; then                \
	    if [ "$(LIBOBJS)" != "" ]; then                             \
		$(MAKE) linkLibsDir LINK_LIBDIR="$(LINK_LIBDIR)";       \
		$(MAKE) linkObjs LIBOBJS="$(LIBOBJS)";                  \
	    fi;                                                         \
	fi
	@if [ "$(LINK_LIBRUN)" != "$(LIBRUN)" ]; then                  \
	    $(MAKE) linkLibsDir LINK_LIBDIR="$(LINK_LIBDIR)";           \
	    if [ "$(LINK_LIBDIR)" = "" ]; then                          \
		if [ "$(LIBRUN)" = "" ]; then                           \
		  echo "  symlinking to $(LIBRUNDIR)/$(LINK_LIBRUN) for linkage ..."; \
		  rm -f `basename $(LINK_LIBRUN)` lib/`basename $(LINK_LIBRUN)`;      \
		  $(LNS) $(LIBRUNDIR)/$(LINK_LIBRUN) .;                 \
		  if [ "$(NO_LINK_LIBDIR)" != "yes" ]; then             \
		    (cd lib && $(LNS) ../$(LIBRUNDIR)/$(LINK_LIBRUN) .); \
		  fi;                                                   \
		else                                                    \
		  echo "  symlinking to $(LIBRUN) for linkage ...";     \
		  rm -f `basename $(LIBRUN)` lib/`basename $(LIBRUN)`;  \
		  $(LNS) $(LIBRUN) .;                                   \
		  if [ "$(NO_LINK_LIBDIR)" != "yes" ]; then             \
		      (cd lib && $(LNS) ../$(LIBRUN) .);                 \
		  fi;                                                   \
		fi;                                                     \
	    else                                                        \
		if [ "$(FORCE_LINK_LIBRUN)" != "" ]; then               \
		    echo "  symlinking to $(LIBRUNDIR)/$(LINK_LIBRUN) for linkage ..."; \
		    rm -f `basename $(LINK_LIBRUN)` lib/`basename $(LINK_LIBRUN)`;      \
		    $(LNS) $(LIBRUNDIR)/$(LINK_LIBRUN) .;               \
		    if [ "$(NO_LINK_LIBDIR)" != "yes" ]; then           \
			(cd lib && $(LNS) ../$(LIBRUNDIR)/$(LINK_LIBRUN) .); \
		    fi;                                                 \
		else                                                    \
		    if [ "$(LINK_LIBDIR)" != "" ]; then                 \
			echo "  symlinking to ../$(LIBRUN) for linkage ..."; \
			rm -f $(LINK_LIBDIR)/`basename $(LIBRUN)`;      \
			(cd $(LINK_LIBDIR) && $(LNS) ../$(LIBRUN) .);    \
		    fi;                                                 \
		fi;                                                     \
	    fi;                                                         \
	fi
	@if [ "$(LINK_EXTRA_OBJ)" != "$(EXTRA_OBJ)" ]; then            \
	    $(MAKE) linkLibsDir LINK_LIBDIR="$(LINK_LIBDIR)";           \
	    $(MAKE) linkExtraObj EXTRA_OBJ="$(EXTRA_OBJ)";              \
	fi

linkObjs:
	@for i in $(LIBOBJS); do                                       \
	    echo "  symlinking to $$i for linkage ...";                 \
	    if [ "$(LINK_LIBDIR)" = "" ]; then                          \
		rm -f `basename $$i` lib/`basename $$i`;                \
		$(LNS) $$i .;                                           \
		if [ "$(NO_LINK_LIBDIR)" != "yes" ]; then               \
		    (cd lib && $(LNS) ../$$i .);                         \
		fi                                                      \
	    else                                                        \
		if [ "$(LINK_LIBDIR)" != "" ]; then                     \
		    rm -f $(LINK_LIBDIR)/`basename $$i`;                \
		    (cd $(LINK_LIBDIR) && $(LNS) ../$$i .);              \
		fi;                                                     \
	    fi;                                                         \
	done

linkExtraObj:
	@for i in $(EXTRA_OBJ); do                                     \
	    echo "  symlinking to $$i for linkage ...";                 \
	    if [ "$(LINK_LIBDIR)" = "" ]; then                          \
		rm -f `basename $$i` lib/`basename $$i`;                \
		$(LNS) $$i .;                                           \
		if [ "$(NO_LINK_LIBDIR)" != "yes" ]; then               \
		    (cd lib && $(LNS) ../$$i .);                         \
		fi                                                      \
	    else                                                        \
		if [ "$(LINK_LIBDIR)" != "" ]; then                     \
		    rm -f $(LINK_LIBDIR)/`basename $$i`;                \
		    (cd $(LINK_LIBDIR) && $(LNS) ../$$i .);              \
		fi;                                                     \
	    fi;                                                         \
	done

removeLinkLibs::
	@-if [ "$(LINK_LIBDIR)" = "" ]; then                            \
	    rm -f $(EXTRA_LINK_LIBS) $(EXTRA_LINK_OBJ)                  \
		  $(LINK_LIBOBJS) $(LINK_LIBRUN);                       \
	fi

#
# linking to bitmap files in a project directory
#
bitmapLink:
	@-if [ "$(COLLECT_BITMAPS)" != "" ]; then \
	  $(MAKE) do_bitmapLink; \
	fi

do_bitmapLink::
	test -d bitmaps || mkdir bitmaps
	for i in $(BITMAPLINK_DIRS) $(EXTRA_BITMAPLINK_DIRS); do      \
	  if [ -d $$i ]; then                                         \
	    if [ -d $$i/bitmaps ]; then                               \
	      if [ "`echo $$i/bitmaps/*`" != '$$i/bitmaps/*' ]; then  \
		echo linking bitmaps from $$i;                        \
		(cd bitmaps && $(LNS) ../$$i/bitmaps/* . 2>/dev/null);  \
		(cd bitmaps && rm -f CVS RCS \* not_delivered);         \
	      fi;                                                     \
	    fi;                                                       \
	  fi;                                                         \
	done

#
# linking to binary files in a project directory
#
binaryLink:
	@-if [ "$(COLLECT_BINARIES)" != "" ]; then \
	  $(MAKE) do_binaryLink; \
	fi

do_binaryLink::
	test -d binary || mkdir binary
	@-for i in $(BINARYLINK_DIRS); do                            \
	  if [ -d $$i ]; then                                        \
	    if [ "`echo $$i/*$(BIN_O)`" != '$$i/*$(BIN_O)' ]; then   \
	      echo linking binaries from $$i;                        \
	      (cd binary && $(LNS) ../$$i/*$(BIN_O) . 2>/dev/null);    \
	      (cd binary && $(LNS) ../$$i/*.cls . 2>/dev/null);        \
	      (cd binary && rm -f CVS RCS not_delivered \*.cls \*$(BIN_O) ); \
	    fi;                                                      \
	  fi;                                                        \
	done
	@-if [ "$(EXTRA_BINARYLINK_DIRS)" != "" ]; then              \
	    $(MAKE) binaryLinkExtra;                                 \
	fi

binaryLinkExtra:
	@-for i in $(EXTRA_BINARYLINK_DIRS); do                 \
	    echo linking binary $$i;                            \
	    rm -f binary/`basename $$i`;                        \
	    (cd binary && $(LNS) ../$$i .);                       \
	done

#
# linking to source files in a project directory
#
sourceLink:
	@-if [ "$(COLLECT_SOURCES)" != "" ]; then \
	  $(MAKE) do_sourceLink; \
	fi

do_sourceLink::
	test -d source || mkdir source
	@-for i in $(SOURCELINK_DIRS); do                       \
	      if [ -d $$i ]; then                               \
		if [ "`echo $$i/*.st`" != $$i'/*.st' ]; then    \
		  echo linking sourcefiles from $$i;            \
		  (cd source && $(LNS) ../$$i/*.st . 2> /dev/null || true);       \
		  (cd source && rm -f CVS RCS not_delivered \*.st); \
		fi;                                             \
	      else                                              \
		if [ -d $(TOP)/$$i ]; then                      \
		  if [ "`echo $(TOP)/$$i/*.st`" != $(TOP)/$$i'/*.st' ]; then \
		    echo linking sourcefiles from $(TOP)/$$i;   \
		    (cd source && $(LNS) ../$(TOP)/$$i/*.st . 2> /dev/null || true);      \
		    (cd source && rm -f CVS RCS not_delivered \*.st);       \
		  fi;                                           \
		fi;                                             \
	      fi;                                               \
	done

#
# create zip files containing sources
# (do not compress - ZipArchive class cannot do this right now
#
sourceZip:
	test -d source || mkdir source
	test -d source/stx || mkdir source/stx
	for i in $(SOURCELINK_DIRS); do                 \
	    if [ -d $$i ]; then                                 \
		if [ "`echo $$i/*.zip`" != $$i'/*.zip' ]; then  \
		    echo "copy zip-sourcefile from $$i";        \
		    cp $$i/*.zip source/stx;                    \
		fi                                              \
	    else                                                \
		if [ -d $(TOP)/$$i ]; then                      \
		    if [ "`echo $(TOP)/$$i/*.st`" != $(TOP)/$$i/'*.st' ]; then  \
			echo "copy zip-sourcefile from $(TOP)/$$i";             \
			cp $(TOP)/$$i/*.zip source/stx; \
		    fi                                          \
		fi                                              \
	    fi                                                  \
	done

#
# linking to resource files in a project directory
#
resourceLink:
	@-if [ "$(COLLECT_RESOURCES)" != "" ]; then \
	  $(MAKE) do_resourceLink; \
	fi

do_resourceLink::
	@test -d resources || mkdir resources
	@-for i in $(RESOURCELINK_DIRS); do                   \
	      if [ -d $$i ]; then                             \
		if [ "`echo $$i/*`" != '$$i/*' ]; then        \
		  echo linking resource files from $$i ...;   \
		  (cd resources && $(LNS) ../$$i/* . 2> /dev/null || true);       \
		  (cd resources && rm -f CVS RCS not_delivered \*); \
		fi;                                           \
	      else                                            \
		if [ -d $(TOP)/$$i ]; then                    \
		  if [ "`echo $(TOP)/$$i/*`" != '$(TOP)/$$i/*' ]; then    \
		    echo linking resource files from $(TOP)/$$i ...;      \
		    (cd resources && $(LNS) ../$(TOP)/$$i/* . 2> /dev/null || true);      \
		    (cd resources && rm -f CVS RCS not_delivered \*);       \
		  fi;                                                     \
		fi;                                                       \
	      fi;                                                         \
	done

styleLink:
	@-if [ "$(COLLECT_RESOURCES)" != "" ]; then \
	  $(MAKE) do_styleLink; \
	fi

do_styleLink::
	@test -d resources || mkdir resources
	@-echo "linking style files from $(LIBVIEWDIR)/styles ..."
	@-rm -f resources/*.style resources/*.common
	@-(cd resources && $(LNS) ../$(LIBVIEWDIR)/styles/* . 2> /dev/null || true)
	@rm -f resources/RCS resources/CVS resources/not_delivered

includeLink:
	@test -d include || mkdir include
	@-for i in $(INCLUDELINK_FILES); do                   \
	    if [ ! -r include/$$i ]; then                     \
		if [ -f $(INCLUDE)/$$i ]; then                \
		    echo "linking $$i ...";                   \
		    rm -f include/`basename $$i`;             \
		    (cd include && $(LNS) ../$(INCLUDE)/$$i .); \
		else                                          \
		    echo "oops - no $(INCLUDE)/$$i";          \
		fi;                                           \
	    fi;                                               \
	done

#
# checkin all changed files
#
checkin::
	@echo "comment: "
	@(read comment ; $(MAKE) doCheckin COMMENT="$$comment")

checkinlocal::
	@echo "comment: "
	@(read comment ; $(MAKE) doCheckin COMMENT="$$comment" LOCALCHECKIN="yes" )

#
# checkin; expects $(COMMENT) to be set
#
doCheckin::
	@-if [ -d CVS ]; then                                   \
	    if [ "$(LOCALCHECKIN)" != "yes" ]; then             \
		cvs commit -m"$(COMMENT)";                      \
	    else                                                \
		cvs commit -l -m"$(COMMENT)";                   \
	    fi                                                  \
	fi

ident::
	@-ident *.st Make.proto

releaseDir:
	@-if [ ! -d $(TOP)/releases ]; then                             \
	    echo "creating release directory";                          \
	    mkdir $(TOP)/releases;                                      \
	    echo 2 > $(TOP)/releases/NEXT_MAJOR;                        \
	    echo 10 > $(TOP)/releases/NEXT_MINOR;                       \
	    echo 5 > $(TOP)/releases/NEXT_VSN;                          \
	    echo 1 > $(TOP)/releases/NEXT_REL;                          \
	fi

incRelease:
	@(read rel < $(TOP)/releases/NEXT_REL ; \
	  expr $$rel + 1 > $(TOP)/releases/NEXT_REL)

incVersion:
	@(read vsn < $(TOP)/releases/NEXT_VSN ; \
	  expr $$vsn + 1 > $(TOP)/releases/NEXT_VSN)
	echo 1 > $(TOP)/releases/NEXT_REL

incMinor:
	@(read min < $(TOP)/releases/NEXT_MIN ; \
	  expr $$min + 1 > $(TOP)/releases/NEXT_MIN)
	echo 1 > $(TOP)/releases/NEXT_VSN
	echo 1 > $(TOP)/releases/NEXT_REL

#
# make a new release
#
release:
	@$(MAKE) releaseDir
	@$(MAKE) incRelease
	@(read maj<$(TOP)/releases/NEXT_MAJOR ; \
	  read min<$(TOP)/releases/NEXT_MINOR ; \
	  read vsn<$(TOP)/releases/NEXT_VSN ; \
	  read rel<$(TOP)/releases/NEXT_REL ; \
	  $(MAKE) doRelease REL=$$rel RELEASEID="$$maj.$$min.$$vsn.$$rel" )

#
# make a new version
#
version:
	@$(MAKE) releaseDir
	@$(MAKE) incVersion
	@(read maj<$(TOP)/releases/NEXT_MAJOR ; \
	  read min<$(TOP)/releases/NEXT_MINOR ; \
	  read vsn<$(TOP)/releases/NEXT_VSN ; \
	  read rel<$(TOP)/releases/NEXT_REL ; \
	  $(MAKE) doRelease VSN=$$vsn RELEASEID="$$maj.$$min.$$vsn.$$rel" )

#
# make a new minor
#
minor:
	@$(MAKE) releaseDir
	@$(MAKE) incMinor
	@(read maj<$(TOP)/releases/NEXT_MAJOR ; \
	  read min<$(TOP)/releases/NEXT_MINOR ; \
	  read vsn<$(TOP)/releases/NEXT_VSN ; \
	  read rel<$(TOP)/releases/NEXT_REL ; \
	  $(MAKE) doRelease MIN=$$min RELEASEID="$$maj.$$min.$$vsn.$$rel" )

doRelease:
	@-if [ -d $(TOP)/releases/$(RELEASEID) ]; then   \
	    echo "Release $(RELEASEID) already exists";  \
	    echo;                                        \
	    echo "stop make";                            \
	    sh -c "exit 1";                              \
	fi
	test -d $(TOP)/releases/$(RELEASEID) ||         \
	mkdir $(TOP)/releases/$(RELEASEID)
	@if [ -d $(TOP)/releases/$(RELEASEID) ]; then    \
	    echo "making new release $(RELEASEID) ... "; \
	    $(MAKE) manifest RELPATH="." RELEASEID=$(RELEASEID); \
	fi

#
# extract rcs ids and add to manifest file
# as $(TOP)/releases/$(RELEASEID)/MANIFEST
#
manifest:
	@-for i in $(RCSSOURCES); do                                    \
	    rlog -h $$i | grep "head:" | sed "s/head://" >/tmp/ID;      \
	    (read id</tmp/ID ; echo $(RELPATH)/$$i $$id >> $(TOP)/releases/$(RELEASEID)/MANIFEST); \
	    tail -1 $(TOP)/releases/$(RELEASEID)/MANIFEST; \
	done
	if [ "$(ALLSUBDIRS)"x != x ]; then                 \
	  for i in $(ALLSUBDIRS)" "; do                    \
	    if [ -d $$i ]; then                            \
	      echo "";                                     \
	      echo "manifest in $$i ... ";                 \
	      echo "";                                     \
	      (cd $$i && $(MAKE) makeMakefile);             \
	      (cd $$i && $(MAKE) manifest RELPATH="$(RELPATH)/$$i" RELEASEID=$(RELEASEID));       \
	    fi;                                            \
	  done;                                            \
	fi


stcinfo:
	$(STC) $(STCFLAGS) -V -version

echoObjs:
	@-if [ "$(OBJS)" != "" ]; then \
	    $(MAKE) doEchoObjs; \
	fi

doEchoObjs:
	@-for i in $(OBJS); do \
	    echo `basename $$i .$(O)` ;\
	done

#
# additional/changed rules
#
.SUFFIXES: .st .chg .c .o .tco .chk .note .i .copt .cls .dep .H .STH

__STANDARD_O_RULE__:
	$(STC) $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS_ARCH) $(CFLAGS) $(CFLAGS_LOCAL) -CC="$(CLASSLIB_CC)" -c $(PWD)/$(STFILE).st  && \
	    $(TOUCH) $(PWD)/$(STFILE).$(O)

__STANDARD_C_RULE__:
	$(STC) $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS_ARCH) $(CFLAGS) $(CFLAGS_LOCAL) -CC="$(CLASSLIB_CC)" -C $(PWD)/$(STFILE).st

__STANDARD_S_RULE__:
	$(STC) $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS_ARCH) $(CFLAGS) $(CFLAGS_LOCAL) -CC="$(CLASSLIB_CC)" -S $(PWD)/$(STFILE).st

__STANDARD_H_RULE__:
	$(STC) $(STCFLAGS) $(STC_MSGFORMAT) -H. -warn -headerOnly $(PWD)/$(STFILE).st  && \
	    $(TOUCH) $(PWD)/$(STFILE).$(H)

.st.STH:
	@$(MAKE) OPT="$(OPT)" STC="$(STC)" STFILE=$* $(H_RULE)

.SUFFIXES: .st .gdb
.st.gdb:
	(echo "r $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS_ARCH) $(CFLAGS) $(CFLAGS_LOCAL) -CC="$(CLASSLIB_CC)" -C $<" ; echo "bt" ; cat -) | gdb $(STC)

# Now the header files are no longer stored in stx/include, but together
# with the .st files. The .H files may be older then the .st files (if the
# class layout didn't change, so they should not be recreated implicitely!
#
#.st.H:
#       @$(MAKE) OPT="$(OPT)" STC="$(STC)" STFILE=$* $(H_RULE)


%.o: %.st
	$(STC) $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS_ARCH) $(CFLAGS) $(CFLAGS_LOCAL) -CC="$(CLASSLIB_CC)" -c $(PWD)/$<  && \
	    $(TOUCH) $(PWD)/$@

%.c: %.st
	$(STC) $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS_ARCH) $(CFLAGS) $(CFLAGS_LOCAL) -CC="$(CLASSLIB_CC)" -C $(PWD)/$<

.c.i:
	$(CC) $(CFLAGS_ARCH) $(CFLAGS) -E $*.c > $*.i

#.c.s:
#       $(CC)  $(CFLAGS_ARCH) $(CFLAGS) -S $*.c

.st.s:
	@$(MAKE) CC="$(CLASSLIB_CC)" OPT="$(CLASSLIB_OPT)" SEPINITCODE="$(SEPINITCODE)" STC="$(STC)" STFILE=$* $(S_RULE)

.chg.c:
	    $(STC) -VT $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS) -C $*.chg

.chg.$(O):
	    $(STC) $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS) -c $*.chg
	    @$(TOUCH) $*.$(O)

.st.dep:
	    $(STC) $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS) -makeDepend $*.st

.st.chk:
	    $(STC) $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS) -check $*.st

.st.note:
	    $(STC) $(STCFLAGS) $(STC_MSGFORMAT) $(CFLAGS) -check +notice +hint $*.st

.st.cls:
	    $(TOP)/projects/smalltalk/stx -I -noInfoPrint -q -f $(TOP)/projects/smalltalk/stbc $(STBC_ARGS) $*.st

#.st.cls:
#            $(TOP)/projects/smalltalk/stx -I -noInfoPrint -q -f $(TOP)/projects/smalltalk/stbc \
#                                         -s $(TOP)/projects/smalltalk/smalltalk $*.st

#
# all-rule for Make.protos that dont need one ...
#
AIX::   all

HP::    all

HP_ACC32::    all

HP_ACC64::    all

ULTRIX:: all

LINUX_i386:: all

LUNIX_i386_ELF:: all

SGI5::  all

SGI5_gcc::  all

SGI:: all

SGI_gcc:: all

REALIX_88k:: all

SUN_sparc:: all

OSF_ALPHA:: all

#------------------ end of rules/stdRules ---------------------

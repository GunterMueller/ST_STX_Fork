"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2006-2013 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

ProjectDefinition subclass:#LibraryDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Projects'
!

!LibraryDefinition class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006-2013 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!LibraryDefinition class methodsFor:'description - compilation'!

primaryTarget
    "the primary make target in Make.proto/bc.mak"

    ^ 'classLibRule'
! !

!LibraryDefinition class methodsFor:'description - project information'!

description
    "Returns a description string which will appear in nt.def / bc.def"

    self module = 'stx' ifTrue:[
	^ 'Smalltalk/X Class library'
    ].

    ^ 'Class Library'

    "Created: / 17-08-2006 / 20:52:16 / cg"
    "Modified: / 18-08-2006 / 16:15:53 / cg"
!

fileDescription
    "Return a description string which will appear in nt.def / bc.def and the rc-file"

    ^ self description , ' (LIB)'

    "Created: / 14-09-2006 / 10:55:23 / cg"
!

productType
    "Returns the product type for autopackage"

    ^ 'Library'

    "Created: / 21-12-2010 / 09:28:59 / cg"
! !

!LibraryDefinition class methodsFor:'file generation'!

basicFileNamesToGenerate
    "answer a dictionary (filename -> generator method) with all the files, 
     that have to be generated for this package"

    |dict|

    dict := super basicFileNamesToGenerate.
    dict at:'libInit.cc' put:#'generate_libInit_dot_cc'.
    ^ dict.
!

generateFile:filename
    filename = 'libInit.cc' ifTrue:[
	^ self generate_libInit_dot_cc
    ].
    ((filename = 'lib.rc') or:[filename = self rcFilename]) ifTrue:[
	^ self generate_packageName_dot_rc
    ].
    ^ super generateFile:filename

    "Created: / 22-08-2006 / 18:36:24 / cg"
    "Modified: / 07-09-2006 / 17:07:46 / cg"
!

generate_libInit_dot_cc
    ^ self replaceMappings: self libInit_dot_cc_mappings
            in: self libInit_dot_cc

    "
     stx_libbasic2 generate_libInit_dot_cc
     bosch_dapasx_datenbasis generate_libInit_dot_cc
     bosch_dapasx_application generate_libInit_dot_cc
    "

    "Created: / 08-08-2006 / 12:47:16 / fm"
    "Modified: / 09-08-2006 / 11:30:52 / fm"
    "Modified: / 19-09-2006 / 22:41:40 / cg"
! !

!LibraryDefinition class methodsFor:'file mappings'!

bc_dot_mak_mappings
    |d resFileName|

    resFileName := self resourceFilename. "/ (self package copyFrom:(self package lastIndexOfAny:':/')+1),'.$(RES)'.

    d := super bc_dot_mak_mappings.
    ^ d
        at: 'LIBRARY_NAME' put: ( self libraryName );
        at: 'COMMONSYMFLAG' put: (self commonSymbolsFlag);
        at: 'HEADEROUTPUTARG' put: (self headerFileOutputArg);
        at: 'RESFILENAME' put: resFileName;
        at: 'DEPENDENCIES' put: (self generateDependencies_win32);
        at: 'MAKE_PREREQUISITES' put: (self generateRequiredMakePrerequisites_bc_dot_mak ? '');
        yourself.

    "Created: / 09-08-2006 / 11:44:36 / fm"
    "Modified: / 09-08-2006 / 20:00:01 / fm"
    "Modified: / 14-09-2006 / 18:58:15 / cg"
!

extensionLine_libInit_dot_cc_mappings

    ^ Dictionary new
        at: 'LIBRARY_NAME' put: ( self st2c:(ProjectDefinition projectDefinitionClassNameForDefinitionOf:self package) );
        yourself

    "Created: / 09-08-2006 / 11:19:59 / fm"
    "Modified: / 14-09-2006 / 18:56:26 / cg"
!

libInit_dot_cc_mappings

    ^ Dictionary new
        at: 'LIBRARY_NAME' put: (self libraryName);
        at: 'PACKAGE' put: (self package);
        at: 'EXTERN_DECLARATIONS' put: (self generateExternalDeclarationLines_libInit_dot_cc);
        at: 'EXTERN_DECLARATION_FOR_EXTENSIONS' put: (self generateExternalDeclarationForExtensions_libInit_dot_cc);
        at: 'DEFINITION_CLASSES' put: (self generateDefinitionClassLine_libInit_dot_cc);
        at: 'CLASSES' put: (self generateClassLines_libInit_dot_cc);
        at: 'EXTENSION' put: (self generateExtensionLine_libInit_dot_cc);
        yourself

    "
     stx_libbasic libInit_dot_cc_mappings
    "

    "Created: / 09-08-2006 / 11:20:24 / fm"
    "Modified: / 16-08-2006 / 18:19:03 / User"
    "Modified: / 14-09-2006 / 18:56:42 / cg"
    "Modified: / 17-06-2016 / 10:48:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

make_dot_proto_mappings
    |d|

    d := super make_dot_proto_mappings.
    ^ d
        at: 'MAKE_PREREQUISITES' put: (self generateRequiredMakePrerequisites_make_dot_proto);
        yourself.
!

vc_dot_def_mappings

^Dictionary new
    at: 'LIBRARY_NAME' put: (self libraryName);
    at: 'DESCRIPTION' put: (self description asString storeString);
    at: 'VERSION_NUMBER' put: (self versionNumber);
    yourself

    "Created: / 09-08-2006 / 11:21:21 / fm"
    "Modified: / 14-09-2006 / 18:58:07 / cg"
! !

!LibraryDefinition class methodsFor:'file mappings support'!

commonSymbolsFlag
    "some libraries are compiled with COMMONSYMBOLS -
     This saves a lot of space in the generated dll/so files;
     However, it also requires the librun to be rebuilt, whenever one of
     the commonSymbols-libs changes.
     Therefore, NEVER do this for end-user or application libraries;
     ONLY do it for a subset of the predefined, eXept-provided standard stx libraries"

    (
	#(
	    'stx:libbasic'        'stx:libview'         'stx:libtool'
	    'stx:libbasic2'       'stx:libview2'        'stx:libtool2'
	    'stx:libbasic3'       'stx:libwidg'         'stx:libhtml'
	    'stx:libcomp'         'stx:libwidg2'        'stx:libui'
	    'stx:libboss'         'stx:libdb'
	)
    includes:self package) ifTrue:[
	^ '$(COMMONSYMBOLS)'
    ].
    ^ ''

    "Created: / 18-08-2006 / 13:01:52 / cg"
    "Modified: / 23-08-2006 / 09:48:11 / cg"
!

generateExtensionLine_libInit_dot_cc
    |mappings|

    ^ self hasExtensionMethods
        ifFalse:['']
        ifTrue:[
            mappings := self extensionLine_libInit_dot_cc_mappings.
            self replaceMappings: mappings in: self extensionLine_libInit_dot_cc.]

    "
     DapasXProject generateExtensionLine_libInit_dot_cc
     DapasX_Datenbasis generateExtensionLine_libInit_dot_cc
    "

    "Created: / 09-08-2006 / 11:23:34 / fm"
    "Modified: / 14-09-2006 / 14:19:59 / cg"
! !

!LibraryDefinition class methodsFor:'file templates'!

bc_dot_def
    "the template code for the bc.def file"

"/^
"/'LIBRARY         %(LIBRARY_NAME)
"/DESCRIPTION     %(DESCRIPTION)
"/CODE            PRELOAD MOVEABLE DISCARDABLE
"/SEGMENTS
"/    INITCODE    PRELOAD DISCARDABLE
"/EXPORTS
"/    __%(LIBRARY_NAME)_Init              @1
"/    __%(LIBRARY_NAME)_InitDefinition    @2
"/'

^
'LIBRARY         %(LIBRARY_NAME)
DESCRIPTION     %(DESCRIPTION)
CODE            PRELOAD MOVEABLE DISCARDABLE
SEGMENTS
    INITCODE    PRELOAD DISCARDABLE
EXPORTS
    __%(LIBRARY_NAME)_Init              @1
'

    "Created: / 08-08-2006 / 12:26:58 / fm"
    "Modified: / 08-08-2006 / 19:32:27 / fm"
    "Modified: / 18-08-2006 / 17:13:45 / cg"
!

bc_dot_mak
    "answer a template for the bc.mak makefile.
     Any variable definition %(Variable) will be later replaced by the mapping.
     $% characters have to be duplicated"

^
'# $','Header','$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: ',self name",' at ',Timestamp now printString",'.
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
TOP=%(TOP)
INCLUDE_TOP=$(TOP)\..

%(ADDITIONAL_BASE_ADDRESS_DEFINITION)

!!INCLUDE $(TOP)\rules\stdHeader_bc

!!INCLUDE Make.spec

LIBNAME=%(LIBRARY_NAME)
MODULE_PATH=%(MODULE_PATH)
RESFILES=%(RESFILENAME)

%(ADDITIONAL_DEFINITIONS)

LOCALINCLUDES=%(LOCAL_INCLUDES)
LOCALDEFINES=%(LOCAL_DEFINES)

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) %(HEADEROUTPUTARG) $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) %(COMMONSYMFLAG) -varPrefix=$(LIBNAME)
LOCALLIBS=%(ADDITIONAL_LINK_LIBRARIES)

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL:: %(ADDITIONAL_TARGETS) %(PRIMARY_TARGET)

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
%(MAKE_PREREQUISITES)


%(ADDITIONAL_RULES)

%(ADDITIONAL_HEADERRULES)

test: $(TOP)\goodies\builder\reports
        pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
        $(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
        -del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
%(DEPENDENCIES)
# ENDMAKEDEPEND --- do not remove this line
%(ADDITIONAL_RULES_HG)'

    "Created: / 09-08-2006 / 11:44:20 / fm"
    "Modified: / 09-08-2006 / 19:59:32 / fm"
    "Modified: / 26-07-2012 / 00:57:20 / cg"
    "Modified: / 28-11-2012 / 10:18:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extensionLine_libInit_dot_cc

    ^ '    _%(LIBRARY_NAME)_extensions_Init(pass,__pRT__,snd);'

    "Created: / 08-08-2006 / 15:48:56 / fm"
    "Modified: / 08-08-2006 / 19:32:33 / fm"
!

libInit_dot_cc
    "the template code for the libInit.cc file"

^
'/*
 * $','Header','$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: ',self name,'.
 */
#define __INDIRECTVMINITCALLS__
#include <stc.h>

#ifdef WIN32
# pragma codeseg INITCODE "INITCODE"
#endif

#if defined(INIT_TEXT_SECTION) || defined(DLL_EXPORT)
DLL_EXPORT void _%(LIBRARY_NAME)_Init() INIT_TEXT_SECTION;
DLL_EXPORT void _%(LIBRARY_NAME)_InitDefinition() INIT_TEXT_SECTION;
#endif

%(EXTERN_DECLARATIONS)
%(EXTERN_DECLARATION_FOR_EXTENSIONS)

void _%(LIBRARY_NAME)_InitDefinition(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("%(LIBRARY_NAME)__DFN", _%(LIBRARY_NAME)_InitDefinition, "%(PACKAGE)");
%(DEFINITION_CLASSES)
  __END_PACKAGE__();
}

void _%(LIBRARY_NAME)_Init(int pass, struct __vmData__ *__pRT__, OBJ snd)
{
  __BEGIN_PACKAGE2__("%(LIBRARY_NAME)", _%(LIBRARY_NAME)_Init, "%(PACKAGE)");
%(CLASSES)
%(EXTENSION)
  __END_PACKAGE__();
}
'

    "Created: / 08-08-2006 / 12:40:45 / fm"
    "Modified: / 08-08-2006 / 19:33:01 / fm"
    "Modified: / 18-08-2006 / 12:57:02 / cg"
    "Modified: / 17-06-2016 / 10:49:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

make_dot_proto

^
'# $','Header','$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: ',self name",' at ',Timestamp now printString",'.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# The Makefile as generated by this Make.proto supports the following targets:
#    make         - compile all st-files to a classLib
#    make clean   - clean all temp files
#    make clobber - clean all
#
# This file contains definitions for Unix based platforms.
# It shares common definitions with the win32-make in Make.spec.

#
# position (of this package) in directory hierarchy:
# (must point to ST/X top directory, for tools and includes)
TOP=%(TOP)
INCLUDE_TOP=$(TOP)/..

# subdirectories where targets are to be made:
SUBDIRS=%(SUBDIRECTORIES)


# subdirectories where Makefiles are to be made:
# (only define if different from SUBDIRS)
# ALLSUBDIRS=

REQUIRED_SUPPORT_DIRS=%(REQUIRED_SUPPORT_DIRS)

# if your embedded C code requires any system includes,
# add the path(es) here:,
# ********** OPTIONAL: MODIFY the next lines ***
# LOCALINCLUDES=-Ifoo -Ibar
LOCALINCLUDES=%(LOCAL_INCLUDES)


# if you need any additional defines for embedded C code,
# add them here:,
# ********** OPTIONAL: MODIFY the next lines ***
# LOCALDEFINES=-Dfoo -Dbar -DDEBUG
LOCALDEFINES=%(LOCAL_DEFINES)

LIBNAME=%(LIBRARY_NAME)
STCLOCALOPT=''-package=$(PACKAGE)'' -I. $(LOCALINCLUDES) $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES) %(HEADEROUTPUTARG) %(COMMONSYMFLAG) -varPrefix=$(LIBNAME)


# ********** OPTIONAL: MODIFY the next line ***
# additional C-libraries that should be pre-linked with the class-objects
LD_OBJ_LIBS=%(ADDITIONAL_LINK_LIBRARIES)
LOCAL_SHARED_LIBS=%(ADDITIONAL_SHARED_LINK_LIBRARIES)


# ********** OPTIONAL: MODIFY the next line ***
# additional C targets or libraries should be added below
LOCAL_EXTRA_TARGETS=

OBJS= $(COMMON_OBJS) $(UNIX_OBJS)

%(ADDITIONAL_DEFINITIONS)

all:: preMake %(PRIMARY_TARGET) postMake

pre_objs:: %(ADDITIONAL_TARGETS) %(ADDITIONAL_TARGETS_SVN)

%(ADDITIONAL_RULES)

%(ADDITIONAL_RULES_SVN)

%(ADDITIONAL_RULES_HG)

%(ADDITIONAL_HEADERRULES)

# run default testsuite for this package
test: $(TOP)/goodies/builder/reports
        $(MAKE) -C $(TOP)/goodies/builder/reports -f Makefile.init
        $(TOP)/goodies/builder/reports/report-runner.sh -D . -r Builder::TestReport -p $(PACKAGE)



# add more install actions here
install::

# add more install actions for aux-files (resources) here
installAux::

# add more preMake actions here
preMake::

# add more postMake actions here
postMake:: cleanjunk

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
%(MAKE_PREREQUISITES)

# build all packages containing referenced classes for this package
# they are not needed to compile the package (but later, to load it)
references:
%(MAKE_REFERENCES)

cleanjunk::
%(TAB)-rm -f *.s *.s2

clean::
%(TAB)-rm -f *.o *.H

clobber:: clean
%(TAB)-rm -f *.so *.dll

',
"
$(INSTALLBASE)::
%(TAB)@test -d $@ || mkdir $@

$(INSTALLBASE)/packages:: $(INSTALLBASE)
%(TAB)@test -d $@ || mkdir $@

$(INSTALLBASE)/packages/$(MODULE):: $(INSTALLBASE)/packages
%(TAB)@test -d $@ || mkdir $@

$(INSTALLBASE)/packages/$(MODULE)/dapasx:: $(INSTALLBASE)/packages/$(MODULE)
%(TAB)@test -d $@ || mkdir $@

$(INSTALLBASE)/packages/$(MODULE)/dapasx/interactiver_editor:: $(INSTALLBASE)/packages/$(MODULE)/dapasx
%(TAB)@test -d $@ || mkdir $@

$(INSTALLBASE)/packages/$(MODULE)/$(MODULE_DIR):: $(INSTALLBASE)/packages/$(MODULE)
%(TAB)@test -d $@ || mkdir $@
"
'
# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
%(DEPENDENCIES)
# ENDMAKEDEPEND --- do not remove this line

'

    "Created: / 08-08-2006 / 20:45:36 / fm"
    "Modified: / 09-08-2006 / 16:50:23 / fm"
    "Modified: / 24-06-2009 / 21:39:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 26-07-2012 / 00:57:29 / cg"
    "Modified: / 03-03-2014 / 12:17:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

vc_dot_def

"/^
"/'LIBRARY        %(LIBRARY_NAME)
"/DESCRIPTION     %(DESCRIPTION)
"/VERSION         %(VERSION_NUMBER)
"/CODE            EXECUTE READ
"/DATA            READ WRITE
"/SECTIONS
"/    INITCODE    READ EXECUTE
"/    INITDATA    READ WRITE
"/EXPORTS
"/    _%(LIBRARY_NAME)_Init               @1
"/    _%(LIBRARY_NAME)_InitDefinition     @2
"/IMPORTS'

^
'LIBRARY        %(LIBRARY_NAME)
DESCRIPTION     %(DESCRIPTION)
VERSION         %(VERSION_NUMBER)
CODE            EXECUTE READ
DATA            READ WRITE
SECTIONS
    INITCODE    READ EXECUTE
    INITDATA    READ WRITE
EXPORTS
    _%(LIBRARY_NAME)_Init               @1
IMPORTS'

    "Modified: / 08-08-2006 / 19:33:14 / fm"
! !


!LibraryDefinition class methodsFor:'obsolete'!

lib_dot_rc
    <resource: #obsolete>

^
'/*------------------------------------------------------------------------
 * $','Header','$
 *
 * DO NOT EDIT
 * automagically generated from the projectDefinition: ',self name,'.
 *------------------------------------------------------------------------*/

// #if (__BORLANDC__ < 0x0550)
// #include <ver.h>
// #endif

VS_VERSION_INFO VERSIONINFO
  FILEVERSION     %(FILEVERSION)
  PRODUCTVERSION  %(PRODUCTVERSION)
#if (__BORLANDC__)
  FILEFLAGSMASK   VS_FF_DEBUG | VS_FF_PRERELEASE
  FILEFLAGS       VS_FF_PRERELEASE | VS_FF_SPECIALBUILD
  FILEOS          VOS_NT_WINDOWS32
  FILETYPE        %(FILETYPE)
  FILESUBTYPE     VS_USER_DEFINED
#endif

BEGIN
  BLOCK "StringFileInfo"
  BEGIN
    BLOCK "040904E4"
    BEGIN
      VALUE "CompanyName", %(COMPANYNAME)
      VALUE "FileDescription", "Smalltalk/X Additional Developer Basic Classes Library\0"
      VALUE "FileVersion", "5.2.8.1\0"
      VALUE "InternalName", "libbasic3\0"
      VALUE "LegalCopyright", "Copyright eXept Software AG 1998-2006\0"
      VALUE "ProductName", "Smalltalk/X\0"
      VALUE "ProductVersion", "5.2.8.1\0"
    END

  END

  BLOCK "VarFileInfo"
  BEGIN                               //  Language   |    Translation
    VALUE "Translation", 0x409, 0x4E4 // U.S. English, Windows Multilingual
  END
END
'

    "Created: / 17-08-2006 / 19:37:50 / cg"
    "Modified: / 24-01-2012 / 18:35:45 / cg"
! !

!LibraryDefinition class methodsFor:'queries'!

definitionClassOfApplicationBundle
    "Return the applicationDefinition of the applicationBundle or nil. 
     This is the applicationDefinition of the package which gets actually deployed.
     For example, for all stx libraries, this will be stx_projects_smalltalk.
     For expecco, this would be exept_expecco_application.
     The algorithm here follows the parent hierarchy (not the class hierarchy) of the package name.
     Some classes may explicitly redefine this (if the folder structure is not hierarchical).
     This information is currently used for automatic check of language translations.

     Notice: libraries which are used by more than one project, should only return the one
     which is their 'natural' bundle - usually defined by the position in the package hierarchy.
     This is a little experimental - may change."

    |libPackageID parentPackageID parentDefinitionClass|

    libPackageID := self package asPackageId.
    [
        parentPackageID := libPackageID parentPackage.
        parentPackageID isNil ifTrue:[^ nil].

        parentDefinitionClass := parentPackageID projectDefinitionClass.
        parentDefinitionClass notNil ifTrue:[
            ^ parentDefinitionClass definitionClassOfApplicationBundle
        ].
        libPackageID := parentPackageID
    ] loop.

    "
     exept_expecco definitionClassOfApplicationBundle
    "
!

isAbstract
    ^ self == LibraryDefinition
!

projectType
    ^ LibraryType
!

supportedLanguages
    "Returns a list of languages that (should be / are) supported by this application or library.
     Currently this is only used by lint, to verify that the corresponding languages are 
     present in the resource files."

    |app|

    (app := self definitionClassOfApplicationBundle) notNil ifTrue:[
        ^ app supportedLanguages
    ].
    ^ super supportedLanguages.

    "
     exept_expecco definitionClassOfApplicationBundle
     stx_libtool definitionClassOfApplicationBundle
    "
! !

!LibraryDefinition class methodsFor:'sanity checks'!

searchForInconsistencies
    self searchForNeverCompiledSuperclasses.

"
    self searchForInconsistencies
    DapasX_Datenbasis searchForInconsistencies
"

    "Created: / 09-08-2006 / 16:30:46 / fm"
!

searchForNeverCompiledSuperclasses
      self compiled_classesDo:[:includedClass |
            includedClass allSuperclassesDo:[:eachSuperClass |
                eachSuperClass package == PackageId noProjectID ifTrue:[
                    self inconsistency:'uncompiled superclass: ' , eachSuperClass name
                ].
            ]
      ].

"
    self searchForNeverCompiledSuperclasses
    DapasX_Datenbasis searchForNeverCompiledSuperclasses
"

    "Created: / 09-08-2006 / 16:31:54 / fm"
! !

!LibraryDefinition class methodsFor:'testing'!

isLibraryDefinition
    ^ self isAbstract not

    "
     stx_libboss isLibraryDefinition
     ProjectDefinition isLibraryDefinition
     LibraryDefinition isLibraryDefinition
    "

    "Created: / 23-08-2006 / 15:17:50 / cg"
! !

!LibraryDefinition class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


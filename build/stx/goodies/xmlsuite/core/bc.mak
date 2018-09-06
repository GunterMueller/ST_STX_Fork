# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_xmlsuite_core.
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
TOP=..\..\..
INCLUDE_TOP=$(TOP)\..



!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_xmlsuite_core
MODULE_PATH=goodies\xmlsuite\core
RESFILES=stx_goodies_xmlsuite_coreWINrc.$(RES)


LIBEXPAT_DIR=expat-2.0.1
!ifdef USEMINGW64
LIBEXPAT=$(LIBEXPAT_DIR)/.libs/libexpat.a
LIBEXPAT_TARGET   = x86_64-w64-mingw32
!else
! ifdef USEMINGW32
LIBEXPAT=$(LIBEXPAT_DIR)/.libs/libexpat.a
LIBEXPAT_TARGET   = i686-pc-mingw32
! else
LIBEXPAT$(LIBEXPAT_DIR)/bcb5/release/libexpats_mtd.lib
! endif
!endif      


LOCALINCLUDES=-I$(LIBEXPAT_DIR)\lib -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic2 -I$(INCLUDE_TOP)\stx\libtool -I$(INCLUDE_TOP)\stx\libview -I$(INCLUDE_TOP)\stx\libview2 -I$(INCLUDE_TOP)\stx\libwidg2
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=$(LIBEXPAT)

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL:: $(LIBEXPAT) classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libbasic2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libview2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "
	pushd ..\..\..\libwidg2 & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "




!if defined(USEMINGW32) || defined(USEMINGW64)
$(LIBEXPAT): $(LIBEXPAT_DIR)/config.status
	pushd $(LIBEXPAT_DIR) & set "PATH=C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make

$(LIBEXPAT_DIR)/config.status:
	pushd $(LIBEXPAT_DIR) & set "PATH=C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & bash configure --build=$(LIBEXPAT_TARGET)

clobber::
	-pushd $(LIBEXPAT_DIR) & set "PATH=C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & IF EXIST makefile (make distclean)

clean::
	-pushd $(LIBEXPAT_DIR) & set "PATH=C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & IF EXIST makefile (make clean)

!else
$(LIBEXPAT):
	pushd $(LIBEXPAT_DIR)
	$(MAKE_BAT)
	popd
!endif




test: $(TOP)\goodies\builder\reports\NUL
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)XMLv2__AbstractSAX2Handler.$(O) XMLv2__AbstractSAX2Handler.$(C) XMLv2__AbstractSAX2Handler.$(H): XMLv2__AbstractSAX2Handler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOM3Inspector.$(O) XMLv2__DOM3Inspector.$(C) XMLv2__DOM3Inspector.$(H): XMLv2__DOM3Inspector.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libview2\ApplicationModel.$(H) $(INCLUDE_TOP)\stx\libview2\Model.$(H) $(INCLUDE_TOP)\stx\libwidg2\AbstractHierarchicalItem.$(H) $(INCLUDE_TOP)\stx\libwidg2\HierarchicalItem.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOM3NodeDumper.$(O) XMLv2__DOM3NodeDumper.$(C) XMLv2__DOM3NodeDumper.$(H): XMLv2__DOM3NodeDumper.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOMConfiguration.$(O) XMLv2__DOMConfiguration.$(C) XMLv2__DOMConfiguration.$(H): XMLv2__DOMConfiguration.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOMError.$(O) XMLv2__DOMError.$(C) XMLv2__DOMError.$(H): XMLv2__DOMError.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOMErrorHandler.$(O) XMLv2__DOMErrorHandler.$(C) XMLv2__DOMErrorHandler.$(H): XMLv2__DOMErrorHandler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOMErrorMonitor.$(O) XMLv2__DOMErrorMonitor.$(C) XMLv2__DOMErrorMonitor.$(H): XMLv2__DOMErrorMonitor.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOMImplementation.$(O) XMLv2__DOMImplementation.$(C) XMLv2__DOMImplementation.$(H): XMLv2__DOMImplementation.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOMImplementationRegistry.$(O) XMLv2__DOMImplementationRegistry.$(C) XMLv2__DOMImplementationRegistry.$(H): XMLv2__DOMImplementationRegistry.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__InputSource.$(O) XMLv2__InputSource.$(C) XMLv2__InputSource.$(H): XMLv2__InputSource.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__NameList.$(O) XMLv2__NameList.$(C) XMLv2__NameList.$(H): XMLv2__NameList.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Node.$(O) XMLv2__Node.$(C) XMLv2__Node.$(H): XMLv2__Node.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__NodeList.$(O) XMLv2__NodeList.$(C) XMLv2__NodeList.$(H): XMLv2__NodeList.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)XMLv2__NodeName.$(O) XMLv2__NodeName.$(C) XMLv2__NodeName.$(H): XMLv2__NodeName.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__ParseError.$(O) XMLv2__ParseError.$(C) XMLv2__ParseError.$(H): XMLv2__ParseError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Parser.$(O) XMLv2__Parser.$(C) XMLv2__Parser.$(H): XMLv2__Parser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__SAXError.$(O) XMLv2__SAXError.$(C) XMLv2__SAXError.$(H): XMLv2__SAXError.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__TypeInfo.$(O) XMLv2__TypeInfo.$(C) XMLv2__TypeInfo.$(H): XMLv2__TypeInfo.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__UserDataHandler.$(O) XMLv2__UserDataHandler.$(C) XMLv2__UserDataHandler.$(H): XMLv2__UserDataHandler.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__XMLBuilder.$(O) XMLv2__XMLBuilder.$(C) XMLv2__XMLBuilder.$(H): XMLv2__XMLBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__XMLEventRecorder.$(O) XMLv2__XMLEventRecorder.$(C) XMLv2__XMLEventRecorder.$(H): XMLv2__XMLEventRecorder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__XMLReader.$(O) XMLv2__XMLReader.$(C) XMLv2__XMLReader.$(H): XMLv2__XMLReader.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__XMLReaderImplementationQuery.$(O) XMLv2__XMLReaderImplementationQuery.$(C) XMLv2__XMLReaderImplementationQuery.$(H): XMLv2__XMLReaderImplementationQuery.st $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Notification.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\Query.$(H) $(STCHDR)
$(OUTDIR)XMLv2__XMLWriter.$(O) XMLv2__XMLWriter.$(C) XMLv2__XMLWriter.$(H): XMLv2__XMLWriter.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_xmlsuite_core.$(O) stx_goodies_xmlsuite_core.$(C) stx_goodies_xmlsuite_core.$(H): stx_goodies_xmlsuite_core.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Attr.$(O) XMLv2__Attr.$(C) XMLv2__Attr.$(H): XMLv2__Attr.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__CharacterData.$(O) XMLv2__CharacterData.$(C) XMLv2__CharacterData.$(H): XMLv2__CharacterData.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__ContentHandler.$(O) XMLv2__ContentHandler.$(C) XMLv2__ContentHandler.$(H): XMLv2__ContentHandler.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__AbstractSAX2Handler.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOM3XMLReader.$(O) XMLv2__DOM3XMLReader.$(C) XMLv2__DOM3XMLReader.$(H): XMLv2__DOM3XMLReader.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__XMLReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOMException.$(O) XMLv2__DOMException.$(C) XMLv2__DOMException.$(H): XMLv2__DOMException.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__SAXError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DTDHandler.$(O) XMLv2__DTDHandler.$(C) XMLv2__DTDHandler.$(H): XMLv2__DTDHandler.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__AbstractSAX2Handler.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Document.$(O) XMLv2__Document.$(C) XMLv2__Document.$(H): XMLv2__Document.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DocumentFragment.$(O) XMLv2__DocumentFragment.$(C) XMLv2__DocumentFragment.$(H): XMLv2__DocumentFragment.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DocumentType.$(O) XMLv2__DocumentType.$(C) XMLv2__DocumentType.$(H): XMLv2__DocumentType.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Element.$(O) XMLv2__Element.$(C) XMLv2__Element.$(H): XMLv2__Element.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Entity.$(O) XMLv2__Entity.$(C) XMLv2__Entity.$(H): XMLv2__Entity.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__EntityReference.$(O) XMLv2__EntityReference.$(C) XMLv2__EntityReference.$(H): XMLv2__EntityReference.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__EntityResolver.$(O) XMLv2__EntityResolver.$(C) XMLv2__EntityResolver.$(H): XMLv2__EntityResolver.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__AbstractSAX2Handler.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__ErrorHandler.$(O) XMLv2__ErrorHandler.$(C) XMLv2__ErrorHandler.$(H): XMLv2__ErrorHandler.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__AbstractSAX2Handler.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__ExpatXMLReader.$(O) XMLv2__ExpatXMLReader.$(C) XMLv2__ExpatXMLReader.$(H): XMLv2__ExpatXMLReader.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__XMLReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__IndentingXMLWriter.$(O) XMLv2__IndentingXMLWriter.$(C) XMLv2__IndentingXMLWriter.$(H): XMLv2__IndentingXMLWriter.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__XMLWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__NamedNodeMap.$(O) XMLv2__NamedNodeMap.$(C) XMLv2__NamedNodeMap.$(H): XMLv2__NamedNodeMap.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__NodeList.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Notation.$(O) XMLv2__Notation.$(C) XMLv2__Notation.$(H): XMLv2__Notation.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__ProcessingInstruction.$(O) XMLv2__ProcessingInstruction.$(C) XMLv2__ProcessingInstruction.$(H): XMLv2__ProcessingInstruction.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__SAXParseError.$(O) XMLv2__SAXParseError.$(C) XMLv2__SAXParseError.$(H): XMLv2__SAXParseError.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__SAXError.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__XMLGenerator.$(O) XMLv2__XMLGenerator.$(C) XMLv2__XMLGenerator.$(H): XMLv2__XMLGenerator.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__XMLReader.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__XMLSuiteDOM3Implementation.$(O) XMLv2__XMLSuiteDOM3Implementation.$(C) XMLv2__XMLSuiteDOM3Implementation.$(H): XMLv2__XMLSuiteDOM3Implementation.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__DOMImplementation.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Attributes.$(O) XMLv2__Attributes.$(C) XMLv2__Attributes.$(H): XMLv2__Attributes.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__NamedNodeMap.$(H) $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__NodeList.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)XMLv2__CDATASection.$(O) XMLv2__CDATASection.$(C) XMLv2__CDATASection.$(H): XMLv2__CDATASection.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__CharacterData.$(H) $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Comment.$(O) XMLv2__Comment.$(C) XMLv2__Comment.$(H): XMLv2__Comment.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__CharacterData.$(H) $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__DOM3Builder.$(O) XMLv2__DOM3Builder.$(C) XMLv2__DOM3Builder.$(H): XMLv2__DOM3Builder.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__AbstractSAX2Handler.$(H) $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__ContentHandler.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__IndentingAndHighlightingXMLWriter.$(O) XMLv2__IndentingAndHighlightingXMLWriter.$(C) XMLv2__IndentingAndHighlightingXMLWriter.$(H): XMLv2__IndentingAndHighlightingXMLWriter.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__IndentingXMLWriter.$(H) $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__XMLWriter.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLv2__Text.$(O) XMLv2__Text.$(C) XMLv2__Text.$(H): XMLv2__Text.st $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__CharacterData.$(H) $(INCLUDE_TOP)\stx\goodies\xmlsuite\core\XMLv2__Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\ArrayedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\Character.$(H) $(INCLUDE_TOP)\stx\libbasic\CharacterArray.$(H) $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Magnitude.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\UninterpretedBytes.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

# **Must be at end**

# Enforce recompilation of package definition class if Mercurial working
# copy state changes. Together with --guessVersion it ensures that package
# definition class always contains correct binary revision string.
!IFDEF HGROOT
$(OUTDIR)stx_goodies_xmlsuite_core.$(O): $(HGROOT)\.hg\dirstate
!ENDIF

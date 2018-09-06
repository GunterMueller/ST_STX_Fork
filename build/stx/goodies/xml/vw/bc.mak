# $Header: /cvs/stx/stx/goodies/xml/vw/bc.mak,v 1.31 2017-12-13 14:30:38 stefan Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_xml_vw.
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


# see stdHeader_bc for LIBXMLVW_BASE
LIB_BASE=$(LIBXMLVW_BASE)


!INCLUDE $(TOP)\rules\stdHeader_bc

!INCLUDE Make.spec

LIBNAME=libstx_goodies_xml_vw
MODULE_PATH=goodies\xml\vw
RESFILES=stx_goodies_xml_vwWINrc.$(RES)



LOCALINCLUDES= -I$(INCLUDE_TOP)\stx\libbasic -I$(INCLUDE_TOP)\stx\libbasic3 -I$(INCLUDE_TOP)\stx\libcompat
LOCALDEFINES=

STCLOCALOPT=-package=$(PACKAGE) -I. $(LOCALINCLUDES) -headerDir=. $(STCLOCALOPTIMIZATIONS) $(STCWARNINGS) $(LOCALDEFINES)  -varPrefix=$(LIBNAME)
LOCALLIBS=

OBJS= $(COMMON_OBJS) $(WIN32_OBJS)

ALL::  classLibRule

classLibRule: $(OUTDIR) $(OUTDIR)$(LIBNAME).dll

!INCLUDE $(TOP)\rules\stdRules_bc

# build all mandatory prerequisite packages (containing superclasses) for this package
prereq:
	pushd ..\..\..\libbasic & $(MAKE_BAT) "CFLAGS_LOCAL=$(GLOBALDEFINES) "







test: $(TOP)\goodies\builder\reports\
	pushd $(TOP)\goodies\builder\reports & $(MAKE_BAT)
	$(TOP)\goodies\builder\reports\report-runner.bat -D . -r Builder::TestReport -p $(PACKAGE)
        
clean::
	-del *.$(CSUFFIX)


# BEGINMAKEDEPEND --- do not remove this line; make depend needs it
$(OUTDIR)AttributeDef.$(O) AttributeDef.$(C) AttributeDef.$(H): AttributeDef.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AttributeType.$(O) AttributeType.$(C) AttributeType.$(H): AttributeType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DocumentType.$(O) DocumentType.$(C) DocumentType.$(H): DocumentType.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ElementContext.$(O) ElementContext.$(C) ElementContext.$(H): ElementContext.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Node.$(O) Node.$(C) Node.$(H): Node.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XML__NodeSet.$(O) XML__NodeSet.$(C) XML__NodeSet.$(H): XML__NodeSet.st $(INCLUDE_TOP)\stx\libbasic\Collection.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\OrderedCollection.$(H) $(INCLUDE_TOP)\stx\libbasic\SequenceableCollection.$(H) $(STCHDR)
$(OUTDIR)NodeTag.$(O) NodeTag.$(C) NodeTag.$(H): NodeTag.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Pattern.$(O) Pattern.$(C) Pattern.$(H): Pattern.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SAXDriver.$(O) SAXDriver.$(C) SAXDriver.$(H): SAXDriver.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SAXLocator.$(O) SAXLocator.$(C) SAXLocator.$(H): SAXLocator.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)StreamWrapper.$(O) StreamWrapper.$(C) StreamWrapper.$(H): StreamWrapper.st $(INCLUDE_TOP)\stx\libbasic\Link.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)URIResolver.$(O) URIResolver.$(C) URIResolver.$(H): URIResolver.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLNodeBuilder.$(O) XMLNodeBuilder.$(C) XMLNodeBuilder.$(H): XMLNodeBuilder.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLParser.$(O) XMLParser.$(C) XMLParser.$(H): XMLParser.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLSignal.$(O) XMLSignal.$(C) XMLSignal.$(H): XMLSignal.st $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)stx_goodies_xml_vw.$(O) stx_goodies_xml_vw.$(C) stx_goodies_xml_vw.$(H): stx_goodies_xml_vw.st $(INCLUDE_TOP)\stx\libbasic\LibraryDefinition.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(INCLUDE_TOP)\stx\libbasic\ProjectDefinition.$(H) $(STCHDR)
$(OUTDIR)Attribute.$(O) Attribute.$(C) Attribute.$(H): Attribute.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)CDATA_AT.$(O) CDATA_AT.$(C) CDATA_AT.$(H): CDATA_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Comment.$(O) Comment.$(C) Comment.$(H): Comment.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ComplexPattern.$(O) ComplexPattern.$(C) ComplexPattern.$(H): ComplexPattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ConcretePattern.$(O) ConcretePattern.$(C) ConcretePattern.$(H): ConcretePattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DOM_SAXDriver.$(O) DOM_SAXDriver.$(C) DOM_SAXDriver.$(H): DOM_SAXDriver.st $(INCLUDE_TOP)\stx\goodies\xml\vw\SAXDriver.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Document.$(O) Document.$(C) Document.$(H): Document.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ENTITIES_AT.$(O) ENTITIES_AT.$(C) ENTITIES_AT.$(H): ENTITIES_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ENTITY_AT.$(O) ENTITY_AT.$(C) ENTITY_AT.$(H): ENTITY_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Element.$(O) Element.$(C) Element.$(H): Element.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Entity.$(O) Entity.$(C) Entity.$(H): Entity.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Enumeration_AT.$(O) Enumeration_AT.$(C) Enumeration_AT.$(H): Enumeration_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IDREFS_AT.$(O) IDREFS_AT.$(C) IDREFS_AT.$(H): IDREFS_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)IDREF_AT.$(O) IDREF_AT.$(C) IDREF_AT.$(H): IDREF_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ID_AT.$(O) ID_AT.$(C) ID_AT.$(H): ID_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InvalidSignal.$(O) InvalidSignal.$(C) InvalidSignal.$(H): InvalidSignal.st $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLSignal.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MalformedSignal.$(O) MalformedSignal.$(C) MalformedSignal.$(H): MalformedSignal.st $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLSignal.$(H) $(INCLUDE_TOP)\stx\libbasic\Error.$(H) $(INCLUDE_TOP)\stx\libbasic\Exception.$(H) $(INCLUDE_TOP)\stx\libbasic\GenericException.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)NMTOKENS_AT.$(O) NMTOKENS_AT.$(C) NMTOKENS_AT.$(H): NMTOKENS_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)NMTOKEN_AT.$(O) NMTOKEN_AT.$(C) NMTOKEN_AT.$(H): NMTOKEN_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)NOTATION_AT.$(O) NOTATION_AT.$(C) NOTATION_AT.$(H): NOTATION_AT.st $(INCLUDE_TOP)\stx\goodies\xml\vw\AttributeType.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)NodeBuilder.$(O) NodeBuilder.$(C) NodeBuilder.$(H): NodeBuilder.st $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLNodeBuilder.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Notation.$(O) Notation.$(C) Notation.$(H): Notation.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)OXSAXTestDriver.$(O) OXSAXTestDriver.$(C) OXSAXTestDriver.$(H): OXSAXTestDriver.st $(INCLUDE_TOP)\stx\goodies\xml\vw\SAXDriver.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PI.$(O) PI.$(C) PI.$(H): PI.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SAXWriter.$(O) SAXWriter.$(C) SAXWriter.$(H): SAXWriter.st $(INCLUDE_TOP)\stx\goodies\xml\vw\SAXDriver.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SourceNodeBuilder.$(O) SourceNodeBuilder.$(C) SourceNodeBuilder.$(H): SourceNodeBuilder.st $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLNodeBuilder.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SourceScannerNodeBuilder.$(O) SourceScannerNodeBuilder.$(C) SourceScannerNodeBuilder.$(H): SourceScannerNodeBuilder.st $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLNodeBuilder.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)Text.$(O) Text.$(C) Text.$(H): Text.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)XMLParserStX.$(O) XMLParserStX.$(C) XMLParserStX.$(H): XMLParserStX.st $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLParser.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)AnyPattern.$(O) AnyPattern.$(C) AnyPattern.$(H): AnyPattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ConcretePattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ChoicePattern.$(O) ChoicePattern.$(C) ChoicePattern.$(H): ChoicePattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ComplexPattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DiscardingNodeBuilder.$(O) DiscardingNodeBuilder.$(C) DiscardingNodeBuilder.$(H): DiscardingNodeBuilder.st $(INCLUDE_TOP)\stx\goodies\xml\vw\NodeBuilder.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLNodeBuilder.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)DocumentFragment.$(O) DocumentFragment.$(C) DocumentFragment.$(H): DocumentFragment.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Document.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)EmptyPattern.$(O) EmptyPattern.$(C) EmptyPattern.$(H): EmptyPattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ConcretePattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)GeneralEntity.$(O) GeneralEntity.$(C) GeneralEntity.$(H): GeneralEntity.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Entity.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)InitialPattern.$(O) InitialPattern.$(C) InitialPattern.$(H): InitialPattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ConcretePattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)MixedPattern.$(O) MixedPattern.$(C) MixedPattern.$(H): MixedPattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ComplexPattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ModifiedPattern.$(O) ModifiedPattern.$(C) ModifiedPattern.$(H): ModifiedPattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ComplexPattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)NamePattern.$(O) NamePattern.$(C) NamePattern.$(H): NamePattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ConcretePattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)PCDATAPattern.$(O) PCDATAPattern.$(C) PCDATAPattern.$(H): PCDATAPattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ConcretePattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)ParameterEntity.$(O) ParameterEntity.$(C) ParameterEntity.$(H): ParameterEntity.st $(INCLUDE_TOP)\stx\goodies\xml\vw\Entity.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Node.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SAXBuilder.$(O) SAXBuilder.$(C) SAXBuilder.$(H): SAXBuilder.st $(INCLUDE_TOP)\stx\goodies\xml\vw\NodeBuilder.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\XMLNodeBuilder.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)SequencePattern.$(O) SequencePattern.$(C) SequencePattern.$(H): SequencePattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ComplexPattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)TerminalPattern.$(O) TerminalPattern.$(C) TerminalPattern.$(H): TerminalPattern.st $(INCLUDE_TOP)\stx\goodies\xml\vw\ConcretePattern.$(H) $(INCLUDE_TOP)\stx\goodies\xml\vw\Pattern.$(H) $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)
$(OUTDIR)extensions.$(O): extensions.st $(INCLUDE_TOP)\stx\libbasic\Object.$(H) $(STCHDR)

# ENDMAKEDEPEND --- do not remove this line

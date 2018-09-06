# $Header: /cvs/stx/stx/goodies/xml/vw/Make.spec,v 1.18 2017-12-13 14:30:29 stefan Exp $
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_xml_vw.
#
# Warning: once you modify this file, do not rerun
# stmkmp or projectDefinition-build again - otherwise, your changes are lost.
#
# This file contains specifications which are common to all platforms.
#

# Do NOT CHANGE THESE DEFINITIONS
# (otherwise, ST/X will have a hard time to find out the packages location from its packageID,
#  to find the source code of a class and to find the library for a package)
MODULE=stx
MODULE_DIR=goodies/xml/vw
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to CC for inline C-code
#  -Ixxx       : include path passed to CC for inline C-code
#  +optspace   : optimized for space
#  +optspace2  : optimized more for space
#  +optspace3  : optimized even more for space
#  +optinline  : generate inline code for some ST constructs
#  +inlineNew  : additionally inline new
#  +inlineMath : additionally inline some floatPnt math stuff
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCLOCALOPTIMIZATIONS=+optinline +inlineNew
# STCLOCALOPTIMIZATIONS=+optspace3
STCLOCALOPTIMIZATIONS=+optspace3


# Argument(s) to the stc compiler (stc --usage).
#  -warn            : no warnings
#  -warnNonStandard : no warnings about ST/X extensions
#  -warnEOLComments : no warnings about EOL comment extension
#  -warnPrivacy     : no warnings about privateClass extension
#  -warnUnused      : no warnings about unused variables
#
# ********** OPTIONAL: MODIFY the next line(s) ***
# STCWARNINGS=-warn
# STCWARNINGS=-warnNonStandard
# STCWARNINGS=-warnEOLComments
STCWARNINGS=-warnNonStandard

COMMON_CLASSES= \
	XML::AttributeDef \
	XML::AttributeType \
	XML::DocumentType \
	XML::ElementContext \
	XML::Node \
	XML::NodeSet \
	XML::NodeTag \
	XML::Pattern \
	XML::SAXDriver \
	XML::SAXLocator \
	XML::StreamWrapper \
	XML::URIResolver \
	XML::XMLNodeBuilder \
	XML::XMLParser \
	XML::XMLSignal \
	stx_goodies_xml_vw \
	XML::Attribute \
	XML::CDATA_AT \
	XML::Comment \
	XML::ComplexPattern \
	XML::ConcretePattern \
	XML::DOM_SAXDriver \
	XML::Document \
	XML::ENTITIES_AT \
	XML::ENTITY_AT \
	XML::Element \
	XML::Entity \
	XML::Enumeration_AT \
	XML::IDREFS_AT \
	XML::IDREF_AT \
	XML::ID_AT \
	XML::InvalidSignal \
	XML::MalformedSignal \
	XML::NMTOKENS_AT \
	XML::NMTOKEN_AT \
	XML::NOTATION_AT \
	XML::NodeBuilder \
	XML::Notation \
	XML::OXSAXTestDriver \
	XML::PI \
	XML::SAXWriter \
	XML::SourceNodeBuilder \
	XML::SourceScannerNodeBuilder \
	XML::Text \
	XML::XMLParserStX \
	XML::AnyPattern \
	XML::ChoicePattern \
	XML::DiscardingNodeBuilder \
	XML::DocumentFragment \
	XML::EmptyPattern \
	XML::GeneralEntity \
	XML::InitialPattern \
	XML::MixedPattern \
	XML::ModifiedPattern \
	XML::NamePattern \
	XML::PCDATAPattern \
	XML::ParameterEntity \
	XML::SAXBuilder \
	XML::SequencePattern \
	XML::TerminalPattern \




COMMON_OBJS= \
    $(OUTDIR)AttributeDef.$(O) \
    $(OUTDIR)AttributeType.$(O) \
    $(OUTDIR)DocumentType.$(O) \
    $(OUTDIR)ElementContext.$(O) \
    $(OUTDIR)Node.$(O) \
    $(OUTDIR)XML__NodeSet.$(O) \
    $(OUTDIR)NodeTag.$(O) \
    $(OUTDIR)Pattern.$(O) \
    $(OUTDIR)SAXDriver.$(O) \
    $(OUTDIR)SAXLocator.$(O) \
    $(OUTDIR)StreamWrapper.$(O) \
    $(OUTDIR)URIResolver.$(O) \
    $(OUTDIR)XMLNodeBuilder.$(O) \
    $(OUTDIR)XMLParser.$(O) \
    $(OUTDIR)XMLSignal.$(O) \
    $(OUTDIR)stx_goodies_xml_vw.$(O) \
    $(OUTDIR)Attribute.$(O) \
    $(OUTDIR)CDATA_AT.$(O) \
    $(OUTDIR)Comment.$(O) \
    $(OUTDIR)ComplexPattern.$(O) \
    $(OUTDIR)ConcretePattern.$(O) \
    $(OUTDIR)DOM_SAXDriver.$(O) \
    $(OUTDIR)Document.$(O) \
    $(OUTDIR)ENTITIES_AT.$(O) \
    $(OUTDIR)ENTITY_AT.$(O) \
    $(OUTDIR)Element.$(O) \
    $(OUTDIR)Entity.$(O) \
    $(OUTDIR)Enumeration_AT.$(O) \
    $(OUTDIR)IDREFS_AT.$(O) \
    $(OUTDIR)IDREF_AT.$(O) \
    $(OUTDIR)ID_AT.$(O) \
    $(OUTDIR)InvalidSignal.$(O) \
    $(OUTDIR)MalformedSignal.$(O) \
    $(OUTDIR)NMTOKENS_AT.$(O) \
    $(OUTDIR)NMTOKEN_AT.$(O) \
    $(OUTDIR)NOTATION_AT.$(O) \
    $(OUTDIR)NodeBuilder.$(O) \
    $(OUTDIR)Notation.$(O) \
    $(OUTDIR)OXSAXTestDriver.$(O) \
    $(OUTDIR)PI.$(O) \
    $(OUTDIR)SAXWriter.$(O) \
    $(OUTDIR)SourceNodeBuilder.$(O) \
    $(OUTDIR)SourceScannerNodeBuilder.$(O) \
    $(OUTDIR)Text.$(O) \
    $(OUTDIR)XMLParserStX.$(O) \
    $(OUTDIR)AnyPattern.$(O) \
    $(OUTDIR)ChoicePattern.$(O) \
    $(OUTDIR)DiscardingNodeBuilder.$(O) \
    $(OUTDIR)DocumentFragment.$(O) \
    $(OUTDIR)EmptyPattern.$(O) \
    $(OUTDIR)GeneralEntity.$(O) \
    $(OUTDIR)InitialPattern.$(O) \
    $(OUTDIR)MixedPattern.$(O) \
    $(OUTDIR)ModifiedPattern.$(O) \
    $(OUTDIR)NamePattern.$(O) \
    $(OUTDIR)PCDATAPattern.$(O) \
    $(OUTDIR)ParameterEntity.$(O) \
    $(OUTDIR)SAXBuilder.$(O) \
    $(OUTDIR)SequencePattern.$(O) \
    $(OUTDIR)TerminalPattern.$(O) \
    $(OUTDIR)extensions.$(O) \




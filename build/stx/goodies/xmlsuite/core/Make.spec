# $Header$
#
# DO NOT EDIT
# automagically generated from the projectDefinition: stx_goodies_xmlsuite_core.
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
MODULE_DIR=goodies/xmlsuite/core
PACKAGE=$(MODULE):$(MODULE_DIR)


# Argument(s) to the stc compiler (stc --usage).
#  -headerDir=. : create header files locally
#                (if removed, they will be created as common
#  -Pxxx       : defines the package
#  -Zxxx       : a prefix for variables within the classLib
#  -Dxxx       : defines passed to to CC for inline C-code
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
	XMLv2::AbstractSAX2Handler \
	XMLv2::DOM3Inspector \
	XMLv2::DOM3NodeDumper \
	XMLv2::DOMConfiguration \
	XMLv2::DOMError \
	XMLv2::DOMErrorHandler \
	XMLv2::DOMErrorMonitor \
	XMLv2::DOMImplementation \
	XMLv2::DOMImplementationRegistry \
	XMLv2::InputSource \
	XMLv2::NameList \
	XMLv2::Node \
	XMLv2::NodeList \
	XMLv2::NodeName \
	XMLv2::ParseError \
	XMLv2::Parser \
	XMLv2::SAXError \
	XMLv2::TypeInfo \
	XMLv2::UserDataHandler \
	XMLv2::XMLBuilder \
	XMLv2::XMLEventRecorder \
	XMLv2::XMLReader \
	XMLv2::XMLReaderImplementationQuery \
	XMLv2::XMLWriter \
	stx_goodies_xmlsuite_core \
	XMLv2::Attr \
	XMLv2::CharacterData \
	XMLv2::ContentHandler \
	XMLv2::DOM3XMLReader \
	XMLv2::DOMException \
	XMLv2::DTDHandler \
	XMLv2::Document \
	XMLv2::DocumentFragment \
	XMLv2::DocumentType \
	XMLv2::Element \
	XMLv2::Entity \
	XMLv2::EntityReference \
	XMLv2::EntityResolver \
	XMLv2::ErrorHandler \
	XMLv2::ExpatXMLReader \
	XMLv2::IndentingXMLWriter \
	XMLv2::NamedNodeMap \
	XMLv2::Notation \
	XMLv2::ProcessingInstruction \
	XMLv2::SAXParseError \
	XMLv2::XMLGenerator \
	XMLv2::XMLSuiteDOM3Implementation \
	XMLv2::Attributes \
	XMLv2::CDATASection \
	XMLv2::Comment \
	XMLv2::DOM3Builder \
	XMLv2::IndentingAndHighlightingXMLWriter \
	XMLv2::Text \




COMMON_OBJS= \
    $(OUTDIR_SLASH)XMLv2__AbstractSAX2Handler.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOM3Inspector.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOM3NodeDumper.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOMConfiguration.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOMError.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOMErrorHandler.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOMErrorMonitor.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOMImplementation.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOMImplementationRegistry.$(O) \
    $(OUTDIR_SLASH)XMLv2__InputSource.$(O) \
    $(OUTDIR_SLASH)XMLv2__NameList.$(O) \
    $(OUTDIR_SLASH)XMLv2__Node.$(O) \
    $(OUTDIR_SLASH)XMLv2__NodeList.$(O) \
    $(OUTDIR_SLASH)XMLv2__NodeName.$(O) \
    $(OUTDIR_SLASH)XMLv2__ParseError.$(O) \
    $(OUTDIR_SLASH)XMLv2__Parser.$(O) \
    $(OUTDIR_SLASH)XMLv2__SAXError.$(O) \
    $(OUTDIR_SLASH)XMLv2__TypeInfo.$(O) \
    $(OUTDIR_SLASH)XMLv2__UserDataHandler.$(O) \
    $(OUTDIR_SLASH)XMLv2__XMLBuilder.$(O) \
    $(OUTDIR_SLASH)XMLv2__XMLEventRecorder.$(O) \
    $(OUTDIR_SLASH)XMLv2__XMLReader.$(O) \
    $(OUTDIR_SLASH)XMLv2__XMLReaderImplementationQuery.$(O) \
    $(OUTDIR_SLASH)XMLv2__XMLWriter.$(O) \
    $(OUTDIR_SLASH)stx_goodies_xmlsuite_core.$(O) \
    $(OUTDIR_SLASH)XMLv2__Attr.$(O) \
    $(OUTDIR_SLASH)XMLv2__CharacterData.$(O) \
    $(OUTDIR_SLASH)XMLv2__ContentHandler.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOM3XMLReader.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOMException.$(O) \
    $(OUTDIR_SLASH)XMLv2__DTDHandler.$(O) \
    $(OUTDIR_SLASH)XMLv2__Document.$(O) \
    $(OUTDIR_SLASH)XMLv2__DocumentFragment.$(O) \
    $(OUTDIR_SLASH)XMLv2__DocumentType.$(O) \
    $(OUTDIR_SLASH)XMLv2__Element.$(O) \
    $(OUTDIR_SLASH)XMLv2__Entity.$(O) \
    $(OUTDIR_SLASH)XMLv2__EntityReference.$(O) \
    $(OUTDIR_SLASH)XMLv2__EntityResolver.$(O) \
    $(OUTDIR_SLASH)XMLv2__ErrorHandler.$(O) \
    $(OUTDIR_SLASH)XMLv2__ExpatXMLReader.$(O) \
    $(OUTDIR_SLASH)XMLv2__IndentingXMLWriter.$(O) \
    $(OUTDIR_SLASH)XMLv2__NamedNodeMap.$(O) \
    $(OUTDIR_SLASH)XMLv2__Notation.$(O) \
    $(OUTDIR_SLASH)XMLv2__ProcessingInstruction.$(O) \
    $(OUTDIR_SLASH)XMLv2__SAXParseError.$(O) \
    $(OUTDIR_SLASH)XMLv2__XMLGenerator.$(O) \
    $(OUTDIR_SLASH)XMLv2__XMLSuiteDOM3Implementation.$(O) \
    $(OUTDIR_SLASH)XMLv2__Attributes.$(O) \
    $(OUTDIR_SLASH)XMLv2__CDATASection.$(O) \
    $(OUTDIR_SLASH)XMLv2__Comment.$(O) \
    $(OUTDIR_SLASH)XMLv2__DOM3Builder.$(O) \
    $(OUTDIR_SLASH)XMLv2__IndentingAndHighlightingXMLWriter.$(O) \
    $(OUTDIR_SLASH)XMLv2__Text.$(O) \
    $(OUTDIR_SLASH)extensions.$(O) \




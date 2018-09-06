"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_xml_vw
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!

!stx_goodies_xml_vw class methodsFor:'documentation'!

documentation
"
    Package documentation:

    Contains the opensourced and free licenced VisualWorks XML parser.
    You will need the ST/X specific changes in the xml/stx package to work under ST/X.
    Loading the xml/stx package will pull in the xml/vw parts as well

    [author:]
        imported from vw

    [primary maintainer:]
        cg, sv
"
! !

!stx_goodies_xml_vw class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'exept:xml/inspector'    "XML::XMLInspector - referenced by XML::Node>>inspector2TabTree "
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes.
     Please take a look at the #referencedPreRequisites method as well."

    ^ #(
        #'stx:libbasic'    "Collection - superclass of XML::NodeSet"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     These packages are NOT needed as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes.
     Please also take a look at the #mandatoryPreRequisites method"

    ^ #(
        #'stx:libbasic3'    "ClassCommentChange - referenced by XML::SourceScannerNodeBuilder>>scan_comment:"
        #'stx:libcompat'    "BindingReference - referenced by XML::SourceScannerNodeBuilder>>scan_class:"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine #referencedPrerequisites or #mandatoryPreRequisites."

    ^ #(
    )
! !

!stx_goodies_xml_vw class methodsFor:'description - compilation'!

additionalBaseAddressDefinition_bc_dot_mak
    "this is an optional definition, which (if present) may speed up the dll-loading a little
     on win32 systems."

    ^ '
# see stdHeader_bc for LIBXMLVW_BASE
LIB_BASE=$(LIBXMLVW_BASE)
'
! !

!stx_goodies_xml_vw class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'XML::AttributeDef'
        #'XML::AttributeType'
        #'XML::DocumentType'
        #'XML::ElementContext'
        #'XML::Node'
        #'XML::NodeSet'
        #'XML::NodeTag'
        #'XML::Pattern'
        #'XML::SAXDriver'
        #'XML::SAXLocator'
        #'XML::StreamWrapper'
        #'XML::URIResolver'
        #'XML::XMLNodeBuilder'
        #'XML::XMLParser'
        #'XML::XMLSignal'
        #'stx_goodies_xml_vw'
        #'XML::Attribute'
        #'XML::CDATA_AT'
        #'XML::Comment'
        #'XML::ComplexPattern'
        #'XML::ConcretePattern'
        #'XML::DOM_SAXDriver'
        #'XML::Document'
        #'XML::ENTITIES_AT'
        #'XML::ENTITY_AT'
        #'XML::Element'
        #'XML::Entity'
        #'XML::Enumeration_AT'
        #'XML::IDREFS_AT'
        #'XML::IDREF_AT'
        #'XML::ID_AT'
        #'XML::InvalidSignal'
        #'XML::MalformedSignal'
        #'XML::NMTOKENS_AT'
        #'XML::NMTOKEN_AT'
        #'XML::NOTATION_AT'
        #'XML::NodeBuilder'
        #'XML::Notation'
        #'XML::OXSAXTestDriver'
        #'XML::PI'
        #'XML::SAXWriter'
        #'XML::SourceNodeBuilder'
        #'XML::SourceScannerNodeBuilder'
        #'XML::Text'
        #'XML::XMLParserStX'
        #'XML::AnyPattern'
        #'XML::ChoicePattern'
        #'XML::DiscardingNodeBuilder'
        #'XML::DocumentFragment'
        #'XML::EmptyPattern'
        #'XML::GeneralEntity'
        #'XML::InitialPattern'
        #'XML::MixedPattern'
        #'XML::ModifiedPattern'
        #'XML::NamePattern'
        #'XML::PCDATAPattern'
        #'XML::ParameterEntity'
        #'XML::SAXBuilder'
        #'XML::SequencePattern'
        #'XML::TerminalPattern'
        (#'XML::OXSAXTests' autoload)
        (#'XML::PseudoCharacterTable' autoload)
        (#'XML::SAXIndenter' autoload)
        (#'XML::TestXMLParser' autoload)
        (#'XML::XMLParserTests' autoload)
    )
!

extensionMethodNames
    "lists the extension methods which are to be included in the project.
     Entries are 2-element array literals, consisting of class-name and selector.
     A correponding method with real names must be present in my concrete subclasses
     if it has extensions."

    ^ #(
        Object isDocument
    )
! !

!stx_goodies_xml_vw class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in nt.def / bc.def"

    ^ 'Smalltalk/X XML Framework (VW)'
!

legalCopyright
    "Return copyright string which will appear in <lib>.rc"

    ^ nil
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_xml_vw class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/stx_goodies_xml_vw.st,v 1.22 2017-12-13 14:30:54 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/stx_goodies_xml_vw.st,v 1.22 2017-12-13 14:30:54 stefan Exp $'
! !


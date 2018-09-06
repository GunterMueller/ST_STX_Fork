"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_xmlsuite_core
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_xmlsuite_core class methodsFor:'description'!

excludedFromPreRequisites  
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
        #'stx:goodies/xmlsuite/xmlreaderimpl'
        #'stx:goodies/sunit'
        
    )

    "Modified: / 17-08-2006 / 19:48:59 / cg"
    "Created: / 20-06-2009 / 16:50:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 10-01-2010 / 11:07:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:libbasic'    "ArrayedCollection - extended"
        #'stx:libview2'    "ApplicationModel - superclass of XMLv2::DOM3Inspector"
        #'stx:libwidg2'    "AbstractHierarchicalItem - superclass of XMLv2::DOM3Inspector::DOM3NodeItem"
    )
!

referencedPreRequisites
    "list packages which are a prerequisite, because they contain
     classes which are referenced by my classes.
     We do not need these packages as a prerequisite for compiling or loading,
     however, a class from it may be referenced during execution and having it
     unloaded then may lead to a runtime doesNotUnderstand error, unless the caller
     includes explicit checks for the package being present.
     This method is generated automatically,
     by searching all classes (and their packages) which are referenced by my classes."

    ^ #(
        #'stx:libbasic2'    "Random - referenced by XMLv2::XMLGenerator>>generateAttributeValue"
        #'stx:libtool'    "InspectorView - referenced by XMLv2::DOM3Inspector>>domNodeInspectorView"
        #'stx:libview'    "Color - referenced by XMLv2::IndentingAndHighlightingXMLWriter class>>attributeValueColor"
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
    )
! !

!stx_goodies_xmlsuite_core class methodsFor:'description - compilation'!

additionalDefinitions_bc_dot_mak
    "allows for additional definitions/rules to be added to the bc.mak file.
     Subclasses may redefine this."

    ^ '
LIBEXPAT_DIR=expat-2.0.1
!!ifdef USEMINGW64
LIBEXPAT=$(LIBEXPAT_DIR)/.libs/libexpat.a
LIBEXPAT_TARGET   = x86_64-w64-mingw32
!!else
!! ifdef USEMINGW32
LIBEXPAT=$(LIBEXPAT_DIR)/.libs/libexpat.a
LIBEXPAT_TARGET   = i686-pc-mingw32
!! else
LIBEXPAT$(LIBEXPAT_DIR)/bcb5/release/libexpats_mtd.lib
!! endif
!!endif      
'

    "Created: / 02-02-2016 / 22:19:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-02-2016 / 02:06:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalDefinitions_make_dot_proto
    "allows for additional definitions/rules to be added to the bc.mak file.
     Subclasses may redefine this."

    ^ '
LIBEXPAT_DIR=expat-2.0.1
LIBEXPAT=expat-2.0.1/lib/libexpat.a
'

    "Created: / 05-02-2016 / 02:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalLinkLibraries_bc_dot_mak
    "allows for additional static libraries to be added to the bc.mak file.
     Subclasses may redefine this"

    "backward compatibilty with old projects"

    ^'$(LIBEXPAT)'

    "Created: / 09-01-2010 / 14:01:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-02-2016 / 22:19:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalLinkLibraries_make_dot_proto
    "allows for additional static libraries to be added to the make.proto file."

    ^'$(LIBEXPAT)'

    "Created: / 22-08-2006 / 23:53:33 / cg"
    "Modified: / 04-02-2016 / 17:08:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_bc_dot_mak
    "obsolete - kept for compatibility with old project files"
    
    ^ '
!!if defined(USEMINGW32) || defined(USEMINGW64)
$(LIBEXPAT): $(LIBEXPAT_DIR)/config.status
        pushd $(LIBEXPAT_DIR) & set "PATH=C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & make

$(LIBEXPAT_DIR)/config.status:
        pushd $(LIBEXPAT_DIR) & set "PATH=C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & bash configure --build=$(LIBEXPAT_TARGET)

clobber::
        -pushd $(LIBEXPAT_DIR) & set "PATH=C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & IF EXIST makefile (make distclean)

clean::
        -pushd $(LIBEXPAT_DIR) & set "PATH=C:\MINGW\MSYS\1.0\bin;C:\MSYS\1.0\bin;%%PATH%%" & IF EXIST makefile (make clean)

!!else
$(LIBEXPAT):
        pushd $(LIBEXPAT_DIR)
        $(MAKE_BAT)
        popd
!!endif
'

    "Created: / 09-01-2010 / 14:03:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-02-2016 / 02:20:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalRules_make_dot_proto
    "allows for additional rules to be added to the make.proto file."

    ^ '
$(LIBEXPAT): $(LIBEXPAT_DIR)/config.status
        $(MAKE) -C expat-2.0.1
        $(MAKE) -C expat-2.0.1 install

$(LIBEXPAT_DIR)/config.status:
        cd $(LIBEXPAT_DIR) && CC=$(CC) CFLAGS="$(CCCONFOPT) -fPIC" ./configure --prefix=$$PWD

clobber::
        -$(MAKE) -C $(LIBEXPAT_DIR) distclean

clean::
        -$(MAKE) -C $(LIBEXPAT_DIR) clean

        
'

    "Created: / 22-08-2006 / 23:59:16 / cg"
    "Modified: / 05-02-2016 / 02:27:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_bc_dot_mak
    "obsolete - kept for compatibility with old project files"
    
    ^ '$(LIBEXPAT)'

    "Created: / 09-01-2010 / 14:02:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-02-2016 / 22:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

additionalTargets_make_dot_proto
    "allows for additional targets to be added to the make.proto file."

    ^ '$(LIBEXPAT)'

    "Created: / 22-08-2006 / 23:53:33 / cg"
    "Modified: / 04-02-2016 / 17:07:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

localIncludes
    "allow for the specification of additional include directories"

    ^ '-I$(LIBEXPAT_DIR)/lib'

    "Created: / 09-01-2010 / 14:03:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-02-2016 / 02:08:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_xmlsuite_core class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        (BenchmarkXML autoload)
        #'XMLv2::AbstractSAX2Handler'
        #'XMLv2::DOM3Inspector'
        #'XMLv2::DOM3NodeDumper'
        #'XMLv2::DOMConfiguration'
        #'XMLv2::DOMError'
        #'XMLv2::DOMErrorHandler'
        #'XMLv2::DOMErrorMonitor'
        #'XMLv2::DOMImplementation'
        #'XMLv2::DOMImplementationRegistry'
        #'XMLv2::InputSource'
        #'XMLv2::NameList'
        #'XMLv2::Node'
        #'XMLv2::NodeList'
        #'XMLv2::NodeName'
        #'XMLv2::ParseError'
        #'XMLv2::Parser'
        #'XMLv2::SAXError'
        #'XMLv2::TypeInfo'
        #'XMLv2::UserDataHandler'
        #'XMLv2::XMLBuilder'
        #'XMLv2::XMLEventRecorder'
        #'XMLv2::XMLReader'
        #'XMLv2::XMLReaderImplementationQuery'
        #'XMLv2::XMLWriter'
        #'stx_goodies_xmlsuite_core'
        #'XMLv2::Attr'
        #'XMLv2::CharacterData'
        #'XMLv2::ContentHandler'
        #'XMLv2::DOM3XMLReader'
        #'XMLv2::DOMException'
        #'XMLv2::DTDHandler'
        #'XMLv2::Document'
        #'XMLv2::DocumentFragment'
        #'XMLv2::DocumentType'
        #'XMLv2::Element'
        #'XMLv2::Entity'
        #'XMLv2::EntityReference'
        #'XMLv2::EntityResolver'
        #'XMLv2::ErrorHandler'
        #'XMLv2::ExpatXMLReader'
        #'XMLv2::IndentingXMLWriter'
        #'XMLv2::NamedNodeMap'
        #'XMLv2::Notation'
        #'XMLv2::ProcessingInstruction'
        #'XMLv2::SAXParseError'
        #'XMLv2::XMLGenerator'
        #'XMLv2::XMLSuiteDOM3Implementation'
        #'XMLv2::Attributes'
        #'XMLv2::CDATASection'
        #'XMLv2::Comment'
        #'XMLv2::DOM3Builder'
        #'XMLv2::IndentingAndHighlightingXMLWriter'
        #'XMLv2::Text'
        (#'XMLv2::AbstractDOM3TestCase' autoload)
        (#'XMLv2::AbstractW3CDOM3TestCase' autoload)
        (#'XMLv2::DOM3Tests' autoload)
        (#'XMLv2::DOMBuilder' autoload)
        (#'XMLv2::EncodingTests' autoload)
        (#'XMLv2::JamesClarkCanonicalXMLWriterTestResource' autoload)
        (#'XMLv2::JamesClarkCanonicalXMLWriterTests' autoload)
        (#'XMLv2::JamesClarkXMLTests' autoload)
        (#'XMLv2::NodeNameTests' autoload)
        (#'XMLv2::OASISXMLTests' autoload)
        (#'XMLv2::W3XMLTestSuiteResource' autoload)
        (#'XMLv2::XMLBuilderTests' autoload)
        (#'XMLv2::XMLReaderTests' autoload)
        (#'XMLv2::XMLWriterTests' autoload)
        (#'XMLv2::CincomDOMXMLReader' autoload)
        (#'XMLv2::CincomImplementation' autoload)
        (#'XMLv2::JamesClarkCanonicalXMLWriter' autoload)
        (#'XMLv2::NodeTests' autoload)
        (#'XMLv2::W3CDOM3CoreTests' autoload)
        (#'XMLv2::OldXMLWriter' autoload)
        (#'XMLv2::XMLSyntaxHighlightingWriter' autoload)
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        Character isInXMLCharSpec:
        Character isXMLBaseChar
        Character isXMLChar
        Character isXMLCombiningChar
        Character isXMLDigit
        Character isXMLExtender
        Character isXMLIdeographic
        Character isXMLLetter
        Character isXMLPubidChar
        Character isXMLWhiteSpace
        CharacterArray asJamesClarkCanonicalXMLEscapedString
        CharacterArray asXMLEscapedString
        Character xmlBaseCharValues
        Character xmlCombiningCharValues
        Character xmlDigitValues
        Character xmlExtenderValues
    )
! !

!stx_goodies_xmlsuite_core class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'eXept Software AG'
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Class library'
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Claus Gittinger 1988-2008\nCopyright eXept Software AG 1998-2008'
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Smalltalk/X'
! !

!stx_goodies_xmlsuite_core class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
    "        

    ^ '$URL$'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'287M'"$"
! !

!stx_goodies_xmlsuite_core class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


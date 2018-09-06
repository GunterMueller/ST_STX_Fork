"{ Package: 'stx:goodies/xmlsuite/xmlreaderimpl' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_xmlsuite_xmlreaderimpl
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_xmlsuite_xmlreaderimpl class methodsFor:'description'!

excludedFromPreRequisites
    "list packages which are to be explicitely excluded from the automatic constructed
     prerequisites list. If empty, everything that is found along the inheritance of any of
     my classes is considered to be a prerequisite package."

    ^ #(
    )
!

mandatoryPreRequisites
    "list packages which are mandatory as a prerequisite.
     This are packages containing superclasses of my classes and classes which
     are extended by myself.
     They are mandatory, because we need these packages as a prerequisite for loading and compiling.
     This method is generated automatically,
     by searching along the inheritance chain of all of my classes."

    ^ #(
        #'stx:goodies/xml/vw'    "XML::NodeBuilder - superclass of XMLv2::VWSAXBuilder"
        #'stx:goodies/xmlsuite/core'    "XMLv2::XMLReader - superclass of XMLv2::VWXMLReader"
        #'stx:libbasic'    "LibraryDefinition - superclass of stx_goodies_xmlsuite_xmlreaderimpl"
    )
!

postLoadAction
	"
    | packageDir expatXMLReaderLib |
    packageDir := Smalltalk getPackageDirectoryForPackage: self package. 

    expatXMLReaderLib := ((packageDir construct: 'precompiled') construct: Smalltalk versionString) construct:
                                    ('XMLv2__ExpatXMLReader' , 
                                    ObjectFileLoader sharedLibraryExtension). 
    expatXMLReaderLib exists ifFalse:
        [expatXMLReaderLib := ((packageDir construct: 'precompiled') construct: 'common') construct:
                                        ('XMLv2__ExpatXMLReader' , 
                                        ObjectFileLoader sharedLibraryExtension)].
    expatXMLReaderLib exists ifTrue:
        [Transcript showCR:'Loading precompiled ExpatXMLReader class from: ' , expatXMLReaderLib nameString.
        ObjectFileLoader loadObjectFile: expatXMLReaderLib nameString].
	"
	
    "
        self postLoadAction   
    "

    "Modified: / 25-03-2009 / 13:46:27 / Martin Plicka <plickm1@fel.cvut.cz>"

!

preLoadAction
	"
	ObjectFileLoader searchedLibraries:
	        (ObjectFileLoader searchedLibraries asOrderedCollection
			add: '/usr/lib/libexpat.so';
			yourself) asArray
	"
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
    )
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites."

    ^ #(
    )
! !

!stx_goodies_xmlsuite_xmlreaderimpl class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        #'XMLv2::VWSAXBuilder'
        #'XMLv2::VWXMLReader'
        #'stx_goodies_xmlsuite_xmlreaderimpl'
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
    )
! !

!stx_goodies_xmlsuite_xmlreaderimpl class methodsFor:'description - project information'!

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

!stx_goodies_xmlsuite_xmlreaderimpl class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
     Do not make the string shorter!!!!!! We have to use fixed-length keyword!!!!!!
    "        

    ^ '$URL::                                                                                                                        $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'266             '"$"
! !

!stx_goodies_xmlsuite_xmlreaderimpl class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


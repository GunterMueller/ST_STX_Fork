"{ Package: 'stx:goodies/cypress' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_cypress
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_cypress class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

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
        #'stx:libbasic'    "ArithmeticValue - extended"
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
        #'stx:libbasic3'    "ChangeSet - referenced by CypressModel>>asChangeSet"
        #'stx:libcomp'    "Parser - referenced by CypressMethod>>source:"
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

!stx_goodies_cypress class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        CypressAbstractReaderWriter
        CypressJSONReader
        CypressModel
        #'stx_goodies_cypress'
        CypressAbstractReader
        CypressAbstractWriter
        CypressClass
        CypressMethod
        CypressPackage
        CypressRepository
        CypressFileTreeReader
        CypressReader
        CypressWriter
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        CharacterArray withLineEndings:
        'CharacterArray class' lfString
        Array asCypressPropertyObject
        Array writeCypressJsonOn:forHtml:indent:
        Boolean writeCypressJsonOn:forHtml:indent:
        Character isSafeForHTTP
        Class asCypressClassDefinition
        Dictionary asCypressPropertyObject
        Dictionary writeCypressJsonOn:forHtml:indent:
        Number writeCypressJsonOn:forHtml:indent:
        Object asCypressPropertyObject
        String asCypressPropertyObject
        String encodeForHTTP
        String writeCypressJsonOn:forHtml:indent:
        Method asCypressMethodDefinition
        'ConfigurableFeatures class' hasCypress
        PackageId asCypressPackage
        Symbol asCypressPackage
        'ProjectDefinition class' asCypressPackage
    )
! !

!stx_goodies_cypress class methodsFor:'description - project information'!

applicationIconFileName
    "Return the name (without suffix) of an icon-file (the app's icon); will be included in the rc-resource file"

    ^ nil
    "/ ^ self applicationName
!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Jan Vrany'

    "Modified: / 11-09-2012 / 11:54:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Cypress Package Format Reader/Writer'

    "Modified: / 11-09-2012 / 11:54:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ 'Copyright Jan Vrany & Dale Henrichs 2012'

    "Modified: / 11-09-2012 / 11:54:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productInstallDirBaseName
    "Returns a default installDir which will appear in <app>.nsi.
     This is usually not the one you want to keep"

    ^ (self package asCollectionOfSubstringsSeparatedByAny:':/') last
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Cypress'

    "Modified: / 11-09-2012 / 11:55:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_cypress class methodsFor:'description - svn'!

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

    ^ "$SVN-Revision:"'21              '"$"
! !

!stx_goodies_cypress class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id::                                                                                                                        $'
! !


"{ Package: 'stx:goodies/petitparser' }"

"{ NameSpace: Smalltalk }"

LibraryDefinition subclass:#stx_goodies_petitparser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'* Projects & Packages *'
!


!stx_goodies_petitparser class methodsFor:'accessing'!

monticelloPackageName
    "hook for packages which have been loaded from monticello"

    ^ 'PetitParser'

    "Created: / 17-12-2010 / 19:44:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser class methodsFor:'accessing - monticello'!

monticelloLastMergedVersionInfo
    "The last merged version is: "

    ^ '
    Name: PetitParser-JanKurs.253
    Author: JanKurs
    Time: 30-10-2014, 03:55:46 AM
    UUID: c7100f9c-e875-4453-8f26-e0c91dd49b91
    Repository: http://smalltalkhub.com/mc/Moose/PetitParser/main
    '

    "Created: / 03-10-2014 / 02:27:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-11-2014 / 08:27:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

monticelloName
    "Return name of the package for Monticello. This is used when package is exported"

    ^ 'PetitParser'

    "Created: / 03-10-2014 / 01:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser class methodsFor:'accessing - tests'!

testSuite
    "generate and return a testSuite containing all of my test-classes"

    Smalltalk loadPackage: 'stx:goodies/petitparser/tests'.
    ^ 'stx:goodies/petitparser/tests' asPackageId projectDefinitionClass testSuite

! !

!stx_goodies_petitparser class methodsFor:'description'!

excludedFromPreRequisites
    "list all packages which should be ignored in the automatic
     preRequisites scan. See #preRequisites for more."

    ^ #(
        #'stx:goodies/monticello'    "MCDirectoryRepository - referenced by stx_goodies_petitparser class>>monticelloExportTo:"
        #'stx:libscm/mercurial'    "HGPackageWorkingCopy - referenced by stx_goodies_petitparser class>>monticelloExportTo:"
        #'stx:libscm/mercurial/monticello'    "HGMCVersionInfo - referenced by stx_goodies_petitparser class>>monticelloExportTo:"
        #'stx:libwidg'    "ScrollableView - referenced by PPParser>>inspector2TabTree"
        #'stx:libwidg2'    "HierarchicalListView - referenced by PPParser>>inspector2TabTree"            
    )

    "Modified: / 03-06-2015 / 08:47:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
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
        #'stx:libbasic2'    "Text - extended"
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
    )
!

stcOptimizationOptions
    "do not inline the not operation here - it is overwritten"

    ^ '+optspace3 -inlinenot'

    "Created: / 23-08-2006 / 01:27:22 / cg"
!

subProjects
    "list packages which are known as subprojects.
     The generated makefile will enter those and make there as well.
     However: they are not forced to be loaded when a package is loaded;
     for those, redefine requiredPrerequisites"

    ^ #(
        #'stx:goodies/petitparser/analyzer'
        #'stx:goodies/petitparser/tests'
        #'stx:goodies/petitparser/parsers/smalltalk'
        #'stx:goodies/petitparser/parsers/java'
        #'stx:goodies/petitparser/compiler'
)
! !

!stx_goodies_petitparser class methodsFor:'description - compilation'!

additionalRules_make_dot_proto
    "allows for additional rules to be added to the make.proto file."

    ^ '
mc:
	mkdir mc

mcz: mc
	$(TOP)/projects/smalltalk/smalltalk --eval "                            \
		Class tryLocalSourceFirst: true.				\
		Smalltalk packagePath add:''$(TOP)/..'' .                       \
		Smalltalk loadPackage:''stx:goodies/petitparser''.              \
		(Smalltalk at: #''stx_goodies_petitparser'') monticelloExportTo: ''mc''.\
		Smalltalk exit: 0."

'

    "Created: / 04-10-2014 / 21:45:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser class methodsFor:'description - contents'!

classNamesAndAttributes
    "lists the classes which are to be included in the project.
     Each entry in the list may be: a single class-name (symbol),
     or an array-literal consisting of class name and attributes.
     Attributes are: #autoload or #<os> where os is one of win32, unix,..."

    ^ #(
        "<className> or (<className> attributes...) in load order"
        PPCharSetPredicate
        PPContext
        PPContextMemento
        PPFailure
        PPMemento
        PPParser
        PPStream
        PPToken
        #'stx_goodies_petitparser'
        PPDelegateParser
        PPEndOfFileParser
        PPEndOfLineParser
        PPEpsilonParser
        PPFailingParser
        PPListParser
        PPLiteralParser
        PPPluggableParser
        PPPredicateParser
        PPStartOfLine
        PPStartOfLineParser
        PPStartOfLogicalLineParser
        PPStartOfWordParser
        PPUnresolvedParser
        PPActionParser
        PPAndParser
        PPChoiceParser
        PPCompositeParser
        PPConditionalParser
        PPEndOfInputParser
        PPExpressionParser
        PPFlattenParser
        PPLiteralObjectParser
        PPLiteralSequenceParser
        PPMemoizedParser
        PPNotParser
        PPOptionalParser
        PPPredicateObjectParser
        PPPredicateSequenceParser
        PPRepeatingParser
        PPSequenceParser
        PPTrimmingParser
        PPLimitedChoiceParser
        PPLimitedRepeatingParser
        PPPossessiveRepeatingParser
        PPTokenParser
        PPWrappingParser
        PPGreedyRepeatingParser
        PPLazyRepeatingParser
    )
!

extensionMethodNames
    "list class/selector pairs of extensions.
     A correponding method with real names must be present in my concrete subclasses"

    ^ #(
        Block asParser
        BlockContext asParser
        Character asParser
        Collection asChoiceParser
        Collection asSequenceParser
        Interval asParser
        Object asParser
        Object isPetitFailure
        Object isPetitParser
        PositionableStream asPetitStream
        SequenceableCollection asPetitStream
        Set asParser
        Stream asPetitStream
        String asParser
        Symbol asParser
        Symbol value:
        Text asPetitStream
        UndefinedObject asParser
        PositionableStream peekTwice
        Collection asParser
    )
! !

!stx_goodies_petitparser class methodsFor:'description - monticello'!

monticelloTimestamps

    ^#(
    )
! !

!stx_goodies_petitparser class methodsFor:'description - project information'!

companyName
    "Return a companyname which will appear in <lib>.rc"

    ^ 'Lukas Renggli & SWING Research Group'

    "Modified: / 17-12-2010 / 19:43:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a description string which will appear in vc.def / bc.def"

    ^ 'Smalltalk/X Scannerless Parser & Parser Combinator Library'

    "Modified: / 17-12-2010 / 19:43:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

legalCopyright
    "Return a copyright string which will appear in <lib>.rc"

    ^ '(C) Lukas Renggli'

    "Modified: / 17-12-2010 / 19:43:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

productName
    "Return a product name which will appear in <lib>.rc"

    ^ 'Petit Parser'

    "Modified: / 17-12-2010 / 19:43:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser class methodsFor:'description - svn'!

svnRepositoryUrlString
    "Return a SVN repository URL of myself.
     (Generated since 2011-04-08)
    "

    ^ '$URL: https://vranyj1@swing.fit.cvut.cz/svn/squeak/petitparser/trunk/squeak_petitparser.st $'
!

svnRevisionNr
    "Return a SVN revision number of myself.
     This number is updated after a commit"

    ^ "$SVN-Revision:"'11              '"$"
! !

!stx_goodies_petitparser class methodsFor:'utilities - monticello'!

monticelloExportTo: directory
    "Export .mcz packages to given directory"

    | packages message exporter mcrepo hgrev hgrepo |

    Smalltalk loadPackage: 'stx:goodies/monticello'.
    Smalltalk loadPackage: 'stx:libscm/mercurial/monticello'.
    Class tryLocalSourceFirst: true.

    packages := #(
        'stx:goodies/petitparser'
        'stx:goodies/petitparser/tests'
        'stx:goodies/petitparser/analyzer'
        'stx:goodies/petitparser/analyzer/tests'

        'stx:goodies/petitparser/parsers/smalltalk'
        'stx:goodies/petitparser/parsers/smalltalk/tests'
        'stx:goodies/petitparser/parsers/java'

        'stx:goodies/petitparser/compiler'
        'stx:goodies/petitparser/compiler/tests'
        'stx:goodies/petitparser/compiler/tests/extras'
        'stx:goodies/petitparser/compiler/benchmarks'
    ).

    packages do:[:pkgnm |
        Smalltalk loadPackage: pkgnm. 
    ].

    packages do:[:pkgnm | 
        | pm cs |

        pm := HGPackageWorkingCopy named: pkgnm.
        hgrepo isNil ifTrue:[
            hgrepo := pm repository.
        ].
        hgrev isNil ifTrue:[ 
            hgrev := pm revision.
        ] ifFalse:[ 
            hgrev = pm revision ifFalse:[ 
                self error: 'Package revisions differ!!'
            ].
        ].
    ].

    message := (hgrepo @ hgrev) messageDigest.

    exporter := [:pkgnm|
        | mcpkg mcwc mcvi mcversion |

        Stdout nextPutAll: 'Exporting '; nextPutLine: pkgnm.
        mcpkg := MCPackage named: pkgnm.
        mcwc := mcpkg workingCopy.        
        mcvi := HGMCVersionInfo forPackage: pkgnm.
        mcvi message: message.        
        [
           mcversion := mcwc newVersion.
           mcversion snapshot options includeExtrasForSTX: false.
        ] on: MCVersionNameAndMessageRequest do:[:ex |
            ex resume: (Array with: mcvi name with: message)
        ].
        mcversion info: mcvi.	
        mcrepo storeVersion: mcversion.
    ].

    mcrepo := MCDirectoryRepository new directory: directory.
    packages do: exporter.

    "
    stx_goodies_petitparser monticelloExportTo: '/tmp'
    "

    "Created: / 04-10-2014 / 21:30:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2015 / 00:20:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_petitparser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/stx_goodies_petitparser.st,v 1.15 2014-03-04 20:30:48 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/petitparser/stx_goodies_petitparser.st,v 1.15 2014-03-04 20:30:48 cg Exp $'
!

version_HG
    ^ '$Changeset: <not expanded> $'
!

version_MC
    ^ '$PetitParser-lr.231 a18ceb3c-e6d2-4b74-91c9-33f05d2e0514 2013-03-16T21:51:30 lr$'
!

version_SVN
    ^ '$Id: stx_goodies_petitparser.st,v 1.15 2014-03-04 20:30:48 cg Exp $'
! !


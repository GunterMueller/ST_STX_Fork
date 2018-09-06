"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#ProjectProblem
	instanceVariableNames:'package fixes allProblems'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Projects'
!

ProjectProblem subclass:#ClassProblem
	instanceVariableNames:'className'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::ClassProblem subclass:#InconsistentProjectDefinition
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::InconsistentProjectDefinition subclass:#ClassListedBeforeItsPool
	instanceVariableNames:'poolName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::InconsistentProjectDefinition subclass:#ClassListedBeforeItsSuperclass
	instanceVariableNames:'superClassName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::InconsistentProjectDefinition subclass:#ClassListedButDoesNotExist
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::InconsistentProjectDefinition subclass:#ClassListedButInOtherPackage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::InconsistentProjectDefinition subclass:#ClassListedMultipleTimes
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::InconsistentProjectDefinition subclass:#ClassNotListed
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::InconsistentProjectDefinition subclass:#ClassIsCompiledButSuperclassIsAutoloaded
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::InconsistentProjectDefinition subclass:#ClassShouldNotBeInPackage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::ClassProblem subclass:#ClassUsesPoolProblem
	instanceVariableNames:'poolName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::ClassUsesPoolProblem subclass:#ClassUsesPoolButItIsNotASharedPool
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::ClassUsesPoolProblem subclass:#ClassUsesPoolInNamespaceButNamespaceIsNotDefined
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::ClassUsesPoolProblem subclass:#ClassUsesPoolButItDoesNotExist
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::ClassProblem subclass:#MethodProblem
	instanceVariableNames:'selector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::MethodProblem subclass:#ExtensionMethodListedButInDifferentPackage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::MethodProblem subclass:#ExtensionMethodNotListed
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::MethodProblem subclass:#ExtensionMethodsClassDoesNotExist
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::InconsistentProjectDefinition subclass:#ClassIsCompiledButSuperclassProjectDefinitionIsMissing
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem subclass:#InvalidPackageName
	instanceVariableNames:'badName'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::MethodProblem subclass:#MethodCompilabilityIssue1
	instanceVariableNames:'errors warnings'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

Object subclass:#Error
	instanceVariableNames:'message startPosition endPosition'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem::MethodCompilabilityIssue1
!

Object subclass:#Warning
	instanceVariableNames:'message startPosition endPosition'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem::MethodCompilabilityIssue1
!

ProjectProblem::MethodProblem subclass:#MethodCompilabilityIssue2
	instanceVariableNames:'rules errors warnings'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::MethodProblem subclass:#MethodInNoPackage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::MethodProblem subclass:#MethodListedInOtherPackage
	instanceVariableNames:'otherProjectDefinitionClasses'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::MethodProblem subclass:#ExtensionMethodListedButDoesNotExist
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::MethodProblem subclass:#MethodSourceCorrupted
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem::MethodProblem subclass:#MethodSourceNotAvailable
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

ProjectProblem subclass:#ProjectDefinitionDoesNotExist
	instanceVariableNames:'missing'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ProjectProblem
!

!ProjectProblem class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    I represent a problem as detected by the project consistency checker,
    which is optionally executed before committing a package to a repository.
    Typically, I find inconsistencies, uncompilable methods or missing prerequisites,
    which might lead to trouble when the package is later to be compiled to a dll via stc.

    [instance variables:]
        package         - the package in question

        fixes           - a collection of possible fixes
                          (to be shown in the HTML view of the problem browser)

        allProblems     - the collection of problems I am part of
                          (only needed to be able to do the 
                           'fix other problems of this kind' operation,
                           for example in the MethodOnNoPackage problem.)

    [see also:]
        ProjectChecker ProjectDefinition
"
! !

!ProjectProblem class methodsFor:'instance creation'!

newClassIsCompiledButSuperclassIsAutoloaded

    ^ClassIsCompiledButSuperclassIsAutoloaded new

    "Created: / 20-09-2013 / 11:18:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newClassIsCompiledButSuperclassProjectDefinitionIsMissing

    ^ClassIsCompiledButSuperclassProjectDefinitionIsMissing new

    "Created: / 05-10-2013 / 12:43:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newClassListedBeforeItsPool

    ^ClassListedBeforeItsPool new

    "Created: / 13-09-2012 / 17:13:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newClassListedBeforeItsSuperclass

    ^ClassListedBeforeItsSuperclass new

    "Created: / 13-09-2012 / 17:13:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newClassListedButDoesNotExist

    ^ClassListedButDoesNotExist new

    "Created: / 23-02-2012 / 13:18:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newClassListedButInOtherPackage

    ^ClassListedButInOtherPackage new
!

newClassListedMultipleTimes

    ^ClassListedMultipleTimes new

    "Created: / 13-09-2012 / 17:40:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newClassNotListed

    ^ClassNotListed new

    "Created: / 23-02-2012 / 13:59:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newClassShouldNotBeInPackage

    ^ClassShouldNotBeInPackage new
!

newClassUsesPoolButItDoesNotExist

    ^ClassUsesPoolButItDoesNotExist new

    "Created: / 23-02-2012 / 13:37:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newClassUsesPoolButItIsNotASharedPool

    ^ClassUsesPoolButItIsNotASharedPool new

    "Created: / 23-02-2012 / 13:48:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newClassUsesPoolInNamespaceButNamespaceIsNotDefined

    ^ClassUsesPoolInNamespaceButNamespaceIsNotDefined new

    "Created: / 13-09-2012 / 16:40:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newExtensionMethodListedButDoesNotExist

    ^ExtensionMethodListedButDoesNotExist new

    "Created: / 23-02-2012 / 14:26:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newExtensionMethodListedButInDifferentPackage

    ^ExtensionMethodListedButInDifferentPackage new
!

newExtensionMethodNotListed

    ^ExtensionMethodNotListed new

    "Created: / 23-02-2012 / 14:27:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newExtensionMethodsClassDoesNotExist

    ^ExtensionMethodsClassDoesNotExist new
!

newInvalidPackageName

    ^InvalidPackageName new
!

newMethodCompilabilityIssue1
    ^ MethodCompilabilityIssue1 new

    "Created: / 11-04-2012 / 15:34:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-05-2014 / 15:35:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newMethodCompilabilityIssue2
    ^ MethodCompilabilityIssue2 new

    "Created: / 29-05-2014 / 15:37:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newMethodInNoPackage

    ^MethodInNoPackage new

    "Created: / 23-02-2012 / 14:27:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newMethodListedInOtherPackage

    ^ MethodListedInOtherPackage new
!

newMethodSourceCorrupted

    ^MethodSourceCorrupted new

    "Created: / 11-04-2012 / 12:35:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newMethodSourceNotAvailable

    ^MethodSourceNotAvailable new

    "Created: / 11-04-2012 / 12:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newProjectDefinitionDoesNotExist

    ^ProjectDefinitionDoesNotExist new

    "Created: / 23-02-2012 / 13:08:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem methodsFor:'accessing'!

allProblems:something
    allProblems := something.
!

countOtherProblemsOfThisKind
    ^ allProblems 
        count:
            [:problem | 
                problem class == self class
                and:[ problem ~~ self
                and:[ problem alreadyFixed not]]
            ].
!

description
    "Return a (HTML) describing the problem."

    ^self subclassResponsibility

    "Created: / 23-02-2012 / 13:04:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

descriptionAndFixes
    "Return a (HTML) describing the problem plus possible fixes."

    |descriptionText fixes|

    (self alreadyFixed) ifTrue:[^ 'Already fixed.'].

    descriptionText := self description.

    "/ don't use cached fixes (after a fix, the problem may return an empty fix list)
    fixes := self fixes.
    fixes isEmpty ifTrue:[ ^ descriptionText ].            

    ^String streamContents:[:html |
        html nextPutAll: descriptionText.

        html nextPutAll: '<br><br>'.
        fixes size == 1 ifTrue:[
            html nextPutLine: 'Possible fix:'.
        ] ifFalse:[
            html nextPutLine: 'Possible fixes:'.
        ].
        html nextPutLine:'<ul>'.
        fixes withIndexDo:[:fix :index|
            html
                nextPutAll:'<li><a ACTION="doit: self application doFix: ';
                nextPutAll: index printString;
                nextPutAll:'">';
                nextPutAll: fix first;
                nextPutAll:'</a></li>'.
        ].
        html nextPutLine:'</ul>'.
    ].

    "Created: / 26-07-2012 / 09:46:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

klass
    "Return the class which is subject of the problem.
     To be redefined in problems which are class-related"

    ^ nil
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^self subclassResponsibility

    "Created: / 23-02-2012 / 13:03:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
    ^ package
!

package:aSymbol
    package := aSymbol asSymbol.

    "Modified: / 11-04-2012 / 16:00:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

packageDefinitionClass
    ^ProjectDefinition definitionClassForPackage: package

    "Created: / 23-02-2012 / 13:26:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

severity
    "Return a severity - one of #error, #warning, #info"

    ^#warning "/by default

    "Created: / 23-02-2012 / 13:09:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem methodsFor:'fixing'!

allUnfixedProblemsOfMyKindDo:aBlock
    allProblems do:[:p |
        (p class == self class and:[ p alreadyFixed not]) ifTrue:[
            aBlock value:p
        ]
    ]
!

alreadyFixed
    ^ false
!

doFix: index
    self initializeFixes.
    ^ (fixes at: index) second value

    "Created: / 26-07-2012 / 10:07:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fixes
    "Return (possibly empty) list of description-action pairs that
     the user may take to fix/investigate the problem.
     Returned value should be list of pairs (label, action block).
     To be overriden in subclasses.

     The list should be an array of pairs ( fix label , fix block ).
     Fix block should return true, if the fix was successful,
     false otherwise"

     ^#()

    "Created: / 26-07-2012 / 09:46:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem methodsFor:'initialization'!

initializeFixes

    fixes isNil ifTrue:[
        fixes := self fixes
    ].

    "/ super initialize.   -- commented since inherited method does nothing

    "Created: / 26-07-2012 / 09:54:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem methodsFor:'printing & storing'!

displayOn:aGCOrStream
    |lbl|

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    lbl := self label.
    self alreadyFixed ifTrue:[
        aGCOrStream
            nextPutAll:lbl string;
            emphasis:#italic;
            nextPutAll:' (already fixed)'
    ] ifFalse:[
        aGCOrStream nextPutAll:lbl.
    ].

    "Created: / 14-02-2012 / 17:02:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    self severity printOn:aStream.
    aStream nextPut:$:; space.
    self label printOn:aStream.
    aStream nextPut:$).

    "Modified: / 23-02-2012 / 16:49:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem methodsFor:'utilities-HTML'!

linkToClass: classOrclassName
    | className |

    className := classOrclassName isBehavior
                    ifTrue: [classOrclassName storeString]
                    ifFalse:[classOrclassName].

    ^'<A INFO="Click to browse class" 
ACTION="doit: SystemBrowser default openInClass:%1">
<CODE>%1</CODE></A>'
        bindWith: className

    "Created: / 23-02-2012 / 13:44:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linkToClass: classOrclassName selector: selector
    ^self linkToClass: classOrclassName selector:  selector omitClassName: false

    "Created: / 23-02-2012 / 13:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linkToClass: classOrclassName selector: selector omitClassName: omitClassName

    | className |
    className := classOrclassName isBehavior
                    ifTrue: [classOrclassName name]
                    ifFalse:[classOrclassName].
    ^omitClassName ifTrue:[
        '<A INFO="Click to browse method" 
ACTION="doit: SystemBrowser default openInClass:%1 selector: %2">
<CODE>#%3</CODE></A>'
            bindWith: className
                with: selector storeString
                with: selector
    ] ifFalse:[
        '<A INFO="Click to browse method" 
ACTION="doit: SystemBrowser default openInClass:%1 selector: %2">
<CODE>%1>>%3</CODE></A>'
            bindWith: className
                with: selector storeString
                with: selector
    ]

    "Created: / 26-07-2012 / 10:26:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linkToPackage: packageId

    ^'<A INFO="Click to browse package" 
ACTION="doit: SystemBrowser default openOnPackage:''%1''">
<CODE>%1</CODE></A>'
        bindWith: packageId
! !

!ProjectProblem::ClassProblem methodsFor:'accessing'!

className
    ^ className
!

className:something
    className := something.
!

klass
    "Return the class which is subject of the problem"

"/    | class |
"/
"/    (className endsWith: ' class') ifTrue:[
"/        class := Smalltalk at: (className copyTo: className size - 6) asSymbol.
"/        class := class theMetaclass.
"/    ] ifFalse:[
"/        class := Smalltalk at: className  asSymbol
"/    ].
"/    ^class

    "/ the above is exactly:
    ^ Smalltalk classNamed:className

    "Created: / 26-07-2012 / 10:21:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassProblem methodsFor:'fixing'!

doUpdateAllProjectDefinitions
    "full update the project definition class;
     will do a rescan to add all missing items"

    | def |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].

    def
        updateMethodsCodeUsingCompiler:Compiler 
        ignoreOldDefinition:false.

    UserNotification notify: ('Project definitions updated. Do not forget to check in build support files!!').
    ^true
! !

!ProjectProblem::InconsistentProjectDefinition methodsFor:'fixing'!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    ^Array
        with: (Array 
                with: ('Full update of the package definition (rescan) of "%1"' bindWith:package)
                with: [ self doUpdateAllProjectDefinitions ])
! !

!ProjectProblem::ClassListedBeforeItsPool methodsFor:'accessing'!

poolName
    ^ poolName
!

poolName:something
    poolName := something.
! !

!ProjectProblem::ClassListedBeforeItsPool methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'Class %2 is listed in project definition (%1) before one of its pools (%3).
<br>Such class will fail to compile (if the package is being stc-compiled)
and load (if the package is being loaded from source).
<br>Make sure class (%3) is listed before (%2).

'
bindWith: (self linkToClass: self packageDefinitionClass class selector: #classNamesAndAttributes omitClassName: true)
    with: (self linkToClass: className)
    with: (self linkToClass: poolName)

    "Modified: / 13-09-2012 / 18:29:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Class %1 listed in project definition "%2" before one of its pools' bindWith: className allBold with:self packageDefinitionClass

    "Modified: / 13-09-2012 / 17:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassListedBeforeItsSuperclass methodsFor:'accessing'!

superClassName
    ^ superClassName
!

superClassName:something
    superClassName := something.
! !

!ProjectProblem::ClassListedBeforeItsSuperclass methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'Class %2 is listed in project definition (%1) before its superclass %3.
<br>The package can be stc-compiled 
(because the generated makefile compiles in correct order)
but the class may fail to load from source.
<br>Make sure %3 is listed before %2.

'
bindWith: (self linkToClass: self packageDefinitionClass class selector: #classNamesAndAttributes omitClassName: true)
    with: (self linkToClass: className)
    with: (self linkToClass: superClassName)

    "Modified: / 13-09-2012 / 18:29:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Class %1 listed in project definition "%2" before its superclass %3' 
        bindWith: className allBold 
        with:self packageDefinitionClass
        with:superClassName

    "Modified: / 13-09-2012 / 17:36:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassListedButDoesNotExist methodsFor:'accessing'!

severity
    "Return a severity - one of #error, #warning, #info"

    ^#error

    "Created: / 11-04-2012 / 12:48:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassListedButDoesNotExist methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    |msg|

    self klass isNil ifTrue:[
        msg :=
'Class "<code>%1</code>" is listed in the project definition but not present in the system.
<br>
You should either create it or remove it from %2.'
    ] ifFalse:[
        msg :=
'Class "<code>%1</code>" is listed in the project definition but is located in another package ("',self klass package,'")
<br>
You should either move the class to this package it or remove it from the list in %2.'
    ].
    ^ msg
        bindWith: className 
        with: (self linkToClass: self packageDefinitionClass class selector: #classNamesAndAttributes)

    "Modified: / 28-02-2012 / 22:23:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^'Missing class: ', className allBold

    "Modified: / 23-02-2012 / 13:20:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassListedButDoesNotExist methodsFor:'fixing'!

alreadyFixed
    | cls def |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].   "/ ouch - can this happen?

    (def compiled_classNames includes:className) ifFalse:[^ true].

    cls := self klass.
    cls isNil ifTrue:[^ false].

    ^ cls package = self package 
!

doMoveClassToPackage
    | cls def |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    cls := self klass.
    cls isNil ifTrue:[ ^ false ].
    cls package:def package.
    UserNotification notify: ('Do not forget to check in the class into the appropriate repository!!').
    ^true
!

doRemoveClassFromProjectDefinition
    | def cls |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    cls := self klass.
    cls isNil ifTrue:[ ^ false ].
    def excludeClasses:{ cls } usingCompiler:nil.
    UserNotification notify: ('Class removed from project. Do not forget to check in build support files!!' bindWith: className).
    ^true
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |allFixes|

    allFixes := OrderedCollection new.
    allFixes add:{
                    'Remove from project definition' .
                    [ self doRemoveClassFromProjectDefinition ]
                 }.
    self klass notNil ifTrue:[
        allFixes add:{
                        'Move class to package' .
                        [ self doMoveClassToPackage ]
                     }.
    ].
    allFixes addAll:super fixes.
    ^ allFixes
! !

!ProjectProblem::ClassListedButInOtherPackage methodsFor:'accessing'!

severity
    "Return a severity - one of #error, #warning, #info"

    ^#error

    "Created: / 11-04-2012 / 12:48:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassListedButInOtherPackage methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    |msg|

    msg :=
'Class "<code>%1</code>" is listed in the project definition but is assigned to another package (%2).
<br>
You should either remove it from the classList %3 or completely assign it to %4.'.

    ^ msg
        bindWith: className
        with:(self klass package)
        with: (self linkToClass: self packageDefinitionClass class selector: #classNamesAndAttributes omitClassName: true)
        with: package
!

label
    ^'Class %1 is assigned to another package (%2)'
        bindWith:className allBold
        with: self klass package
! !

!ProjectProblem::ClassListedButInOtherPackage methodsFor:'fixing'!

alreadyFixed
    | cls def |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].   "/ ouch - can this happen?

    (def allClassNames includes:className) ifFalse:[^ true].

    cls := self klass.
    cls isNil ifTrue:[^ false].

    ^ cls package = package 
!

doMoveClassToPackage
    | cls def |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    cls := self klass.
    cls isNil ifTrue:[ ^ false ].
    cls package:def package.
    UserNotification notify: ('Do not forget to check in the class into the appropriate repository!!').
    ^true
!

doRemoveClassFromProjectDefinition
    | def cls |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    cls := self klass.
    cls isNil ifTrue:[ ^ false ].
    def excludeClasses:{ cls } usingCompiler:nil.
    UserNotification notify: ('Class removed from project. Do not forget to check in build support files!!' bindWith: className).
    ^true
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |allFixes|

    allFixes := OrderedCollection new.
    allFixes add:{
                    'Remove from project definition' .
                    [ self doRemoveClassFromProjectDefinition ]
                 }.
    self klass notNil ifTrue:[
        allFixes add:{
                        'Move class to package' .
                        [ self doMoveClassToPackage ]
                     }.
    ].
    allFixes addAll:super fixes.
    ^ allFixes
! !

!ProjectProblem::ClassListedMultipleTimes methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'A class %1 is listed more than once in %2.

Such package will fail to compile, as linker will complain
about multiple definitions of the same symbols. Make sure each
class is listed only once.
'
    bindWith: (self linkToClass: className)
        with: (self linkToClass: self packageDefinitionClass class selector: #classNamesAndAttributes)

    "Modified: / 26-11-2014 / 09:25:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Class %1 listed multiple times in project definition "%2"' bindWith: className allBold with:self packageDefinitionClass

    "Modified: / 23-02-2012 / 13:34:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassNotListed methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'Class %1 is not listed in project definition (%2).
<br>The class won''t be compiled and - if some other class dependents on it - the whole package will fail to compile
at all.'
bindWith: (self linkToClass: className)
    with: (self linkToClass: self packageDefinitionClass class selector: #classNamesAndAttributes omitClassName: true)

    "Modified: / 26-07-2012 / 10:27:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Class %1 not listed in project definition "%2"' bindWith: className allBold with:self packageDefinitionClass 

    "Modified: / 23-02-2012 / 13:55:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassNotListed methodsFor:'fixing'!

alreadyFixed
    | cls def |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].   "/ ouch - can this happen?

    cls := self klass.
    "/ One may "fix" the problem by actually removing the class. 
    "/ In this case, consider problem as "fixed".
    cls isNil ifTrue:[^ true].

    ^ (def compiled_classNames includes:className) 
!

doIncludeAllClassesInProject
    "Include all unlisted subject classes in project definition. 
     Return false if fix fails, true otherwise"

    |any|

    any := false.
    self allUnfixedProblemsOfMyKindDo:[:p |
        "/ evaluating or here    
        any := any | (p doIncludeInProjectAsAutoloaded:false)
    ].
    ^ any
!

doIncludeInProject
    "Include subject class in project definition. Return false if
     fix fails, true otherwise"

    ^ self doIncludeInProjectAsAutoloaded:false
!

doIncludeInProjectAsAutoloaded
    "Include subject class in project definition. Return false if
     fix fails, true otherwise"

    ^ self doIncludeInProjectAsAutoloaded:true
!

doIncludeInProjectAsAutoloaded:asAutoloaded
    "Include subject class in project definition. Return false if
     fix fails, true otherwise"

    | def cls |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    cls := self klass.
    cls isNil ifTrue:[ ^ false ].
    asAutoloaded ifTrue:[
        def makeClassesAutoloaded:(Array with: cls) usingCompiler: nil.
    ] ifFalse:[
        def includeClasses:(Array with: cls) usingCompiler: nil.
    ].
    UserNotification notify: ('Class added. Do not forget to check in build support files!!' bindWith: className).
    ^true

    "Created: / 26-07-2012 / 10:41:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |numOther fixes|

    numOther := self countOtherProblemsOfThisKind.
    fixes := OrderedCollection new.
    fixes add:{ 'Add class to project (as compiled)' . 
                [ self doIncludeInProject ] 
              }.
    numOther > 0 ifTrue:[
        fixes add:{ 'Add all listed classes to project (as compiled)' . 
                    [ self doIncludeAllClassesInProject ] 
                  }.
    ].

    fixes 
        add:{ 'Add class to project as autoloaded' . 
                [ self doIncludeInProjectAsAutoloaded ] 
            };
        add:{ 'Full update of the project definitions (rescan)' . 
                [ self doUpdateAllProjectDefinitions ] 
            }.
    ^ fixes

    "Created: / 26-07-2012 / 10:41:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassIsCompiledButSuperclassIsAutoloaded methodsFor:'accessing'!

description
    "Return a (HTML) describing the problem."

    ^
'Class %1 is compiled (i.e., not autoloaded) but its superclass %2 is autoloaded. 
<p>
Such class won''t compile with STC because of a missing superclass header file.
To fix it, either make %1 autoloaded or make %2 compiled.'
bindWith: (self linkToClass: className)
    with: (self linkToClass: (Smalltalk at: className) superclass name)

    "Modified: / 20-09-2013 / 11:04:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^ 'Class ', className , ' is compiled but its superclass is autoloaded'

    "Modified: / 20-09-2013 / 11:00:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassIsCompiledButSuperclassIsAutoloaded methodsFor:'fixing'!

doIncludeInProjectAsAutoloaded
    "Include subject class in project definition. Return false if
     fix fails, true otherwise"

    ^ self doIncludeInProjectAsAutoloaded:true
!

doIncludeInProjectAsAutoloaded:asAutoloaded
    "Include subject class in project definition. Return false if
     fix fails, true otherwise"

    | def cls |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    cls := self klass.
    cls isNil ifTrue:[ ^ false ].
    asAutoloaded ifTrue:[
        def makeClassesAutoloaded:(Array with: cls) usingCompiler: nil.
    ] ifFalse:[
        def includeClasses:(Array with: cls) usingCompiler: nil.
    ].
    UserNotification notify: ('Class added. Do not forget to check in build support files!!' bindWith: className).
    ^true

    "Created: / 26-07-2012 / 10:41:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doMakeSuperclassCompiled
    "Include subject's super class in project definition as compiled class. 
     Return false if fix fails, true otherwise"

    | def cls superclass superclassDef|

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    cls := self klass.
    cls isNil ifTrue:[ ^ false ].

    superclass := (Smalltalk at: className) superclass.
    superclassDef := superclass projectDefinitionClass.
    superclassDef isNil ifTrue:[^ false].

    superclassDef includeClasses:(Array with: superclass) usingCompiler: nil.

    UserNotification notify: ('Superclass added/changed. Do not forget to check in build support files!!' bindWith: className).
    ^true
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |fixes superClass superPackage|

    fixes := super fixes asNewOrderedCollection.

    superClass := (Smalltalk at: className) superclass.
    superPackage := superClass package.

    superPackage = package ifTrue:[
        fixes add:
            { 'Make ',className,' autoloaded in project' . 
                        [ self doIncludeInProjectAsAutoloaded ]}.
        fixes add:    
            { 'Make superclass ',(superClass name),' compiled' . 
                        [ self doMakeSuperclassCompiled ]} .
    ] ifFalse:[
        fixes add:
            { 'Make ',className,' autoloaded in project "',package,'"' . 
                        [ self doIncludeInProjectAsAutoloaded ]}.

        fixes add:    
            { 'Make superclass ',(superClass name),' compiled in "',superPackage,'"'. 
                        [ self doMakeSuperclassCompiled ]} .
    ].
    ^ fixes
! !

!ProjectProblem::ClassShouldNotBeInPackage methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'Class %1 should not be assigned to a Folder-only package (%2).
Folder-only packages are only meant for organization and to visit subprojects for compilation.
<br>The class won''t be compiled and - if some other class dependents on it - the whole package will fail to compile
at all.'
bindWith: (self linkToClass: className)
    with: (self linkToClass: self packageDefinitionClass class selector: #classNamesAndAttributes omitClassName: true)
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Class %1 not listed in project definition "%2"' bindWith: className allBold with:self packageDefinitionClass 

    "Modified: / 23-02-2012 / 13:55:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassShouldNotBeInPackage methodsFor:'fixing'!

alreadyFixed
    | cls def |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].   "/ ouch - can this happen?

    cls := self klass.
    "/ One may "fix" the problem by actually removing the class. 
    "/ In this case, consider problem as "fixed".
    cls isNil ifTrue:[^ true].

    ^ (def compiled_classNames includes:className) 
!

doIncludeAllClassesInProject
    "Include all unlisted subject classes in project definition. 
     Return false if fix fails, true otherwise"

    |any|

    any := false.
    self allUnfixedProblemsOfMyKindDo:[:p |
        "/ evaluating or here    
        any := any | (p doIncludeInProjectAsAutoloaded:false)
    ].
    ^ any
!

doIncludeInProject
    "Include subject class in project definition. Return false if
     fix fails, true otherwise"

    ^ self doIncludeInProjectAsAutoloaded:false
!

doIncludeInProjectAsAutoloaded
    "Include subject class in project definition. Return false if
     fix fails, true otherwise"

    ^ self doIncludeInProjectAsAutoloaded:true
!

doIncludeInProjectAsAutoloaded:asAutoloaded
    "Include subject class in project definition. Return false if
     fix fails, true otherwise"

    | def cls |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    cls := self klass.
    cls isNil ifTrue:[ ^ false ].
    asAutoloaded ifTrue:[
        def makeClassesAutoloaded:(Array with: cls) usingCompiler: nil.
    ] ifFalse:[
        def includeClasses:(Array with: cls) usingCompiler: nil.
    ].
    UserNotification notify: ('Class added. Do not forget to check in build support files!!' bindWith: className).
    ^true

    "Created: / 26-07-2012 / 10:41:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |numOther fixes|

    numOther := self countOtherProblemsOfThisKind.
    fixes := OrderedCollection new.
    fixes add:{ 'Add class to project (as compiled)' . 
                [ self doIncludeInProject ] 
              }.
    numOther > 0 ifTrue:[
        fixes add:{ 'Add all listed classes to project (as compiled)' . 
                    [ self doIncludeAllClassesInProject ] 
                  }.
    ].

    fixes 
        add:{ 'Add class to project as autoloaded' . 
                [ self doIncludeInProjectAsAutoloaded ] 
            };
        add:{ 'Full update of the project definitions (rescan)' . 
                [ self doUpdateAllProjectDefinitions ] 
            }.
    ^ fixes

    "Created: / 26-07-2012 / 10:41:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassUsesPoolProblem methodsFor:'accessing'!

poolName
    ^ poolName
!

poolName:something
    poolName := something.
! !

!ProjectProblem::ClassUsesPoolButItIsNotASharedPool methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'A class %1 uses pool %2 but it does not exist.

The pool should be removed from the class definition;
otherwise the package won''t compile due to a missing class.'
    bindWith: (self linkToClass: className)
        with: (self linkToClass: poolName)

    "Modified: / 23-02-2012 / 13:48:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Used pool %1 is not a SharedPool' bindWith: className allBold

    "Modified: / 23-02-2012 / 13:40:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassUsesPoolInNamespaceButNamespaceIsNotDefined methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'A class %1 uses pool %2 from same namespace as the class,
but the namespace is not explicitly named in the shared pools definition.

Due to a bug in stc, such code will fail to compile. A pool definition
must contain a fully qualified class name including namespace.'
    bindWith: (self linkToClass: className)
        with: (self linkToClass: poolName)

    "Modified: / 13-09-2012 / 16:32:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^ 'Missing namespace prefix in shared pools definition of %1' bindWith: className allBold

    "Modified: / 13-09-2012 / 16:28:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassUsesPoolButItDoesNotExist methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'A class %1 uses pool %2 but it does not exist.

The pool should be removed from the class definition;
otherwise the package won''t compile due to a missing class.'
    bindWith: (self linkToClass: className) with: poolName

    "Modified: / 13-09-2012 / 16:24:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Missing pool: ' , className allBold

    "Modified: / 23-02-2012 / 13:34:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodProblem methodsFor:'accessing'!

className:something selector: sel
    className := something.
    selector :=  sel

    "Created: / 23-02-2012 / 14:17:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method
    | class |

    class := self klass.
    class isNil ifTrue:[ ^ nil ].
    ^class compiledMethodAt: selector

    "Created: / 26-07-2012 / 10:09:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method: method

    self className: method mclass name selector: method selector

    "Created: / 11-04-2012 / 12:32:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selector
    ^ selector
!

selector:something
    selector := something.
! !

!ProjectProblem::MethodProblem methodsFor:'fixes'!

doRemoveMethodFromExtensionsList
    "update the extension method info in the project definition.
     Return false if fix fails, true otherwise"

    | def mthd |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    mthd := self method.
    mthd isNil ifTrue:[ ^ false ].

    def excludeMethods:(Array with:mthd) usingCompiler:nil.
    UserNotification notify: ('ProjectDefinition updated. Do not forget to check it in!!').
    ^true
!

doRemoveNamedMethodFromExtensionsList
    "update the extension method info in the project definition.
     Return false if fix fails, true otherwise"

    | def |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].

    def excludeMethodFor:selector inClassNamed:className usingCompiler:nil.    
    UserNotification notify: ('ProjectDefinition updated. Do not forget to check it in!!').
    ^true
! !

!ProjectProblem::MethodProblem methodsFor:'utilities-HTML'!

linkToMethod

    ^self linkToClass: className selector: selector

    "Created: / 23-02-2012 / 14:21:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ExtensionMethodListedButInDifferentPackage methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    |mthd text|

    (mthd := self method) isNil ifTrue:[ ^ 'Method removed.' ].

    mthd package = mthd mclass package ifTrue:[
        text :=
'Method %1 is listed as an extension in "%3", but is actually associated to its class''s package "%4" (ie. not as extension).
<P>Maybe the method used to be an extension but is now a proper part of the class.
If this is the case, you should remove the method name from the extensions list (%3).
<P>Otherwise, the method may have lost its package information due to a recompilation in
a tool which did not known about the original package association.
Then, you should reassociate the method to the extending package.'
    ] ifFalse:[
        text :=
'Method %1 is listed as an extension in "%3" but is actually assicualted to a different package: "%4".
<P>The package will compile but may fail to (auto)load from sources.
<P>It is recommended to either remove the method name from the extensions list (%3) 
or move the method it to the correct package.'
    ].
    ^ text
        bindWith: (self linkToClass: (Smalltalk classNamed: className) selector: selector) "className"        
            with: selector
            with: (self linkToClass: self packageDefinitionClass class selector: #extensionMethodNames)
            with: mthd package

    "Modified: / 23-02-2012 / 15:18:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    |mthd text|

    text := 'Extension method %1 » %2 listed but in different package'.

    (mthd := self method) notNil ifTrue:[
        mthd package = mthd mclass package ifTrue:[
            text := 'Extension method %1 » %2 listed but in classes package' 
        ]
    ].
    ^ text
        bindWith: className allBold 
        with: selector allBold

    "Modified: / 23-02-2012 / 14:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ExtensionMethodListedButInDifferentPackage methodsFor:'fixes'!

alreadyFixed
    |mthd|

    (self packageDefinitionClass extensionMethods includes:self method) ifFalse:[^ true].
    ^ ((mthd := self method) notNil 
        and:[ mthd package = package ])
!

doMoveMethodToProject
    self method package:package
! !

!ProjectProblem::ExtensionMethodListedButInDifferentPackage methodsFor:'fixing'!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |mthd|

    (mthd := self method) isNil ifTrue:[ ^ #() ].

"/    mthd package = mthd mclass package ifTrue:[
"/        ^Array
"/            with: (Array with: 'Remove from the extensionMethodNames list' with: [ self doRemoveMethodFromExtensionsList ])    
"/    ].
"/
    ^Array
        with: (Array with: 'Remove from the extensionMethodNames list' with: [ self doRemoveMethodFromExtensionsList ])    
        with: (Array with: ('Move method to package "%1"' bindWith:package) with: [ self doMoveMethodToProject ])

    "Created: / 26-07-2012 / 10:41:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ExtensionMethodNotListed methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

^'Method %1 is not listed in %2.
<br>It should either be listed in the project definition, or moved to the owning classes package'
    bindWith: (self linkToMethod)
        with: (self linkToClass: self packageDefinitionClass class selector: #extensionMethodNames)

    "Modified: / 23-02-2012 / 14:34:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Extension method %1 » %2 not listed in project definition "%3"' bindWith: className allBold with: selector allBold with:self packageDefinitionClass

    "Modified: / 23-02-2012 / 14:22:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ExtensionMethodNotListed methodsFor:'fixing'!

alreadyFixed
    ^ (self packageDefinitionClass extensionMethods includes:self method)        
!

doMoveToClassesPackage
    "move the extension method to the owning classes package.
     Return false if fix fails, true otherwise"

    | cls mthd |

    cls := self klass.
    cls isNil ifTrue:[ ^ false ].
    mthd := cls compiledMethodAt:selector.
    mthd package:(cls package).

    UserNotification notify: ('Do not forget to check in the method''s package (or class) ("%1")!!' bindWith:cls package).
    ^true
!

doUpdateExtensionMethodsInProject
    "update the extension method info in the project definition.
     Return false if fix fails, true otherwise"

    | def mthd |

    def := self packageDefinitionClass.
    def isNil ifTrue:[ ^ false ].
    mthd := self method.
    mthd isNil ifTrue:[ ^ false ].

    def includeMethods:(Array with:mthd) usingCompiler:nil.
    UserNotification notify: ('ProjectDefinition updated. Do not forget to check it in!!').
    ^true
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    ^Array
        with: (Array 
                    with: ('Add method to package ("%1")' bindWith:package)   
                    with: [ self doUpdateExtensionMethodsInProject ] )
        with: (Array 
                    with: ('Move method to classes package ("%1")' bindWith:self klass package)  
                    with: [ self doMoveToClassesPackage ] )
        with: (Array 
                    with: ('Full update of the package definition (rescan) of "%1"' bindWith:self klass package) 
                    with: [ self doUpdateAllProjectDefinitions ] )
! !

!ProjectProblem::ExtensionMethodsClassDoesNotExist methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

^'Method %1 >> %2 listed in %3 but class does not exist.
The package will compile but may fail to (auto)load from sources.

It is recommended to remove the method from the list (%3).'
    bindWith: className 
        with: selector
        with: (self linkToClass: self packageDefinitionClass class selector: #extensionMethodNames)
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Extension method %1 » %2 listed but class not existing' 
        bindWith: className allBold 
        with: selector allBold

    "Modified: / 23-02-2012 / 14:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ExtensionMethodsClassDoesNotExist methodsFor:'fixing'!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    ^Array
        with: (Array with: 'Remove from the extensionMethodNames list' with: [ self doRemoveNamedMethodFromExtensionsList ])    

    "Created: / 26-07-2012 / 10:41:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassIsCompiledButSuperclassProjectDefinitionIsMissing methodsFor:'accessing'!

description
    "Return a (HTML) describing the problem."

    ^
'Class %1 is compiled (i.e. not autoloaded) but its superclass''s project 
definition class is missing.
<BR>(superclass %2 has no project definition for "%3").
<P>
Such class won''t compile with STC because the superclass''s package
will likely be missing.'
bindWith: (self linkToClass: className)
    with: (self linkToClass: (Smalltalk at: className) superclass name)
    with: (self linkToPackage: (Smalltalk at: className) superclass package)

    "Modified: / 05-10-2013 / 12:43:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |fixes superClass superPackage|

    fixes := super fixes asNewOrderedCollection.

    superClass := (Smalltalk at: className) superclass.
    superPackage := superClass package.

    fixes add:
        { 'Create project definition class for project "',superPackage,'"' . 
                    [ self createPackageDefinitionForSuperclass ]
        }.

    ^ fixes
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^ 'Class ', className , ' is compiled but its superclass''s package definition is missing'

    "Modified: / 05-10-2013 / 12:41:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ClassIsCompiledButSuperclassProjectDefinitionIsMissing methodsFor:'fixing'!

createPackageDefinitionForSuperclass
    "crate super class's project definition. 
     Return false if fix fails, true otherwise"

    | superclass superclassDef|

    superclass := (Smalltalk at: className) superclass.
    superclassDef := ProjectDefinition definitionClassForPackage:superclass package createIfAbsent:true.
    superclassDef isNil ifTrue:[^ false].
    ^true
! !

!ProjectProblem::InvalidPackageName methodsFor:'accessing'!

badName:something
    badName := something.
!

severity
    "Return a severity - one of #error, #warning, #info"

    ^#error
! !

!ProjectProblem::InvalidPackageName methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'The package name "%1" is invalid.
Names must be of the form "module:subpackage/..." or "module".
<P>
You <b>must</b> change this to a valid name, otherwise package management won''t work,
and the package cannot be compiled to a binary dll.'
    bindWith: (badName ? package)
!

label
    ^'Invalid package name: "%1"' bindWith: (badName ? package)
! !

!ProjectProblem::MethodCompilabilityIssue1 methodsFor:'accessing'!

severity
    ^ errors notNil ifTrue:[#error] ifFalse:[#warning]

    "Modified: / 11-04-2012 / 15:40:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue1 methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    | issuePrinter |

    issuePrinter := 
        [:stream :issue|
            stream nextPutAll:'<li>'.
            issue descriptionOn: stream.
            stream nextPutAll:'</li>'.
            stream cr.
        ].

    ^ String streamContents:[:s|
        s
            nextPutAll: 'The following problems have been found in ';
            nextPutAll: self linkToMethod;
            nextPutAll: ':'; cr;
            nextPutAll: '<ul>'.
        errors ? #() do:[:issue|issuePrinter value: s value: issue].
        warnings ? #() do:[:issue|issuePrinter value: s value: issue].
        s
            nextPutAll: '</ul>'.

        errors notNil ifTrue:[
            s nextPutAll:
'STC won''t compile such code, therefore you must fix it before committing'
        ].
    ]

    "Modified: / 11-04-2012 / 15:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^ (errors notNil 
        ifTrue:[ 'Uncompilable method %1 » %2' ]
        ifFalse:[ 'Warnings for method %1 » %2' ]) bindWith: className allBold with: selector allBold


    "Modified: / 11-04-2012 / 16:04:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue1 methodsFor:'error handling'!

addError:aMessage from: position to: endPos
    errors isNil ifTrue:[ errors := OrderedCollection new].
    errors add: (Error message: aMessage from: position to: endPos)
!

addWarning:aMessage from: position to: endPos
    warnings isNil ifTrue:[ warnings := OrderedCollection new].
    warnings add: (Warning message: aMessage from: position to: endPos)
!

correctableError:aMessage position:position to:endPos from:aCompiler
    "error notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    self error:aMessage position:position to:endPos from:aCompiler.
    ^ false. "/ no correction

    "Created: / 30-07-1999 / 18:11:15 / cg"
    "Modified: / 02-11-2010 / 12:58:54 / cg"
!

correctableSelectorWarning:aMessage position:position to:endPos from:aCompiler
    "warning notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    self warning:aMessage position:position to:endPos from:aCompiler.
    ^ false. "/ no correction

    "Modified: / 02-11-2010 / 12:59:04 / cg"
!

correctableWarning:aMessage position:position to:endPos from:aCompiler
    "error notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    self warning:aMessage position:position to:endPos from:aCompiler.
    ^ false

    "Created: / 02-11-2010 / 13:29:40 / cg"
!

error:aMessage position:position to:endPos from:aCompiler
    "error notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    "Argh!!!!!!!! If its an ignorable error, why signal error!!!!!! Bad design,
    even worse workaround. Sigh."
    (thisContext findNextContextWithSelector:#ignorableParseError: or:nil or:nil) notNil
    "/ thisContext sender sender sender sender selector == #ignorableParseError:
        ifTrue:[ ^ self ].

    self addError:aMessage from: position to: endPos

    "Created: / 30-07-1999 / 18:10:30 / cg"
    "Modified: / 10-09-2012 / 11:32:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unusedVariableWarning:aMessage position:position to:endPos from:aCompiler
    "warning notification during fileIn.
     This is sent by the compiler/evaluator if it detects errors."

    ^ self warning:aMessage position:position to:endPos from:aCompiler
!

warning:aMessage position:position to:endPos from:aCompiler
    "warning notification during fileIn - ignore it.
     This is sent by the compiler/evaluator if it detects errors."

"/    No, do not show warnings now, too many false positives
"/    warnings isNil ifTrue:[ warnings := OrderedCollection new].
"/    warnings   add: (Warning message: aMessage from: position to: endPos).

    "Created: / 30-07-1999 / 18:11:05 / cg"
    "Modified (comment): / 12-04-2012 / 18:19:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue1 methodsFor:'queries'!

hasIssue
    ^ (errors ? warnings) notNil

    "Created: / 11-04-2012 / 15:43:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue1::Error class methodsFor:'instance creation'!

message: message from: startPosition to: endPosition

    ^self new
        message: message;
        startPosition: startPosition;
        endPosition: endPosition;
        yourself.

    "Created: / 11-04-2012 / 15:38:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue1::Error methodsFor:'accessing'!

endPosition
    ^ endPosition
!

endPosition:something
    endPosition := something.
!

message
    ^ message
!

message:something
    message := something.
!

startPosition
    ^ startPosition
!

startPosition:something
    startPosition := something.
! !

!ProjectProblem::MethodCompilabilityIssue1::Error methodsFor:'accessing-description'!

descriptionOn: stream

    stream nextPutAll: message; space; nextPutAll:'(error)'

    "Created: / 11-04-2012 / 15:52:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue1::Warning class methodsFor:'instance creation'!

message: message from: startPosition to: endPosition

    ^self new
        message: message;
        startPosition: startPosition;
        endPosition: endPosition;
        yourself.

    "Created: / 11-04-2012 / 15:38:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue1::Warning methodsFor:'accessing'!

endPosition
    ^ endPosition
!

endPosition:something
    endPosition := something.
!

message
    ^ message
!

message:something
    message := something.
!

startPosition
    ^ startPosition
!

startPosition:something
    startPosition := something.
! !

!ProjectProblem::MethodCompilabilityIssue1::Warning methodsFor:'accessing-description'!

descriptionOn: stream

    stream nextPutAll: message; space"/; nextPutAll:'(warning)'

    "Created: / 11-04-2012 / 15:52:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue2 methodsFor:'accessing'!

severity
    | severities |

    severities := rules collect:[ :rule | rule severity ].
    (severities includes: #error) ifTrue:[ ^ #error ].
    ^ #warning

    "Modified: / 29-05-2014 / 15:41:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue2 methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    | issuePrinter |

    issuePrinter := 
        [:stream :rule|
            stream nextPutAll:'<li>'.
            stream nextPutAll: rule name.
            stream nextPutAll: '<br></br>'.
            stream nextPutAll:'<p>'.            
            stream nextPutAll: rule rationale.
            stream nextPutAll:'</p>'.            
            stream nextPutAll:'</li>'.
            stream cr.
        ].

    ^ String streamContents:[:s|
        s
            nextPutAll: 'The following problems have been found in ';
            nextPutAll: self linkToMethod;
            nextPutAll: ':'; cr;
            nextPutAll: '<ul>'.
        rules ? #() do:[:rule|issuePrinter value: s value: rule].

        s
            nextPutAll: '</ul>'.

        errors notNil ifTrue:[
            s nextPutAll:
'STC won''t compile such code, therefore you must fix it before committing'
        ].
    ]

    "Modified: / 29-05-2014 / 16:26:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^ ((self severity == #error) 
        ifTrue:[ 'Uncompilable method %1 » %2' ]
        ifFalse:[ 'Warnings for method %1 » %2' ]) bindWith: className allBold with: selector allBold

    "Modified: / 29-05-2014 / 15:39:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue2 methodsFor:'adding & removing'!

addViolation: anRBLintRule
    rules isNil ifTrue:[ rules := OrderedCollection new ].
    rules add: anRBLintRule

    "Created: / 29-05-2014 / 15:42:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodCompilabilityIssue2 methodsFor:'queries'!

hasIssue
    ^ rules notEmptyOrNil

    "Created: / 11-04-2012 / 15:43:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-05-2014 / 15:41:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodInNoPackage methodsFor:'accessing-description'!

alreadyFixed
    | m |

    "/ One may "fix" the problem by actually removing the method. 
    "/ In this case, also consider problem as "fixed".
    m := self method.
    ^ m isNil or:[m package ~= PackageId noProjectID]

    "Modified (format): / 19-12-2013 / 15:38:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

description
    "Return a (HTML) describing the problem."

    ^
'Method %1 does not belong to any package. Such methods
are not committed and will be lost when you restart/recompile.
Especially, it will not be included when you generate a compiled class library.
However, it will be kept in the changes file, so it is not completely lost.
The method should be moved to some package, %2 maybe?'
    bindWith: (self linkToMethod)
        with: package

    "Modified: / 23-02-2012 / 14:21:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Unpackaged method %1 » %2' bindWith: className allBold with: selector allBold

    "Modified: / 23-02-2012 / 14:19:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodInNoPackage methodsFor:'fixing'!

doMoveAllListedMethodsToClassPackage
    "move all listed methods to their corresponding classes package.
     Return false if fix fails, true otherwise"

    | mth cls any |

    any := false.
    self allUnfixedProblemsOfMyKindDo:[:p |
        cls := p klass.
        cls notNil ifTrue:[
            mth := p method.
            mth notNil ifTrue:[
                cls package ~= PackageId noProjectID ifTrue:[
                    mth package:(cls package).
                    any := true.
                ]
            ]
        ]
    ].
    ^ any
!

doMoveAllListedMethodsToPackage
    "move all listed methods to the package.
     Return false if fix fails, true otherwise"

    | m any |

    any := false.
    self allUnfixedProblemsOfMyKindDo:[:p |
        m := p method.
        m notNil ifTrue:[
            m package: package.
            any := true.
        ]
    ].
    ^ any
!

doMoveMethodToPackage
    "move the method to the package.
     Return false if fix fails, true otherwise"

    | m |

    m := self method.
    m notNil ifTrue:[
        m package: package.
        ^ true
    ] ifFalse:[
        ^ false
    ]
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |ops|

    ops := OrderedCollection new.
    
    ops add:{                        
            ('Move method to package "%1"' bindWith:package) .
            [ self doMoveMethodToPackage ]
        }.
    
    self countOtherProblemsOfThisKind > 0 ifTrue:[
        (allProblems conform:[:p | p klass isNil or:[p klass package = package]]) ifFalse:[    
            ops add:{
                    ('Move all listed unpackaged methods to their owning class package') .
                    [ self doMoveAllListedMethodsToClassPackage ]
                }.
        ] ifTrue:[    
            ops add:{
                    ('Move all listed unpackaged methods to package "%1"' bindWith:package) .
                    [ self doMoveAllListedMethodsToPackage ]
                }.
        ].
    ].
    ^ ops

    "Created: / 26-07-2012 / 09:53:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodListedInOtherPackage methodsFor:'accessing'!

otherProjectDefinitionClasses
    ^ otherProjectDefinitionClasses
!

otherProjectDefinitionClasses:aCollectionOfClasses
    otherProjectDefinitionClasses := aCollectionOfClasses.
! !

!ProjectProblem::MethodListedInOtherPackage methodsFor:'accessing-description'!

alreadyFixed
    | m |

    "/ One may "fix" the problem by actually removing the method. 
    "/ In this case, also consider problem as "fixed".
    m :=  self method.
    ^ m isNil 
        or:[otherProjectDefinitionClasses isEmptyOrNil
        or:[(otherProjectDefinitionClasses contains:[:cls | cls extensionMethods includes:m]) not]]
!

description
    "Return a (HTML) describing the problem."

    ^
'Method "%1" is also listed in "%2". 
The method may only be present in exactly one package, "%3" perhaps?'
    bindWith: (self linkToMethod)
        with: (otherProjectDefinitionClasses size == 1
                ifTrue:[ self linkToPackage: (otherProjectDefinitionClasses first package) ]
                ifFalse:[ '%1 other packages' bindWith:otherProjectDefinitionClasses size ])
        with: (self linkToPackage:package)
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Method %1 » %2 also present in other pacakge(s)' bindWith: className allBold with: selector allBold
! !

!ProjectProblem::MethodListedInOtherPackage methodsFor:'fixing'!

doRemoveMethodFromOtherPackages
    "remove the method to the other package(s).
     Return false if fix fails, true otherwise"

    | m |

    m := self method.
    m isNil ifTrue:[^ false].

    m package: package.
    otherProjectDefinitionClasses do:[:each |
        each excludeMethods:(Array with:m) usingCompiler:nil.
    ].
    UserNotification notify: ('Other ProjectDefinition updated. Do not forget to check that one in also!!').
    ^ true.
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |removeThisFromOtherPackages|

    removeThisFromOtherPackages :=
        {
            ('Remove method from other package(s)') .
            [ self doRemoveMethodFromOtherPackages ]
        }.

    ^ {
        removeThisFromOtherPackages
      }
! !

!ProjectProblem::ExtensionMethodListedButDoesNotExist methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

^'Method %1 listed in %3 but does not exist.
The package will compile but may fail to (auto)load from sources.

It is recommended to remove the method from the list (%3).'
    bindWith: (self linkToClass: (Smalltalk classNamed: className) selector: selector) "className"        
        with: selector
        with: (self linkToClass: self packageDefinitionClass class selector: #extensionMethodNames)

    "Modified: / 23-02-2012 / 15:18:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^'Extension method %1 » %2 listed but not existing' bindWith: className allBold with: selector allBold

    "Modified: / 23-02-2012 / 14:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ExtensionMethodListedButDoesNotExist methodsFor:'fixing'!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    ^ {
        { 
          'Remove from the extensionMethodNames list' .
          [ self doRemoveNamedMethodFromExtensionsList ]
        }
    }

    "Created: / 26-07-2012 / 10:41:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodSourceCorrupted methodsFor:'accessing'!

severity
    "Return a severity - one of #error, #warning, #info"

    ^#error

    "Created: / 11-04-2012 / 12:47:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodSourceCorrupted methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'Source code for %1 is <b>corrupted</b>. This is likely because
the binary class version does not match the source file. This may happen,
for instance, if you compile a class library and then edit the ".st" file,
or you have checked out from the SCM into the file system over the existing source code,
from which the class was compiled.
<P>Be very careful with checkin or fileOut (do NOT save over any existing file), 
and check the results for currupt source code,
<P>Sometimes, you can fix this by disabling the "Use Local Source" in the SCM manager''s settings
dialog. If that does not help, it is recommended to leave ST/X, restore the old source or compile a system
based on the current source, restart ST/X, reapply the changes via the Changebrowser and commit then.'
    bindWith: (self linkToMethod)
        with: package

    "Modified: / 11-04-2012 / 12:47:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^ 'Corrupted source code for %1 » %2' bindWith: className allBold with: selector allBold

    "Modified: / 11-04-2012 / 12:42:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodSourceNotAvailable methodsFor:'accessing'!

severity
    "Return a severity - one of #error, #warning, #info"

    ^#error

    "Created: / 11-04-2012 / 12:47:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::MethodSourceNotAvailable methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    ^
'Source code for %1 is not available. Check your package path
and/or source code management settings.
'
    bindWith: (self linkToMethod)
        with: package

    "Modified: / 11-04-2012 / 12:44:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Return the label (possibly instance if a Text) shortly describing the problem"

    ^ 'Unavailable source code for %1 » %2' bindWith: className allBold with: selector allBold

    "Modified: / 11-04-2012 / 12:41:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ProjectDefinitionDoesNotExist methodsFor:'accessing'!

missing:arg
    missing := arg
!

severity
    "Return a severity - one of #error, #warning, #info"

    ^#error

    "Created: / 11-04-2012 / 12:48:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ProjectDefinitionDoesNotExist methodsFor:'accessing-description'!

description
    "Return a (HTML) describing the problem."

    (missing ? package) = 'stx' ifTrue:[
        ^
'Move your code to another package.
<br>The package name "stx" is reserveed for exept''s ST/X development.'
    ].

    ^
'A project definition class for package "%1" does not exist.
<br>Project definition classes keep the meta information of a package,
such as contents and build parameters.
You <b>must</b> create it, otherwise package management won''t work,
and the package cannot be compiled to a binary dll.'
    bindWith: (missing ? package)

    "Modified: / 23-02-2012 / 13:29:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    ^'Project definition class for "%1" does not exist' bindWith: (missing ? package)

    "Modified: / 23-02-2012 / 13:21:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectProblem::ProjectDefinitionDoesNotExist methodsFor:'fixing'!

alreadyFixed
    ^ (ProjectDefinition definitionClassForPackage:(missing ? package)) notNil        
!

doCreateMissingPackage
    ProjectDefinition
        definitionClassForPackage:missing
        projectType: (ProjectDefinition defaultProjectType)
        createIfAbsent:true.
!

doTryToLoadMissingPackage
    (Smalltalk loadPackage:missing) ifFalse:[
        Dialog warn:('Failed to load the missing package %1' bindWith:missing)
    ].
!

fixes
    "return a list of description-actionBlock pairs for possible fixes"

    |allFixes|

    allFixes := OrderedCollection new.
    allFixes add:{
                    'Try to load package %1' bindWith:missing .
                    [ self doTryToLoadMissingPackage ]
                 }.
    allFixes add:{
                    'Create package %1' bindWith:missing . 
                    [ self doCreateMissingPackage ]
                 }.
    allFixes addAll:super fixes.
    ^ allFixes
! !

!ProjectProblem class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


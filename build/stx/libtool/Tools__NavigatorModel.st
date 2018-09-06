"
 COPYRIGHT (c) 2000 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

ApplicationModel subclass:#NavigatorModel
	instanceVariableNames:'environmentHolder environment'
	classVariableNames:'AllEntry SuperSendEntry UncommentedEntry'
	poolDictionaries:''
	category:'Interface-Browsers-New'
!

!NavigatorModel class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2000 by eXept Software AG
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
    A base abstract superclass for all tools browsing the code.

    The `environment` instvar should be used to access the code elements
    (classes, packages, namespace). The tool should never access Smalltalk
    directly, but the `environment`. By default, the `environment` is 
    initialized to Smalltalk. The `environment` could be whatever object
    you like, but it MUST be polymorph with Smalltalk. Also, all classes-like
    objects it returns MUST be polymorph with Class. Otherwise, expect
    a lot of DNUs.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        environment         

    [class variables:]

    [see also:]

"
! !

!NavigatorModel class methodsFor:'initialization'!

initialize
    AllEntry := '* all *'.

    "Created: / 24.2.2000 / 13:41:29 / cg"
! !

!NavigatorModel class methodsFor:'defaults'!

isPseudoCategory:cat
    ^ cat = self nameListEntryForChanged
    or:[ cat = self nameListEntryForUndocumented
    or:[ cat = self nameListEntryForUnloaded
    or:[ cat = self nameListEntryForExtendedClasses
    or:[ cat = self nameListEntryForALL ]]]]
!

isPseudoProject:prj
    ^ prj = self nameListEntryForChanged
    or:[ prj = self nameListEntryForALL ]
!

isPseudoProtocol:protocol
    ^ protocol = self nameListEntryForObsolete
    or:[ protocol = self nameListEntryForSuperSend
    or:[ protocol = self nameListEntryForUncommented ]]
!

markForBeingInChangeList
    ^ ' *'

    "Created: / 29-08-2006 / 10:26:05 / cg"
!

markForBeingManagedBySVN: package

    | repo branch mark |    

    (ConfigurableFeatures includesFeature: #SubversionSupportEnabled) ifFalse:[^''].
    package = PackageId noProjectID ifTrue:[^''].
    
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    repo := (Smalltalk at:#SVN::RepositoryManager) current 
                repositoryForPackage: package onlyFromCache: true.
    repo ifNil:[^''].
    mark := ' [SVN]'.
    branch := repo workingCopy branchOrNil.
    branch ifNotNil:[mark := ' [SVN: ', branch path,']'].
    ^mark withColor: Color gray

    "Created: / 06-04-2010 / 11:23:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-09-2011 / 10:43:00 / cg"
    "Modified: / 19-01-2012 / 10:44:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markForBeingManagedBySVN: package branch: branch

    | mark |
    mark := branch 
                ifNil:
                    [' [SVN]']
                ifNotNil:
                    [' [SVN: ',branch,']'].

    ^mark withColor: Color gray.

    "Created: / 14-12-2010 / 15:56:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameListEntryForALL
    ^ AllEntry ? '* all *'

    "Created: / 24.2.2000 / 13:39:10 / cg"
    "Modified: / 25.2.2000 / 21:18:30 / cg"
!

nameListEntryForALLWithCount
    ^ '* all (%1) *'
!

nameListEntryForAllTests
    ^ '* all tests (%1) *'
!

nameListEntryForAnnotated
    ^ '* annotated (%1) *'

    "Created: / 07-09-2011 / 10:11:40 / cg"
!

nameListEntryForBookmarked
    ^ '* bookmarked (%1) *'
!

nameListEntryForChanged
    ^ '* changed *'
!

nameListEntryForChangedWithCount
    ^ '* changed (%1) *'
!

nameListEntryForDocumentation
    ^ '* documentation (%1) *'
!

nameListEntryForExtendedClasses
    ^ '* extended *'
!

nameListEntryForExtendedClassesWithCount
    ^ '* extended (%1) *'
!

nameListEntryForExtensions
    ^ '* extensions (%1) *'
!

nameListEntryForFailedTests
    "obsoleted by nameListEntryForTestsNotPassed, because it is unclear what failed test means
     (any of error, fail, inconc, never run, or only the explicit fail?)"
     
    ^ '* failed tests (%1) *'

    "Created: / 08-03-2010 / 18:26:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameListEntryForFullyCovered
    ^ '* covered (%1) *'

    "Created: / 20-07-2011 / 18:20:53 / cg"
!

nameListEntryForInheritedTests
    ^ '* inherited tests (%1) *'
!

nameListEntryForLong
    ^ '* long (%1) *'
!

nameListEntryForMustBeRedefinedInSubclass
    ^ '* must be redefined (%1) *'
!

nameListEntryForNILCategory
    ^ '* no category *'
!

nameListEntryForNonStatic
    ^ '* instance *'
!

nameListEntryForNotInstrumented
    ^ '* coverage unknown or not instrumented (%1) *'

    "Created: / 20-07-2011 / 18:41:53 / cg"
!

nameListEntryForObsolete
    ^ '* obsolete (%1) *'
!

nameListEntryForOverride
    ^ '* override (%1) *'
!

nameListEntryForPartiallyCovered
    ^ '* partially covered (%1) *'

    "Created: / 20-07-2011 / 18:21:05 / cg"
!

nameListEntryForPassedTests
    ^ '* passed tests (%1) *'

    "Created: / 08-03-2010 / 18:26:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameListEntryForRedefine
    ^ '* redefine (%1) *'
!

nameListEntryForRedefined
    ^ '* redefined (%1) *'
!

nameListEntryForRequired
    ^ '* required (%1) *'
!

nameListEntryForStatic
    ^ '* static *'
!

nameListEntryForSuperSend
    ^ '* super (%1) *'
!

nameListEntryForTestsNotPassed
    "includes all non-passed states
     (i.e. fail, error, skipped, inconclusive and never run)"
     
    ^ '* tests not passed (%1) *'
!

nameListEntryForUncommented
    ^ '* uncommented (%1) *'
!

nameListEntryForUncovered
    ^ '* not covered (%1) *'

    "Created: / 20-07-2011 / 18:20:44 / cg"
!

nameListEntryForUndocumented
    ^ '* undocumented *'
!

nameListEntryForUndocumentedWithCount
    ^ '* undocumented (%1) *'
!

nameListEntryForUnloaded
    ^ '* unloaded *'
!

nameListEntryForUnloadedWithCount
    ^ '* unloaded (%1) *'
!

nameListEntryForVisited
    ^ '* visited (%1) *'
!

pseudoEntryForegroundColor
    ^ UserPreferences current colorForPseudoProtocolsInMethodListInBrowser.

    "Modified: / 07-09-2011 / 09:59:55 / cg"
! !

!NavigatorModel class methodsFor:'interface specs'!

metaSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:Tools::NavigatorModel andSelector:#metaSpec
     Tools::NavigatorModel new openInterface:#metaSpec
    "

    <resource: #canvas>

    ^ 
     #(FullSpec
        name: metaSpec
        window: 
       (WindowSpec
          label: 'MetaToggles'
          name: 'MetaToggles'
          min: (Point 0 0)
          max: (Point 1024 721)
          bounds: (Rectangle 0 0 300 28)
        )
        component: 
       (SpecCollection
          collection: (
           (RadioButtonSpec
              label: 'Instance'
              name: 'InstanceToggle'
              layout: (LayoutFrame 0 0.0 0 0.0 0 0.5 25 0)
              translateLabel: true
              tabable: true
              model: notMetaToggle
              isTriggerOnDown: true
              select: true
              isToggle: true
            )
           (RadioButtonSpec
              label: 'Class'
              name: 'ClassToggle'
              layout: (LayoutFrame 0 0.5 0 0 0 1.0 25 0)
              translateLabel: true
              labelChannel: metaToggleLabelHolder
              tabable: false
              model: metaToggle
              isTriggerOnDown: true
              select: true
              isToggle: true
            )
           )
         
        )
      )
! !

!NavigatorModel class methodsFor:'misc'!

classResources
    ^ NewSystemBrowser classResources
! !

!NavigatorModel class methodsFor:'plugIn spec'!

aspectSelectors

    ^#(
        environmentHolder
    )

    "Created: / 24-02-2014 / 10:35:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigatorModel class methodsFor:'queries'!

hasSubversionSupport
    ^ ConfigurableFeatures includesFeature: #SubversionSupportEnabled

    "Created: / 06-04-2010 / 11:09:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2011 / 10:45:45 / cg"
    "Modified: / 19-01-2012 / 10:43:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isAbstract
    ^ self == Tools::NavigatorModel

    "Created: / 03-09-2013 / 15:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigatorModel methodsFor:'accessing'!

environment
    ^ environment

    "Created: / 03-09-2013 / 19:19:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

environment:env
    self environmentHolder value: env.

    "Modified: / 24-02-2014 / 10:21:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigatorModel methodsFor:'aspects'!

environmentHolder
    "return/create the 'environmentHolder' value holder (automatically generated)"

    environmentHolder isNil ifTrue:[
        environmentHolder := ValueHolder with: environment.
"/        environmentHolder := ValueHolder with: nil.

        environmentHolder addDependent:self.
    ].
    ^ environmentHolder

    "Modified: / 28-02-2014 / 19:27:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

environmentHolder:aValueModel 
    "set the 'environmentHolder' value holder (automatically generated)"
    
    | oldValue  newValue |

    environmentHolder notNil ifTrue:[
        oldValue := environmentHolder value.
        environmentHolder removeDependent:self.
    ] ifFalse:[ 
        oldValue := environment.
    ].

    environmentHolder := aValueModel.
    environmentHolder notNil ifTrue:[
        environmentHolder addDependent:self.
    ].
    newValue := environmentHolder value.
    oldValue ~~ newValue ifTrue:[
        self 
            update:#value
            with:newValue
            from:environmentHolder.
    ].

    "Modified: / 28-02-2014 / 19:30:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigatorModel methodsFor:'change & update'!

environmentChanged
    "My environment has changed. Update cached environment value.
     Subclasses may need to override and invalidate it's contents."

    | env |

    env := environmentHolder value.
    environment := env.

    "Created: / 24-02-2014 / 10:18:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-02-2014 / 23:34:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

update:something with:aParameter from:changedObject
    "Invoked when an object that I depend upon sends a change notification."

    changedObject == environmentHolder ifTrue:[
        self environmentChanged.
        ^ self.
    ].
    super update:something with:aParameter from:changedObject

    "Modified: / 24-02-2014 / 10:18:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigatorModel methodsFor:'initialization'!

initialize

    environment := environment ? Smalltalk.
    super initialize.

    "Created: / 03-09-2013 / 15:35:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-02-2014 / 23:27:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigatorModel methodsFor:'misc'!

resources
    "answer the resources of my masterApp, if there is one"

    |m|

    (m := self masterApplication) notNil ifTrue:[
        ^ m resources
    ].
    ^ super resources
! !

!NavigatorModel methodsFor:'queries'!

hasSubversionSupport
    ^ ConfigurableFeatures includesFeature: #SubversionSupportEnabled

    "Modified: / 07-09-2011 / 10:45:49 / cg"
    "Modified: / 19-01-2012 / 10:43:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigatorModel class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


NavigatorModel initialize!

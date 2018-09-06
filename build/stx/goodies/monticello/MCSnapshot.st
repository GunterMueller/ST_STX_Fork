"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MCSnapshot
	instanceVariableNames:'definitions'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-Base'
!


!MCSnapshot class methodsFor:'as yet unclassified'!

empty
	^ self fromDefinitions: #()
!

fromDefinitions: aCollection
	^ self new initializeWithDefinitions: aCollection
! !

!MCSnapshot methodsFor:'accessing'!

= other
	^ definitions asArray = other definitions asArray
!

definitions
	^ definitions
!

hash
	^ definitions asArray hash
!

includeExtrasForSTX
   <resource: #obsolete>

   self obsoleteFeatureWarning:'Use `options includeExtrasForSTX` instead'.
   ^ self options includeExtrasForSTX

    "Modified: / 07-09-2015 / 15:28:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includeExtrasForSTX: aBoolean
   <resource: #obsolete>

   self obsoleteFeatureWarning:'Use `options includeExtrasForSTX: aBoolean` instead'.
   self options includeExtrasForSTX: aBoolean

    "Modified: / 07-09-2015 / 15:27:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

options
    "Return a snapshot options (as MCSnapshotOptions) with options
     for the receiver. Options may be modified."

    | options |
    options := self objectAttributeAt: #options.
    options isNil ifTrue:[ 
        options := MCSnapshotOptions new.
        options := self objectAttributeAt: #options put: options.
    ].
    ^ options

    "Created: / 07-09-2015 / 15:24:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

options: aMCSnapshotOptions
    self objectAttributeAt: #options put: aMCSnapshotOptions.

    "Created: / 07-09-2015 / 15:26:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSnapshot methodsFor:'converting'!

asChangeSet

    ^(ChangeSet withAll:
        (self definitions collect:[:def|def asChange]))

    "Created: / 13-10-2010 / 17:18:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2010 / 23:05:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSnapshot methodsFor:'copying'!

postCopy
    "Do half-shallow copy of definitions to allow for their transformation"
    definitions := definitions copy.
    1 to: definitions size do:[:i|
        definitions at: i put: (definitions at:i) copy
    ]

    "Created: / 29-05-2013 / 01:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2013 / 00:54:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSnapshot methodsFor:'initializing'!

initializeWithDefinitions: aCollection
	definitions := aCollection.
! !

!MCSnapshot methodsFor:'loading'!

install
	MCPackageLoader installSnapshot: self
!

updatePackage: aPackage
	MCPackageLoader updatePackage: aPackage withSnapshot: self
! !

!MCSnapshot methodsFor:'patching'!

patchRelativeToBase: aSnapshot
	^ MCPatch fromBase: aSnapshot target: self
! !

!MCSnapshot methodsFor:'queries'!

includesClassNamed: className
    definitions reverseDo:[:definition|
        (definition isClassDefinition and:[definition className = className])
            ifTrue:[ ^ true ].
    ].
    ^false

    "Created: / 31-05-2013 / 00:04:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCSnapshot class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSnapshot.st,v 1.10 2013-08-12 00:59:30 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCSnapshot.st,v 1.10 2013-08-12 00:59:30 vrany Exp $'
!

version_SVN
    ^ '$Id: MCSnapshot.st,v 1.10 2013-08-12 00:59:30 vrany Exp $'
! !


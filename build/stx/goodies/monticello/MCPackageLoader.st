"{ Package: 'stx:goodies/monticello' }"

Object subclass:#MCPackageLoader
	instanceVariableNames:'requirements unloadableDefinitions overrideDefinitions
		obsoletions additions removals errorDefinitions provisions'
	classVariableNames:'Debugging'
	poolDictionaries:''
	category:'SCM-Monticello-Loading'
!


!MCPackageLoader class methodsFor:'initialization'!

new
    ^self basicNew initialize
! !

!MCPackageLoader class methodsFor:'as yet unclassified'!

installSnapshot: aSnapshot
	self new
		installSnapshot: aSnapshot;
		load
!

unloadPackage: aPackage
	self new
		unloadPackage: aPackage;
		loadWithNameLike: aPackage name, '-unload'
!

updatePackage: aPackage withSnapshot: aSnapshot
	self new
		updatePackage: aPackage withSnapshot: aSnapshot;
		load
! !

!MCPackageLoader methodsFor:'accessing'!

overrideDefinitions
    ^ overrideDefinitions
!

unloadableDefinitions
    ^ unloadableDefinitions
! !

!MCPackageLoader methodsFor:'patch ops'!

addDefinition: aDefinition
	additions add: aDefinition
!

modifyDefinition: old to: new
	self addDefinition: new.
	obsoletions at: new put: old.
!

removeDefinition: aDefinition
	removals add: aDefinition
! !

!MCPackageLoader methodsFor:'private'!

analyze
        | sorter |
        sorter := self sorterForItems: additions.
        additions := sorter orderedItems.
        requirements := sorter externalRequirements.
        unloadableDefinitions := sorter itemsWithMissingRequirements asSortedCollection.

        overrideDefinitions := additions select:[:e|e isOverrideDefinition].
        additions := additions reject: [:e|e isOverrideDefinition].
        
        sorter := self sorterForItems: removals.
        removals := sorter orderedItems reversed.

    "Modified: / 08-11-2010 / 17:34:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicLoad
        | allowEmptyStatements allowSqueakExtensions |

        allowEmptyStatements := ParserFlags allowEmptyStatements.
        allowSqueakExtensions := ParserFlags allowSqueakExtensions.
        ParserFlags allowEmptyStatements: true.
        ParserFlags allowSqueakExtensions: true.

        errorDefinitions := OrderedCollection new.
        self warnAboutUnloadables.


        [[
        | oldErrorDefinitions |
        additions do: [:ea | self tryToLoad: ea] displayingProgress: 'Loading...'.
        removals do: [:ea | ea unload] displayingProgress: 'Cleaning up...'.
        self shouldWarnAboutErrors ifTrue: [self warnAboutErrors].
        oldErrorDefinitions := errorDefinitions.        
        errorDefinitions := OrderedCollection new.
        oldErrorDefinitions do: [:ea | self tryToLoad: ea] displayingProgress: 'Reloading...'.
        additions do: [:ea | ea postloadOver: (self obsoletionFor: ea)] displayingProgress: 'Initializing...'.

        self warnAboutOverrides.
        self warnAboutErrors.

        ]
        
                on: InMidstOfFileinNotification 
                do: [:n | n resume: true]]
                        ensure: 
                            [self flushChangesFile.
                            ParserFlags allowEmptyStatements: allowEmptyStatements.
                            ParserFlags allowSqueakExtensions: allowSqueakExtensions.        
                            ]

    "Modified: / 08-11-2010 / 23:49:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2011 / 18:20:54 / cg"
!

dependencyWarning
	^ String streamContents:
		[:s |
		s nextPutAll: 'This package depends on the following classes:'; cr.
		requirements do: [:ea | s space; space; nextPutAll: ea; cr].
		s nextPutAll: 'You must resolve these dependencies before you will be able to load these definitions: '; cr.
		unloadableDefinitions do: [:ea | s space; space; nextPutAll: ea summary; cr]] 
!

errorDefinitionWarning
	^ String streamContents:
		[:s |
		s nextPutAll: 'The following definitions had errors while loading.  Press Proceed to try to load them again (they may work on a second pass):'; cr.
		errorDefinitions do: [:ea | s space; space; nextPutAll: ea summary; cr]] 
!

flushChangesFile
        "The changes file is second in the SourceFiles array"

        "(SourceFiles at: 2) flush"

    "Modified: / 11-09-2010 / 18:32:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ifInteractive: aBlock

    ^self ifInteractive: aBlock else:[]

    "Created: / 06-03-2011 / 20:32:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ifInteractive: interactiveBlock else: noninteractiveBlock

    MCInteractiveLoadingQuery query 
        ifTrue:[interactiveBlock value]
        ifFalse:[noninteractiveBlock value].

    "Created: / 06-03-2011 / 20:31:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
	super initialize.
	additions := OrderedCollection new.
	removals := OrderedCollection new.
	obsoletions := Dictionary new.

!

obsoletionFor: aDefinition
	^ obsoletions at: aDefinition ifAbsent: [nil]
!

orderDefinitionsForLoading: aCollection
	^ (self sorterForItems: aCollection) orderedItems
!

orderedAdditions
	^ additions
!

provisions
	^ provisions ifNil: [provisions := Set withAll: Smalltalk keys]
!

shouldWarnAboutErrors
	^ errorDefinitions isEmpty not and: [false "should make this a preference"]
!

sorterForItems: aCollection
	| sorter |
	sorter := MCDependencySorter items: aCollection.
	sorter addExternalProvisions: self provisions.
	^ sorter
!

tryToLoad: aDefinition
        [aDefinition loadOver: (self obsoletionFor: aDefinition)] on: Error do: [:ex |
            errorDefinitions add: aDefinition.

            Debugging == true ifTrue:[
                ex reject
            ].
            Transcript showCR:'error during load (to debug, set MCPackageLoader:Debugging to true): '.
            Transcript showCR:ex description.
        ].

    "Modified: / 11-09-2012 / 09:55:23 / cg"
!

tryToLoadAll: definitions label: label

    definitions do:[:e|self tryToLoad: e] displayingProgress: label.

    "Created: / 09-11-2010 / 17:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

useChangeSetNamed: baseName during: aBlock
        "Use the named change set, or create one with the given name."
        | changeHolder oldChanges "newChanges" |

        changeHolder := (ChangeSet respondsTo: #newChanges:)
                                                ifTrue: [ChangeSet]
                                                ifFalse: [Smalltalk].
        oldChanges := (ChangeSet respondsTo: #current)
                                                ifTrue: [ChangeSet current]
                                                ifFalse: [Smalltalk changes].

        "/JV @ 2010-09-11: Don't care about changes
        "/newChanges := (ChangeSorter changeSetNamed: baseName) ifNil: [ ChangeSet new name: baseName ].
        "/changeHolder newChanges: newChanges.
        "/[aBlock value] ensure: [changeHolder newChanges: oldChanges].
        "/ Class withoutUpdatingChangesDo: aBlock
        aBlock value.

    "Modified: / 08-11-2010 / 20:01:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-09-2011 / 15:56:36 / cg"
!

useNewChangeSetDuring: aBlock
	^self useNewChangeSetNamedLike: 'MC' during: aBlock
!

useNewChangeSetNamedLike: baseName during: aBlock
	^self useChangeSetNamed: (ChangeSet uniqueNameLike: baseName) during: aBlock
!

warnAboutDependencies
    "
    
    
        self notify: self dependencyWarning
    "

    "Modified: / 13-10-2010 / 15:44:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warnAboutErrors

    | changes |

    errorDefinitions isNilOrEmptyCollection ifTrue:[^self].
    changes := ChangeSet withAll:(errorDefinitions select:[:e|e notNil] thenCollect:[:e|e asChange]).

    changes := Tools::ChangeSetBrowser2
                openOn: changes
                label:'Error definitions'.

    "Created: / 08-11-2010 / 20:19:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2011 / 20:39:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2011 / 18:00:02 / cg"
!

warnAboutOverrides

    | changes confirmedChanges definitions |

    overrideDefinitions isNilOrEmptyCollection ifTrue:[^self].
    self ifInteractive:[
        changes := ChangeSet withAll:(overrideDefinitions collect:[:e|e asChange]).
        self assert:(changes includes:nil) not.
        confirmedChanges := Tools::ChangeSetBrowser2
                    confirmChanges: changes
                    label:'Overridden definitions. Load anyway?'.
        confirmedChanges notEmpty ifTrue:[
            confirmedChanges := confirmedChanges flatten.
            definitions := confirmedChanges collect:[:e|e mcDefinition].
            self assert:(definitions includes:nil) not.
            self tryToLoadAll: definitions label: 'Loading overrides...'.
        ]
    ] else:[
        self tryToLoadAll: overrideDefinitions label: 'Loading overrides...'.
    ]

    "Created: / 08-11-2010 / 20:19:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2011 / 20:33:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2011 / 19:31:40 / cg"
!

warnAboutUnloadables

    | changes confirmedChanges definitions |

    unloadableDefinitions isNilOrEmptyCollection ifTrue:[^self].
    self ifInteractive:[
        changes := ChangeSet withAll:(unloadableDefinitions collect:[:e|e asChange]).
        self assert:(changes includes:nil) not.
        confirmedChanges := Tools::ChangeSetBrowser2
                    confirmChanges: changes
                    label:'Unsatisfied dependencies. Load anyway?'.
        confirmedChanges notEmpty ifTrue:[
            confirmedChanges := confirmedChanges flatten.
            definitions := confirmedChanges collect:[:e|e mcDefinition].
            self assert:(definitions includes:nil) not.
            self tryToLoadAll: definitions label: 'Loading unloadables...'.
        ]
    ] else:[
        self tryToLoadAll: unloadableDefinitions label: 'Loading unloadables...'.
    ]

    "Created: / 08-11-2010 / 20:19:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2011 / 20:36:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-08-2011 / 19:31:22 / cg"
! !

!MCPackageLoader methodsFor:'public'!

installSnapshot: aSnapshot
	| patch |
	patch := aSnapshot patchRelativeToBase: MCSnapshot empty.
	patch applyTo: self.

!

load
	self analyze.
	unloadableDefinitions isEmpty ifFalse: [self warnAboutDependencies].
	self useNewChangeSetDuring: [self basicLoad]
!

loadWithName: baseName
	self analyze.
	unloadableDefinitions isEmpty ifFalse: [self warnAboutDependencies].
	self useChangeSetNamed: baseName during: [self basicLoad]
!

loadWithNameLike: baseName
	self analyze.
	unloadableDefinitions isEmpty ifFalse: [self warnAboutDependencies].
	self useNewChangeSetNamedLike: baseName during: [self basicLoad]
!

unloadPackage: aPackage
	self updatePackage: aPackage withSnapshot: MCSnapshot empty
!

updatePackage: aPackage withSnapshot: aSnapshot
        |  patch packageSnap |

        MCStXPackageQuery 
            answer: aPackage name 
            do:[
                packageSnap := aPackage snapshot.
                patch := aSnapshot patchRelativeToBase: packageSnap.
                patch applyTo: self.
                packageSnap definitions do: [:ea | self provisions addAll: ea provisions]
            ]

    "Modified: / 14-09-2010 / 22:09:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-09-2011 / 12:44:16 / cg"
! !

!MCPackageLoader class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPackageLoader.st,v 1.10 2014-12-11 15:51:20 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCPackageLoader.st,v 1.10 2014-12-11 15:51:20 cg Exp $'
!

version_SVN
    ^ '$Id: MCPackageLoader.st,v 1.10 2014-12-11 15:51:20 cg Exp $'
! !


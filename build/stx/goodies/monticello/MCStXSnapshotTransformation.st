"{ Package: 'stx:goodies/monticello' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MCStXSnapshotTransformation
	instanceVariableNames:'original transformed'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X Storing'
!

!MCStXSnapshotTransformation class methodsFor:'documentation'!

documentation
"
    An abstract superclass to snapshot tranformations. Used to alter MCSnaphot data
    to hide-out nasty differences between St/X and Squeak/Pharo package model so
    .mcz can be safely passed to from one environment to another without information
    loss. 

    CAUTION: Tricky.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        MCStXSnapshotPreWriteTransformation
        MCStXSnapshotPostReadTransformation
"
! !

!MCStXSnapshotTransformation class methodsFor:'testing'!

isAbstract
    ^self == MCStXSnapshotTransformation

    "Created: / 29-05-2013 / 11:32:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStXSnapshotTransformation class methodsFor:'transforming'!

transform: anMCSnapshot
    "Returns a transformed **copy** of the original snapshot"

    ^self new transform: anMCSnapshot.

    "Created: / 29-05-2013 / 11:36:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStXSnapshotTransformation class methodsFor:'utilities'!

reindentUsingTabsAndSpaces: aString
    "Reindent `aString` so the indentation is done using pelicular mixture
     of tabs and spaces it is demanded by Claus Gittinger for Smalltalk/X 
     code.

     Assume `aString` is a method source an that it is indented using 
     either tabs only or mixture of tabs and spaces.
    "
    | lines lineNr |

    "First, detect which scheme is used..."
    lines := aString asStringCollection.
    lines size < 2 ifTrue:[ ^ aString ].
    lineNr := 2.
    [ 
        lineNr <= lines size 
            and: [ (lines at: lineNr) isEmptyOrNil ]
    ] whileTrue:[ 
        lineNr := lineNr + 1.
    ].    
    (lineNr > lines size or:[(lines at: lineNr) first == Character space]) ifTrue:[ 
        "/ Indented by mixture, no need to do anything"
        ^ aString
    ] ifFalse:[ 
        2 to: lines size do:[:lineNr |
            | original expanded |

            original := lines at: lineNr.
            expanded := original class streamContents:[ :out |
                | in tabs |


                in := original readStream.
                tabs := 0.
                [ in peek == Character tab ] whileTrue:[
                    in next.
                    tabs := tabs + 1.
                ].

                false ifTrue:[ 
                    "/ Use tabs, then spaces to indent.
                    out next: tabs // 2 put: Character tab.
                    (tabs \\ 2) ~~ 0 ifTrue:[ 
                        out next: 4 put: Character space.
                    ].
                ] ifFalse:[ 
                    "/ Use spaces only - it seems that St/X fileout does that now...
                    out next: tabs * 4 put: Character space.            
                ].
                [ in atEnd ] whileFalse:[
                    out nextPut: in next.
                ].
            ].  
            lines at: lineNr put: expanded.  
        ].
    ].
    ^ lines asStringWithoutFinalCR.

    "
    | s |

    s := (MCStXSnapshotTransformation class >> #reindentUsingTabsOnly:) source.
    self assert: (MCStXSnapshotTransformation reindentUsingTabsAndSpaces: (MCStXSnapshotTransformation reindentUsingTabsOnly: s)) = s
    "

    "Created: / 24-04-2015 / 14:36:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-04-2015 / 22:32:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reindentUsingTabsOnly: aString
    "Reindent `aString` so the indentation is done using tabs only,
     as it is norm on Squeak / Pharo.

     Assume `aString` is a method source an that it is indented using 
     either tabs only or using arcane Smalltalk/X space/tab mixture.
    "
    | lines lineNr |

    "First, detect which scheme is used..."
    lines := aString asStringCollection.
    lines size < 2 ifTrue:[ ^ aString ].
    lineNr := 2.
    [ 
        lineNr <= lines size 
            and: [ (lines at: lineNr) isEmptyOrNil ]
    ] whileTrue:[ 
        lineNr := lineNr + 1.
    ].
    (lineNr > lines size or:[(lines at: lineNr) first == Character tab]) ifTrue:[ 
        "/ Indented by tabs, no need to do anything"
        ^ aString
    ] ifFalse:[ 
        2 to: lines size do:[:lineNr |
            | original expanded |

            original := lines at: lineNr.
            expanded := original class streamContents:[ :out |
                | in nonWhitespaceSeen |


                in := original readStream.
                nonWhitespaceSeen := false.
                [ in atEnd not and:[nonWhitespaceSeen not] ] whileTrue:[  
                    | spaces |

                    spaces := 0.
                    [ in peek == Character tab ] whileTrue:[
                        in next.
                        out nextPut: Character tab; nextPut: Character tab.
                    ].
                    [ in peek == Character space ] whileTrue:[
                        in next.
                        spaces := spaces + 1.
                    ].
                    out next: spaces // 4 put: Character tab.
                    out next: spaces \\ 4 put: Character space.
                    nonWhitespaceSeen := (in peek == Character tab or:[ in peek == Character space ]) not.
                ].
                [ in atEnd ] whileFalse:[
                    out nextPut: in next.
                ].
            ].  
            lines at: lineNr put: expanded.  
        ].
    ].
    ^ lines asStringWithoutFinalCR.

    "
    MCStXSnapshotTransformation reindentUsingTabs:
        (MCStXSnapshotTransformation class >> #reindentUsingTabs:) source
    "

    "Created: / 24-04-2015 / 14:36:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-04-2015 / 22:31:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStXSnapshotTransformation methodsFor:'accessing'!

original
    ^ original
!

transformed
    ^ transformed
! !

!MCStXSnapshotTransformation methodsFor:'transforming'!

transform: anMCSnapshot
    "Returns a transformed **copy** of the original snapshot"

    original := anMCSnapshot.
    transformed := original copy.

    "use #copy to allow modifications to definitions collection while
     transforming."
    transformed definitions copy reverseDo:[:definition|
        definition accept: self.        
    ].
    ^transformed.

    "Created: / 29-05-2013 / 11:40:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-05-2013 / 00:10:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStXSnapshotTransformation methodsFor:'visiting'!

visitClassDefinition: definition

    "Modified: / 29-05-2013 / 12:07:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitClassTraitDefinition: definition

    "Modified: / 29-05-2013 / 12:08:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitMetaclassDefinition: definition

    "Modified: / 29-05-2013 / 12:08:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitMethodDefinition: definition

    "Modified: / 29-05-2013 / 12:08:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitOrganizationDefinition: defintion

    "Modified: / 29-05-2013 / 12:08:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

visitTraitDefinition: definition

    "Modified: / 29-05-2013 / 12:08:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCStXSnapshotTransformation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStXSnapshotTransformation.st,v 1.2 2013-05-30 23:35:33 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCStXSnapshotTransformation.st,v 1.2 2013-05-30 23:35:33 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


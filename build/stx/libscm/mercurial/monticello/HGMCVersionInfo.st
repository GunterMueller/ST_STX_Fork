"{ Package: 'stx:libscm/mercurial/monticello' }"

"{ NameSpace: Smalltalk }"

MCLazyVersionInfo subclass:#HGMCVersionInfo
	instanceVariableNames:'package changeset'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Monticello'
!

!HGMCVersionInfo class methodsFor:'documentation'!

documentation
"
    A Monticello ancestry object representing Mercurial history.
    Useful when exporting package maintained in Mercurial to
    Monticello.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!HGMCVersionInfo class methodsFor:'instance creation'!

forPackage: pkg 
    | pm cs |

    pm := HGPackageWorkingCopy named: pkg.
    cs := pm repository @ pm revision.
    ^self forPackage: pkg changeset: cs

    "Created: / 07-06-2013 / 01:27:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-09-2014 / 11:41:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forPackage: package changeset: changeset

    ^self new initializeWithPackage: package changeset: changeset

    "Created: / 07-06-2013 / 01:28:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMCVersionInfo methodsFor:'accessing'!

ancestors

    ancestors isNil ifTrue:[
        | p1 p2 spliced |
        p1 := p2 := spliced := #().

        changeset parent1 notNil ifTrue:[
            p1 := Array with: (self class forPackage: package changeset:changeset parent1).
        ].
        changeset parent2 notNil ifTrue:[
            p2 := Array with: (self class forPackage: package changeset:changeset parent2).
        ].
        spliced := self splicedAncestorsFor: changeset id.
        ancestors := p1 , p2 , spliced.
    ].
    ^super ancestors

    "Created: / 07-06-2013 / 01:16:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-09-2015 / 00:46:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeset
    ^ changeset
!

message:something
    message := something.
!

stepChildren

    stepChildren isNil ifTrue:[
        stepChildren := #()
    ].
    ^super stepChildren

    "Created: / 07-06-2013 / 01:17:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMCVersionInfo methodsFor:'initialization'!

initializeWithPackage: aSymbol changeset: anHGChangeset

    package := aSymbol.
    changeset := anHGChangeset.

    message:= changeset message.
    date:= changeset timestamp asDate.
    time:= changeset timestamp asTime.
    author:= changeset author.

"/    name := (ProjectDefinition definitionClassForPackage: package) monticelloNameForMCZ , '-', changeset id printStringWithoutNumber , '.' , changeset id revno printString.
    name := (ProjectDefinition definitionClassForPackage: package) monticelloNameForMCZ 
                , '-' , ((author upTo: $<) select:[:c|c isAlphaNumeric])
                , '.' , changeset id printStringWithoutNumber 
                , '.' , (changeset timestamp printStringFormat: '%(year)%(month)%(day)%h%m%s').

    id := UUID fromBytes: (SHA1Stream hashValueOf: name).

    ancestors := stepChildren := nil.

    "Created: / 07-06-2013 / 01:32:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-06-2013 / 02:01:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMCVersionInfo methodsFor:'private'!

splicedAncestorsFor: changesetId
    | prjDef splicedAncestors |

    prjDef := ProjectDefinition definitionClassForPackage: package.
    prjDef notNil ifTrue:[ 
        prjDef monticelloSplicemap pairWiseDo:[ :commitid :mcversion |
            commitid first = HGChangesetId name ifTrue:[ 
                commitid decodeAsLiteralArray = changesetId ifTrue:[ 
                    | mcversionDecoded |
                    mcversionDecoded := mcversion decodeAsLiteralArray.
                    splicedAncestors isNil ifTrue:[ 
                        splicedAncestors := Array with: mcversionDecoded
                    ] ifFalse:[
                        splicedAncestors := splicedAncestors copyWith: mcversionDecoded
                    ]
                ].
            ].
        ].
    ].
    ^ splicedAncestors ? #()

    "
    (HGMCVersionInfo forPackage: 'stx:goodies/petitparser/compiler') splicedAncestorsFor ('f6f68d32de73' asHGChangesetId)
    (HGMCVersionInfo forPackage: 'stx:goodies/petitparser') splicedAncestorsFor ('f6f68d32de73' asHGChangesetId)
    "

    "Created: / 07-09-2015 / 18:18:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGMCVersionInfo class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


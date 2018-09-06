"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:libscm/mercurial' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HGContribution
	instanceVariableNames:'changesets'
	classVariableNames:'Date1 Date2'
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Tools'
!

!HGContribution class methodsFor:'documentation'!

copyright
"
stx:libscm - a new source code management library for Smalltalk/X
Copyright (C) 2012-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!HGContribution class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."
    Date1 := Timestamp fromString: '2011-04-01'.
    Date2 := Timestamp fromString: '2015-03-31'.

    "Modified: / 24-04-2018 / 15:31:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGContribution class methodsFor:'instance creation'!

summaryFromChangesets:aCollection 
    "of HGChangeser"
    
    | author2ChangesetMap |

    author2ChangesetMap := Dictionary new.
    aCollection do:[:cs |(author2ChangesetMap at:cs author ifAbsentPut:[Set new]) add:cs].  
    ^ author2ChangesetMap values 
        collect:[:changesets | self new setChangesets:changesets ].

    "Created: / 16-04-2018 / 22:40:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2018 / 20:06:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

summaryFromFile: anHGChangesetFile
    | path branch revset changesets|

    path := anHGChangesetFile pathName.
    branch := anHGChangesetFile changeset branch name.
    revset := 'ancestors(.) and filelog(''%1'') and !!merge() and branch(%2)' bindWith: path with: branch.
    changesets := anHGChangesetFile repository log:revset limit:nil.
    changesets := changesets select:[:each | self hasChangeset: each contributedTo: path ].
    ^ self summaryFromChangesets: changesets

    "
    HGChangesetBrowser openOnRepository: anHGChangesetFile repository revset: (HGRevset fromString: revset).
    "

    "Created: / 17-04-2018 / 13:46:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2018 / 09:39:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGContribution class methodsFor:'queries'!

hasChangeset: anHGChangeset contributedTo: aString
    "
    Given a changeset and file, return true, if the changeset contains
    changes that count as meaningful a 'contribution'.

    Naively, each changeset that modifies a file is a 'contribution'. 
    Due to long and complex history, not each changeset actually adds
    anything meaningful. Namely:

     1. Merge changesets are not counted as 'contribution'. Sadly, not
        all merges are tracked in mercurial history since we've been
        using SubVersion for a long time and subversion merges are
        note recorded.

     2. For couple years, JV was contracted by eXept. To be on a safe
        side, in that period no changes of his counts as his contribution
        (might be, but would be hard to tell and argue :-)

     3. Modifications involving only version methods and/or #copyright method 
        do not count as a 'contribution'.

     Complicated. isn't it?
    "

    "/ 1. Merge changesets are not counted as 'contribution'.
    anHGChangeset isMerge ifTrue:[ ^ false ].
    (anHGChangeset summary includesString: 'trunk' caseSensitive: false) ifTrue:[ ^ false ].
    (anHGChangeset summary includesString: 'merge' caseSensitive: false) ifTrue:[ ^ false ].

    "/ 2. For couple years, JV was contracted by eXept
    ((anHGChangeset author includesString: 'jan vrany' caseSensitive: false)
        and:[ anHGChangeset timestamp between: Date1 and: Date2]) ifTrue:[ ^ false ].

    "/ 3. Modifications involving only version methods do not count as
    (aString endsWith:'.st') ifTrue:[ 
        | file parent |

        file := anHGChangeset / aString.
        self assert: file notNil.
        [
            parent := anHGChangeset parent1 / aString.
        ] on: HGError do:[:ex |
            "/ HGChangeset >> #/ throws an `HGError` when file
            "/ does not exist in that changeset. In that case,
            "/ consider the changeset as contribution (it
            "/ added the file),
            ^ true.
        ].
        (parent notNil and:[ file sha1 ~= parent sha1 ]) ifTrue:[ 
            | fileCS parentCS diffs |

            [ 
                file readingFileDo:[:s | fileCS := ChangeSet fromStream: s ].
                parent readingFileDo:[:s | parentCS := ChangeSet fromStream: s ].
            ] on: Error do:[:ex | 
                "/ In case of an error, we cannot check. Let's play safe side
                "/ and consider it no contribution.
                ^ false
            ].

            diffs := fileCS diffSetsAgainst: parentCS.
            diffs isEmpty ifTrue:[ ^ false ].

            ((diffs changed allSatisfy: [ :pair | self isVersionOrCopyrightMethodChange: pair first ])
                and:[ (diffs onlyInReceiver allSatisfy: [ :chg | self isVersionOrCopyrightMethodChange: chg])
                and:[ (diffs onlyInArg allSatisfy: [ :chg | self isVersionOrCopyrightMethodChange: chg])]])
                    ifTrue:[ ^ false ].    
        ].
    ].
    ^ true.

    "
    HGCopyrightUpdater main:#('--cwd' 'libbasic' 'UnorderedNumbersError.st')
    "

    "Created: / 24-04-2018 / 14:56:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-05-2018 / 09:28:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGContribution class methodsFor:'testing'!

isVersionOrCopyrightMethodChange:aChange
    ^ aChange isMethodChange
        and:[ (AbstractSourceCodeManager isVersionMethodSelector: aChange selector)
                or:[ aChange selector == #copyright ] ]

    "Created: / 14-05-2018 / 08:25:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGContribution methodsFor:'accessing'!

author
    ^ changesets anyOne author

    "Created: / 16-04-2018 / 22:59:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesets
    ^ changesets
!

name
    ^ (self author upTo: $<) trimSeparators

    "Created: / 16-04-2018 / 23:02:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

years
    | years current |

    years := OrderedCollection new.
    changesets do:[:changeset | 
        | year |

        year := changeset timestamp year.
        current isNil ifTrue:[ 
            current := year to: year.
        ] ifFalse:[                 
            self assert: (current isKindOf: Interval).
            (current stop ~~ year) ifTrue:[
                current stop = (year - 1) ifTrue:[ 
                    current stop: year.
                ] ifFalse:[ 
                    years add: current.
                    current := year to: year.
                ].
            ].
        ].
    ].
    years add: current.
    ^ years.

    "Created: / 23-04-2018 / 16:02:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2018 / 12:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGContribution methodsFor:'initialization'!

setChangesets: aChangessets
    changesets := aChangessets asArray sort: [ :a :b | a timestamp < b timestamp ].

    "Created: / 16-04-2018 / 22:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGContribution methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut: $(.
    aStream nextPutAll: self author.
    aStream nextPut: $).

    "Modified: / 03-05-2018 / 23:16:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGContribution class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


HGContribution initialize!

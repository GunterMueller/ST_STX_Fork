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

Object subclass:#HGCopyrightUpdater
	instanceVariableNames:'verbose dryrun removeYearToNow'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-StX-Tools'
!

!HGCopyrightUpdater class methodsFor:'documentation'!

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

!HGCopyrightUpdater methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ repository := nil.
    "/ patterns := nil.
    "/ wc := nil.
    verbose := 0.
    dryrun := false.
    removeYearToNow := false.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 17-05-2018 / 11:42:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setDryRun: aBoolean
    
    dryrun := aBoolean

    "Created: / 14-05-2018 / 19:57:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setRemoveYearToNow: aBoolean
    removeYearToNow := aBoolean

    "Created: / 17-05-2018 / 11:41:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setVerbose: anInteger
    
    verbose := anInteger

    "Created: / 03-05-2018 / 22:36:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCopyrightUpdater methodsFor:'private'!

collectCopyrightsFromContributionsTo:anHGChangesetFile 
    | contributions  copyrights |

    contributions := self searchForContributions:anHGChangesetFile.
    contributions isEmpty ifTrue:[
        ^ #()
    ].
    copyrights := OrderedCollection new.
    contributions do:[:contribution | 
        contribution years do:[:years | 
            copyrights add:((HGCopyrightLine new)
                        years:years;
                        holder:contribution name)
        ].
    ].
    ^ copyrights

    "Created: / 15-05-2018 / 13:17:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

collectCopyrightsFromText:lines 
    | current  copyrights  lineNr |

    copyrights := OrderedCollection new.
    current := nil.
    lineNr := 1.
    [ lineNr <= lines size ] whileTrue:[
        | line  copyright |

        line := lines at:lineNr.
        copyright := HGCopyrightLine readFrom:line onError:[ nil ].
        copyright notNil ifTrue:[
            copyright line:lineNr.
            current isNil ifTrue:[
                current := OrderedCollection with:copyright.
            ] ifFalse:[
                current add:copyright
            ].
        ] ifFalse:[
            current notNil ifTrue:[
                copyrights add:current.
                current := nil.
            ].
        ].
        lineNr := lineNr + 1.
    ].
    current notNil ifTrue:[
        copyrights add:current.
        current := nil.
    ].
    ^ copyrights

    "Created: / 17-04-2018 / 13:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-05-2018 / 13:49:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

collectMissing1: computed in: present
    "
    Return a list of copyright lines missing in `present`. 
    Both `present` and `computed` lines MUST have the same holder.

    WARNING: do not use this method, this is a helper for
    #collectMissing:in:
    "

    | missing |

    missing := Set new.
    computed do:[:c |
        (present noneSatisfy:[:p|(c years start in: p years) and:[c years stop in: p years]]) ifTrue:[ 
            missing add: c.
        ].
    ].
    ^ missing.

    "Created: / 16-05-2018 / 09:33:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-05-2018 / 13:57:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

collectMissing: computed in: present
    "
    Return a list of copyright lines missing in `present`
    "

    | presentHolders buckets missing |

    "/ First, sort copyright lines into 'buckets' by copyright holder.
    buckets := Dictionary new.
    presentHolders := Set new.
    present do:[:each | 
        (buckets at: each holder ifAbsentPut: [Array with: Set new with: Set new]) second add: each.
        presentHolders add: each holder.
    ].
    computed do:[:each | 
        | holder |

        holder := presentHolders detect:[:holder | holder includesString: each holder caseSensitive: false ] ifNone:[ each holder ].
        (buckets at: each holder ifAbsentPut: [Array with: Set new with: Set new]) first add: each.
    ].
    missing := SortedCollection new.
    buckets do:[:bucket | 
        missing addAll: (self collectMissing1: bucket first in: bucket second).
    ].
    ^ missing.

    "Created: / 15-05-2018 / 13:34:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-05-2018 / 09:31:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

searchForContributions: anHGChangesetFile
    "
    Return a list of contributions (as HGContribution) for given changeset file.
    "
    | contributions |
    contributions := HGContribution summaryFromFile:anHGChangesetFile.
    (contributions notEmpty and:[verbose > 1]) ifTrue:[ 
        Transcript showCR:'Contributions:'.  
        contributions do:[:contribution |  
            Transcript space; show: contribution author; show: ': '; cr.
            contribution changesets do:[:changeset | 
                Transcript show: '  * '; show: changeset id printString; show:' ('; show: changeset timestamp printString; show: ')'.
                verbose > 3 ifTrue:[ 
                    Transcript cr; nextPutAll: changeset message; cr.
                ] ifFalse:[ 
                    Transcript space; showCR: changeset summary
                ].
            ].
        ]
    ].    
    ^ contributions

    "Created: / 15-05-2018 / 13:08:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateCopyrights: computed present: present in: lines
    | changed missingInsertPosition missing |

    self assert: present notEmpty.
    self assert: present last line notNil.

    missingInsertPosition := present last line .
    changed := false.

    verbose > 0 ifTrue:[ 
        Transcript showCR: 'Copyrights:'.
        present do:[:copyright | Transcript show: ((removeYearToNow and:[copyright isYearToNow]) ifTrue:[ '- ' ] ifFalse:[ '  ']); showCR: copyright asString ]
    ].

    "/ Reject (invalid) copyright lines in form YYYY-now (such as 2016-now)
    present copy reverseDo:[ :copyright |
        (removeYearToNow and:[ copyright isYearToNow ]) ifTrue:[ 
            present remove: copyright.
            lines removeIndex: copyright line.
            missingInsertPosition := missingInsertPosition - 1.
            changed := true.
        ].
    ].

    "/ Add all missing copyrights
    missing := self collectMissing: computed in: present. 
    missing isEmpty ifTrue:[ ^ changed ].
    verbose > 0 ifTrue:[ 
        missing do:[:copyright | Transcript show: '+ '; showCR: copyright asString ].
    ].
    missing withIndexDo:[ :copyright :index |
        lines add: copyright asString beforeIndex: missingInsertPosition + index.
        changed := true.
    ].
    ^ changed

    "Created: / 23-04-2018 / 15:55:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-05-2018 / 11:42:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCopyrightUpdater methodsFor:'utilities'!

updateFile:file
    "
    For given file (as `HGWorkingCopyFile`) add missing copyright lines
    based on commits and saves update contents back to file (unless dry-run
    is specified, see #setDryRun:)
    "

    | wc computed lines presentRuns changed |

    verbose > 0 ifTrue:[ 
       Transcript show:'File '; showCR: file baseName.  
    ].

    wc := file repository workingCopy.

    self assert:(wc parent1Id = file changesetId).
    self assert:(wc / file pathName) exists.

    "/ Collect copyright lines from file contents....
    lines := (wc / file pathName) contents.
    presentRuns := self collectCopyrightsFromText:lines.

    "/ Compute copyright lines from contributions (i.e., based on commit authors)
    computed := self collectCopyrightsFromContributionsTo: file.  
    computed isEmpty ifTrue:[ ^ self ].

    "/ At this point, we know that there has been a contribution.
    "/ If there are existing no copytight notices in the file
    "/ (i.e, `presentRuns` is empty), raise a warning.
    presentRuns isEmpty ifTrue:[ 
        Warning raiseErrorString: ('File %1 has contributions but not copyright notice!!' bindWith: file pathName).
        ^ self 
    ].

    computed do:[:each | each prefix: presentRuns first last prefix ].

    changed := false.
    presentRuns reverseDo:[:copyright |
        changed := (self updateCopyrights: computed present: copyright in: lines) or:[ changed ].
    ].
    (changed and:[dryrun not]) ifTrue:[ 
        (wc / file pathName) contents: lines.
    ].
    verbose > 0 ifTrue:[ 
       Transcript showCR:'--'; cr.
    ]. 
    "
    HGCopyrightUpdateTool main:#('--cwd' 'goodies/regression'   '-v' '-v' '-v' '--dry-run')

    HGCopyrightUpdateTool main:#('--cwd' 'librun'   '-v' '-v' '-v' '--dry-run' 'send.c')
    HGCopyrightUpdateTool main:#('--cwd' 'librun'   '-v' '-v' '-v' '--dry-run' 'hmm.c')

    HGCopyrightUpdateTool main:#('--cwd' '../..'   '-v' '-v' '-v' '--dry-run' 'LICENSE.txt')

    HGCopyrightUpdateTool main:#('--cwd' 'goodies/smallsense'   '-v' '-v' '-v' '--dry-run' 'SmallSense__SmalltalkQuickFixer.st')
    HGCopyrightUpdateTool main:#('--cwd' 'goodies/smallsense'   '-v' '-v' '-v' '--dry-run' 'SmallSense__SmalltalkEditSupportTests.st')

    HGCopyrightUpdateTool main:#('--cwd' 'libbasic' '-v' '-v' '-v' '--dry-run')
    HGCopyrightUpdateTool main:#('--cwd' 'libbasic' '-v' '-v' '-v' '--dry-run' 'SmalltalkChunkFileSourceReader.st')
    HGCopyrightUpdateTool main:#('--cwd' 'libbasic' '-v' '-v' '-v' '--dry-run' 'UnorderedNumbersError.st')
    HGCopyrightUpdateTool main:#('--cwd' 'libbasic' '-v' '-v' '-v' '--dry-run' 'Method.st')
    HGCopyrightUpdateTool main:#('--cwd' 'libbasic' '-v' '-v' '-v' '--dry-run' 'Array.st')
    HGCopyrightUpdateTool main:#('--cwd' 'libbasic' '-v' '-v' '-v' '--dry-run' 'WeakArray.st')
    HGCopyrightUpdateTool main:#('--cwd' 'libbasic' '-v' '-v' '-v' '--dry-run' 'UnixOperatingSystem.st')
    "

    "Created: / 16-05-2018 / 23:01:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-06-2018 / 21:02:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGCopyrightUpdater class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group,
                           Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

ChangeSetDiffComponent subclass:#ChangeSetDiffEntry
	instanceVariableNames:'versionBase versionA versionB versionMerged mergeInfo'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes-Diff'
!

!ChangeSetDiffEntry class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany, SWING Research Group,
                           Czech Technical University in Prague
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!ChangeSetDiffEntry class methodsFor:'instance creation'!

versionA:versionA 

    ^self new
"/        versionB: versionA asAntiChange
        versionA: versionA.

    "Modified (comment): / 20-03-2012 / 21:42:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionA:versionA versionB:versionB 

    ^self new
        versionA: versionA;
        versionB: versionB.
!

versionB:versionB 

    ^self new
"/        versionA: versionB asAntiChange;
        versionB: versionB.

    "Modified: / 20-03-2012 / 21:42:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffEntry class methodsFor:'image specs'!

iconMinus
    ^ ToolbarIconLibrary iconMinus12x12

    "Modified: / 31-08-2011 / 10:51:21 / cg"
!

iconPlus
    ^ ToolbarIconLibrary iconPlus12x12

    "Modified: / 31-08-2011 / 10:51:34 / cg"
! !

!ChangeSetDiffEntry methodsFor:'accessing'!

changeClass

    ^(versionA ? versionB) changeClass

    "Created: / 30-11-2011 / 11:35:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changeSelector

    | chg |

    (chg := versionA ? versionB) isMethodChange ifTrue:[
        ^chg changeSelector            
    ] ifFalse:[
        ^nil
    ]

    "Created: / 30-11-2011 / 11:40:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

className

    ^(versionA ? versionB) className

    "Created: / 01-11-2009 / 16:48:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeInfo
    (mergeInfo isNil and:[Tools::TextMergeInfo notNil]) ifTrue:[
        mergeInfo := Tools::TextMergeInfo new.
        mergeInfo text1: self versionBaseText text2: self versionAText text3: self versionBText.
    ].
    ^mergeInfo

    "Created: / 19-03-2012 / 14:57:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergeInfo:aTextMergeInfo
    mergeInfo := aTextMergeInfo.

    "Created: / 19-03-2012 / 14:57:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergedUsingVersionA

    versionMerged ifNil:[^false].
    versionA ifNil:[^false].

    ^versionA sameAs: versionMerged

    "Created: / 24-11-2009 / 08:16:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergedUsingVersionB

    versionMerged ifNil:[^false].
    versionB ifNil:[^false].

    ^versionB sameAs: versionMerged

    "Created: / 24-11-2009 / 08:16:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mergedUsingVersionBase

    versionMerged ifNil:[^false].
    versionBase ifNil:[^false].

    ^versionBase sameAs: versionMerged

    "Created: / 24-11-2009 / 08:16:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name

    ^self versionAorB displayString

    "Created: / 24-11-2009 / 09:56:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nonMetaClassName

    ^(versionA ? versionB) nonMetaClassName

    "Created: / 21-11-2009 / 07:42:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionA
    ^ versionA
!

versionA:something
    versionA := something.
!

versionALabel
    ^ parent versionALabel

    "Created: / 09-11-2009 / 12:38:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionAText
    ^versionA notNil ifTrue:[            
        versionA source
    ] ifFalse:[
        nil
    ].

    "Created: / 06-07-2011 / 12:29:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionAorB

    ^versionA ? versionB

    "Created: / 02-11-2009 / 18:48:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionB
    ^ versionB
!

versionB:something

    versionB := something.

    "Modified: / 20-03-2012 / 22:08:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBLabel
    ^ parent versionBLabel

    "Created: / 09-11-2009 / 12:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBText
    ^versionB notNil ifTrue:[            
        versionB source
    ] ifFalse:[
        nil
    ].

    "Created: / 06-07-2011 / 12:29:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBase
    ^ versionBase
!

versionBase:something
    versionBase := something.
!

versionBaseText
    ^versionBase notNil ifTrue:[            
        versionBase source
    ] ifFalse:[
        nil
    ].

    "Created: / 16-03-2012 / 15:20:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMerged
    "Returns a change representing a merge"

    | merged |
    merged := versionMerged.
    (merged isNil and:[mergeInfo notNil]) ifTrue:[
        | source |

        source := mergeInfo text.
        source isEmpty ifTrue:[ ^ nil ].
        merged := (versionA ? versionB ? versionBase) copy.
        merged source: source.
        merged isClassDefinitionChange ifTrue:[
            merged setupFromSource.
        ]

    ].
    ^merged

    "Modified: / 16-11-2015 / 13:19:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMerged:aChange
    versionMerged := aChange.
    self changed:#resolution with: aChange

    "Modified: / 24-11-2009 / 12:58:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionMergedLabel

    (versionMerged isNil)
        ifTrue:[^'<unresolved>' withColor:#red].
    (versionMerged sameAs: versionA)
        ifTrue:[^self versionALabel].
    (versionMerged sameAs: versionB)
        ifTrue:[^self versionBLabel].
    (versionMerged sameAs: versionBase)
        ifTrue:[^self versionBaseLabel].
    ^'manual merge'
! !

!ChangeSetDiffEntry methodsFor:'enumerating'!

do: aBlock

    aBlock value: self

    "Created: / 25-11-2009 / 10:22:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffEntry methodsFor:'merging'!

automerge

    "Automerge version methods"
    versionB ifNil:[^self].
    versionB isMethodCodeChange ifTrue:[
        (AbstractSourceCodeManager isVersionMethodSelector: versionB selector) ifTrue:[
            versionMerged := versionB copy.
            self mergeInfo mergeUsingB: (versionB source)
        ]
    ].

    "Created: / 02-11-2009 / 18:51:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-04-2012 / 16:37:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 09-04-2012 / 18:01:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffEntry methodsFor:'private'!

sort:sortBlock
    "superclass ChangeSetDiffComponent says that I am responsible to implement this method"

    "Ignored"

    "Modified: / 17-01-2013 / 13:57:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffEntry methodsFor:'testing'!

isConflict
    "Return true, if there is a conflict. For simple two-way diff,
     conflict is when there are both versionA and versionB and they
     differ. For three-way diff/merge, conflict is iff the entry is not
     yet merged"

    ^versionBase isNil ifTrue:[
        "/two-way diff
        versionA notNil and:[versionB notNil and:[(versionA sameAs: versionB) not]]
    ] ifFalse:[
        self isMerged not
    ].

    "Created: / 01-08-2012 / 17:10:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDiffItem
    ^ true
!

isForCopyrightMethod
    "Returns true, if this is an entry for version method"

    | version |

    version := versionA ? versionB.
    ^version isMethodCodeChange
        and:[version isForMeta and: [version selector == #copyright]]

    "Created: / 01-08-2012 / 16:39:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isForVersionMethod
    "Returns true, if this is an entry for version method"

    | version |

    version := versionA ? versionB.
    ^version isMethodCodeChange
        and:[(AbstractSourceCodeManager isVersionMethodSelector: version selector) or:[AbstractSourceCodeManager isExtensionsVersionMethodSelector: version selector]]

    "Created: / 18-04-2012 / 18:50:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-07-2013 / 13:17:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMerged
    | mi |

    versionMerged notNil ifTrue:[ ^ true ].

    ^(mi := self mergeInfo) notNil ifTrue:[
        mi isMerged
    ] ifFalse:[
        false
    ]

    "Created: / 19-03-2012 / 15:12:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffEntry class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


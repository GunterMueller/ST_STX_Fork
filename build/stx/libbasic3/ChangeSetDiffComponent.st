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

Object subclass:#ChangeSetDiffComponent
	instanceVariableNames:'parent'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes-Diff'
!

!ChangeSetDiffComponent class methodsFor:'documentation'!

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

!ChangeSetDiffComponent methodsFor:'accessing'!

changesetA
    "Answers a changeset with containing all versionA changes"
    | cs |

    cs := ChangeSet new name: self versionALabel.
    self do:[:item|
        (item versionA notNil" and:[item versionMerged isClassDefinitionChange or:[item versionMerged isMethodCodeChange]]") ifTrue:[
            cs add: item versionA
        ]
    ].
    ^cs

    "Modified: / 18-12-2013 / 20:55:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetB
    "Answers a changeset with containing all versionA changes"
    | cs |

    cs := ChangeSet new name: self versionBLabel.
    self do:[:item|
        (item versionB notNil" and:[item versionMerged isClassDefinitionChange or:[item versionMerged isMethodCodeChange]]") ifTrue:[
            cs add: item versionB
        ]
    ].
    ^cs

    "Modified: / 18-12-2013 / 20:55:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetBase
    "Answers a changeset with containing all versionA changes"
    | cs |

    cs := ChangeSet new name: self versionBaseLabel.
    self do:[:item|
        (item versionBase notNil" and:[item versionBase isClassDefinitionChange or:[item versionBase isMethodCodeChange]]") ifTrue:[
            cs add: item versionBase
        ]
    ].
    ^cs

    "Created: / 20-03-2012 / 13:31:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2013 / 11:47:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

changesetMerged
    "Answers a changeset with containing all versionA changes"
    | cs |

    cs := ChangeSet new name: 'Merged'.
    self do:[:item|
        (item versionMerged notNil "and:[item versionMerged isClassDefinitionChange or:[item versionMerged isMethodCodeChange]]") ifTrue:[
            cs add: item versionMerged
        ]
    ].
    ^cs

    "Created: / 20-03-2012 / 13:32:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-11-2013 / 11:47:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

depth
    "Return the depth if diff component hierarchy, 0 if there is no nesting at all"
    ^0

    "Created: / 15-01-2013 / 11:26:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffs

    ^#()

    "Created: / 10-11-2009 / 11:29:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flattened

    ^ChangeSetDiffSet new add: self

    "Created: / 05-12-2009 / 11:07:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

parent
    ^ parent
!

parent:aDiffSet
    parent := aDiffSet.
!

versionALabel
    ^ parent versionALabel

    "Created: / 09-11-2009 / 12:38:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBLabel
    ^ parent versionBLabel

    "Created: / 09-11-2009 / 12:38:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionBaseLabel
    ^ parent versionBaseLabel

    "Created: / 20-03-2012 / 13:31:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffComponent methodsFor:'change & update'!

changed: aspect with: param

    (aspect = #resolution and:[parent notNil])
        ifTrue:[parent changed: aspect with: param].
    super changed: aspect with: param.

    "Created: / 24-11-2009 / 12:58:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffComponent methodsFor:'enumerating'!

do: aBlock

    self subclassResponsibility

    "Created: / 25-11-2009 / 10:22:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffComponent methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation of the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    self name printOn: aStream.
    aStream nextPut:$).

    "Modified: / 26-11-2009 / 16:25:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffComponent methodsFor:'private'!

flattenOn: stream

    ^stream nextPut: self

    "Created: / 05-12-2009 / 11:06:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sort
    self sort: [:a :b|a printString < b printString ].

    "Created: / 17-01-2013 / 13:56:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sort: sortBlock
    self subclassResponsibility

    "Created: / 17-01-2013 / 13:57:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiffComponent methodsFor:'testing'!

isConflict
    "Return true, if there is a conflict."

    ^ self subclassResponsibility

    "Modified (comment): / 01-08-2012 / 17:11:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isDiffItem
    ^ false
!

isDiffSet
    ^ false
!

isEmpty

    ^false
!

isForCopyrightMethod
    "Returns true, if this is an entry for #copyright method"
    ^self subclassResponsibility

    "Created: / 01-08-2012 / 16:37:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isForVersionMethod
    "Returns true, if this is an entry for version method"
    ^self subclassResponsibility

    "Created: / 18-04-2012 / 19:04:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isMerged
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!ChangeSetDiffComponent class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


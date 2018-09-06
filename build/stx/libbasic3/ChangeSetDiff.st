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

Object subclass:#ChangeSetDiff
	instanceVariableNames:'diffset same'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Changes-Diff'
!

!ChangeSetDiff class methodsFor:'documentation'!

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

!ChangeSetDiff class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!ChangeSetDiff class methodsFor:'utilities'!

versionA:changesetA versionB:changesetB 
    ^ (self new)
        versionA:changesetA versionB:changesetB;
        diffset

    "Created: / 02-11-2009 / 16:12:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionA:changesetA versionB:changesetB versionBase: versionBase 
    ^ (self new)
        versionA:changesetA versionB:changesetB versionBase: versionBase;
        diffset

    "Created: / 03-11-2009 / 07:58:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiff methodsFor:'accessing'!

diffset
    ^ diffset
!

same
    ^ same
! !

!ChangeSetDiff methodsFor:'diffing'!

versionA:changesetA versionB:changesetB 

    self versionA:changesetA versionB:changesetB versionBase: nil

    "Created: / 31-10-2009 / 19:12:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2009 / 18:38:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionA:a versionB:b versionBase:base 
    |ds diffsByClass include|

    diffsByClass := Dictionary new.
    ds := a diffSetsAgainst:b.
    same := ds same.

    include := [:chg | 
            true"(AbstractSourceCodeManager isVersionMethodSelector:chg selector) not"
    ].
    ds onlyInReceiver do:[:chg | 
          (include value:chg) ifTrue:[
            (diffsByClass at:chg nonMetaClassName
                ifAbsentPut:[ChangeSetDiffSet new name:chg nonMetaClassName]) 
                    add:(ChangeSetDiffEntry versionA:chg)
        ]
    ].
    ds changed do:[:chgPair | 
        | chg |

        chg := chgPair first ? chgPair second.
        (include value:chg) ifTrue:[
            (diffsByClass at:chg nonMetaClassName
                ifAbsentPut:[ChangeSetDiffSet new name:chg nonMetaClassName]) 
                    add:(ChangeSetDiffEntry versionA:chgPair first versionB:chgPair second)
        ]
    ].
    ds onlyInArg do:[:chg | 
        (include value:chg) ifTrue:[
            (diffsByClass at:chg nonMetaClassName
                ifAbsentPut:[ChangeSetDiffSet new name:chg nonMetaClassName]) 
                    add:(ChangeSetDiffEntry versionB:chg)
        ]
    ].
    base notNil ifTrue:[
        "Try to assign base version to each diff item"
        "Sorry, we are using O^2 algorithm here, I'm too lazy now :-)"
        diffsByClass do:[:diffs | 
            diffs do:[:diff | 
                |versionBase|

                versionBase := base detect:[:each | each isForSameAs:(diff versionA ? diff versionB)] ifNone:[nil].

                "/ only the category is different;
                "/ make it a MethodCategory changes.
                (versionBase notNil and:[versionBase isMethodCodeChange and:[
                    diff versionA notNil and:[diff versionA isMethodCategoryChange 
                        and:[diff versionA notNil  and:[diff versionB isMethodCategoryChange]]]]]) ifTrue:[
                            versionBase := MethodCategoryChange new
                                        className:versionBase className
                                        selector:versionBase selector
                                        category:versionBase methodCategory;
                                        origin: versionBase
                            ].
"/                versionBase isNil ifTrue:[
"/                    diff versionA isClassRemoveChangeOrMethodRemoveChange not ifTrue:[
"/                        versionBase := diff versionA asAntiChange
"/                    ] ifFalse:[
"/                        versionBase := diff versionA copy
"/                    ]
"/                ].
                diff versionBase:versionBase.
                diff automerge
            ]
        ]
    ].
    diffsByClass size = 1 ifTrue:[
        diffset addAll:diffsByClass anElement diffs
    ] ifFalse:[
        diffset addAll:diffsByClass values
    ].
    diffset versionALabel:a name.
    diffset versionBLabel:b name.
    base notNil ifTrue:[
        diffset versionBaseLabel:base name.
    ].

    "Created: / 02-11-2009 / 16:17:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-06-2011 / 08:22:49 / Jan Vrany <enter your email here>"
    "Modified: / 18-12-2013 / 21:05:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiff methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    diffset := ChangeSetDiffSet new.
    same := ChangeSet new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 19-03-2012 / 21:51:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ChangeSetDiff class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


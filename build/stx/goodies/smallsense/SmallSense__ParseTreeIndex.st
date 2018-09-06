"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

OrderedCollection subclass:#ParseTreeIndex
	instanceVariableNames:'tree source'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core-Index'
!

!ParseTreeIndex class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    For given parse tree, a ParseTreeIndex provides an
    fast access to individual (leave) nodes by keeping
    an index. Used by CodeView2 for various queries

    Experimental

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ParseTreeIndex methodsFor:'accessing'!

atCharacterPosition: characterPosition
    "Retrun entry at given character position or nil, if none"

    | index element |

    0"1" to:0 by:-1 do:[:d |
        index := (self indexForInserting:characterPosition) - d.
        index > self size ifTrue:[^nil].
        element := self at:index ifAbsent:nil.
        element notNil ifTrue:[
            (characterPosition between: element start and: element stop) ifTrue:[^element].
        ].
        index + 1 > self size ifTrue:[^nil].
        element := self at:index + 1 ifAbsent:nil.
        element notNil ifTrue:[
            (characterPosition between: element start and: element stop) ifTrue:[^element].
        ].

    ].
        ^nil

    "Created: / 20-10-2013 / 01:02:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source
    ^ source
!

source:something
    source := something.
!

tree
    ^ tree
!

tree:aParseNode
    tree := aParseNode.
! !

!ParseTreeIndex methodsFor:'inspecting'!

inspector2TabParseTreeInspector
    ^ (self newInspector2Tab)
        label:'Parse Tree';
        priority:35;
        application:
            [
                SmallSense::ParseTreeInspector new node:tree source:source
            ];
        yourself

    "Created: / 09-04-2014 / 09:31:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-04-2014 / 08:58:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspector2Tabs
    ^ super inspector2Tabs , #(inspector2TabParseTreeInspector)

    "Created: / 09-04-2014 / 09:32:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-04-2014 / 08:47:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeIndex methodsFor:'utilities'!

newElementFor: aParseNode

    ^(ParseTreeIndexEntry new node: aParseNode)

    "Created: / 16-02-2012 / 21:00:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParseTreeIndex class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


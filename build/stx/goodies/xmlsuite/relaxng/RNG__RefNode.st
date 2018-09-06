"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

Object subclass:#RefNode
	instanceVariableNames:'referencedNode name parent prev next bindingInfo pattern'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Content model'
!


!RefNode class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 12-05-2005 / 12:03:39 / masca"
! !

!RefNode methodsFor:'accessing'!

bindingInfo
    ^ bindingInfo

    "Created: / 12-05-2005 / 17:09:30 / masca"
!

name
    ^ name

    "Created: / 02-05-2005 / 13:52:19 / janfrog"
!

name:aString
    name := aString.

    "Created: / 02-05-2005 / 13:52:19 / janfrog"
!

next

    ^"referencedNode" next

    "Created: / 02-05-2005 / 14:07:53 / janfrog"
    "Modified: / 12-05-2005 / 12:04:29 / masca"
!

next:aNode
    next := aNode.

    "Created: / 12-05-2005 / 12:01:53 / masca"
!

parent:aNode

    parent := aNode

    "Created: / 03-05-2005 / 11:10:41 / janfrog"
!

prev
    ^ prev

    "Created: / 12-05-2005 / 12:01:53 / masca"
!

prev:aNode
    prev := aNode.

    "Created: / 12-05-2005 / 12:01:53 / masca"
!

referencedNode
    ^ referencedNode

    "Created: / 02-05-2005 / 13:53:50 / janfrog"
!

referencedNode:aContentModelNode
    referencedNode := aContentModelNode.
    referencedNode parent:self.

    "Created: / 02-05-2005 / 13:53:50 / janfrog"
    "Modified: / 13-05-2005 / 15:29:17 / masca"
! !

!RefNode methodsFor:'checking'!

checkContents

    "nothing to do"

    "Created: / 02-05-2005 / 13:56:50 / janfrog"
!

postParseFor:aSchema

    "^referencedNode postParseFor:aSchema"

    "Created: / 02-05-2005 / 14:06:50 / janfrog"
    "Modified: / 16-05-2005 / 09:23:01 / masca"
! !

!RefNode methodsFor:'delegation'!

doesNotUnderstand:aMessage 
    ^ (referencedNode respondsTo:aMessage selector) 
        ifTrue:[ aMessage reinvokeFor: referencedNode ]
        ifFalse:[ super doesNotUnderstand:aMessage ]

    "Created: / 13-05-2005 / 15:01:09 / masca"
! !

!RefNode methodsFor:'initialization'!

initialize

    prev := next := TerminatorNode default.
    bindingInfo := BindingInfo new.

    "Created: / 12-05-2005 / 12:03:57 / masca"
    "Modified: / 12-05-2005 / 17:09:51 / masca"
!

initializeBindingInfoFromAttributes:anAttributes 
    self bindingInfo initializeFromAttributes:anAttributes

    "Created: / 12-05-2005 / 17:10:38 / masca"
! !

!RefNode methodsFor:'printing'!

nameForPrint
    ^referencedNode pattern nameForPrint

    "Created: / 02-05-2005 / 14:32:05 / janfrog"
!

printOn:aStream

    aStream nextPutAll:'R:'.

    referencedNode printOn:aStream.

    "Created: / 02-05-2005 / 14:32:31 / janfrog"
    "Modified: / 19-05-2005 / 10:13:36 / masca"
! !

!RefNode methodsFor:'testing'!

isRefNode

    ^true

    "Created: / 16-05-2005 / 09:25:20 / masca"
!

isTerminatorNode

    ^false

    "Created: / 02-05-2005 / 14:07:36 / janfrog"
! !

!RefNode class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__RefNode.st,v 1.1.1.1 2005-11-01 22:07:14 vranyj1 Exp $'
! !

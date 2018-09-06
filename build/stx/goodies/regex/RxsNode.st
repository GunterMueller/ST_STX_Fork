"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.
"
"{ Package: 'stx:goodies/regex' }"

"{ NameSpace: Regex }"

Object subclass:#RxsNode
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Regex-Syntax'
!

RxsNode comment:'||| This is a part of the Regular Expression Matcher package, (c) Vassili Bykov, 1996.
||| Refer to `documentation'' protocol of RxParser class for details.

A generic syntax tree node, provides some common responses to the standard tests, as well as tree structure printing -- handy for debugging.'
!

!RxsNode class methodsFor:'documentation'!

copyright
"
    The RegEx package was written and is copyrighted by Vassili Bykov
    (vbykov@cam.org).
    See #RxParser >> boringStuff on what you may (or may not do) with it.

    This package is not part of the ST/X licence - it is distributed with 
    ST/X for your convenience.

"
! !

!RxsNode methodsFor:'constants'!

indentCharacter
	"Normally, #printOn:withIndent: method in subclasses
	print several characters returned by this method to indicate
	the tree structure."

	^$+
! !

!RxsNode methodsFor:'testing'!

isAtomic
	"Answer whether the node is atomic, i.e. matches exactly one 
	constant predefined normal character.  A matcher may decide to 
	optimize matching of a sequence of atomic nodes by glueing them 
	together in a string."

	^false "tentatively"
!

isNullable
	"True if the node can match an empty sequence of characters."

	^false "for most nodes"
! !

!RxsNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsNode.st,v 1.5 2009-10-01 07:05:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/regex/RxsNode.st,v 1.5 2009-10-01 07:05:24 cg Exp $'
! !

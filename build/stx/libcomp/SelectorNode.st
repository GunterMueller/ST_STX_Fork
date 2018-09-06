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
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

ParseNode subclass:#SelectorNode
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView-Syntax'
!

!SelectorNode class methodsFor:'documentation'!

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
    A (helper) node that represents a selector (or its part).
    SelectorNodes are not directly created nor used by the
    parser/compiler itself.

    Some custom subclasses (syntax highlighters for instance)
    makes use of it.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        SyntaxHighlighter2

"
! !

!SelectorNode class methodsFor:'instance creation'!

value: selector from: start to: end

    ^self new
        value: selector;
        startPosition:start endPosition: end

    "Created: / 16-02-2012 / 20:56:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNode methodsFor:'accessing'!

name
    "req'd because ParseTreeIndex::Element sends it"

    ^ value
!

selector
    ^ value

    "Created: / 25-02-2014 / 22:08:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

value
    ^ value
!

value:aString
    value := aString.
! !

!SelectorNode methodsFor:'testing'!

isSelector

    ^true

    "Created: / 16-02-2012 / 21:04:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SelectorNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/SelectorNode.st,v 1.3 2014-07-05 08:31:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/SelectorNode.st,v 1.3 2014-07-05 08:31:39 cg Exp $'
! !


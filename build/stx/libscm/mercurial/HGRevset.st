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

Object subclass:#HGRevset
	instanceVariableNames:'expression comment'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Mercurial-Core'
!

!HGRevset class methodsFor:'documentation'!

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
!

documentation
"
    HGRevset represent a `revset` expression as used by Mercurial.
    Revset is an expression specifying a set of changesets (commits).


    For more on revsets see `hg help revset`

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        hg help revset

"
! !

!HGRevset class methodsFor:'instance creation'!

expression: expression comment: comment
    ^ self new setExpression: expression comment: comment.

    "Created: / 24-03-2014 / 21:55:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromString: aString
    ^ self new setExpression: aString

    "Created: / 07-02-2014 / 12:59:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevset methodsFor:'comparing'!

= another
    ^ (another isKindOf: self class)
        and:[ self asString = another asString ].

    "Created: / 24-03-2014 / 21:52:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    ^ expression hash

    "Created: / 24-03-2014 / 21:52:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevset methodsFor:'constructing'!

reverse
    expression isNil ifTrue:[ ^ self ].
    ^ self class    
        expression: 'reverse(', (expression ? '') , ')'
        comment:  comment

    "Created: / 25-03-2014 / 01:42:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevset methodsFor:'conversion'!

asHGRevset
    ^ self

    "Created: / 07-02-2014 / 12:59:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asString
    ^ expression

    "Created: / 07-02-2014 / 12:59:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevset methodsFor:'displaying'!

displayString
    ^ comment notNil 
        ifTrue:[ expression asText , ((' - ', comment) asText colorizeAllWith: Color gray)]
        ifFalse:[ expression ]

    "Created: / 24-03-2014 / 21:44:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-03-2014 / 01:27:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HGRevset methodsFor:'initialization'!

setComment: aString
    comment := aString

    "Created: / 24-03-2014 / 21:43:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setExpression: aString
    expression := aString

    "Created: / 07-02-2014 / 12:59:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setExpression: expr comment: comm
    expression := expr.
    comment := comm

    "Created: / 24-03-2014 / 21:55:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


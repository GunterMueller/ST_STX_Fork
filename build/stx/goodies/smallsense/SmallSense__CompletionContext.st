"{ Encoding: utf8 }"

"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Object subclass:#CompletionContext
	instanceVariableNames:'environment node position support'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Core'
!

!CompletionContext class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany
Copyright (C) 2014 Claus Gittinger

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

!CompletionContext class methodsFor:'instance creation'!

node: node position: position

    ^self new node: node position: position

    "Created: / 26-11-2011 / 16:22:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionContext methodsFor:'accessing'!

environment
    "Return an system environment for completion."

    ^ environment

    "Modified (comment): / 13-05-2014 / 11:54:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

environment:aSystemEnvironment
    "Sets an envirronment for completion. Only classes and/or methods in
     the environment are offered for completion"
    environment := aSystemEnvironment.

    "Modified (comment): / 13-05-2014 / 11:55:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

language
    "Return a programming language in which to complete. i.e., the language of edited source code"

    | lang |

    lang := self textView editedLanguage.
    lang isNil ifTrue:[ 
        lang := support language.
    ].
    ^ lang

    "Modified: / 10-03-2015 / 10:04:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

node
    ^ node
!

position
    ^ position
!

support
    ^ support
!

textView
    ^ support textView

    "Created: / 11-02-2015 / 23:50:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionContext methodsFor:'initialization'!

node:nd position: pos

    node := nd.
    position := pos.

    "Created: / 26-11-2011 / 16:22:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2013 / 23:31:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

support: anEditSupport
    support := anEditSupport.

    "Modified: / 21-01-2014 / 23:31:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionContext methodsFor:'private'!

wordBeforeCursor
    ^ support wordBeforeCursor.

    "Created: / 27-09-2013 / 15:53:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-03-2014 / 23:03:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wordBeforeCursorConsisitingOfCharactersMatching: characterMatchBlock
    ^ support wordBeforeCursorConsisitingOfCharactersMatching: characterMatchBlock

    "Created: / 20-10-2013 / 00:17:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-03-2014 / 23:03:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionContext methodsFor:'queries'!

isAfterNode
    ^ node notNil and:[node endPosition < (position - 1)]

    "Created: / 26-11-2011 / 16:24:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2013 / 23:31:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isBeforeNode
    ^node notNil and:[position < node startPosition]

    "Created: / 26-11-2011 / 16:24:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-09-2013 / 13:11:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isInNode
    ^ node notNil and:[(position - 1) between:node startPosition and:node endPosition]

    "Created: / 26-11-2011 / 16:24:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-10-2013 / 23:31:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CompletionContext class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


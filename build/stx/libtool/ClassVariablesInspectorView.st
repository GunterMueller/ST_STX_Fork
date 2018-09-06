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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

SmalltalkInspectorView subclass:#ClassVariablesInspectorView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector'
!

!ClassVariablesInspectorView class methodsFor:'documentation'!

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
    same as a smalltalk inspector - separate subclass to allow for a different menu,
    and filtering classVars.

    [author:]
        Claus Gittinger
"
! !

!ClassVariablesInspectorView methodsFor:'private'!

indexList
    "redefined to only show class variables"

    keys := OrderedCollection new.
    inspectedObject keysDo:[:k |
                                (Smalltalk keyIsClassVariableNameKey:k) ifTrue:[
                                    keys add:k
                                ]
                           ].
    keys := keys asSortedCollection:[:a :b | a displayString < b displayString].
    ^ keys
! !

!ClassVariablesInspectorView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/ClassVariablesInspectorView.st,v 1.2 2006/01/30 18:17:56 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


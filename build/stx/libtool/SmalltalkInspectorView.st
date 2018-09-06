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

DictionaryInspectorView subclass:#SmalltalkInspectorView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector'
!

!SmalltalkInspectorView class methodsFor:'documentation'!

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
    same as a dictionary inspector - separate subclass to allow for a different menu.

    [author:]
        Claus Gittinger
"
! !

!SmalltalkInspectorView methodsFor:'initialization & release'!

initialize
    super initialize.

    hideNilValues := true.
! !

!SmalltalkInspectorView methodsFor:'private'!

indexList
    "redefined to not show class variables"

^ super indexList.
"/    keys := OrderedCollection new.
"/    inspectedObject keysDo:[:k |
"/                                (Smalltalk keyIsClassVariableNameKey:k) ifFalse:[
"/                                    keys add:k
"/                                ]
"/                           ].
"/    keys := keys asSortedCollection:[:a :b | a displayString < b displayString].
"/    ^ keys
! !

!SmalltalkInspectorView class methodsFor:'documentation'!

version
    ^ '$Id: SmalltalkInspectorView.st 7854 2012-01-30 17:49:41Z vranyj1 $'
!

version_CVS
    ^ '§Header: /cvs/stx/stx/libtool/SmalltalkInspectorView.st,v 1.4 2010/03/03 11:16:38 cg Exp §'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: SmalltalkInspectorView.st 7854 2012-01-30 17:49:41Z vranyj1 $'
! !


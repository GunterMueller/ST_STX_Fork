"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#WidgetWrapper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!WidgetWrapper class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2003 by eXept Software AG
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
    This is a dummy stub - only present to provide a superclass for
    some VW Public Domain code (which subclass or add loose code to WidgetWrapper).
"
! !

!WidgetWrapper class methodsFor:'others'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/WidgetWrapper.st,v 1.3 2017-01-23 22:36:42 cg Exp $'
! !

!WidgetWrapper methodsFor:'accessing'!

createAdaptor

	^ COAST.CatDMWidgetStateAdaptor on: self
!

widgetWrapper

	^ self
! !

!WidgetWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/WidgetWrapper.st,v 1.3 2017-01-23 22:36:42 cg Exp $'
! !

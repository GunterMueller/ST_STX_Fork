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

Object subclass:#ScrollWrapper
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST80'
!

!ScrollWrapper class methodsFor:'documentation'!

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
    some VW Public Domain code (which subclass or add loose code to ScrollWrapper).
"
! !

!ScrollWrapper class methodsFor:'others'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/ScrollWrapper.st,v 1.5 2017-01-23 22:37:08 cg Exp $'
! !

!ScrollWrapper methodsFor:'accessing'!

scrollWrapper

	^ self
! !

!ScrollWrapper methodsFor:'misc'!

sharedOnFrame: aFrame slotName: aSlotSymbol
        "transform the scroll wrapper into a shared one
         the scroll position will be kept in the specified frame/slot"

        |app origin|

        app := self topComponent.
        origin := COAST.CoastScrollValueHolder adaptFrame: aFrame slot: aSlotSymbol application: app.
        origin addDependent: self.
!

sharedOnFrame: aFrame slotName: aSlotSymbol application: aCoastLocalApplicationModel
        "transform the scroll wrapper into a shared one
         the scroll position will be kept in the specified frame/slot"

        |origin|

        origin := COAST.CoastScrollValueHolder adaptFrame: aFrame slot: aSlotSymbol application: aCoastLocalApplicationModel.
        origin addDependent: self.
! !

!ScrollWrapper class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/ScrollWrapper.st,v 1.5 2017-01-23 22:37:08 cg Exp $'
! !


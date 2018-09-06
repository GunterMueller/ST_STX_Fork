"
 COPYRIGHT (c) 2011 by eXept Software AG
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

Object subclass:#Preferences
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!Preferences class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2011 by eXept Software AG
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
    DO NOT DIRECTLY REFER TO THIS CLASS OR USE IT OTHERWISE IN YOUR CODE:

    This is a dummy, mimicry class to allow some squeak code to access
    UserPreferences.
    Its protocol is neither complete, nor fully compatible with the corresponding
    squeak original class.
"
! !

!Preferences class methodsFor:'defaults'!

automaticViewerPlacement
    ^ true
!

coloredTilesEnabled
    ^ false
!

fenceEnabled
    ^ false
!

menuBorderColor
    ^ Color black


!

menuBorderWidth
    ^ 1

!

menuColor
    ^ View defaultViewBackgroundColor
!

menuLineLowerColor
    ^ Color black
!

menuLineUpperColor
    ^ Color black
!

menuTitleBorderColor
    ^ Color black

!

menuTitleBorderWidth
    ^ 1

!

menuTitleColor
    ^ Color black

!

noviceMode


    ^ false
!

showPlayerSource
    ^ false
!

useCategoryListsInViewers
    ^ false
!

useDetailPanesInViewers
    ^ false
!

useScrollingInPartsLists
    ^ false
!

valueOfFlag:aSymbolicFlag
    ^ self perform:aSymbolicFlag ifNotUnderstood:false
! !

!Preferences class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Preferences.st,v 1.4 2017-01-28 00:00:14 cg Exp $'
!

version_SVN
    ^ '$Id: Preferences.st,v 1.4 2017-01-28 00:00:14 cg Exp $'
! !


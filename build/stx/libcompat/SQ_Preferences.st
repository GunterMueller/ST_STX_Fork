"{ Package: 'stx:libcompat' }"

Object subclass:#Preferences
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!Preferences class methodsFor:'documentation'!

documentation
"
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
    ^ '$Header: /cvs/stx/stx/libcompat/SQ_Preferences.st,v 1.5 2000-12-01 11:25:14 cg Exp $'
! !

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
"{ Package: 'stx:libhtml' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HTMLPageStyle
	instanceVariableNames:'activeAnchorBGColor activeAnchorFGColor anchorFGColor
		anchorUnderline codeFGColor exampleFGColor fontSize fontStyles
		headerNumbers initialHeaderNumbers printTOC textFGColor
		viewBGColor visitedAnchorFGColor extraListItemSpacing'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLPageStyle class methodsFor:'documentation'!

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
    Attention: Please read the warning in HTMLElement.
"
! !

!HTMLPageStyle methodsFor:'accessing'!

anchorUnderline
    ^ anchorUnderline ? false
!

anchorUnderline:something
    anchorUnderline := something.
!

exampleFGColor
    ^ exampleFGColor
!

exampleFGColor:something
    exampleFGColor := something.
!

extraListItemSpacing
    ^ extraListItemSpacing ? 2
!

extraListItemSpacing:something
    extraListItemSpacing := something.
!

fetchDeviceColorsFor:aDevice
    activeAnchorFGColor := activeAnchorFGColor onDevice:aDevice.
    activeAnchorBGColor := activeAnchorBGColor onDevice:aDevice.
    anchorFGColor := anchorFGColor onDevice:aDevice.
    codeFGColor := codeFGColor onDevice:aDevice.
    textFGColor := textFGColor onDevice:aDevice.
    viewBGColor := viewBGColor onDevice:aDevice.
    visitedAnchorFGColor := visitedAnchorFGColor onDevice:aDevice.
!

fontSize
    ^ fontSize
!

fontSize:something
    fontSize := something.
!

fontStyles
    ^ fontStyles
!

fontStyles:something
    fontStyles := something.
!

headerNumbers
    ^ headerNumbers ? false
!

headerNumbers:something
    headerNumbers := something.
!

initialHeaderNumbers
    ^ initialHeaderNumbers
!

initialHeaderNumbers:something
    initialHeaderNumbers := something.
!

printTOC
    ^ printTOC ? false
!

printTOC:something
    printTOC := something.
!

textFGColor
    ^ textFGColor
!

textFGColor:something
    textFGColor := something.
!

viewBGColor
    ^ viewBGColor
!

viewBGColor:something
    viewBGColor := something.
!

visitedAnchorFGColor
    ^ visitedAnchorFGColor
!

visitedAnchorFGColor:something
    visitedAnchorFGColor := something.
! !

!HTMLPageStyle methodsFor:'accessing-color & font'!

activeAnchorBGColor
    ^ activeAnchorBGColor
!

activeAnchorBGColor:something
    activeAnchorBGColor := something.
!

activeAnchorFGColor
    ^ activeAnchorFGColor
!

activeAnchorFGColor:something
    activeAnchorFGColor := something.
!

anchorFGColor
    ^ anchorFGColor
!

anchorFGColor:something
    anchorFGColor := something.
!

codeFGColor
    ^ codeFGColor
!

codeFGColor:something
    codeFGColor := something.
! !

!HTMLPageStyle class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLPageStyle.st,v 1.8 2017-11-28 18:24:16 cg Exp $'
! !


"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"



"{ Package: 'stx:libtool2' }"

SimpleDialog subclass:#SelectionBrowser
	instanceVariableNames:'title'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Dialogs'
!

SelectionBrowser class instanceVariableNames:'lastSelection'

"
 The following class instance variables are inherited by this class:

	SimpleDialog - 
	ApplicationModel - ClassResources
	Model - 
	Object - 
"
!

!SelectionBrowser class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997-1998 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    The abstract superclass for the ResourceSelectionBrowser
    and the FileSelectionBrowser.

    [author:]
       Thomas Zwick
"
! !

!SelectionBrowser class methodsFor:'accessing'!

lastSelection
    "returns the last selection; file path or resource class"

    ^lastSelection
!

lastSelection: aString
    "sets the last selection; file path or resource class"

    lastSelection := aString
! !

!SelectionBrowser class methodsFor:'queries'!

isVisualStartable
    "return true, if this application can be started via #open.
     (to allow start of a change browser via double-click in the browser)"

    self == SelectionBrowser ifTrue:[^false].
    ^super isVisualStartable
! !

!SelectionBrowser methodsFor:'accessing'!

title: aString
    "sets the title"

    title := aString

! !

!SelectionBrowser methodsFor:'help'!

openHTMLDocument: aHTMLFilename
    "open a HTMLDocumentView on aHTMLFilename"

    HTMLDocumentView openFullOnDocumentationFile: aHTMLFilename
! !

!SelectionBrowser methodsFor:'startup & release'!

postBuildWith:aBuilder
    "sets the title (can be defined)"

    builder window label: title ? builder window label.

    super postBuildWith:aBuilder
! !

!SelectionBrowser class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

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

"{ NameSpace: Tools }"

Object subclass:#Toolbox
	instanceVariableNames:'browser environment'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Tools'
!

!Toolbox class methodsFor:'documentation'!

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
    Concrete subclasses provide lenguage-specfici services for other tools
    like list of classes/globals used in a method, list of messages sent by 
    this method, senders/implementors of a selector and so on.

    NOTE: Lot of code used to be directly in tools, namely NewSystemBrowser.
    The code should be moved to toolbox classes to allow reuse and to allow
    for multiple languages (Smalltalk / Java / JavaScript / Ruby).

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!Toolbox class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!Toolbox methodsFor:'accessing'!

browser
    ^ browser
!

browser:aNewSystemBrowser
    browser := aNewSystemBrowser.
!

environment
    ^ environment
!

environment:env
    environment := env.
! !

!Toolbox methodsFor:'accessing-methods'!

globalsReferencedByMethods: methods
    "Returns a list of globals (classes) referenced by given methods"

    ^ self subclassResponsibility

    "Created: / 24-02-2014 / 16:19:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Toolbox methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ browser := nil.
    environment := Smalltalk

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 05-09-2013 / 12:46:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Toolbox methodsFor:'menu-methods'!

messagesMenuFor:actionSelector
    withMethods: methods
    withMethodSelectors:withMethodSelectors
    withSentSelectors: withSentSelectors
    withSelfSelectorsOnly: withSelfSelectorsOnly 

    ^ self subclassResponsibility.

    "Modified: / 24-02-2014 / 16:17:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Toolbox methodsFor:'private'!

ensureBrowser
    browser isNil ifTrue:[
        browser := NewSystemBrowser new.
        browser open.
    ].
    ^ browser

    "Created: / 31-08-2013 / 22:46:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Toolbox class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libtool/Tools__Toolbox.st,v 1.3 2014-02-25 10:41:16 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__Toolbox.st,v 1.3 2014-02-25 10:41:16 vrany Exp $'
! !


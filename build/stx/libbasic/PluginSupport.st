"
 COPYRIGHT (c) 2005 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Object subclass:#PluginSupport
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

Query subclass:#StartParameterQuery
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:PluginSupport
!

!PluginSupport class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005 by Claus Gittinger
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
    Provides support functions to run ST/X in an external (web-browser) window as a plugin.
    (actually, it could be started from any other application just the same...)

    [author:]
        Claus Gittinger

    [see also:]
        Smalltalk
"
! !

!PluginSupport class methodsFor:'startup'!

embedView:aView inWindowWithID:windowID
    "embed a view in the external (web-browser-) window"

    |browserWindow|

    browserWindow := ExternalTopView newWithID:windowID.
    browserWindow viewBackground:(Color red).
    browserWindow clear.
    browserWindow width:self getBrowserWindowWidth.
    browserWindow height:self getBrowserWindowHeight.

    browserWindow becomeParentOf:aView.
    self setPluginWindowHandle:(aView id).
!

showPluginWarning:message inWindowWithID:windowID
    |messageView|

    messageView := Label new.
    messageView label:message.
    self embedView:messageView inWindowWithID:windowID 
!

startClass:anApplicationClass inWindowWithID:windowID parameters:parameters
    "open up a new instance of an application- or view-class in the external browserWindow"

    |applicationOrView view|

    StartParameterQuery answer:parameters do:[
        (anApplicationClass isSubclassOf:ApplicationModel) ifTrue:[
            applicationOrView := anApplicationClass new.
            applicationOrView allButOpen.
            view := applicationOrView window.
        ] ifFalse:[
            applicationOrView := anApplicationClass new.
            applicationOrView isView ifTrue:[
                view := applicationOrView
            ] ifFalse:[
                view := applicationOrView window.
            ].
        ].
    ].

    self embedView:view inWindowWithID:windowID 
!

startInBrowserWithWindowID:windowID parameters:parameters
    "take application-info from the browser-parameters,
     and open up a new instance of it in the external browserWindow"

    |appClassName appClass src|

    src := parameters at:'src' ifAbsent:nil.
    src notNil ifTrue:[
        "/ fetch this document from the browser...
        self 
            showPluginWarning:'Cannot (yet) load Application code'
            inWindowWithID:windowID.
    ].

    appClassName := parameters at:'application' ifAbsent:nil.
    appClassName notNil ifTrue:[
        appClass := Smalltalk classNamed:appClassName.
        appClass notNil ifTrue:[
            self
                startClass:appClass
                inWindowWithID:windowID
                parameters:parameters.
            ^ self.
        ].
        self 
            showPluginWarning:'Missing Application Class: ', appClassName
            inWindowWithID:windowID.
        ^ self.
    ].

    self
        startClass:NewLauncher
        inWindowWithID:windowID
        parameters:parameters.

    "
     |v|

     v := StandardSystemView new.
     v openAndWait.
     self startInBrowserWithWindowID:v id parameters:(Dictionary new).
    "

    "
     |v app|

     v := StandardSystemView new.
     v create.
     app := WorkspaceApplication new.
     app window:v.
     app allButOpen.
     app openWindow.
    "

    "Modified: / 14-09-2010 / 16:07:42 / cg"
! !

!PluginSupport class methodsFor:'support'!

getBrowserWindowHeight
%{
    extern int __pluginGetBrowserWindowHeight();

    RETURN (__mkSmallInteger(__pluginGetBrowserWindowHeight()));
%}.
!

getBrowserWindowWidth
%{
    extern int __pluginGetBrowserWindowWidth();

    RETURN (__mkSmallInteger(__pluginGetBrowserWindowWidth()));
%}.
!

setPluginWindowHandle:windowId
%{
    extern void __pluginSetWindow();
#   define HWND         void *

    if (__isExternalAddress(windowId)) {
        HWND hWnd = (HWND)__externalAddressVal(windowId);
        __pluginSetWindow(hWnd);
    }
%}.
! !

!PluginSupport class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/PluginSupport.st,v 1.16 2012-08-03 20:26:00 stefan Exp $'
! !

"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

Object subclass:#HTMLScriptEnvironment
	instanceVariableNames:'window'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Documentation'
!

!HTMLScriptEnvironment class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    whenever a script is encountered in a document,
    an anonymous subclass of myself is created and a single instance of
    it. The scripts variables are defined as instance variables, the methods
    are installed as instance methods.
    This is the script-object, which does all the smalltalkScript stuff.

    For javaScript, the mechanism is similar, using an instance of
    JavaScriptEnvironment.

    [author:]
        Claus Gittinger
"





! !

!HTMLScriptEnvironment methodsFor:'accessing'!

window
    "return the window object.
     For now, that's the only defined (non-global) object."

    ^ window

    "Created: / 18.9.1996 / 16:06:50 / cg"
    "Modified: / 17.5.1998 / 21:15:35 / cg"
! !

!HTMLScriptEnvironment methodsFor:'evaluation'!

_evaluateAction:aString with:aComponentName
    "invoked when some HTML-element (such as a button) with an ONCLICK
     action is pressed. This is supposed to parse the passed string as
     an expression in my language (i.e. smalltalkScript) and invoke that
     function."

    |selector|

    ErrorSignal handle:[:ex |
        self warn:'error in script: ' , ex errorString
    ] do:[
        selector := aString asSymbol.
        (self respondsTo:selector) ifTrue:[
            (aString endsWith:$:) ifTrue:[
                self perform:selector with:aComponentName.
            ] ifFalse:[
                self perform:selector.
            ].
        ] ifFalse:[
            self warn:('script does not define action: ' , selector)
        ]
    ].

    "Created: / 17.5.1998 / 21:14:50 / cg"
    "Modified: / 17.5.1998 / 21:24:31 / cg"
! !

!HTMLScriptEnvironment methodsFor:'setup'!

_setupForWindow:aWindow
    "invoked after creation and definition of all my methods;
     this must setup the object-tree as visible to the script;
     i.e. window
             view
             document
                images 
                applets 
                forms 
                links 
                anchors
             location
             history
             frames
     This is (for now) very rudimentary."

    |painter
     document formElements realForms formNames appletElements appletViews appletNames index|

    painter := aWindow painter.
    painter notNil ifTrue:[
        formElements := painter forms.
        index := 1.
        formNames := 
            formElements
                collect:[:aFormElement | |nm|

                            nm := aFormElement nameString.
                            nm isNil ifTrue:[
                                nm := 'form' , index printString
                            ].
                            index := index + 1.
                            nm
                        ].
        realForms := 
            formElements 
                collect:[:aFormElement |
                            |widgets widgetNames widgetViews|

                            widgets := aFormElement widgets select:[:wE | wE nameString notNil].
                            index := 1.
                            widgetNames := widgets collect:[:aWidgetElement | |nm|
                                                nm := aWidgetElement nameString.
                                                index := index + 1.
                                                nm
                                           ]. 
                            widgetViews := widgets collect:[:aWidgetElement | aWidgetElement view].
                            Structure newWith:widgetNames values:widgetViews.
                        ].

        appletElements := aWindow painter applets.
        index := 1.
        appletNames := 
            appletElements
                collect:[:anAppletElement | |nm|

                            nm := anAppletElement nameString.
                            nm isNil ifTrue:[
                                nm := 'form' , index printString
                            ].
                            index := index + 1.
                            nm
                        ].
        appletViews := appletElements collect:[:anAppletElement | anAppletElement view].
    ].

    document := Structure newWith:#(images applets forms links anchors).
    formNames notNil ifTrue:[
        document forms:(Structure newWith:formNames values:realForms).
    ].
    appletNames notNil ifTrue:[
        document applets:(Structure newWith:appletNames values:appletViews).
    ].

    window := Structure newWith:#(location history document frames view).
    window location:(aWindow currentURL).
    window history:(aWindow history).
    window document:document.
    window view:aWindow.

    "Created: / 21.9.1996 / 12:44:55 / cg"
    "Modified: / 17.5.1998 / 21:17:11 / cg"
!

_start
    ^ self perform:#start ifNotUnderstood:[].
!

_stop
    ^ self perform:#stop ifNotUnderstood:[].
! !

!HTMLScriptEnvironment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/HTMLScriptEnvironment.st,v 1.15 2016-09-22 13:11:57 cg Exp $'
! !


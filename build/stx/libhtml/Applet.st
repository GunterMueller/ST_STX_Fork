View subclass:#Applet
	instanceVariableNames:'parameters codeBase resolver'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!

!Applet class methodsFor:'documentation'!

documentation
"
    This is an Abstract superclass for applets.
    Applets are meant to provide an interface similar
    to Java applets. They have a much simpler interface
    than regular views.

    [Instance variables:]

        resolver        - the HTML URL resolver

        parameters      - parameters from the HTML page

        codeBase        - the loaded codes base


    The entries are:

        init            - to initialize applet-private data

        repaint:aGC     - to redraw the applets full area.
                          The argument is some GraphicsContext.
"
! !

!Applet class methodsFor:'standAlone startup'!

open
    |topView applet|

    topView := StandardSystemView new.
    topView label:self class name.

    applet := self in:topView.
    applet layout:(0.0@0.0 corner:1.0@1.0) asLayout.
    applet init.

    topView open
! !

!Applet methodsFor:'accessing'!

codeBase:urlString
    "set the codeBase - an internal interface"

    codeBase := urlString

    "Modified: 8.10.1996 / 18:09:41 / cg"
    "Created: 10.10.1996 / 19:58:20 / cg"
!

getCodeBase
    "return the codeBase - thats the URL, where the applet was loaded from.
     For internal applets, '.' is returned"

    codeBase isNil ifTrue:[
        ^ '.'
    ].
    ^ codeBase

    "Created: 10.10.1996 / 19:58:00 / cg"
    "Modified: 10.10.1996 / 20:14:33 / cg"
!

getParameter:name
    parameters isNil ifTrue:[^ nil].
    ^ parameters at:(name asSymbol) ifAbsent:nil

    "Created: 8.10.1996 / 18:45:08 / cg"
    "Modified: 9.10.1996 / 12:28:02 / cg"
!

parameters
    "return the parameters; this contains key-value pairs
     containing the applets parameters (as specified in <PARAM> tags)"

    ^ parameters

    "Modified: 8.10.1996 / 18:09:41 / cg"
    "Created: 8.10.1996 / 18:57:37 / cg"
!

parameters:something
    "set the parameters. Not a public entry."

    parameters := something.

    "Modified: 8.10.1996 / 18:10:02 / cg"
    "Created: 8.10.1996 / 18:57:48 / cg"
!

resolver:anImageAndDocumentResolver
    "set the resolver - an internal interface"

    resolver := anImageAndDocumentResolver

    "Modified: 8.10.1996 / 18:09:41 / cg"
    "Created: 10.10.1996 / 19:58:20 / cg"
! !

!Applet methodsFor:'event handling'!

redrawX:x y:y width:w height:h
    "redraw the applets view area.
     Here, a full redraw is always performed. To do a partial
     redraw, either redefine the #redrawX:y:width:height: message,
     or fetch the GC's clipRectangle in the repaint method."

    self repaint.

    "Modified: 8.10.1996 / 18:11:21 / cg"
! !

!Applet methodsFor:'initialization'!

init
    "redefinable in subclasses - without a need to do a super>>init"

    "Created: 8.10.1996 / 18:26:46 / cg"
! !

!Applet methodsFor:'redrawing'!

repaint
    "clear and repaint"

    shown ifTrue:[
        self clear.
        self repaint:self
    ]

    "Created: 8.10.1996 / 17:22:28 / cg"
    "Modified: 10.10.1996 / 20:09:29 / cg"
!

repaint:aGC
    "to be redefined by a concrete applet"

    "Created: 8.10.1996 / 18:08:59 / cg"
! !

!Applet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libhtml/Applet.st,v 1.8 1997-02-11 21:44:21 ca Exp $'
! !

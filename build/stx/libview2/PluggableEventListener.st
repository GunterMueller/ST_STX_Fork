"
 COPYRIGHT (c) 2014 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

EventListener subclass:#PluggableEventListener
	instanceVariableNames:'keyPressAction keyReleaseAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI'
!

!PluggableEventListener class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2014 by Claus Gittinger
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
    a preliminary version of a pluggable event listener.
    can be configured via handler blocks.

    [see also:]
        WindowSensor WindowEvent WindowGroup

    [author:]
        Claus Gittinger
"
!

example
"
    to eat a particular key from another view:

    |v e|

    v := StandardSystemView extent:300@200.
    v add:(e := EditTextView origin:0.0@0.0 corner:1.0@1.0).
    v label:'key a is ignored'.
    v openAndWait.

    e sensor addEventListener:(
        PluggableEventListener new
            keyPressAction:[:event |
                event key == $a ifTrue:[
                    Transcript showCR:'a key eaten'.
                    true.
                ] ifFalse:[
                    Transcript showCR:'other key ok:',event key printString.
                    false
                ]
            ]).

    to get events for a hotKey (attention: synchronous,
    so you better enqueue the event into an application's private queue
    in the handler block)

    Display rootView
        addHotKeyHandler:(
                PluggableEventListener new
                    keyPressAction:[:event |
                        Transcript showCR:event.
                        event key = 'F2' ifTrue:[
                            Transcript showCR:'F2 pressed'.
                            true.
                        ] ifFalse:[
                            Transcript showCR:'other key ok:',event key printString.
                            false
                        ]
                    ])
         forKey:'F2'
         modifierMask:nil  
"
! !

!PluggableEventListener methodsFor:'accessing'!

keyPressAction:aBlock
    "install a block as handler for keyPress events.    
     the block will get the windowEvent as argument,
     and is supposed to return true if it handled the event,
     false if not (so the event is processed as usual)."

    keyPressAction := aBlock.
!

keyReleaseAction:aBlock
    "install a block as handler for keyRelease events.    
     the block will get the windowEvent as argument,
     and is supposed to return true if it handled the event,
     false if not (so the event is processed as usual)."

    keyReleaseAction := aBlock.
! !

!PluggableEventListener methodsFor:'event processing'!

processEvent:anEvent
    "process an event; if true is returned, the event is considered to be
     'eaten' by the listener, and not passed to the view.
     If false is returned, the event is processed as usual.
     Here, the event is dispatched into one of the button*/key* etc. methods"

    |handler|

    anEvent isKeyPressEvent ifTrue:[
        handler := keyPressAction
    ] ifFalse:[
        anEvent isKeyReleaseEvent ifTrue:[
            handler := keyReleaseAction
        ]
    ].

    handler notNil ifTrue:[
        ^ handler value:anEvent
    ].

    ^ false
! !

!PluggableEventListener class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/PluggableEventListener.st,v 1.2 2014-09-23 11:36:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/PluggableEventListener.st,v 1.2 2014-09-23 11:36:30 cg Exp $'
! !


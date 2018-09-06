"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Context variableSubclass:#BlockContext
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Methods'
!

!BlockContext class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    BlockContexts represent the stack context objects of blocks.
    The layout is the same as for other contexts - this class has been added
    to avoid a flag in an instance variable.
    (has become necessary with cheap blocks, which have no home).

    WARNING: layout and size known by compiler and runtime system -
	     do not change.

    [author:]
	Claus Gittinger

    [see also:]
	Context Block Method
	Exception Signal
"
! !

!BlockContext methodsFor:'accessing'!

canReturn
    "return true, if the receiver allows returning through it.
     For normal method contexts, this normally returns true;
     for blocks, it (currently) always returns false."

    ^ false
!

guessedHome
    "a temporary kludge: optimized block contexts do (currently) not provide
     any home info. The code below tries to guess the home."

    |sender tryVars selSender possibleBlocks method|

    (home isNil or:[home isContext not]) ifTrue:[
	(sender := self sender) notNil ifTrue:[
	    tryVars := false.
	    (selSender := sender selector) notNil ifTrue:[
		(selSender endsWith:'do:') ifTrue:[
		    tryVars := true.
		] ifFalse:[
		    (selSender endsWith:'Do:') ifTrue:[
			tryVars := true.
		    ]
		]
	    ].
	    tryVars ifTrue:[
		possibleBlocks := sender argsAndVars select:[:v | v isBlock].
		possibleBlocks := possibleBlocks select:[:b | b home isNil].

		possibleBlocks size == 1 ifTrue:[
		    method := possibleBlocks first method.
		    ^ method.
		].
	    ]
	].
    ].
    ^ nil
!

home
    "return the immediate home of the receiver.
     normally this is the methodcontext, where the block was created,
     for nested block contexts, this is the surrounding blocks context."

    home isContext ifFalse:[^ nil]. "copying blocks have no home"
    ^ home
!

homeReceiver
    "return the receiver from the context, where the receiver was defined"

    home isContext ifFalse:[^ nil]. "copying blocks have no home"
    ^ home receiver

    "Created: / 5.3.1998 / 16:20:31 / stefan"
!

method
    "return the method in which the current contexts block was created."

    home notNil ifTrue:[^ home method].
    ^ super method

    "Modified: / 19-07-2012 / 10:58:55 / cg"
!

methodHome
    "return the method-home for block contexts"

    |con h|

    home isNil ifTrue:[^ nil].
    home isContext ifFalse:[^ nil]. "copying blocks have no method home"

    con := self.
    h := home.
    [h notNil] whileTrue:[
        con := h.
        h := con home
    ].
    ^ con
!

selector
    "return the selector of the context - which is one of the value
     selectors. This selector is not found in the context, but synthesized."

    |nargs|

    nargs := self argumentCount.
    (nargs == 0) ifTrue:[^ #value].
    (nargs == 1) ifTrue:[^ #value:].
    (nargs == 2) ifTrue:[^ #value:value:].
    (nargs == 3) ifTrue:[^ #value:value:value:].
    (nargs == 4) ifTrue:[^ #value:value:value:value:].
    (nargs == 5) ifTrue:[^ #value:value:value:value:value:].
    (nargs == 6) ifTrue:[^ #value:value:value:value:value:value:].
    (nargs == 7) ifTrue:[^ #value:value:value:value:value:value:value:].
    (nargs == 8) ifTrue:[^ #value:value:value:value:value:value:value:value:].
    (nargs == 9) ifTrue:[^ #value:value:value:value:value:value:value:value:value:].
    (nargs == 10) ifTrue:[^ #value:value:value:value:value:value:value:value:value:value:].
    (nargs == 11) ifTrue:[^ #value:value:value:value:value:value:value:value:value:value:value:].
    (nargs == 12) ifTrue:[^ #value:value:value:value:value:value:value:value:value:value:value:value:].
    ^ nil
! !

!BlockContext methodsFor:'printing & storing'!

printReceiverOn:aStream
    "print a string describing the receiver of the context on aStream

     Since this is also used by the debugger(s), be very careful to
     return something useful, even in case internals of the system
     got corrupted ... (i.e. avoid messageNotUnderstood here)"

    |cls who mHome m className homeSel|

    home isContext ifFalse:[
        "
         mhmh - an optimized blocks context
         should get the block here, and get the method from
         that one ...
         ... but in 2.x, there is no easy way to get to the block
         since that one is not in the context.
         Starting with 3.x, the new block calling scheme will fix this.
        "

        "temporary kludge - peek into the sender context.
         If its a do-like method and there is a single block variable
         in the args or temporaries, that must be the one.
         This helps in some cases.
        "
        m := self method.
        m isNil ifTrue:[
            aStream nextPutAll:'[] (optimized) in ???'.
        ] ifFalse:[
            aStream nextPutAll:'[] in '.
            cls := m mclass.
            cls isNil ifTrue:[
                cls := m getMclass.
                cls isNil ifTrue:[
                    className := '*Unbound*'
                ] ifFalse:[
                    className := '(previously in) ',cls name
                ].    
            ] ifFalse:[
                className := cls name.
            ].
            className printOn:aStream. 
            aStream nextPutAll:'>>'.
            m selector printOn:aStream.
        ].
        ^ self.
    ].

    mHome := self methodHome.
    mHome isNil ifTrue:[
        aStream nextPutAll:'[] (no methodHome!!) in ???'.
        ^ self.
    ].

    "
     kludge to avoid slow search for containing class
    "
    homeSel := mHome selector.
    (homeSel == #doIt or:[homeSel == #doIt:]) ifTrue:[
        cls := mHome receiver class.
        homeSel := #doIt.
    ] ifFalse:[
        m := mHome method.
        m isNil ifTrue:[
            aStream nextPutAll:'[] (no method!!) in ???'.
            ^ self.
        ].
        who := m who.
        who notNil ifTrue:[
            cls := who methodClass
        ] ifFalse:[
            cls := receiver class.
        ].
    ].

    cls isNil ifTrue:[
        className := '???(no home class!!)'
    ] ifFalse:[
        className := cls name.
        className isEmptyOrNil ifTrue:[
            className := '???(nameless class!!)'
        ]
    ].
    aStream nextPutAll:'[] in '; nextPutAll:className; nextPutAll:'>>'.
    homeSel printOn:aStream.

    "Modified: / 19-07-2012 / 11:02:41 / cg"
! !

!BlockContext methodsFor:'testing'!

isBlockContext
    "return true, iff the receiver is a BlockContext, false otherwise"

    ^ true
!

isCheapBlockContext
    "return true, iff the receiver is a BlockContext, for a cheap block, false otherwise.
     Cheap blocks do not refer to their home"

    ^ home isNil

    "Created: / 19-07-2012 / 11:22:23 / cg"
! !

!BlockContext class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


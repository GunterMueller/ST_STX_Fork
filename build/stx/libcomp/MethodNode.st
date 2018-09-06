"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

ParseNode subclass:#MethodNode
	instanceVariableNames:'selector arguments locals statements encoder'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler ST-80-compatibility'
!

!MethodNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    This is a pure mimicri class.
    It is not used by ST/X, but provided to support limited
    compatibility for applications which build up codetrees,
    knowing internals of ST-80's compiler class hierarchy.
    This classes protocol is not (not meant to be) fully covering
    the corresponding ST-80's classes protocol. It maps ST-80 messages
    to corresponding ST/X messages (as far as possible).

    NO WARRANTY and GUARANTEE; this class may be removed without notice.
"
! !

!MethodNode methodsFor:'accessing'!

arguments
    ^ arguments
!

arguments:something
    arguments := something.
!

arguments:argVars locals:localVars statements:stats
    arguments := argVars. 
    locals := localVars. 
    statements := stats.

    "Created: / 06-08-2006 / 03:04:18 / cg"
!

encoder
    ^ encoder
!

encoder:something
    encoder := something.
!

locals
    ^ locals
!

selector
    ^ selector
!

selector:sel
    selector := sel.

    "Created: / 06-08-2006 / 01:17:42 / cg"
!

selector:sel arguments:argVars locals:localVars statements:stats
    selector := sel. 
    arguments := argVars. 
    locals := localVars. 
    statements := stats.
!

statementCollection
    "returns an orderedColl for my linked statement list"

    |coll stat|

    coll := OrderedCollection new.
    stat := statements.
    [stat notNil] whileTrue:[
        coll add:stat.
        stat := stat nextStatement.
    ].
    ^ coll
!

statements
    ^ statements 
!

statements:something
    statements := something.
! !

!MethodNode methodsFor:'code generation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    statements do:[:stat |
        stat isSequenceable ifTrue:[
            stat do:[:eachSubStat |
                eachSubStat codeForSideEffectOn:aStream inBlock:nil for:aCompiler
            ]
        ] ifFalse:[
            stat codeForSideEffectOn:aStream inBlock:nil for:aCompiler 
        ].
    ].

    "Created: / 06-08-2006 / 03:29:54 / cg"
    "Modified: / 06-08-2006 / 23:19:01 / cg"
!

emitEffect:aStream
    statements do:[:stat |
	stat codeForSideEffectOn:aStream inBlock:nil for:nil 
    ].
! !

!MethodNode methodsFor:'printing'!

printOn:aStream indent:i
    |n parts|

    selector isNil ifTrue:[
        self basicPrintOn:aStream.
        ^ self.
    ].

    n := selector numArgs.
    n == 0 ifTrue:[
        aStream nextPutAll:selector printString.
    ] ifFalse:[
        parts := selector partsIfSelector.
        parts with:arguments do:[:part :arg |
            aStream nextPutAll:part; space.
            aStream nextPutAll:arg name.
            aStream space.
        ]
    ].
    aStream cr.

    statements notNil ifTrue:[
        statements do:[:stat |
            aStream spaces:i+4.
            stat printOn:aStream indent:i+4.
            aStream nextPut:$..
            aStream cr.
        ].
    ].

    "Modified: / 06-08-2006 / 15:12:15 / cg"
! !

!MethodNode methodsFor:'testing'!

isMethodNode
    ^ true
! !

!MethodNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcomp/MethodNode.st,v 1.14 2014-03-24 12:12:59 stefan Exp $'
! !


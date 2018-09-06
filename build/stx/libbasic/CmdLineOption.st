"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
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

Object subclass:#CmdLineOption
	instanceVariableNames:'action description short shortSpec long longSpec'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Command line'
!

!CmdLineOption class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

optionsFor: anObject

    "Returns a collection of command line options for
     given object."

    ^anObject class allSelectors asSet 
                select:[:sel|sel startsWith: 'cmdlineOption']
                thenCollect:[:sel|anObject perform: sel].
! !

!CmdLineOption methodsFor:'accessing'!

action
    ^ action

    "Created: / 28-01-2009 / 11:49:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

action:aBlockOrMessageSend

    aBlockOrMessageSend numArgs > 1 ifTrue:
        [CmdLineOptionError raiseErrorString: 'Action must be zero-or-one arg block/message send'].    
    action := aBlockOrMessageSend.

    "Created: / 28-01-2009 / 11:49:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-06-2009 / 15:46:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

description
    ^ description

    "Created: / 28-01-2009 / 11:49:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

description:aString
    description := aString.

    "Created: / 28-01-2009 / 11:49:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

long
    ^ long
!

long:aString
    long := aString.
!

short
    ^ short
!

short:aCharacter

    (aCharacter isCharacter 
        and:[aCharacter isLetter or:[aCharacter isDigit]])
            ifTrue:[short := aCharacter]
            ifFalse:[self error: 'short option name should be alphanumeric character']

    "Modified: / 29-05-2009 / 16:05:46 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-09-2016 / 16:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

spec: spec
    "Build an option from option specification"

    long := short := nil.
    (spec isCollection and:[ spec isString not ]) ifTrue:[ 
        spec do:[:each | self spec0: each ]
    ] ifFalse:[ 
        self spec0: spec.
    ].

    "Created: / 14-06-2016 / 06:46:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CmdLineOption methodsFor:'parsing'!

parseL: argv startingAt: index equalCharPosition: equalPos
    "Parse a long option from argv"

    self hasParam ifTrue:[ 
        " Determine whether to parse (GNU-style ?) `--long-option=param` or
          just `--long-option param`."
        (longSpec isNil or:[longSpec includes: $=]) ifTrue:[
            equalPos == 0 ifTrue:[
                ^CmdLineOptionError signal:('Option --%',long,' requires argument').
            ] ifFalse:[
                self process: ((argv at: index) copyFrom: equalPos + 1).
            ].
            ^ index + 1.
        ] ifFalse:[
            index < argv size ifTrue:[ 
                self process: (argv at: index + 1).
                ^ index + 2.
            ] ifFalse:[ 
                 ^CmdLineOptionError signal:('Option --%',long,' requires argument')
            ].
        ]
    ] ifFalse:[ 
        self process.
        ^ index + 1
    ].

    "Created: / 29-06-2016 / 17:00:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2016 / 16:55:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CmdLineOption methodsFor:'printing & storing'!

printOn: stream

    super printOn: stream.
    stream nextPut:$(.
    short ifNotNil:[stream nextPut: $-; nextPut: short].
    (short notNil and: [long notNil]) ifTrue:[stream nextPut:$|].
    long ifNotNil:[stream nextPut: $-;  nextPut: $-; nextPutAll: long].
    stream nextPut:$)

    "Created: / 08-06-2009 / 14:48:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CmdLineOption methodsFor:'private'!

spec0:aStringOrCharacter
    aStringOrCharacter isCharacter ifTrue:[ 
        self specS: '-' , aStringOrCharacter asString.  
        ^ self.
    ].
    aStringOrCharacter isString ifTrue:[ 
        aStringOrCharacter first == $- ifTrue:[ 
            aStringOrCharacter second == $- ifTrue:[ 
                self specL: aStringOrCharacter.  
                ^ self.
            ] ifFalse:[ 
                (aStringOrCharacter size == 2 and:[ aStringOrCharacter second isLetter or:[ aStringOrCharacter second isDigit ]]) ifTrue:[ 
                    self specS: aStringOrCharacter.
                    ^ self.
                ].
            ].
        ] ifFalse:[ 
            self specL: aStringOrCharacter.
            ^ self
        ].
    ].
    self error: 'Invalid option specification: ' , aStringOrCharacter asString.

    "Created: / 14-06-2016 / 06:46:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2016 / 16:55:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

specL:aString
    | firstCharPos lastCharPos |

    long notNil ifTrue: [ self error: 'Long option already specified: ', short asString ].
    firstCharPos := 1.
    (aString first == $- and:[ aString second == $- ]) ifTrue:[ 
        firstCharPos := 3.
    ].
    lastCharPos := aString indexOf: $=.
    lastCharPos == 0 ifTrue:[ 
        lastCharPos := aString indexOf: Character space.
        lastCharPos == 0 ifTrue:[
            lastCharPos := aString size.
        ] ifFalse:[ 
            lastCharPos := lastCharPos - 1.
        ].
    ] ifFalse:[ 
        lastCharPos := lastCharPos - 1.
    ].
    (firstCharPos ~~ 1 or:[ lastCharPos ~~ aString size ])
        ifTrue:[ long := aString copyFrom: firstCharPos to: lastCharPos ]
        ifFalse:[ long := aString ].
    (long conform: [:c | c == $- or:[c isLetter or:[c isDigit]]]) ifFalse:[ 
        long := nil.
        self error: 'Invalid option specification: ' , aString asString.
        ^ self.
    ].
    longSpec := aString.
    (longSpec first == $- and:[ longSpec second == $- ]) ifFalse:[ 
        longSpec := '--' , longSpec
    ].

    "Created: / 29-06-2016 / 09:24:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2016 / 16:52:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

specS:aString
    short notNil ifTrue:[ self error: 'Short option already specified: ', short asString ].
    short := aString second.
    shortSpec := aString.

    "Created: / 29-06-2016 / 09:23:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CmdLineOption methodsFor:'processing'!

process

    action value

    "Created: / 08-06-2009 / 14:35:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

process: value

    action value: value

    "Created: / 08-06-2009 / 14:35:08 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CmdLineOption methodsFor:'queries'!

hasParam

    ^action numArgs = 1

    "Created: / 08-06-2009 / 13:45:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CmdLineOption class methodsFor:'documentation'!

version
    ^'$Header: /cvs/stx/stx/libbasic/CmdLineOption.st,v 1.3 2012-01-13 10:58:29 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: CmdLineOption.st 10737 2011-11-06 21:23:48Z vranyj1 §'
! !


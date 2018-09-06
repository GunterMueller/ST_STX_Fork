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

Object subclass:#CmdLineParser
	instanceVariableNames:'options ignoreUnknownOptions'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Command line'
!

!CmdLineParser class methodsFor:'documentation'!

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
! !

!CmdLineParser class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!CmdLineParser class methodsFor:'parsing'!

parse: argv for: object

    ^self new parse: argv for: object

    "Created: / 28-01-2009 / 12:06:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CmdLineParser methodsFor:'accessing'!

cmdlineOptionHelp

    ^CmdLineOption new
        short: $a;
        long: 'help';
        description: 'Prints short summary of available options';
        action:[self printHelp]

    "Created: / 08-06-2009 / 14:54:11 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

ignoreUnknownOptions
    ^ ignoreUnknownOptions
!

ignoreUnknownOptions:aBoolean
    "When set to true, unknown options are silently ignored and added to
     a list of positional arguments returned by #parse:.
     When set to false, an error is triggered when an unknown option is 
     encountered (this is the default behaviour)"

    ignoreUnknownOptions := aBoolean.

    "Modified (comment): / 29-06-2016 / 00:03:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

options
    ^ options
!

options:something
    options := something.
! !

!CmdLineParser methodsFor:'building'!

on: spec description: description do: action
    | option |

    option := CmdLineOption new.
    option spec: spec.
    option description: description.
    option action: action.
    options isNil ifTrue:[options := OrderedCollection new].
    options add: option.

    "Created: / 14-06-2016 / 06:43:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

on: spec do: action
    ^ self on: spec description: nil do: action

    "Created: / 14-06-2016 / 07:02:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CmdLineParser methodsFor:'error reporting'!

error: message option: option
    ^CmdLineOptionError signal: message

    "Created: / 08-06-2009 / 14:22:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified (format): / 07-09-2016 / 16:54:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

errorOptionHasNoArgument:option 
    self error:'option has no argument' option:option

    "Created: / 08-06-2009 / 14:27:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

errorOptionRequiresArgument:option 
    self error:'option requires an argument' option:option
! !

!CmdLineParser methodsFor:'initialization'!

collectOptionsFrom: anObject

    options := CmdLineOption optionsFor: anObject

    "Created: / 08-06-2009 / 13:06:23 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 06-11-2011 / 21:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initialize
    "Invoked when a new instance is created."

    ignoreUnknownOptions := false.

    "Modified: / 29-06-2016 / 00:04:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-09-2016 / 16:23:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CmdLineParser methodsFor:'parsing'!

parse: argv 
    "
     Parses argv array. Returns array of unparsed (i.e. non-options / unknown options) arguments
    "

    | unparsed current |

    unparsed := OrderedCollection new.
    current := 1.
    [current <= argv size] whileTrue: [ 
        | arg next |

        arg := argv at:current.
        arg first == $- ifTrue:[
            " Maybe an option... "
            next := self parse:argv startingAt:current.
            next == 0 ifTrue:[
                " Option has not been recognized "
                unparsed add: arg.
                next := current + 1.
            ]
        ] ifFalse:[ 
            " Not an option... "
            unparsed addAll: (argv copyFrom: current).
            next := argv size + 1.
        ].
        current := next.
    ].
    ^ unparsed

    "Created: / 28-01-2009 / 12:08:29 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-06-2009 / 13:26:26 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-06-2016 / 00:15:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-09-2016 / 16:23:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parse: argv for: object

     "
      Parses argv array. Returns array of unparsed (i.e. non-option)
      arguments. Options are obtained from given object
     "

    ^self 
        collectOptionsFrom: object;
        parse: argv

    "Created: / 28-01-2009 / 11:50:27 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-06-2009 / 13:07:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

parse:argv options: opts

    "
      Parses argv array. Returns array of unparsed (i.e. non-option)
      arguments. Options are obtained from given object
    "

    options := opts.
    ^self parse: argv

    "Created: / 29-05-2009 / 15:51:41 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-06-2009 / 13:08:12 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CmdLineParser methodsFor:'printing & storing'!

printHelp

    ^self printHelpOn: Stdout

    "Created: / 08-06-2009 / 14:55:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

printHelpOn: stream

    stream nextPutAll:'help...'; cr.

    "Created: / 08-06-2009 / 14:56:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CmdLineParser methodsFor:'private'!

optionByLong:longName 
    ^ options 
        detect:[:option | option long = longName ]
        ifNone:[ 
            longName = 'help' 
                ifTrue:[self cmdlineOptionHelp]
                ifFalse:[ignoreUnknownOptions ifTrue:[nil] ifFalse:[CmdLineOptionError signal:'Unknown option: ' , longName ]]]

    "Created: / 30-01-2009 / 09:15:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-06-2009 / 14:57:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-09-2016 / 16:53:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

optionByShort:shortName 
    ^ options 
        detect:[:option | option short = shortName ]
        ifNone:
            [ shortName == $h 
                ifTrue:[self cmdlineOptionHelp]
                ifFalse:[ignoreUnknownOptions ifTrue:[nil] ifFalse:[CmdLineOptionError signal:'Unknown option: ' , shortName ]]]

    "Created: / 30-01-2009 / 09:16:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-06-2009 / 14:58:14 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 07-09-2016 / 16:53:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parse:argv startingAt:index 
    "Parses arg at index. Returns an index of next arg to be parsed. If the options
     is not recognized (i.e., is unknown), then either an error is triggered
     (when ignoreInknownOptions is false) or 0 is returned (when ignoreInknownOptions
     is true)"
    
    | arg  option  param |

    arg := argv at:index.
    arg second ~= $- ifTrue:[
        " Short option or bunch of those "
        2 to:arg size do:[:subIndex | 
            option := self optionByShort:(arg at:subIndex).
            option notNil ifTrue:[
                option hasParam ifFalse:[
                    option process
                ] ifTrue:[
                    " Do additional check, if this short option is last."
                    ((subIndex ~= arg size) or:[ (argv size) < (index + 1) ]) ifTrue:[
                        self errorOptionRequiresArgument:option
                    ].
                    param := (argv at:index + 1).
                    option process:param.
                    ^ index + 2
                ]
            ] ifFalse:[ ^ 0 ].
        ].
        ^ index + 1
    ] ifFalse:[
        " Long option starting with -- "
        | equalPos |

        equalPos := arg indexOf:$=.
        equalPos ~~ 0 ifTrue:[ 
            option := self optionByLong:(arg copyFrom:3 to: equalPos - 1)
        ] ifFalse:[ 
            option := self optionByLong:(arg copyFrom:3).
        ].
        option notNil ifTrue:[
            ^ option parseL: argv startingAt: index equalCharPosition: equalPos
        ] ifFalse:[ 
            ^ 0
        ].
    ].

    "Created: / 28-06-2016 / 23:55:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-06-2016 / 17:01:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 07-09-2016 / 16:24:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CmdLineParser class methodsFor:'documentation'!

version
    ^'$Header: /cvs/stx/stx/libbasic/CmdLineParser.st,v 1.5 2015-02-13 22:48:41 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: CmdLineParser.st,v 1.5 2015-02-13 22:48:41 cg Exp $'
! !


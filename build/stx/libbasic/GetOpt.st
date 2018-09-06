"
  Copyright (c) 2005 Ian Piumarta
  All rights reserved.

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the 'Software'),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, provided that the above copyright notice(s) and this
  permission notice appear in all copies of the Software and that both the
  above copyright notice(s) and this permission notice appear in supporting
  documentation.

  THE SOFTWARE IS PROVIDED 'AS IS'.  USE ENTIRELY AT YOUR OWN RISK.

  Last edited: 2006-02-03 11:13:33 by piumarta on margaux.local
"
"{ Package: 'stx:libbasic' }"

Dictionary subclass:#GetOpt
	instanceVariableNames:'defaultBlock onErrorBlock'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support'
!

!GetOpt class methodsFor:'documentation'!

copyright
"
  Copyright (c) 2005 Ian Piumarta
  All rights reserved.

  Permission is hereby granted, free of charge, to any person obtaining a
  copy of this software and associated documentation files (the 'Software'),
  to deal in the Software without restriction, including without limitation
  the rights to use, copy, modify, merge, publish, distribute, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, provided that the above copyright notice(s) and this
  permission notice appear in all copies of the Software and that both the
  above copyright notice(s) and this permission notice appear in supporting
  documentation.

  THE SOFTWARE IS PROVIDED 'AS IS'.  USE ENTIRELY AT YOUR OWN RISK.

  Last edited: 2006-02-03 11:13:33 by piumarta on margaux.local
"
!

documentation
"
  GetOpt -- command line parser

  Smalltalk version of Unix getopt(3)-like command line parser.
  Crash course:

  1) Create a GetOpt with 'GetOpt new'.
  2) Tell it what options to expect with 'getOpt at: optChar put: optBlock'
     where optChar is a character (the option, duh) and optBlock is a
     unary block (for options without arguments) or a binary block for
     options with arguments.  (The first block parameter is always the
     option letter that was matched; the second, if present, is the
     argument to the option.)
  3) Tell it what to do with option $? if you want to intercept unrecognised
     options.
  4) Send it 'default: unaryBlock' to tell it what to do with non-option
     arguments.
  5) Send it 'parse: aCollection' to parse the arguments in aCollection.

  Note that '-x foo' and '-xfoo' are handled correctly for an option
  'x' that expects an argument (in both cases the argument is 'foo').

  For anyone who didn't understand the crash course, the following:

    | files searchPath outputPath verbose |
    files := OrderedCollection new.
    searchPath := OrderedCollection new.
    outputPath := nil.
    verbose := false.
    GetOpt new
        at: $I put: [ :opt :arg | searchPath add: arg ];
        at: $o put: [ :opt :arg | outputPath := arg ];
        at: $v put: [ :opt | verbose := true ];
        at: $? put: [ :opt | self error: 'illegal option: -' , opt asString ];
        default: [ :arg | files add: arg ];
        parse: Smalltalk arguments startingAt: 1.

  will parse a compiler command line for include directories ('-I dir'
  option, argument appended to 'searchPath'), an output filename
  ('-o filename' option, argument left in 'outputPath'), a verbosity
  flag ('-v' option, setting 'verbose' to true), and zero or more input
  filenames (anything else, appended to 'files').  
  If you still don't understand then you shouldn't be here.

    [author:]
        Ian Piumarta

    [see also:]
        StandaloneStartup
        Smalltalk
        ReadEvalPrintLoop
"
!

example
"
    | commandLine commandLineArguments files searchPath outputPath verbose foo level |

    commandLine := '-I /foo/bar -level 1 --foo -o bla.x -v file1 file2 file3'.
    commandLineArguments := commandLine asCollectionOfWords.

    files := OrderedCollection new.
    searchPath := OrderedCollection new.
    outputPath := nil.
    verbose := foo := false.
    level := nil.
    GetOpt new
        at: $I put: [ :opt :arg | searchPath add: arg ];
        at: $o put: [ :opt :arg | outputPath := arg ];
        at: $v put: [ :opt | verbose := true ];
        at: '-foo' put: [ :opt | foo := true ];
        at: 'level' put: [ :opt :arg | level := arg ];
        at: $? put: [ :opt | self error: 'illegal option: -' , opt asString ];
        default: [ :arg | files add: arg ];
        parse: commandLineArguments startingAt: 1.

    Transcript show:'files: '; showCR:files.
    Transcript show:'searchPath: '; showCR:searchPath.
    Transcript show:'outputPath: '; showCR:outputPath.
    Transcript show:'verbose: '; showCR:verbose.
    Transcript show:'foo: '; showCR:foo.
    Transcript show:'level: '; showCR:level.
"
! !

!GetOpt class methodsFor:'instance creation'!

new
    ^ super new initializeDefaultBlock
! !

!GetOpt methodsFor:'accessing'!

default: unaryBlock 
    defaultBlock := unaryBlock
!

onError: unaryBlock 
    onErrorBlock := unaryBlock
! !

!GetOpt methodsFor:'error reporting'!

error:aMessage
    onErrorBlock notNil ifTrue:[
        onErrorBlock value:aMessage
    ].
    super error:aMessage
! !

!GetOpt methodsFor:'initialization'!

initializeDefaultBlock
    defaultBlock := [:arg | ].
! !

!GetOpt methodsFor:'parsing'!

parse: argumentCollection
    ^ self parse: argumentCollection startingAt: 1
!

parse: argumentCollection startingAt: offset
    | args |

    args := argumentCollection readStream skip: (offset - 1).
    [args atEnd]
        whileFalse:[
            | arg |
            arg := args next.
            self parseArgument: arg with: args ]
! !

!GetOpt methodsFor:'parsing - private'!

parseArgument: arg with: rest
    (arg size > 1 and:[arg first = $-])
        ifTrue:  [self parseOption: arg with: rest]
        ifFalse: [defaultBlock value: arg]
!

parseOption: option with: rest
    | block longOption |

    "/ cg: changed to support non-single-character args (--foo)
    block := self at: option second ifAbsent:nil.
    block isNil ifTrue:[
        option size > 2 ifTrue:[
            longOption := option copyFrom:2.
            block := self at: longOption ifAbsent:nil.
            block notNil ifTrue:[
                "/ a long option; never take rest of option as argument
                block arity = 1
                    ifTrue:  [ ^ block value: longOption ]
                    ifFalse: [ 
                        rest atEnd
                            ifTrue:  [self error: 'argument missing to option ' , longOption].
                        ^ block value: longOption value: rest next
                    ]
            ]
        ].
        block isNil ifTrue:[
            block := self at: $? ifAbsent: nil.
            block isNil ifTrue:[
                ^ defaultBlock value: option
            ] 
        ]
    ].
    ^ block arity = 1
        ifTrue:  [self applyOption: option to: block]
        ifFalse: [self applyOption: option to: block with: rest]

    "Modified: / 19-09-2011 / 10:07:57 / cg"
! !

!GetOpt methodsFor:'private'!

applyOption: anOption to: unaryBlock 
    ^anOption size == 2
        ifTrue:  [unaryBlock value: anOption second]
        ifFalse: [self error: 'option ' , anOption , ' should not have an argument']

    "Modified: / 19-09-2011 / 10:03:31 / cg"
!

applyOption: anOption to: binaryBlock with: rest 
    ^anOption size == 2
        ifTrue:  [rest atEnd
                      ifTrue:  [self error: 'argument missing to option ' , anOption]
                      ifFalse: [binaryBlock value: anOption second value: rest next]]
        ifFalse: [binaryBlock value: anOption second value: (anOption copyFrom: 3)]

    "Modified: / 19-09-2011 / 10:06:05 / cg"
! !

!GetOpt class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/GetOpt.st,v 1.4 2014-07-03 18:46:44 cg Exp $'
! !


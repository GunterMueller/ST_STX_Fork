"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

AbstractJavaCompletionEngine subclass:#AbstractJavaCompletionEngineSimple
	instanceVariableNames:'imports locals'
	classVariableNames:'PatternPrimitiveType PatternReferenceType'
	poolDictionaries:''
	category:'SmallSense-Java'
!

AbstractJavaCompletionEngineSimple class instanceVariableNames:'PatternsForCompletion PatternsForAnalysis'

"
 No other class instance variables are inherited by this class.
"
!

!AbstractJavaCompletionEngineSimple class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!AbstractJavaCompletionEngineSimple class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    PatternPrimitiveType := '( [[:byte:]] | [[:short:]] | [[:int:]] | [[:long:]] | [[:float:]] | [[:double:]] | [[:char:]] | [[:boolean:]] )'.
    PatternReferenceType := '( [[:Identifier:]]( \. [[:Identifier:]] )* )'

    "Modified: / 19-05-2014 / 12:31:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple class methodsFor:'accessing'!

patternsForAnalysis
    PatternsForAnalysis isNil ifTrue:[
        PatternsForAnalysis := self patternsFrom: self patternDefinitionsForAnalysis
    ].
    ^ PatternsForAnalysis

    "Created: / 19-05-2014 / 11:56:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

patternsForCompletion
    PatternsForCompletion isNil ifTrue:[
        PatternsForCompletion := self patternsFrom: self patternDefinitionsForCompletion.  
    ].
    ^ PatternsForCompletion

    "Created: / 14-05-2014 / 16:55:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-05-2014 / 11:56:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

patternsFrom: anArray
    | patterns |

    patterns := Dictionary new.
    anArray pairWiseDo:[:key :def |
        patterns at: key put: (TokenPatternParser parse: def)             
    ].
    ^ patterns

    "Created: / 19-05-2014 / 11:55:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple class methodsFor:'accessing-definitions'!

patternDefinitionsForAnalysis
    ^ { 
        #analyzeImport:                 . '[[:import:]] [[:Identifier:]] ( \. ([[:Identifier:]] | \*) )* ;' .
        #analyzeLocalDecl:              .  '( ', PatternPrimitiveType , ' | ' , PatternReferenceType , ') [[:Identifier:]] ( = | ; )' .
    }

    "
    self flush; patternsForAnalysis
    "

    "Created: / 19-05-2014 / 11:56:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-05-2014 / 10:23:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

patternDefinitionsForCompletion
    ^ { 
        #completeImport:                . '[[:import:]] ( [[:Identifier:]](\.[[:Identifier:]])*\.? )? [[:CARET:]]' .
        #completeNew:                   . '[[:new:]] ( [[:Identifier:]](\.[[:Identifier:]])*\.?)? [[:CARET:]]' .
        #completeLocalDef:              . '( ', PatternPrimitiveType , ' | ' , PatternReferenceType , ') [[:Identifier:]] [[:CARET:]]' .
        #completeCatch:                 . '[[:catch:]] \( (' , PatternReferenceType , ' \.? )? [[:CARET:]]' .
    }

    "
    self flush. self patternsForCompletion
    "

    "Created: / 19-05-2014 / 11:51:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 16:44:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == SmallSense::AbstractJavaCompletionEngineSimple.

    "Modified: / 19-05-2014 / 11:23:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple class methodsFor:'utilities'!

flush
    PatternsForAnalysis := PatternsForCompletion := nil.
    self subclassesDo:[:each | each flush ].

    "Created: / 19-05-2014 / 11:57:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple methodsFor:'accessing'!

patternsForAnalysis
    ^ self class patternsForAnalysis

    "Created: / 19-05-2014 / 13:06:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

patternsForCompletion
    ^ self class patternsForCompletion

    "Created: / 14-05-2014 / 17:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple methodsFor:'accessing-class'!

scannerClass
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!AbstractJavaCompletionEngineSimple methodsFor:'analysis'!

analyze
    | scanner stream |

    imports := OrderedCollection new.
    locals := Dictionary new.
    scanner := self scannerClass for: textView contents.
    scanner allowRunawayString: true.  
    stream := TokenStream on: scanner.
    self patternsForAnalysis keysAndValuesDo:[ :action :pattern |
        | matcher |

        stream reset. "/ Reset the position
        matcher := TokenPatternMatcher for: pattern.
        matcher matchesOnStream: stream do:[:match | 
            self perform: action with: match.
        ].
    ].

    "Created: / 19-05-2014 / 13:06:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 21:18:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

analyzeImport: match

    | import |

    import := String streamContents: [ :s| 2 to: match size - 1 do:[:i | s nextPutAll: (match at: i) value asString ] ].
    imports add: import

    "Created: / 19-05-2014 / 13:43:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

analyzeLocalDecl: match
    | typename name |

    self assert: match size >= 3.

    name := (match at: match size - 1) value.
    typename := String streamContents:[ :s| 1 to: match size - 2 do:[:i | s nextPutAll: (match at: i) value asString ] ].

    locals at: name put: typename.

    "Created: / 23-05-2014 / 10:23:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple methodsFor:'completion-individual'!

addSnippetsStartingWith: prefix
    self scannerClass keywordTable keysDo:[:keyword |
        (keyword startsWith: prefix) ifTrue:[
            result add: (SnippetPO new value: keyword , ' ').        
        ]
    ]

    "Created: / 18-05-2014 / 10:49:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addVariables
    self addFieldsForType: self guessTypeOfThis.

    locals keysDo:[:name | 
        result add: (VariablePO variable: name) 
    ].

    "Created: / 17-05-2014 / 09:15:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-05-2014 / 16:45:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple methodsFor:'completion-private'!

complete
    | line col scanner stream tokens anyMatched |

    line := textView listAt: textView cursorLine.
    col := textView cursorCol.
    line isNil ifTrue:[ ^ nil ].
    line size < (col - 1) ifTrue:[ ^ nil ].

    self analyze.

    scanner := self scannerClass for: line string.
    scanner allowRunawayString: true.  
    stream := TokenStream on: scanner cursor: col - 1.
    anyMatched := false.
    self patternsForCompletion keysAndValuesDo:[ :action :pattern |
        | matcher |

        stream position: 0. "/ Reset the position
        matcher := TokenPatternMatcher for: pattern.
        matcher matchesOnStream: stream do:[:match | 
            self perform: action with: match.
            anyMatched := true.
        ].
    ].
    anyMatched ifFalse:[ 
        | caretI last lastI |

        stream position: 0.
        tokens := stream contents.
        "/ At least there must be CARET token
        tokens size == 1 ifTrue:[ ^ result ].
        tokens first type == #CARET ifTrue:[ ^ result ].

        "/ Find last token before CARET
        caretI := 2.
        [ (tokens at: caretI) type ~~ #CARET ] whileTrue:[ caretI := caretI + 1 ].
        lastI := caretI - 1.
        last := tokens at: lastI.

        last type == #Identifier ifTrue:[
            lastI == 1 ifTrue:[ 
                "/ Only one token on line, complete local variable or receiver's field.
                self completeSnippetsStartingWith: last value.
                self completeLocalOrFieldIn: tokens before: caretI.
            ] ifFalse:[ 
                "/ If preceeding token is dot, complete method or field of the receiver.
                (tokens at: lastI - 1) type == $. ifTrue:[ 
                    self completeMethodOrFieldIn: tokens before: caretI.
                ] ifFalse:[ 
                    "/ Else try to complete field.
                    self completeSnippetsStartingWith: last value.
                    self completeLocalOrFieldIn: tokens before: caretI.
                ].
            ].
        ] ifFalse:[
        "/ Else if last token in dot, complete method or field of the receiver
        last type == $. ifTrue:[ 
            self completeMethodOrFieldIn: tokens before: caretI.
        ]].
    ].
    ^ result

    "Created: / 02-10-2013 / 13:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-08-2014 / 21:19:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeCatch: match
    | prefix |

    match size == 3 ifTrue:[ 
        self addExceptionsStartingWith: nil matchFullName: false.
    ] ifFalse:[
        match size == 4 ifTrue:[ 
            prefix := (match at: 3) value asString.
            self addExceptionsStartingWith: prefix matchFullName: prefix first isLowercase.
        ] ifFalse:[ 
            | last |

            last := match size - 1"Carret token".
            (match at: last) value == $. ifTrue:[ 
                last := last - 1.
            ].
            prefix := String streamContents:[:s | 3 to: last do:[:i | s nextPutAll: (match at: i) value asString] ].    
            self addExceptionsStartingWith: prefix matchFullName: true   
        ].
    ].

    "Created: / 07-08-2014 / 14:59:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 16:10:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeImport: match
    | prefix |

    match size > 2 ifTrue:[ 
        prefix := String streamContents:[:s | 2 to: match size - 1 do:[:i | s nextPutAll: (match at: i) value asString] ].
        self addImportsStartingWith: prefix
    ].

    "Created: / 15-05-2014 / 06:57:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-05-2014 / 13:39:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeLocalDef: match
    "Nothing to so here. Mainly to inhibit local variable/field completion here"

    "Created: / 19-05-2014 / 12:34:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeLocalOrFieldIn: tokens before: caretTokenIndex
    self addVariables

    "Created: / 15-05-2014 / 18:53:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-05-2014 / 09:15:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeMethodOrFieldIn: tokens before: caretTokenIndex
    | type dotIndex |

    dotIndex := (tokens at: caretTokenIndex - 1) type == #Identifier ifTrue:[ caretTokenIndex - 2 ] ifFalse:[ caretTokenIndex - 1 ].  
    self assert: (tokens at: dotIndex) type == $..
    type := self guessTypeOfExpressionBefore: dotIndex in: tokens.
    type isUnknownType ifFalse:[
        self addMethodsForType: type.  
        "/self addFieldsForType: type.
    ] ifTrue:[ 
        (tokens at: caretTokenIndex - 1) type == #Identifier ifTrue:[
            | prefix |

            prefix := (tokens at: caretTokenIndex - 1) value.
            (prefix size >= 3 and:[ prefix ~= 'get' and:[prefix ~= 'set' ]]) ifTrue:[
                self addMethodsStartingWith: prefix.
            ].
        ].
    ].

    "Created: / 15-05-2014 / 18:51:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-05-2014 / 13:16:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeNew: match
    | prefix classes full |

    match size < 2 ifTrue:[ 
        ^ self.
    ].

    match size > 3 ifTrue:[ 
        prefix := String streamContents:[:s | 2 to: match size - 1 do:[:i | s nextPutAll: (match at: i) value asString] ].
        full := true.
    ] ifFalse:[
        match size < 3 ifTrue:[ ^ self ].
        prefix := (match at: 2) value.
        full := false.
    ].
    prefix replaceAll: $. with: $/.
    classes := Set new.
    context environment allClassesDo:[:cls |
        (cls isJavaClass and:[cls isPublic]) ifTrue:[ 
            full ifTrue:[ 
                (cls binaryName startsWith: prefix) ifTrue:[ 
                    classes add: cls.
                ].
            ] ifFalse:[ 
                (cls lastName startsWith: prefix) ifTrue:[ 
                    classes add: cls.
                ].
            ].
        ].
    ].

    classes do:[:cls | 
        self addConstructorsForClass: cls fullName: full.
    ].

    "Created: / 15-05-2014 / 07:16:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-05-2014 / 13:19:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

completeSnippetsStartingWith: prefix
    self addSnippetsStartingWith: prefix

    "Created: / 18-05-2014 / 10:48:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple methodsFor:'guesswork'!

guessTypeOfExpressionBefore: end in: tokens
    | i type |

    i := end - 1.  

    (tokens at: i) type == $) ifTrue:[ 
        "/ OK, end of message send, scan for method name...
        | nparens nargs name |

        nparens := 1.

        i := i - 1.
        nargs := 0.
        (tokens at: i) type == $( ifTrue:[ 
            i := i - 1.
        ] ifFalse:[
            nargs := 1.
            [ i > 0 and:[ nparens ~~ 0 ] ] whileTrue:[ 
                (tokens at: i) type == $) ifTrue:[ 
                    nparens := nparens + 1 
                ] ifFalse:[ 
                    (tokens at: i) type == $( ifTrue:[ 
                        nparens := nparens - 1 
                    ] ifFalse:[ 
                        (((tokens at: i) type == $,) and:[nparens == 1]) ifTrue:[    
                            nargs := nargs + 1.
                        ]
                    ].
                ].
                i := i - 1.
            ].
        ].
        nparens ~~ 0 ifTrue:[ 
            "/ Malformed input
            ^ Type unknown
        ].
        (tokens at: i) type == #Identifier ifFalse:[ 
            "/ Malformed input
            ^ Type unknown
        ].
        name := (tokens at: i) value.
        i > 0 ifTrue:[ 
            (tokens at: i - 1) type == $. ifTrue:[ 
                type := self guessTypeOfExpressionBefore: i - 1 in: tokens.
            ] ifFalse:[ 
                type := self guessTypeOfThis.
            ].
            ^ self guessTypeOfMethod: type of: type numArgs: nargs.
        ].
    ].
    (tokens at: i) type == #Identifier ifTrue:[ 
        "/ Either field or local
        | name type |

        name := (tokens at: i) value.
        (i > 1 and:[ (tokens at: i - 1) type == $. ]) ifTrue:[ 
            "/ Non-this field
            type := self guessTypeOfExpressionBefore: i - 1 in: tokens.      
            ^ self guessTypeOfField: name of: type.  
        ] ifFalse:[ 
            "/ This-field
            ^ self guessTypeOfFieldOrLocal: name
        ].
    ].

    ^ Type unknown    
"/    ^ Type withClass: 
"/        (context environment classNamed:#'JAVA::java::lang::Object')
"/            ? (context environment classNamed:#'java/lang/Object')

    "Created: / 17-05-2014 / 10:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

guessTypeOfField: name of: type
    ^ Type unknown

    "Created: / 17-05-2014 / 10:47:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

guessTypeOfFieldOrLocal: name
    ^ Type unknown

    "Created: / 17-05-2014 / 10:47:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

guessTypeOfMethod: name of: type numArgs: nargs
    | methods |

    methods := Set new.
    type classesDo:[:initialClass | 
        | class |

        class := initialClass.
        [ class notNil and:[ class ~~ JavaObject  ] ] whileTrue:[
            class selectorsAndMethodsDo:[:selector :method |
                method isJavaMethod ifTrue:[ 
                    (selector size > name size 
                        and:[ method numJavaArgs = nargs
                        and:[ (selector at: name size + 1) == $(
                        and:[ (selector startsWith: name) ]]])
                        ifTrue:[ methods add: method ].
                    ].
            ].
        ].
    ].

    self halt.

    "Created: / 15-05-2014 / 09:39:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

guessTypeOfThis
    ^ class isNil 
        ifTrue:[ Type unknown ]
        ifFalse: [ Type withClass: class ]

    "Created: / 17-05-2014 / 10:52:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-05-2014 / 17:34:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractJavaCompletionEngineSimple class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


AbstractJavaCompletionEngineSimple initialize!

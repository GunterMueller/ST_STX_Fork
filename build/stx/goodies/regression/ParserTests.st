"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#ParserTests
	instanceVariableNames:'mockClass'
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-Compilers'
!

!ParserTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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

!ParserTests methodsFor:'accessing'!

mockClass
    ^ mockClass
!

mockClass:something
    mockClass := something.
!

parserClass

    ^Parser

    "Created: / 01-07-2010 / 11:53:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-07-2010 / 17:38:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParserTests methodsFor:'running'!

setUp
    "prepares the testing environment which consists of mock class instance
     for sample annotated methods"
    
    |testClass|

    Class withoutUpdatingChangesDo:[
        testClass := self class 
                    subclass:'AnnotationTestedClass'
                    classInstanceVariableNames:''
                    instanceVariableNames:''
                    classVariableNames:''
                    poolDictionaries:''.
    ].
    self mockClass:testClass.

    "Created: / 29-11-2009 / 20:52:00 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 29-11-2009 / 22:09:27 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 12-07-2010 / 09:33:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    "release allocated resources for testing environment"
    self mockClass: nil.

    "Created: / 29-11-2009 / 20:52:13 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 29-11-2009 / 22:09:33 / pp <Pavel.Pospichal@gmail.com>"
! !

!ParserTests methodsFor:'smoke test'!

testParseAllMethods
    Smalltalk allClassesDo:[:cls |
        Transcript showCR:cls.
        cls instAndClassMethodsDo:[:mthd |
            Parser parseMethod:mthd source in:mthd mclass
        ]
    ].

    "Created: / 28-06-2011 / 22:23:43 / cg"
! !

!ParserTests methodsFor:'tests - annotations'!

testAnnotationWithArrayLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with #(<array>) literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithArrayLiteralExample <annotation: #(1 2 3 4)> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #( 1 2 3 4 ).

    "Created: / 12-01-2010 / 13:43:19 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithByteArrayLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with #[<byte array>] literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithByteArrayLiteralExample <annotation: #[64 128 192]> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #[ 64 128 192 ].

    "Created: / 12-01-2010 / 13:35:36 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithCharacterLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with character literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithCharacterLiteralExample <annotation: $A> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = $A.

    "Created: / 12-01-2010 / 13:20:37 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithFalseLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with false literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithFalseLiteralExample <annotation: false> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = false.

    "Created: / 12-01-2010 / 13:13:26 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithInvalidArgument
    "Negative testing the structure of unknown annotation definition: the annotation with the non-literal argument; see grammar"
    
    |parserState parseErrorOccured|

    " create method for annotation testing purpose "
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithInvalidArgumentExample <annotation: annotation:> ^self.'
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = true.
    self assert:parseErrorOccured = true.

    "Created: / 12-01-2010 / 13:48:48 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithInvalidContentFollowed
    "Negative testing the structure of unknown annotation definition: the annotation with valid argument followed by invalid content; see grammar"
    "Test Note: based on the previous parser behaviour this type of situation is not considered as serious,
     it's considered as ignorable, informing requester and proceeding execution"
    
    |parserState annotation arguments ignorableErrorOccured|

    ignorableErrorOccured := false.
     " create method for annotation testing purpose " " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    self parserClass parseErrorSignal 
        handle:[:ex | 
            ignorableErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithInvalidContentFollowedExample <annotation: #argument #argument> ^self.'
                        in:mockClass.
        ].
     " ignorable error should occured "
    self assert:ignorableErrorOccured = true.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #argument.

    "Created: / 12-01-2010 / 13:52:16 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithKeywordLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with #<keyword> literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithKeywordLiteralExample <annotation: #equals:> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #equals:.

    "Created: / 12-01-2010 / 13:30:47 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithMultiKeywordLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with #<multikeyword> literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithMultiKeywordLiteralExample <annotation: #equals:from:> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #equals:from:.

    "Created: / 12-01-2010 / 13:31:41 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithNegativeNumberLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with negative_number literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithNegativeNumberLiteralExample <annotation: -123> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = -123.

    "Created: / 12-01-2010 / 13:18:46 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithNilLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with nil literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithFalseLiteralExample <annotation: nil> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) isNil.

    "Created: / 12-01-2010 / 13:13:59 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithNumberLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with number literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithNumberLiteralExample <annotation: 123> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = 123.

    "Created: / 12-01-2010 / 13:18:15 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithStringLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with string literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithCharacterLiteralExample <annotation: ''Hello world!!''> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = 'Hello world!!'.

    "Created: / 12-01-2010 / 13:21:43 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithSymbolLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with #<characters> | #<name> literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithSymbolLiteralExample <annotation: #symbol> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #symbol.

    "Created: / 12-01-2010 / 13:26:54 / pp <Pavel.Pospichal@gmail.com>"
!

testAnnotationWithSymbolLiteral2
    "Positive testing the structure of unknown annotation definition: the annotation with #<characters> | #<name> literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithSymbolLiteralExample <annotation: symbol> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #symbol.

    "Created: / 11-07-2010 / 23:00:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testAnnotationWithTrueLiteral
    "Positive testing the structure of unknown annotation definition: the annotation with true literal; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'annotationWithTrueLiteralExample <annotation: true> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = true.

    "Created: / 12-01-2010 / 13:11:22 / pp <Pavel.Pospichal@gmail.com>"
!

testCompoundAnnotationLiteral
    "Positive testing the structure of unknown annotation definition: the annotation is compound of more keywords defining the annotation type; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'compoundAnnotationLiteralExample <annotation: true alt: false> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation:alt:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 2.
    self assert:(arguments at:1) = true.
    self assert:(arguments at:2) = false.

    "Created: / 12-01-2010 / 13:47:00 / pp <Pavel.Pospichal@gmail.com>"
!

testDislocationAfterMethodBody
    "Negative testing the location of annotation definition: the annotation is situated after MethodSequenceNode; see grammar"
    
    |parserState parseErrorOccured|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'dislocationInMethodHeaderExample |x| x:=1. ^x. <annotation: #argument>'
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = true.
    self assert:parseErrorOccured = true.

    "Created: / 12-01-2010 / 12:42:03 / pp <Pavel.Pospichal@gmail.com>"
!

testDislocationInMethodBody
    "Negative testing the location of annotation definition: the annotation is situated in MethodSequenceNode; see grammar"
    
    |parserState parseErrorOccured|

    " create method for annotation testing purpose "
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'dislocationInMethodHeaderExample |x| <annotation: #argument> x:=1. ^x.'
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = true.
    self assert:parseErrorOccured = true.

    "Created: / 12-01-2010 / 12:31:24 / pp <Pavel.Pospichal@gmail.com>"
!

testDislocationInMethodHeader
    "Negative testing the location of annotation definition: the annotation is situated before <name>|BinaryMethodName|KeywordMethodName; see grammar"
    
    |parserState parseErrorOccured|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'<annotation: #argument> dislocationInMethodHeaderExample ^self.'
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = true.
    self assert:parseErrorOccured = true.

    "Created: / 12-01-2010 / 12:29:46 / pp <Pavel.Pospichal@gmail.com>"
!

testEmptyAnnotation
    "Positive testing the structure of unknown annotation definition: the empty annotation; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'emptyAnnotationExample <annotation> |x| x:=1. ^x. '
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 0.

    "Created: / 12-01-2010 / 13:08:15 / pp <Pavel.Pospichal@gmail.com>"
!

testMultipleAnnotationsInMethod
    "Positive testing the multiple annotation definition and theirs order: the annotations are situated in defined location; see grammar"
    
    |parserState parseErrorOccured annotation arguments|

    " create method for annotation testing purpose "
    parseErrorOccured := false.
    self parserClass parseErrorSignal 
        handle:[:ex | 
            parseErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'multipleAnnotationsInMethodExample <annotation1: #argument> <annotation2: #argument> |x| x:=1. ^x.'
                        in:mockClass.
        ].
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
    self assert:parserState errorFlag = false.
    self assert:parseErrorOccured = false.
     " find the annotations record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 2.
     " check the first annotation defined"
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation1:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #argument.
     " check the second annotation defined"
    annotation := parserState annotations at:2.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'annotation2:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #argument.

    "Created: / 12-01-2010 / 12:47:57 / pp <Pavel.Pospichal@gmail.com>"
! !

!ParserTests methodsFor:'tests - context'!

testContextWithInvalidArgument
    "Negative testing the context annotation structure for the no-literal argument"
    
    |parserState|

    " create method for annotation testing purpose "
    self should:[
            parserState := self parserClass 
                        parseMethod:'contextWithNoArgumentsExample <context: context:> ^self.'
                        in:mockClass.
        ] raise:ParseError.

     " check the parser result "
"/    self assert:parserState notNil.
"/    self assert:parserState == #Error.

    "Created: / 11-01-2010 / 22:50:54 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 01-07-2010 / 16:30:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testContextWithInvalidContentFollowed
    "Negative testing the context annotation structure 
     with valid argument followed by invalid content (following literal): <context: #return #return>"
    "Test Note: based on the previous parser behaviour this type of situation is not considered as serious,
     it's considered as ignorable, informing requester and proceeding execution"
    
    |parserState annotation arguments ignorableErrorOccured|

    ignorableErrorOccured := false.
     " create method for annotation testing purpose " " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    self parserClass parseErrorSignal 
        handle:[:ex | 
            ignorableErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'contextWithInvalidContentFollowedExample <context: #return #return> ^self.'
                        in:mockClass.
        ].
     " ignorable error should occured "
    self should:ignorableErrorOccured.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'context:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #return.

    "Created: / 09-01-2010 / 13:14:26 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 11-01-2010 / 23:15:15 / pp <Pavel.Pospichal@gmail.com>"
!

testContextWithNoArguments
    "Negative testing the context annotation structure for the no argument annotation structure <context>"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'contextWithNoArgumentsExample <context> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'context'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 0.

    "Created: / 09-01-2010 / 12:41:53 / Pavel Pospchal <Pavel.Pospichal@gmail.com>"
    "Modified: / 11-01-2010 / 23:15:24 / pp <Pavel.Pospichal@gmail.com>"
!

testStxContext
    "Testing the context annotation structure used in St/X virtual machine"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose : GenericException>>raiseRequest"
    parserState := self parserClass 
                parseMethod:'stxContextExample <context: #return> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'context:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #return.

    "Created: / 29-11-2009 / 09:37:38 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 11-01-2010 / 22:33:21 / pp <Pavel.Pospichal@gmail.com>"
! !

!ParserTests methodsFor:'tests - exception'!

testExceptionWithInvalidArgument
    "Negative testing the exception annotation structure for the no-literal argument"
    
    |parserState|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'exceptionWithInvalidArgumentExample <exception: exception:> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState isNil.
    self assert:parserState = #Error.

    "Created: / 11-01-2010 / 22:57:43 / pp <Pavel.Pospichal@gmail.com>"
!

testExceptionWithInvalidContentFollowed
    "Negative testing the exception annotation structure 
     with valid argument followed by invalid content (following literal): <exception: #handle #handle>"
    "Test Note: based on the previous parser behaviour this type of situation is not considered as serious,
     it's considered as ignorable, informing requester and proceeding execution"
    
    |parserState annotation arguments ignorableErrorOccured|

    ignorableErrorOccured := false.
     " create method for annotation testing purpose " " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    self parserClass parseErrorSignal 
        handle:[:ex | 
            ignorableErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'exceptionWithInvalidContentFollowedExample <exception: #handle #handle> ^self.'
                        in:mockClass.
        ].
     " ignorable error should occured "
    self should:ignorableErrorOccured.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'exception:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #handle.

    "Created: / 11-01-2010 / 23:02:28 / pp <Pavel.Pospichal@gmail.com>"
!

testExceptionWithNoArguments
    "Negative testing the exception annotation structure for the no argument annotation structure <exception>"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'exceptionWithNoArgumentsExample <exception> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'exception'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 0.

    "Created: / 11-01-2010 / 23:06:31 / pp <Pavel.Pospichal@gmail.com>"
!

testSt80HandleException
    "Testing the exception annotation structure used in St-80 virtual machine"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'st80HandleExceptionExample <exception: #handle> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'exception:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #handle.

    "Created: / 29-11-2009 / 09:36:20 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 07-12-2009 / 01:38:31 / pp <Pavel.Pospichal@gmail.com>"
!

testSt80RaiseException
    "Testing the exception annotation structure used in St-80 virtual machine"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'st80RaiseExceptionExample <exception: #raise> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'exception:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #raise.

    "Created: / 29-11-2009 / 22:36:00 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 12-12-2009 / 21:39:21 / pp <Pavel.Pospichal@gmail.com>"
!

testSt80UnwindException
    "Testing the exception annotation structure used in St-80 virtual machine"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'st80UnwindExceptionExample <exception: #unwind> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'exception:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #unwind.

    "Created: / 29-11-2009 / 22:36:49 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 12-12-2009 / 21:39:35 / pp <Pavel.Pospichal@gmail.com>"
! !

!ParserTests methodsFor:'tests - external function'!

testDolphinExternalFunctionByStdcall
    "Testing the external function annotation structure"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'dolphinExternalFunctionByStdcallExample <stdcall: ''hresult CloseThemeData handle''> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'stdcall:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = 'hresult CloseThemeData handle'.

    "Created: / 29-11-2009 / 09:50:11 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 12-01-2010 / 11:56:15 / pp <Pavel.Pospichal@gmail.com>"
!

testSqueakExternalFunctionByApicall
    "Testing the external function annotation structure"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'squeakExternalFunctionByApicallExample <apicall: ''long GetCurrentProcessId (void)'' module: ''kernel32.dll''> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'apicall:module:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 2.
    self assert:(arguments at:1) = 'long GetCurrentProcessId (void)'.
    self assert:(arguments at:2) = 'kernel32.dll'.

    "Created: / 29-11-2009 / 09:49:04 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 11-01-2010 / 23:29:51 / pp <Pavel.Pospichal@gmail.com>"
!

testSqueakExternalFunctionByCdecl
    "Testing the external function annotation structure"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'squeakExternalFunctionByCdeclExample <cdecl: ''long fstat (long MacStat* )'' module: ''libc.dylib''> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'cdecl:module:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 2.
    self assert:(arguments at:1) = 'long fstat (long MacStat* )'.
    self assert:(arguments at:2) = 'libc.dylib'.

    "Created: / 29-11-2009 / 09:49:36 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 11-01-2010 / 23:18:04 / pp <Pavel.Pospichal@gmail.com>"
!

testStVExternalFunctionByApi
    "Testing the external function annotation structure"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'stVExternalFunctionByApiExample <api: ''_func _int32 void''> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'api:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = '_func _int32 void'.

    "Created: / 29-11-2009 / 09:47:49 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 12-12-2009 / 22:08:06 / pp <Pavel.Pospichal@gmail.com>"
!

testStVExternalFunctionByOle
    "Testing the external function annotation structure"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'stVExternalFunctionByOleExample <ole: ''return varchar2 varchar2''> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'ole:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = 'return varchar2 varchar2'.

    "Created: / 29-11-2009 / 09:48:25 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 10-12-2009 / 11:18:29 / pp <Pavel.Pospichal@gmail.com>"
!

testVwExternalFunctionByC
    "Testing the external function annotation structure"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'vwExternalFunctionByCExample <c: ''void func(int x)''> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'c:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = 'void func(int x)'.

    "Created: / 29-11-2009 / 09:46:31 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 12-12-2009 / 22:08:24 / pp <Pavel.Pospichal@gmail.com>"
! !

!ParserTests methodsFor:'tests - external functions STX'!

testSTX_ffiCall_01_cdecl
    |s p|

    s := '<cdecl: char* ''ffiPrintString'' (char *)>'.
    p := Parser new.
    p source:s.
    p nextToken.
    p parsePrimitiveOrResourceSpecOrEmpty.
!

testSTX_ffiCall_02_api
    |s p|

    s := '<api: char* ''ffiPrintString'' (char *)>'.
    p := Parser new.
    p source:s.
    p nextToken.
    p parsePrimitiveOrResourceSpecOrEmpty.
!

testSTX_ffiCall_03_c
    |s p|

    s := '<C: char* >'.
    p := Parser new.
    p source:s.
    p nextToken.
    p parsePrimitiveOrResourceSpecOrEmpty.
!

testSTX_ffiCall_04_undefinedClasses
    |b1 b2|

    self should:[
        b1 := Parser evaluate:'[ NotYetLoadedClass ]'.
    ] raise:ParseError.

    self assert:(b1 == nil).

    self should:[
        b2 := Parser evaluate:'[ NonExistingNameSpace::NotYetLoadedClass ]'.
    ] raise:ParseError.

    self assert:(b2 == nil).

    "
     self run:#test4
     self new test4
    "
! !

!ParserTests methodsFor:'tests - primitive'!

testNewSTXPrimitive
    "Testing the primitive annotation structure used in St/X virtual machine"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'newSTXPrimitiveExample <primitive> ^self'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'primitive'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 0.

    "
     The primitive specifies method as logic which needs special handling
     before setting up a stack frame for the method to make it run. The example structure
     of primitive annotation is following:
        <primitive>"
    "Created: / 29-11-2009 / 09:34:36 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 06-12-2009 / 21:46:35 / pp <Pavel.Pospichal@gmail.com>"
!

testPrimitiveWithInvalidArgument
    "Negative testing the context annotation structure for the no-literal argument"
    
    |parserState|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'primitiveWithInvalidArgumentExample <primitive: primitive:> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState isNil.
    self assert:parserState = #Error.

    "Created: / 12-01-2010 / 08:40:28 / pp <Pavel.Pospichal@gmail.com>"
!

testPrimitiveWithInvalidContentFollowed
    "Negative testing the primitive annotation structure 
     with valid argument followed by invalid content (following literal): <context: #return #return>"
    "Test Note: based on the previous parser behaviour this type of situation is not considered as serious,
     it's considered as ignorable, informing requester and proceeding execution"
    
    |parserState annotation arguments ignorableErrorOccured|

    ignorableErrorOccured := false.
     " create method for annotation testing purpose " " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    self parserClass parseErrorSignal 
        handle:[:ex | 
            ignorableErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'primitiveWithInvalidContentFollowedExample <primitive: ''test'' ''test''> ^self.'
                        in:mockClass.
        ].
     " ignorable error should occured "
    self should:ignorableErrorOccured.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'primitive:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = 'test'.

    "Created: / 12-01-2010 / 08:42:01 / pp <Pavel.Pospichal@gmail.com>"
!

testSqueakPrimitive
    "Testing the named primitive annotation structure used in Squeak virtual machine"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'squeakPrimitiveExample <primitive: ''test''> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'primitive:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments = 'test'.

    "
     The named primitive specifies identifier value used to look up logic which is processed
     before setting up a stack frame for the method to make it run. The example structure
     of named primitive annotation is following:
        <primitive: test>"

    "Created: / 29-11-2009 / 09:34:05 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 07-12-2009 / 01:29:29 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 04-09-2014 / 12:36:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testSt80Primitive
    "Testing the numbered primitive annotation structure used in ST-80 virtual machine"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'st80PrimitiveExample <primitive: 1> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'primitive:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments = 1.

    "
     The numbered primitive specifies index value used to look up logic which is processed
     before setting up a stack frame for the method to make it run. The example structure
     of numbered primitive annotation is following:
        <primitive: 1>"

    "Created: / 29-11-2009 / 09:33:18 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 07-12-2009 / 01:20:27 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 04-09-2014 / 12:36:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testVAgePrimitive
    "Testing the named primitive annotation structure used in Visual Age virtual machine"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'vAgePrimitiveExample <primitive: #test> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'primitive:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments  = #test.

    "
     The named primitive specifies identifier value used to look up logic which is processed
     before setting up a stack frame for the method to make it run. The example structure
     of named primitive annotation is following:
        <primitive: test>"

    "Created: / 29-11-2009 / 09:34:59 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 12-12-2009 / 22:09:48 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 04-09-2014 / 12:37:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ParserTests methodsFor:'tests - resource'!

testResourceWithInvalidArgument
    "Negative testing the context annotation structure for the no-literal argument"
    
    |parserState|

    " create method for annotation testing purpose "
    self should:[
            parserState := self parserClass 
                        parseMethod:'resourceWithInvalidArgumentExample <resource: resource:> ^self.'
                        in:mockClass.
        ] raise:ParseError.

     " check the parser result "
"/    self deny:parserState isNil.
"/    self assert:parserState = #Error.

    "Created: / 12-01-2010 / 11:28:13 / pp <Pavel.Pospichal@gmail.com>"
!

testResourceWithInvalidContentFollowed
    "Negative testing the resource annotation structure 
     with valid argument followed by invalid content (following literal): <resource: #symbol #(array of symbols)>"
    "Test Note: based on the previous parser behaviour this type of situation is not considered as serious,
     it's considered as ignorable, informing requester and proceeding execution"
    
    |parserState annotation arguments ignorableErrorOccured|

    ignorableErrorOccured := false.
     " create method for annotation testing purpose " " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    self parserClass parseErrorSignal 
        handle:[:ex | 
            ignorableErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'resourceWithInvalidContentFollowedExample <resource: #symbol #(1 2 3)> ^self.'
                        in:mockClass.
        ].
     " ignorable error should occured "
    self should:ignorableErrorOccured.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'resource:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #symbol.

    "Created: / 12-01-2010 / 11:33:22 / pp <Pavel.Pospichal@gmail.com>"
!

testResourceWithNoArguments
    "Negative testing the resource annotation structure for the no argument annotation structure <resource>"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'resourceWithNoArgumentsExample <resource> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'resource'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 0.

    "Created: / 12-01-2010 / 11:35:21 / pp <Pavel.Pospichal@gmail.com>"
!

testSingleResourcePragma
    "Testing the resource annotation structure"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'resourcePragmaExample <resource: #skipInDebuggersWalkBack> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'resource:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #skipInDebuggersWalkBack.

    "Created: / 29-11-2009 / 09:40:17 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 12-12-2009 / 22:10:53 / pp <Pavel.Pospichal@gmail.com>"
! !

!ParserTests methodsFor:'tests - scanner'!

test_100_scan_EOLcomment1    
    |parser|

    parser := self parserClass new.
    parser saveComments:true.
    parser
                parseMethod:'foo
"/
1'
                in:mockClass.
     " check the parser result "
    self deny:parser isNil.
    self deny:parser == #Error.
    self assert:parser comments size == 1.
    self assert:parser comments first commentString isEmpty.
!

test_101_scan_EOLcomment2    
    |parser|

    parser := self parserClass new.
    parser saveComments:true.
    parser
                parseMethod:'foo
"/a
1'
                in:mockClass.
     " check the parser result "
    self deny:parser isNil.
    self deny:parser == #Error.
    self assert:parser comments size == 1.
    self assert:parser comments first commentString = 'a'.
!

test_102_scan_EOLcomment3    
    |parser|

    parser := self parserClass new.
    parser saveComments:true.
    parser
                parseMethod:'foo
"/abc
1'
                in:mockClass.
     " check the parser result "
    self deny:parser isNil.
    self deny:parser == #Error.
    self assert:parser comments size == 1.
    self assert:parser comments first commentString = 'abc'.
!

test_110_scan_DelimitedComment1    
    |parser|

    parser := self parserClass new.
    parser parserFlags allowSTXDelimiterComments:true.
    parser saveComments:true.
    parser
                parseMethod:'foo
"<<END
bla
bla bla
END
1'
                in:mockClass.
     " check the parser result "
    self deny:parser isNil.
    self deny:parser == #Error.
    self assert:parser comments size == 1.
    self assert:parser comments first commentString = '<<END\bla\bla bla\END\' withCRs.
!

test_110_scan_DelimitedComment2    
    |parser|

    parser := self parserClass new.
    parser parserFlags allowSTXDelimiterComments:true.
    parser saveComments:true.
    parser
                parseMethod:'foo
"<<<< here is the difference"
1'
                in:mockClass.
     " check the parser result "
    self deny:parser isNil.
    self deny:parser == #Error.
    self assert:parser comments size == 1.
    self assert:parser comments first commentString = '<<END\bla\bla bla\END\' withCRs.

    "Created: / 04-09-2014 / 12:00:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_120_scan_numbers    
    |s n|

    n := Scanner scanNumberFrom:(s := ReadStream on:'0').
    self assert:(n == 0).
    self assert:(s position == 1).

    n := Scanner scanNumberFrom:(s := ReadStream on:'1234 ').
    self assert:(n == 1234).
    self assert:(s position == 4).

    n := Scanner scanNumberFrom:(s := ReadStream on:'1234.0 ').
    self assert:(n = 1234.0).
    self assert:(s position == 6).

    n := Scanner scanNumberFrom:(s := ReadStream on:'1234/ ').
    self assert:(n = 1234).
    self assert:(s position == 4).

    n := Scanner scanNumberFrom:(s := ReadStream on:'1234/2 ').
    self assert:(n = (1234/2)).
    self assert:(s position == 6).

    self assert:( Number readSmalltalkSyntaxFrom:'99d' ) = 99.0.
    self assert:( Number readSmalltalkSyntaxFrom:'99.00d' ) = 99.0.

    self assert:( Number readSmalltalkSyntaxFrom:'12345678901234567890' ) = 12345678901234567890.
    self assert:( Number readSmalltalkSyntaxFrom:'16rAAAAFFFFAAAAFFFF' ) = 16rAAAAFFFFAAAAFFFF.
    self assert:( Number readSmalltalkSyntaxFrom:'(1/10)') = (1/10).
    self assert:( Number readSmalltalkSyntaxFrom:'(1/3)' ) = (1/3).
    self assert:( Number readSmalltalkSyntaxFrom:'(-1/3)' ) = (-1/3).
    self assert:( Number readSmalltalkSyntaxFrom:'(1/-3)' ) = (-1/3).
    self assert:( Number readSmalltalkSyntaxFrom:'(-1/-3)' ) = (1/3).
    self assert:( Number readSmalltalkSyntaxFrom:'-(1/3)' ) = (-1/3).
    self assert:( Number readSmalltalkSyntaxFrom:'-(-1/-3)' ) = (-1/3).
    self assert:( Number readSmalltalkSyntaxFrom:'+00000123.45') = 00000123.45.  
! !

!ParserTests methodsFor:'tests - sysprim'!

testSysPrimitiveWithInvalidArgument
    "Negative testing the context annotation structure for the no-literal argument"
    
    |parserState|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'sysPrimitiveWithInvalidArgumentExample <sysprim: sysprim:> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState isNil.
    self assert:parserState = #Error.

    "Created: / 12-01-2010 / 11:49:19 / pp <Pavel.Pospichal@gmail.com>"
!

testSysPrimitiveWithInvalidContentFollowed
    "Negative testing the sysprim annotation structure 
     with valid argument followed by invalid content (following literal):  <sysprim: #none #none>"
    "Test Note: based on the previous parser behaviour this type of situation is not considered as serious,
     it's considered as ignorable, informing requester and proceeding execution"
    
    |parserState annotation arguments ignorableErrorOccured|

    ignorableErrorOccured := false.
     " create method for annotation testing purpose " " the signal is raised by Parser2::ParseError>>raiseRequest but there is no way how to handle its signal"
    self parserClass parseErrorSignal 
        handle:[:ex | 
            ignorableErrorOccured := true.
            ex proceed
        ]
        do:[
            parserState := self parserClass 
                        parseMethod:'sysPrimitiveWithInvalidContentFollowedExample <sysprim: #none #none> ^self.'
                        in:mockClass.
        ].
     " ignorable error should occured "
    self should:ignorableErrorOccured.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'sysprim:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #none.

    "Created: / 12-01-2010 / 11:51:14 / pp <Pavel.Pospichal@gmail.com>"
!

testSysPrimitiveWithNoArguments
    "Negative testing the exception annotation structure for the no argument annotation structure <sysprim>"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'sysPrimitiveWithNoArgumentsExample <sysprim> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState isNil.
    self deny:parserState = #Error.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'sysprim'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 0

    "Created: / 12-01-2010 / 11:52:40 / pp <Pavel.Pospichal@gmail.com>"
!

testVAgeSysPrimitive
    "Testing the sysprim annotation structure"
    
    |parserState annotation arguments|

    " create method for annotation testing purpose "
    parserState := self parserClass 
                parseMethod:'vAgeSysPrimitiveExample <sysprim: #none> ^self.'
                in:mockClass.
     " check the parser result "
    self deny:parserState = #Error.
    self deny:parserState isNil.
     " find the annotation record in parser state "
    self deny:parserState annotations isNil.
    self assert:(parserState annotations size) = 1.
    annotation := parserState annotations at:1.
    self assert:(annotation size) = 2.
    self assert:(annotation at:1) = 'sysprim:'.
    arguments := annotation at:2.
    self deny:arguments isNil.
    self assert:arguments size = 1.
    self assert:(arguments at:1) = #none.

    "Created: / 29-11-2009 / 09:39:11 / pp <Pavel.Pospichal@gmail.com>"
    "Modified: / 12-12-2009 / 22:11:28 / pp <Pavel.Pospichal@gmail.com>"
! !

!ParserTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$ Id: ParserTests.st 2014 2010-07-12 08:10:01Z vranyj1  $'
! !


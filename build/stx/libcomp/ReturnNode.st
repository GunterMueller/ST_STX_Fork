"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

StatementNode subclass:#ReturnNode
	instanceVariableNames:'myHome blockHome'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!ReturnNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    node for parse-trees, representing return expressions
    This is a helper class for the compiler.

    [author:]
        Claus Gittinger
"
! !

!ReturnNode methodsFor:'accessing'!

expression:e
    super expression:e.

    "/ any block, which is returned cannot be inlined.
    e realNode isBlockNode ifTrue:[
        e realNode possiblyInlined:false
    ]
!

home
    ^ myHome

    "Created: / 19-05-2010 / 15:46:55 / cg"
!

home:someOne blockHome:aBlockNode
    myHome := someOne.
    blockHome := aBlockNode
!

lineNumber:something
    "set lineNr"

    lineNr := something.

    "Created: / 16-11-2006 / 14:38:51 / cg"
! !

!ReturnNode methodsFor:'checks'!

plausibilityCheckIn:aParser
    "check for return-in-return, as in
        ^ foo ifTrue:[ ^x]
     that is (currently) not compilable by stc (generates bad C-code for it).
     TODO: rewite to use lint/lint rules and apply them before accepting"

    |allow warn|

    allow := aParser parserFlags allowPossibleSTCCompilationProblems.
    warn := aParser parserFlags warnAboutPossibleSTCCompilationProblems.
    (allow not or:[warn]) ifTrue:[
        expression containsReturn ifTrue:[
            (expression isMessage 
            and:[ #(
                      'ifTrue:' 'ifFalse:'
                      'ifTrue:ifFalse:' 'ifFalse:ifTrue:'
                      'whileTrue:' 'whileFalse:'
                  ) includes:(expression selector)])
            ifTrue:[
                allow ifTrue:[
                    ^ 'stc will not compile return-in-return'
                ].
                aParser
                    parseError:'stc will not compile return-in-return' 
                    position:startPosition to:endPosition
            ]
        ].
    ].
    ^ nil.

    "Created: / 05-07-2011 / 17:59:48 / cg"
! !

!ReturnNode methodsFor:'code generation'!

basicCodeOn:aStream inBlock:b for:aCompiler
    b isNil ifTrue:[
        self codeLocalReturnOn:aStream inBlock:b for:aCompiler.
        ^ self.
    ].

    "return from homeContext in a block"
    expression isNil ifTrue:[
        "/ nil-expression is not possible in smalltalk;
        "/ however, it might be in a subclass (i.e. JavaScript)
        aStream nextPut:#pushNil.
    ] ifFalse:[
        expression codeOn:aStream inBlock:b for:aCompiler.
    ].
    lineNr notNil ifTrue:[
        self codeLineNumber:lineNr on:aStream for:aCompiler
    ].
    aStream nextPut:#homeRetTop.

    "Created: / 16-11-2006 / 14:05:27 / cg"
!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "redefined - drop not needed since notreached"

    ^ self basicCodeOn:aStream inBlock:b for:aCompiler

    "Modified: / 16-11-2006 / 14:05:32 / cg"
!

codeForSimpleReturnOn:aStream inBlock:b lineNumber:lineNrOrNil for:aCompiler
    "generate code to return myself as a simple method return"

    self basicCodeOn:aStream inBlock:b for:aCompiler.

    "as a ReturnNode, I did return, so retTop is not needed"
"/    aStream nextPut:#retTop.

    "Modified: / 16-11-2006 / 14:05:35 / cg"
!

codeLocalReturnOn:aStream inBlock:b for:aCompiler
    expression isNil ifTrue:[
        aStream nextPut:#retNil.
        ^ self.
    ].
    expression
        codeForSimpleReturnOn:aStream 
        inBlock:b 
        lineNumber:lineNr
        for:aCompiler.
!

codeOn:aStream inBlock:b for:aCompiler
"/    aCompiler parserFlags allowPossibleSTCCompilationProblems ifFalse:[
"/        aCompiler 
"/            parseError:'stc will not compile return within a return'
"/            line:lineNr.
"/    ] ifTrue:[
"/        aCompiler parserFlags warnAboutPossibleSTCCompilationProblems ifTrue:[
"/            aCompiler 
"/                warning:'stc will not compile return within a return'
"/                line:lineNr.
"/        ].
"/    ].
    self basicCodeOn:aStream inBlock:b for:aCompiler

    "Modified: / 16-11-2006 / 14:34:15 / cg"
! !

!ReturnNode methodsFor:'enumerating'!

nodeDo:anEnumerator
    "helper for parse tree walking"

    ^ anEnumerator doReturn:self value:expression

    "Modified: 19.6.1997 / 16:42:40 / cg"
! !

!ReturnNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    |val|

    expression notNil ifTrue:[
        val := expression evaluateIn:anEnvironment.
    ].
    myHome exitWith:val.
    "when we arrive here, the parser context is already gone
     - try block-return"
    blockHome notNil ifTrue:[blockHome exitWith:val].
    "well - what else can be done"
    ^ val
! !

!ReturnNode methodsFor:'printing & storing'!

printOn:aStream indent:i
    aStream nextPutAll:'^ '.
    expression printOn:aStream
! !

!ReturnNode methodsFor:'queries'!

isConstant
    ^ false
!

isJavaScriptReturnNode
    ^ false

    "Created: / 19-05-2010 / 15:14:46 / cg"
!

isReturnNode
    ^ true
!

isSimpleConstant
    ^ false
!

isSimpleExpression
    ^ false
!

isSimpleVariable
    ^ false
! !

!ReturnNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitReturnNode:self
! !

!ReturnNode class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcomp/ReturnNode.st,v 1.45 2014-06-13 10:24:03 cg Exp $'
! !


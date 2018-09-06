"
 COPYRIGHT (c) 1990 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libcomp' }"

"{ NameSpace: Smalltalk }"

StatementNode subclass:#PrimitiveNode
	instanceVariableNames:'code primNumber optional'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Compiler-Support'
!

!PrimitiveNode class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1990 by Claus Gittinger
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
    node for parse-trees, representing primitive code
    This is a helper class for the compiler.

    Primitives are (currently) not always supported by the incremental compiler 
    - if you want a primitive, you must use the stc-compiler and 
    link a new smalltalk.

    On system which support dynamic object loading, methods with primitives are passed 
    to stc and the resulting binary is loaded into the image 
    (also a limited set of numeric primitives could be implemented for more ST-80 
     compatibility - if there is a need).

    To allow autoloaded/filedIn code to be written for best performance, an optional
    primitive directive (in the primitives first lines comment) may specify an
    optional primitive; these are compiled on systems which do support binary code
    loading, and ignored completely on others.

    [author:]
        Claus Gittinger
"
! !

!PrimitiveNode class methodsFor:'instance creation'!

code:aString
    ^ self basicNew code:aString
!

primitiveNumber:anInteger
    ^ self basicNew primitiveNumber:anInteger
! !

!PrimitiveNode methodsFor:'accessing'!

code:aString
    "set the primitives code - check for the 'OPTIONAL' directive"

    |firstLine commentPos words|

    code := aString.
    optional := false.

    firstLine := aString readStream nextLine.
    commentPos := firstLine indexOfSubCollection:'/*'.
    commentPos ~~ 0 ifTrue:[
	words := (firstLine copyFrom:(commentPos + 2)) asCollectionOfWords.
	(words includes:'OPTIONAL') ifTrue:[
	    optional := true
	]
    ]

    "Modified: 24.10.1995 / 11:29:51 / cg"
!

primitiveNumber:anInteger 
    optional := false.
    primNumber := anInteger
! !


!PrimitiveNode methodsFor:'code generation'!

codeForSideEffectOn:aStream inBlock:b for:aCompiler
    "catch code generation"

    optional ifTrue:[^ self].
    aCompiler class newPrimitives == true ifTrue:[^ self].
    self error:'cannot compile primitives (as yet)' mayProceed:true
!

codeOn:aStream inBlock:b for:aCompiler
    "catch code generation"

    optional ifTrue:[^ self].
    aCompiler class newPrimitives == true ifTrue:[^ self].
    self error:'cannot compile primitives (as yet)' mayProceed:true
! !

!PrimitiveNode methodsFor:'enumerating'!

nodeDo:anEnumerator
    "helper for parse tree walking"

    ^ anEnumerator doPrimitive:self code:code primitiveIndex:primNumber
! !

!PrimitiveNode methodsFor:'evaluation'!

evaluateExpressionIn:anEnvironment
    "catch evaluation"

    optional ifTrue:[^ nil].
    self error:'cannot evaluate primitives' mayProceed:true
!

evaluateIn:anEnvironment
    "catch evaluation"

    optional ifTrue:[^ nil].
    self error:'cannot evaluate primitives' mayProceed:true
! !

!PrimitiveNode methodsFor:'queries'!

containsReturn

    "/JV@2011-07-19: I'm not quite sure that this is OK..."
    ^(code includesString: 'return') 
        or: [code includesString: 'RETURN']

    "Created: / 19-07-2011 / 18:47:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isConstant
    ^ false
!

isOptional
    ^ optional
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

!PrimitiveNode methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitPrimitiveNode:self
! !

!PrimitiveNode class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


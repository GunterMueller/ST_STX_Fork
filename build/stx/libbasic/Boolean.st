"
 COPYRIGHT (c) 1988 by Claus Gittinger
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

Object subclass:#Boolean
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Objects'
!

!Boolean class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1988 by Claus Gittinger
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
    Boolean is an abstract class defining the common protocol for logical
    values. The logical values are represented by its two subclasses True and False.

    There are no instances of Boolean in the system and there is only one
    instance of True (which is the global true) and one of False (false).

    Boolean redefines some messages which deal with copying Booleans,
    to make certain there is only one instance of each.
    The system will behave strange if you fiddle around here and create
    new instances of True or False (i.e. it will not recognize these new
    instances as being true or false).

    [author:]
	Claus Gittinger
"
! !

!Boolean class methodsFor:'instance creation'!

basicNew
    "{ Pragma: +optSpace }"

    "catch instance creation
     - there must be exactly one instance of each - no more"

    self error:'new instances of True/False are not allowed'
!

readFrom:aStringOrStream onError:exceptionBlock
    "return a new Boolean, reading a printed representation from aStringOrStream."

    |str word|

    str := aStringOrStream readStream.
    str skipSeparators.
    word := str nextAlphaNumericWord.
    word = 'true' ifTrue:[^ true].
    word = 'false' ifTrue:[^ false].
    ^ exceptionBlock value.

    "
     Boolean readFrom:'true'      
     Boolean readFrom:'false'     
     Boolean readFrom:'xxx'  
     Boolean readFrom:'  true'     
     Boolean readFrom:'  false'    
     Boolean readFrom:'true xxx'      
     Boolean readFrom:'false xxx'     

     Boolean readFromString:'true xxx'   
     Boolean readFromString:'false xxx'  
    "
! !




!Boolean class methodsFor:'queries'!

hasSharedInstances
    "return true if this class has shared instances, that is, instances
     with the same value are identical.
     True returned here - there is only one true and only one false."

    ^ true
!

isAbstract
    ^ self == Boolean
!

isBuiltInClass
    "return true if this class is known by the run-time-system.
     Here, true is returned (for my two subclasses)."

    ^ true

    "Modified: 23.4.1996 / 15:58:22 / cg"
! !




!Boolean methodsFor:'blocked'!

addDependent:someOne
    "/ not really an error ...
    "/ self error:'should not be invoked for booleans'

    "Created: / 17-11-2010 / 13:03:25 / cg"
!

onChangeSend:selector to:someOne
    "/ not really an error ...
    "/ self error:'should not be invoked for booleans'
! !

!Boolean methodsFor:'converting'!

asBoolean
    ^ self
!

literalArrayEncoding
    "encode myself as an array literal, from which a copy of the receiver
     can be reconstructed with #decodeAsLiteralArray."

    ^ self

    "Modified: 5.9.1995 / 22:46:57 / claus"
    "Modified: 22.4.1996 / 13:00:05 / cg"
! !

!Boolean methodsFor:'copying'!

copy
    "return a shallow copy of the receiver
     - since both true and false are unique, return the receiver"

    ^ self
!

deepCopyUsing:aDictionary postCopySelector:postCopySelector
    "return a deep copy of the receiver
     - since both true and false are unique, return the receiver"

    ^ self
!

shallowCopy
    "return a shallow copy of the receiver
     - since both true and false are unique, return the receiver"

    ^ self
!

simpleDeepCopy
    "return a deep copy of the receiver
     - since both true and false are unique, return the receiver"

    ^ self
! !


!Boolean methodsFor:'printing & storing'!

printOn:aStream
    "append a character sequence representing the receiver to the argument, aStream"

    aStream nextPutAll:self printString
!

storeOn:aStream
    "append a character sequence to the argument, aStream from which the
     receiver can be reconstructed using readFrom:."

    ^ self printOn:aStream
!

storeString
    "return  a character sequence to the argument, aStream from which the
     receiver can be reconstructed using readFrom:."

    ^ self printString
! !


!Boolean methodsFor:'testing'!

isBoolean
    "Return true, because it is a boolean."

    ^ true.

    "Modified: / 17-07-2006 / 14:14:24 / cg"
!

isLiteral
    "return true, if the receiver can be used as a literal constant in ST syntax
     (i.e. can be used in constant arrays)"

    ^ true
! !

!Boolean methodsFor:'tracing'!

traceInto:aRequestor level:level from:referrer
    "double dispatch into tracer, passing my type implicitely in the selector"

    ^ aRequestor traceBoolean:self level:level from:referrer


! !

!Boolean methodsFor:'visiting'!

acceptVisitor:aVisitor with:aParameter
    "dispatch for visitor pattern; send #visitBoolean:with: to aVisitor"

    ^ aVisitor visitBoolean:self with:aParameter
! !


!Boolean class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


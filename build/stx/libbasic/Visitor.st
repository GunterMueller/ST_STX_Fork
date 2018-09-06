"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Object subclass:#Visitor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'System-Visiting'
!

!Visitor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    This class is abstract and implements the visitor pattern.
    It defines #visitXXX:with: messages for various kinds of objects.
    Any of these messsages is eventually mapped to #visitObject:with:.

    When a class redefines #acceptVisitor:with:, an method has to be defined here, too.

    Subclasses have to define at least #visitObject:with:

    [author:]
        Stefan Vogel (stefan@zwerg)

    [see also:]
        Object>>acceptVisitor:with:
"
! !

!Visitor methodsFor:'helpers'!

doesNotUnderstand:aMessage
    "catch unimplemented #visitXXX:with: messages and redirect them to #visitObject:with:.
     maybe someone implemented an #acceptVisitor:with: in the XXX class and didn't
     implement the corresponding method here.

     This should not happen, and a error message is printed, because this can also
     occur due to a typo."

    |selector args|

    selector := aMessage selector.
    ((selector startsWith:'visit') and:[selector endsWith:'with:']) ifTrue:[
        ('Visitor: unimplemented #', selector, ' in class ', self className, '. Please define as #visitObject:with:') errorPrintCR.
        args := aMessage arguments.
        ^ self visitObject:(args at:1) with:(args at:2).
    ].

    ^ super doesNotUnderstand:aMessage

    "
       Visitor new visitFoo:#foo with:'arg'
    "
!

visitChildrenOf:anObject
    "recursively enumerate anObjects refs, visiting each of the child objects.
     nil childs are not visited"

    |instVarNames theClass 
     sz "{ Class: SmallInteger }"|

    theClass := anObject class.
    sz := theClass instSize.
    sz ~~ 0 ifTrue:[
        instVarNames := theClass allInstVarNames.
        1 to:sz do:[:i |  |ref|
            ref := anObject instVarAt:i.
            ref notNil ifTrue:[
                ref acceptVisitor:self with:(instVarNames at:i).
                self nextObject.
            ].
        ].
    ].

    theClass isVariable ifTrue:[
        sz := anObject basicSize.
        sz ~~ 0 ifTrue:[
            1 to:sz do:[:i |
                (anObject basicAt:i) acceptVisitor:self with:i.   
                self nextObject.
            ]
        ].
    ].
! !

!Visitor methodsFor:'subclass responsibility'!

nextObject
    "this is sent, when a new Object is going to be visited.
     Subclasses may redefine this to perform specific actions"

    ^ self 
!

visitObject:anObject with:aParameter
    "visit an object. Subclasses must at least implement this method"

    self subclassResponsibility
! !

!Visitor methodsFor:'visiting smalltalk types'!

visitBehavior:aSymbol with:aParameter
    "visit a class"

    self visitObject:aSymbol with:aParameter
!

visitBitArray:aByteArray with:aParameter
    "visit an absolute time value"

    self visitSequenceableCollection:aByteArray with:aParameter
!

visitBlock:aBlock with:aParameter

    self visitObject:aBlock with:aParameter
!

visitBoolean:aBoolean with:aParameter
    "visit a Boolean"

    self visitObject:aBoolean with:aParameter
!

visitByteArray:aByteArray with:aParameter
    "visit a ByteArray value"

    self visitSequenceableCollection:aByteArray with:aParameter
!

visitCharacter:aCharacter with:aParameter
    "visit a Character"

    self visitObject:aCharacter with:aParameter
!

visitCollection:aCollection with:aParameter
    "visit a Collection"

    self visitObject:aCollection with:aParameter
!

visitDate:aDate with:aParameter
    "visit a date value"

    self visitObject:aDate with:aParameter
!

visitDictionary:aDictionary with:aParameter
    "visit a Dictionary"

    self visitCollection:aDictionary with:aParameter
!

visitFloat:aFloat with:aParameter
    "visit a Float"

    self visitNumber:aFloat with:aParameter
!

visitFraction:aFraction with:aParameter
    "visit a Fraction"

    self visitNumber:aFraction with:aParameter
!

visitInteger:anInteger with:aParameter
    "visit an Integer"

    self visitNumber:anInteger with:aParameter
!

visitInterval:anInterval with:aParameter
    "intervals are a special flavor of sequenceable collection (saving memory)
     We treat it as SequenceableCollection by default.
     Encoders that do a dense representation, redefine this to #visitObject"

    ^ self visitSequenceableCollection:anInterval with:aParameter
!

visitNilWith:aParameter
    "visit a nil"

    self visitObject:nil with:aParameter
!

visitNumber:aNumber with:aParameter
    "visit an Integer"

    self visitObject:aNumber with:aParameter
!

visitSequenceableCollection:aCollection with:aParameter
    "visit a SequenceableCollection"

    self visitCollection:aCollection with:aParameter
!

visitSet:aCollection with:aParameter
    "visit a Set"

    self visitCollection:aCollection with:aParameter
!

visitStream:aStream with:aParameter
    "visit a Stream"

    self visitObject:aStream with:aParameter
!

visitString:aString with:aParameter
    "visit a String"

    self visitObject:aString with:aParameter
!

visitSymbol:aSymbol with:aParameter
    "visit a Symbol"

    ^ self visitString:aSymbol with:aParameter
!

visitTimestamp:aTimestamp with:aParameter
    "visit an timestamp value"

    self visitObject:aTimestamp with:aParameter
!

visitUtcTimestamp:aTimestamp with:aParameter
    "visit an UTC timestamp value"

    self visitTimestamp:aTimestamp with:aParameter
! !

!Visitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/Visitor.st,v 1.7 2011-01-24 13:20:08 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic/Visitor.st,v 1.7 2011-01-24 13:20:08 stefan Exp $'
! !

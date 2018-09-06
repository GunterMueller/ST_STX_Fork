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

Visitor subclass:#AspectVisitor
	instanceVariableNames:'aspect'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Visiting'
!

!AspectVisitor class methodsFor:'documentation'!

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
    This is a Visitor that visits only some aspects of an object.

    [author:]
        Stefan Vogel (stefan@zwerg)

    [instance variables:]
        aspect  <Symbol|Object>     something defining the aspect to be visited        

    [class variables:]

    [see also:]

"
! !

!AspectVisitor methodsFor:'accessing'!

aspect
    "return the value of the instance variable 'aspect' (automatically generated)"

    ^ aspect
!

aspect:something
    "set the value of the instance variable 'aspect' (automatically generated)"

    aspect := something.
! !

!AspectVisitor methodsFor:'helpers'!

aspectElementDescriptorFor:anObject
    "return association that should be visited for all child objects of anObject.
     Return a collection of associations. The association key is the name of the object,
     where the association value is the child object"

    ^ anObject elementDescriptorFor:aspect.

    "
        XMLStandardCoder new aspect:#elementDescriptorForInstanceVariables;
                 encodingOf:('blaKey' -> 'blaValue')

        XMLStandardCoder new aspect:#elementDescriptorForInstanceVariables;
                 encodingOf:('blaKey' -> nil)

        XMLStandardCoder new aspect:#elementDescriptorForNonNilInstanceVariables;
                 encodingOf:('blaKey' -> nil)

        XMLStandardCoder new aspect:#blaFaselQuall;
                 encodingOf:('blaKey' -> nil)
    "
!

visitChildrenOf:anObject
    "visit all child objects of anObject.
     If aspect is defined, perform aspect to fetch the child objects.
     Otherwise encode all the instance variables of anObject.

     Subclasses may send this message"

    |childObjectDescriptors|

    aspect isNil ifTrue:[
        "shortcut -- basic mechanism: visit instance variables by name"
        super visitChildrenOf:anObject.
        ^ self.
    ].

    childObjectDescriptors := self aspectElementDescriptorFor:anObject.
    childObjectDescriptors do:[:association|
        association notNil ifTrue:[
            association value acceptVisitor:self with:association key.
            self nextObject.
        ].
    ].

    "
        XMLStandardCoder new aspect:#elementDescriptorForInstanceVariables;
                 encodingOf:('blaKey' -> 'blaValue')

        XMLStandardCoder new aspect:#elementDescriptorForInstanceVariables;
                 encodingOf:('blaKey' -> nil)

        XMLStandardCoder new aspect:#elementDescriptorForNonNilInstanceVariables;
                 encodingOf:('blaKey' -> nil)

        XMLStandardCoder new aspect:#blaFaselQuall;
                 encodingOf:('blaKey' -> nil)
    "
! !

!AspectVisitor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/AspectVisitor.st,v 1.1 2004/06/11 17:55:26 stefan Exp $'
!

version_SVN
    ^ '$Id: AspectVisitor.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !




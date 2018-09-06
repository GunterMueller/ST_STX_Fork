"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava' }"

Object subclass:#JavaField
	instanceVariableNames:'accessFlags class name descriptor signature index constantValue
		annotations'
	classVariableNames:'A_FINAL A_PRIVATE A_PROTECTED A_PUBLIC A_STATIC A_TRANSIENT
		A_VOLATILE A_SMALLTALK A_SYNTHETIC A_ENUM FieldTypeClasses'
	poolDictionaries:''
	category:'Languages-Java-Reader-Support'
!

!JavaField class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaField class methodsFor:'class initialization'!

initialize
    A_PUBLIC := 16r0001.
    A_PRIVATE := 16r0002.
    A_PROTECTED := 16r0004.
    A_STATIC := 16r0008.
    A_FINAL := 16r0010.
    A_VOLATILE := 16r0040.
    A_TRANSIENT := 16r0080.
    A_SYNTHETIC := 16r1000.
    A_ENUM := 16r4000.
    FieldTypeClasses := (IdentityDictionary new)
                at: #B put: JavaByte;
                at: #C put: Character;
                at: #D put: Float;
                at: #F put: ShortFloat;
                at: #I put: Integer;
                at: #J put: LargeInteger;
                at: #S put: JavaShort;
                at: #Z put: Boolean;
                at: #'[B' put: ByteArray;
                at: #'[C' put: Unicode16String;
                at: #'[D' put: DoubleArray;
                at: #'[F' put: FloatArray;
                at: #'[I' put: SignedIntegerArray;
                at: #'[J' put: SignedLongIntegerArray;
                at: #'[S' put: WordArray;
                at: #'[Z' put: JavaBooleanArray;
                yourself

    "
     self initialize"

    "Modified: / 13-05-1998 / 14:44:43 / cg"
    "Modified: / 31-01-2014 / 12:31:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaField class methodsFor:'constants'!

A_FINAL
    ^ A_FINAL


!

A_PRIVATE
    ^ A_PRIVATE


!

A_PROTECTED
    ^ A_PROTECTED

    "Created: / 13.5.1998 / 13:03:51 / cg"
!

A_PUBLIC
    ^ A_PUBLIC


!

A_STATIC
    ^ A_STATIC

    "Created: / 13.5.1998 / 13:03:55 / cg"
!

A_TRANSIENT
    ^ A_TRANSIENT


!

A_VOLATILE
    ^ A_VOLATILE


! !

!JavaField methodsFor:'accessing'!

accessFlags
    ^ accessFlags
!

annotations
    ^ annotations
!

annotations:something
    annotations := something.
!

constantPool
    ^ class constantPool

    "Created: / 17-12-2010 / 18:40:23 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified (format): / 08-12-2014 / 16:20:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

constantValue
    ^ constantValue
!

constantValue:aValue
    constantValue := aValue
!

descriptor
    ^ descriptor

    "Created: / 21-02-2012 / 11:13:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ensureHasAnnotations
    annotations isNil ifTrue:[
        annotations := JavaAnnotationContainer for:self
    ].
    ^ annotations

    "Created: / 25-02-2011 / 16:04:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2011 / 17:13:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:54:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

index
    index isNil ifTrue:[
        self isStatic ifTrue:[
            index := class class instVarIndexFor:name
        ] ifFalse:[
            index := class instVarIndexFor:name
        ].
    ].
    ^ index

    "Modified: / 08-12-2014 / 16:30:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaClass

    ^ class

    "Created: / 27-07-2011 / 09:17:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ name
!

signature
    ^ signature

    "Created: / 15.10.1998 / 10:37:06 / cg"
! !

!JavaField methodsFor:'initialization'!

setAccessFlags:flags
    accessFlags := flags.

    "Created: 16.4.1996 / 13:04:25 / cg"
!

setClass: aClass

    class := aClass

    "Created: / 27-07-2011 / 09:27:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setConstantValue:something
    constantValue := something.

    "Created: 16.4.1996 / 13:04:58 / cg"
!

setDescriptor:aString

    descriptor := aString.

    "Created: / 16-04-1996 / 13:04:43 / cg"
    "Created: / 14-08-2011 / 19:40:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setIndex:anInteger
    index := anInteger.

    "Created: / 22-11-2010 / 17:13:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setName:aString
    name := aString asSymbol.

    "Created: / 16-04-1996 / 13:04:35 / cg"
    "Modified: / 04-10-2013 / 13:02:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSignature:aString
    signature := aString.

    "Created: 16.4.1996 / 13:04:43 / cg"
! !

!JavaField methodsFor:'printing & storing'!

printOn: aStream 
    | signatureOrDescriptor |
    signature notNil ifTrue: [ signatureOrDescriptor := signature ] ifFalse: [
        descriptor notNil ifTrue: [ signatureOrDescriptor := descriptor ] ifFalse: [
            signatureOrDescriptor := 'unknown descriptor'
        ]
    ].
    super printOn: aStream.
    aStream
        nextPutAll: '(name: ';
        nextPutAll: name;
        nextPut: $,;
        space;
        nextPutAll: 'descriptor: ';
        nextPutAll: signatureOrDescriptor;
        nextPut: $)

    "Created: / 22-05-2011 / 16:07:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2011 / 22:03:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaField methodsFor:'queries'!

initialValue
    ^ JavaClass initialValueFromSignature: descriptor

    "Modified: / 14-08-2011 / 19:59:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFinal
    ^ (accessFlags bitAnd:A_FINAL) ~~ 0

    "Modified: / 13.5.1998 / 12:59:26 / cg"
!

isPrivate
    ^ (accessFlags bitAnd:A_PRIVATE) ~~ 0

    "Modified: / 13.5.1998 / 12:59:30 / cg"
!

isProtected
    ^ (accessFlags bitAnd:A_PROTECTED) ~~ 0

    "Modified: / 13.5.1998 / 12:59:35 / cg"
!

isPublic
    ^ (accessFlags bitAnd:A_PUBLIC) ~~ 0

    "Modified: / 13.5.1998 / 12:59:40 / cg"
!

isStatic
    ^ (accessFlags bitAnd:A_STATIC) ~~ 0

    "Modified: / 13.5.1998 / 12:59:43 / cg"
!

isSynthetic
    ^ (accessFlags bitAnd:A_SYNTHETIC) ~~ 0

    "Modified: / 13-05-1998 / 12:59:40 / cg"
    "Created: / 30-03-2012 / 19:49:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTransient
    ^ (accessFlags bitAnd:A_TRANSIENT) ~~ 0

    "Modified: / 13.5.1998 / 12:59:51 / cg"
!

isVolatile
    ^ (accessFlags bitAnd:A_VOLATILE) ~~ 0

    "Modified: / 13.5.1998 / 12:59:56 / cg"
!

type
    ^ JavaMethod typeFromSignature:descriptor in:nil

    "Modified: / 08-01-1998 / 19:13:22 / cg"
    "Modified: / 14-08-2011 / 19:43:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typeClass

    ^(JavaDescriptor fromString: descriptor) javaClass.

    "Created: / 23-11-2010 / 17:02:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-08-2011 / 19:59:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typeClassName

    ^(JavaDescriptor fromString: descriptor) javaClassName.

    "Created: / 13-02-2013 / 19:21:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaField.st,v 1.25 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaField.st,v 1.25 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaField initialize!

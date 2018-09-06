"{ Encoding: utf8 }"

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

"{ NameSpace: Smalltalk }"

Object subclass:#JavaDescriptor
	instanceVariableNames:''
	classVariableNames:'BaseTypes BaseTypesByTypeName'
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaDescriptor class methodsFor:'documentation'!

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

!JavaDescriptor class methodsFor:'instance creation'!

fromString: aString

    ^self readFromString: aString

    "Created: / 25-11-2010 / 18:20:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFrom: aStream

    ^ self
        readFrom:aStream
        onError:[ self conversionErrorSignal
                    raiseErrorString:'invalid java descriptor']

    "Created: / 25-11-2010 / 18:04:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFrom:stream onError:exceptionBlock

    (stream peek == $( or:[stream peek == $<])
        ifTrue: [^self readMethodDescriptorFrom: stream onError: exceptionBlock]
        ifFalse:[^self readFieldDescriptorFrom:  stream onError: exceptionBlock].

    "
        JavaDescriptor fromString:'Ljava/lang/Object;'
        JavaDescriptor fromString:'[I'
        JavaDescriptor fromString:'[[I'
        JavaDescriptor fromString:'(ILjava/lang/Object;)V'
        JavaDescriptor fromString:'(ILjava/lang/Object;)Ljava/lang/Class;'    
        JavaDescriptor fromString:'<T:Ljava/lang/Object;>(Ljava/util/Collection<TT;>;I)Ljava/util/Collection<TT;>;'

    "

    "Created: / 25-11-2010 / 17:50:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-08-2011 / 01:37:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaDescriptor class methodsFor:'accessing'!

baseTypes

    ^BaseTypes

    "Created: / 22-05-2011 / 17:45:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

baseTypesByTypeName

    ^BaseTypesByTypeName

    "Created: / 03-02-2011 / 21:08:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaDescriptor class methodsFor:'class initialization'!

initialize
    "
     WindowGroup activeApplication  spawnClassBrowserFor: BaseTypes values label:'Java primitive types' in:#buffer
    "
    "/WARNING: If you change something here, you MUST also
    "/         change JavaField class>>#initialize !!!!!!
    
    BaseTypes := (IdentityDictionary new)
                at: $B put: JavaByte;
                at: $C put: Character;
                at: $D put: Float;
                at: $F put: ShortFloat;
                at: $I put: Integer;
                at: $J put: LargeInteger;
                at: $S put: JavaShort;
                at: $Z put: Boolean;
                at: $V put: UndefinedObject;
                yourself.
    BaseTypesByTypeName := (Dictionary new)
                at: 'byte' put: JavaByte;
                at: 'char' put: Character;
                at: 'double' put: Float;
                at: 'float' put: ShortFloat;
                at: 'int' put: Integer;
                at: 'long' put: LargeInteger;
                at: 'short' put: JavaShort;
                at: 'boolean' put: Boolean;
                at: 'void' put: UndefinedObject;
                yourself.

    "Created: / 25-11-2010 / 17:51:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-03-2015 / 10:17:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaDescriptor class methodsFor:'queries'!

isJavaPrimitiveArrayName: className 
    | justTypeSymbol |

    (className startsWith: $[) ifTrue: [
        justTypeSymbol := className copyFrom: ((className lastIndexOf: $[) + 1)
                    to: className size
    ]  ifFalse: [ ^ false ].
    ^(  justTypeSymbol size = 1 ) 
        and: [BaseTypes includesKey: justTypeSymbol first].
! !

!JavaDescriptor class methodsFor:'reading-private'!

readArrayTypeFrom: stream onError: exceptionBlock 
    | c |

    stream next. "eat $["
    c := self readFrom: stream onError: exceptionBlock.
    c beArrayType.
    ^c

    "Created: / 25-11-2010 / 18:12:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-03-2015 / 10:08:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readBaseTypeFrom:  stream onError: exceptionBlock

    ^JavaFieldDescriptor javaClass: (BaseTypes at: (stream next) ifAbsent: exceptionBlock)

    "Created: / 25-11-2010 / 18:11:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readFieldDescriptorFrom:  stream onError: exceptionBlock

    | p |
    p := stream peek.

    p == $L ifTrue:[^self readObjectTypeFrom: stream onError: exceptionBlock].
    p == $[ ifTrue:[^self readArrayTypeFrom: stream onError: exceptionBlock].
    (#(
         $B "byte"
         $C "char"
         $D "double"
         $F "float"
         $I "int"
         $J "long"
         $S "short"
         $Z "boolean"
         $V "void"
    ) includes: p) ifTrue:[^self readBaseTypeFrom: stream onError: exceptionBlock].

    exceptionBlock value

    "Created: / 25-11-2010 / 17:55:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-12-2010 / 22:47:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readMethodDescriptorFrom: stream onError: exceptionBlock

    | parameterDescriptors returnDescriptor |

    stream peek == $< ifTrue:[
        self readTypeVariableFrom: stream onError: exceptionBlock
    ].
    stream next. "eat $("
    parameterDescriptors := OrderedCollection new.
    [ stream peek ~= $) ] whileTrue:[
        parameterDescriptors add:( self readFieldDescriptorFrom: stream onError: exceptionBlock).
    ].
    stream next. "eat $)"
"/    stream peek == $V ifFalse:[
"/        returnDescriptor := self readFieldDescriptorFrom: stream onError: exceptionBlock.
"/    ] ifTrue:[
"/        stream next. "eat $V"
"/    ].
    returnDescriptor := self readFieldDescriptorFrom: stream onError: exceptionBlock.

    ^JavaMethodDescriptor parameters: parameterDescriptors return: returnDescriptor

    "
        JavaDescriptor fromString:'(ILjava/lang/Object;)V'
        JavaDescriptor fromString:'(ILjava/lang/Object;)Ljava/lang/Class;'  
    "

    "Created: / 25-11-2010 / 18:36:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-08-2011 / 01:39:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-12-2011 / 17:22:48 / kursjan <kursjan@fit.cvut.cz>"
!

readObjectTypeFrom:  stream onError: exceptionBlock

    | clsName out |

    stream next. "/eat $L.
    out := String new writeStream.    
    [ stream peek ~~ $; and:[stream peek ~~ $< ]] whileTrue:[
        | c |

        c := stream next.
        c isNil ifTrue:[exceptionBlock value. ^nil].
        out nextPut: c.
    ].
    clsName := out contents.
    stream peek == $< ifTrue:[
        self readTypeVariableFrom: stream onError: exceptionBlock
    ].

    "Just a check"
    stream next ~= $; ifTrue:[exceptionBlock value].
    ^JavaFieldDescriptor javaClassName: clsName.

    "Created: / 25-11-2010 / 18:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readTypeVariableFrom:  stream onError: exceptionBlock

    | nangles |

    stream next. "/eat $<.
    nangles := 1.
    [ nangles ~~ 0 ] whileTrue:[
        stream peek == $< ifTrue:[nangles := nangles + 1].
        stream peek == $> ifTrue:[nangles := nangles - 1].
        stream next.
    ]

    "Created: / 13-08-2011 / 01:39:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaDescriptor class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaDescriptor.st,v 1.7 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


JavaDescriptor initialize!

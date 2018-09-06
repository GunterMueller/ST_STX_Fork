"{ Package: 'stx:libjava' }"!

!Behavior methodsFor:'queries'!

isInterface
    "return true, if the receiver is a Java interface"

    ^ false

    "
     True isInterface
    "

    "Created: / 22-02-2012 / 21:53:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Behavior methodsFor:'queries'!

isJavaPrimitiveType

    ^false

    "Created: / 20-12-2010 / 21:52:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean class methodsFor:'queries'!

isJavaPrimitiveType

    ^true

    "Created: / 25-02-2011 / 08:22:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean class methodsFor:'queries'!

javaArrayClass
    ^ JavaBooleanArray

    "Created: / 25-02-2011 / 08:27:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 12:31:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean class methodsFor:'autoboxing support'!

javaBox: anObject
    | wrapper |

    wrapper := (JavaVM classForName: 'java.lang.Boolean') new.
    wrapper perform: #'<init>(Z)V' with: anObject.
    ^ wrapper

    "Created: / 16-08-2011 / 09:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean class methodsFor:'accessing'!

javaName

    ^'boolean'.

    "Modified: / 25-02-2011 / 18:58:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean class methodsFor:'autoboxing support'!

javaUnbox: object onError: errorBlock

    | value |

    (object class binaryName = 'java/lang/Boolean') ifFalse:[
        errorBlock value.
    ].
    value := object instVarNamed: #value.
    (value ~~ 0 and:[value ~~ 1]) ifTrue:[
        errorBlock value.
    ].
    ^value

    "Created: / 22-11-2011 / 11:52:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:41:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean class methodsFor:'autoboxing support'!

javaUnwrap: zeroOrOne

    ^zeroOrOne == 1

    "Created: / 10-12-2011 / 20:00:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean class methodsFor:'autoboxing support'!

javaWrap: boolean

    ^boolean ifTrue:[1] ifFalse:[0].

    "Created: / 18-03-2012 / 22:03:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean class methodsFor:'autoboxing support'!

javaWrapRequired
    ^true

    "Created: / 29-11-2012 / 23:02:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Boolean class methodsFor:'accessing'!

javaWrapperClass
    ^(JavaVM classForName: 'java.lang.Boolean')

    "Created: / 24-02-2012 / 19:43:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-05-2013 / 11:21:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^self basicSize

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray methodsFor:'vm support'!

_CHECKCAST: cls
    ^cls == ByteArray ifTrue:[self] ifFalse:[JavaVM throwClassCastException]

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray methodsFor:'vm support'!

_INSTANCEOF: cls
    ^ByteArray == cls ifTrue:[1] ifFalse:[0]

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray class methodsFor:'testing'!

isInterface

    ^false
! !

!ByteArray class methodsFor:'queries'!

isJavaArrayClass

    ^true

    "Created: / 05-02-2011 / 22:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray class methodsFor:'queries'!

isJavaReferenceType

    "Java arrays are reference types"
    ^true

    "Created: / 20-12-2010 / 22:30:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray class methodsFor:'accessing-java'!

javaArrayClass

    ^JavaArray javaArrayClassFor: self

    "Created: / 11-06-2011 / 23:42:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray class methodsFor:'accessing-java'!

javaComponentClass

    ^JavaByte

    "Created: / 20-12-2010 / 22:05:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ByteArray class methodsFor:'accessing'!

javaName

    ^'[B'.

    "Modified: / 25-02-2011 / 19:02:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character class methodsFor:'queries'!

isJavaPrimitiveType

    ^true

    "Created: / 20-12-2010 / 22:18:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character class methodsFor:'accessing'!

javaArrayClass
    ^ String

    "Created: / 11-02-2011 / 10:44:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character class methodsFor:'autoboxing support'!

javaBox: anObject
    | wrapper |

    wrapper := (JavaVM classForName: 'java.lang.Character') new.
    wrapper perform: #'<init>(C)V' with: anObject codePoint.
    ^ wrapper

    "Created: / 16-08-2011 / 09:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character class methodsFor:'accessing'!

javaName

    ^'char'.

    "Modified: / 25-02-2011 / 18:58:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character class methodsFor:'autoboxing support'!

javaUnbox: object onError: errorBlock

    | value |

    (object class binaryName = 'java/lang/Character') ifFalse:[
        errorBlock value.
    ].
    value := object instVarNamed: #value.
    (value between: 0 and: 255) ifFalse:[
        errorBlock value.
    ].
    ^value

    "Created: / 22-11-2011 / 11:52:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:41:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character class methodsFor:'autoboxing support'!

javaUnwrap: codePoint
    ^ Character codePoint: codePoint

    "Created: / 10-12-2011 / 20:00:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2016 / 10:10:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character class methodsFor:'autoboxing support'!

javaWrap: aCharacter
    ^ aCharacter codePoint

    "Created: / 18-03-2012 / 22:03:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-07-2016 / 10:10:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Character class methodsFor:'accessing'!

javaWrapperClass
    ^(JavaVM classForName: 'java.lang.Character')

    "Created: / 24-02-2012 / 19:42:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-05-2013 / 11:21:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^self basicSize

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'vm support'!

_CHECKCAST: cls
    cls == Unicode16String ifTrue:[^self].
    cls == String          ifTrue:[^self].
    ^JavaVM throwClassCastException.


    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:10:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'vm support'!

_INSTANCEOF: cls
    cls == Unicode16String ifTrue:[^1].
    cls == String          ifTrue:[^1].
    ^0

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:10:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'java conversions'!

asDottedJavaClassName

 "
    examples:
    java.lang.String
    [[[Ljava/lang/Object; => java.lang.Object
    "


    | nm |
    nm := self asJavaComponentClassName.
    (nm first == $L) ifTrue: [
        nm := nm copyFrom: 2 to: nm size - 1.
        (nm includes: $/) ifTrue: [
            "/ No need to do another copt here!!
            nm replaceAll: $/ with: $.
        ].
    ] ifFalse:[
        (nm includes: $/) ifTrue: [
            nm := nm copyReplaceAll: $/ with: $.
        ].
    ].
    ^ nm.

    "Created: / 21-10-2011 / 12:31:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 30-10-2011 / 17:41:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-05-2014 / 12:29:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'java conversions'!

asJavaComponentClassName
    | componentClassName |

    componentClassName := self "utf8Encoded".
    (componentClassName first == $[) ifTrue: [
        componentClassName := componentClassName copyFrom: (componentClassName lastIndexOf: $[) + 1
    ].
    ^ componentClassName.

    "Modified: / 27-05-2014 / 12:25:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'java conversions'!

asNiceJavaClassName
    | niceName |

    niceName := self asJavaComponentClassName asSTXInternalJavaClassName.
    (self occurrencesOf: $[) timesRepeat: [ niceName := niceName , '[]' ].
    niceName := niceName asString copyReplaceAll: $/ with: $..
    ^ niceName.
! !

!CharacterArray methodsFor:'java conversions'!

asSTXInternalJavaClassName
    | internalName |

    internalName := self asJavaComponentClassName.
    (internalName startsWith: $L) ifTrue: [
	internalName := internalName copyFrom: 2 to: internalName size - 1
    ].
    (internalName includes: $.) ifTrue: [
	internalName := internalName asString copyReplaceAll: $. with: $/
    ].
    ^internalName.
! !

!CharacterArray methodsFor:'java conversions'!

asSlashedJavaClassName
    "removes square brackets and adds slashes"
    | internalName |
    internalName := self asJavaComponentClassName.
    (internalName first == $L) ifTrue: [
        internalName := internalName copyFrom: 2 to: internalName size - 1.
        "/ No need to do another copy here
        (internalName includes: $.) ifTrue: [
            internalName replaceAll: $. with: $/
        ].
    ] ifFalse:[
        (internalName includes: $.) ifTrue: [
            internalName := internalName copyReplaceAll: $. with: $/
        ].
    ].
    ^ internalName.

    "Created: / 21-10-2011 / 12:31:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 30-10-2011 / 17:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-05-2014 / 12:30:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray methodsFor:'java queries'!

isJavaArrayDescriptor
^ self startsWith:$[.
! !

!CharacterArray methodsFor:'java queries'!

isJavaPrimitiveTypeDescriptor
    ^ (self size = 1 and: [ JavaDescriptor baseTypes includesKey: self first ]).
! !

!CharacterArray methodsFor:'special string converting'!

withoutSuffix: aString
    "if the receiver endsWith aString, return a copy without it.
     Otherwise return the receiver"

    (self endsWith: aString) ifTrue: [
        ^ self copyFrom: 1 to: self size - aString size
    ].
    ^ self

    "
     'helloworld' withoutSuffix:'world'
     'helloworld' withoutSuffix:'foo'"

    "Created: / 08-12-2012 / 20:26:27 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!CharacterArray class methodsFor:'encoding & decoding'!

decodeFromJavaUTF8: string8
    "Decodes a string from modified UTF8 encoding
     as used in Java .class files. see
     'The class file format specification', section 4.5.7"

    | string16 |
%{
    if (__isString(string8) ) {
        unsigned char *ptr;
        unsigned short c;
        unsigned short* dst;
        int len;

        ptr = __stringVal(string8);
        len = 0;
        while (*ptr) {
            len++;
            if ( ( *ptr & 0x80) == 0 ) {
                ptr++;
            } else {
                len--;
                goto non7bitString;
            }
        }
        RETURN ( string8 );
    non7bitString:
        while (*ptr) {
            len++;
            ptr += (*ptr & 0x80) ? ((*ptr & 0x20) ? 3 : 2) : 1;
        }

        string16 = __MKEMPTYUSTRING(len);
        ptr = __stringVal(string8);
        dst = __unicode16StringVal(string16);
        while (*ptr) {
            int x = *ptr++;
            if ( x & 0x80 ) {
                int y = *ptr++;
                if ( x & 0x20 ) {
                    int z = *ptr++;
                    *dst++ = ( (x & 0xf ) << 12 ) + ( ( y & 0x3f ) << 6 ) + ( z & 0x3f);
                } else {
                    *dst++ = ( ( x & 0x1f ) << 6 ) + ( y & 0x3f );
                }
            } else {
                *dst++ = x;
            }
        }
        RETURN ( string16 );
    }
%}.
    self primitiveFailed.

    "Created: / 22-12-2010 / 23:45:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-02-2011 / 01:12:25 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 13-03-2011 / 15:52:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 14:45:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"

! !

!CharacterArray class methodsFor:'instance creation'!

fromJavaUTF8Bytes:aByteCollection
    "return a new string which represents the characters as decoded
     from the modified utf8 encoded bytes as specified in
     The class file format specification, section 4.5.7"

    ^ self decodeFromJavaUTF8:aByteCollection asString.

    "
     CharacterArray fromUTF8Bytes:#[ 16r41 16r42 ]
     CharacterArray fromUTF8Bytes:#[ 16rC1 16r02 ]
     CharacterArray fromUTF8Bytes:#[ 16rE0 16r81 16r02 ]
     CharacterArray fromUTF8Bytes:#[ 16rEF 16rBF 16rBF ]

   rfc2279 examples:
     CharacterArray fromUTF8Bytes:#[ 16r41 16rE2 16r89 16rA2 16rCE 16r91 16r2E ]
     CharacterArray fromUTF8Bytes:#[ 16rED 16r95 16r9C 16rEA 16rB5 16rAD 16rEC 16r96 16rB4 ]
     CharacterArray fromUTF8Bytes:#[ 16rE6 16r97 16rA5 16rE6 16r9C 16rAC 16rE8 16rAA 16r9E ]

   invalid:
     CharacterArray fromUTF8Bytes:#[ 16rC0 16r80 ]
     CharacterArray fromUTF8Bytes:#[ 16rE0 16r80 16r80 ]
    "

    "Created: / 23-12-2010 / 09:01:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 14:48:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray class methodsFor:'queries'!

isJavaArrayClass

    ^true

    "Created: / 05-02-2011 / 22:45:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray class methodsFor:'accessing-java'!

javaArrayClass

    ^JavaArray javaArrayClassFor: Unicode16String

    "Created: / 11-06-2011 / 23:42:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-08-2011 / 13:18:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CharacterArray class methodsFor:'accessing-java'!

javaComponentClass

    ^Character

    "Created: / 20-12-2010 / 22:05:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'accessing - java'!

binaryName
    "Returns Java binary name for this class."

    ^ 'SMALLTALK/' , self name

    "Created: / 20-11-2013 / 15:55:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'accessing - java'!

classLoader
    JavaVM smalltalkClassLoader

    "Created: / 22-08-2012 / 13:00:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'queries'!

isSynthetic
    ^ false "/ Smalltalk classes are not synthetic...

    "Created: / 20-11-2013 / 16:03:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'accessing - java'!

javaMirror
    ^self javaMirrorClass forClass: self.

    "Created: / 31-07-2012 / 17:39:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Class methodsFor:'accessing - java'!

javaMirrorClass
    "Returns a Java mirror class to be used by Java reflection"

    self isJavaPrimitiveType ifTrue:[ ^ JavaMirror mirrorClassForJavaPrimitive ].
    self isJavaArrayClass ifTrue:[ ^ JavaMirror mirrorClassForJavaArray ].
    ^JavaMirror mirrorClassForAlienClass

    "Created: / 31-07-2012 / 17:39:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurableFeatures class methodsFor:'queries-features'!

hasJavaSupport
    "/ use Smalltalk-at to trick the dependency/prerequisite generator
    ^ (Smalltalk at: #'JavaVM' ifAbsent:nil) notNil

    "
     ConfigurableFeatures hasJavaSupport
     ConfigurableFeatures includesFeature:#JavaSupport
    "

    "Created: / 03-01-2012 / 15:36:03 / cg"
    "Created: / 18-02-2012 / 16:42:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Delay methodsFor:'delaying'!

waitWithState:state
    "suspend the current process until either the relative time delta
     has passed (if millisecondDelta is non-nil), or the absolute millisecondTime
     has been reached (if resumptionTime non-nil)."

    Processor activeProcess state:state.
    self wait.

    "
     Transcript showCR:'1'.
     (Delay forSeconds:10) waitWithState:#sleep.
     Transcript showCR:'2'.
    "

    "Modified: / 18-04-1997 / 11:56:46 / stefan"
    "Created: / 30-11-2011 / 13:38:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 25-07-2013 / 11:33:41 / exept"
    "Modified: / 25-07-2013 / 11:34:54 / cg"
! !

!DoubleArray methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^self basicSize

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DoubleArray methodsFor:'vm support'!

_CHECKCAST: cls
    ^cls == DoubleArray ifTrue:[self] ifFalse:[JavaVM throwClassCastException]

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:11:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DoubleArray methodsFor:'vm support'!

_INSTANCEOF: cls
    ^DoubleArray == cls ifTrue:[1] ifFalse:[0]

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:11:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DoubleArray class methodsFor:'testing'!

isInterface

    ^false
! !

!DoubleArray class methodsFor:'queries'!

isJavaArrayClass

    ^true

    "Created: / 20-12-2010 / 22:47:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DoubleArray class methodsFor:'queries'!

isJavaReferenceType

    "Java arrays are reference types"
    ^true

    "Created: / 20-12-2010 / 22:30:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DoubleArray class methodsFor:'accessing-java'!

javaArrayClass
    ^ JavaArray javaArrayClassFor: self.

    "Created: / 06-12-2011 / 17:28:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!DoubleArray class methodsFor:'accessing-java'!

javaComponentClass

    ^Float

    "Created: / 20-12-2010 / 22:06:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DoubleArray class methodsFor:'accessing'!

javaName

    ^'[D'.

    "Modified: / 25-02-2011 / 19:03:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ExecutableFunction methodsFor:'queries'!

isJavaConstructor
    ^ false

    "Created: / 31-07-2012 / 18:42:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ExecutableFunction methodsFor:'queries'!

isProxyMethod
    "return true, if the receiver is a proxy method.
    false is returned here, true is returned in ProxyMethod."

    ^ false.

    "Created: / 16-12-2012 / 13:35:41 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!Float class methodsFor:'queries'!

isJavaPrimitiveType

    ^true

    "Created: / 06-02-2011 / 17:21:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Float class methodsFor:'accessing'!

javaArrayClass
    ^ DoubleArray

    "Created: / 11-02-2011 / 10:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Float class methodsFor:'autoboxing support'!

javaBox: anObject
    | wrapper |

    wrapper := (JavaVM classForName: 'java.lang.Double') new.
    wrapper perform: #'<init>(D)V' with: anObject with: nil.
    ^ wrapper

    "Created: / 16-08-2011 / 09:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2013 / 01:21:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Float class methodsFor:'accessing'!

javaName

    ^'double'.

    "Modified: / 25-02-2011 / 18:59:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Float class methodsFor:'autoboxing support'!

javaUnbox: object onError: errorBlock

    | value |

    (object class binaryName = 'java/lang/Double') ifFalse:[
        errorBlock value.
    ].
    value := object instVarNamed: #value.
    ^value

    "Modified: / 08-10-2013 / 22:41:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Float class methodsFor:'accessing'!

javaWrapperClass
    ^(JavaVM classForName: 'java.lang.Double')

    "Created: / 24-02-2012 / 19:42:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-05-2013 / 11:21:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FloatArray methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^self basicSize

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FloatArray methodsFor:'vm support'!

_CHECKCAST: cls
    ^cls == FloatArray ifTrue:[self] ifFalse:[JavaVM throwClassCastException]

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:11:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FloatArray methodsFor:'vm support'!

_INSTANCEOF: cls
    ^FloatArray == cls ifTrue:[1] ifFalse:[0]

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:11:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FloatArray class methodsFor:'testing'!

isInterface

    ^false
! !

!FloatArray class methodsFor:'queries'!

isJavaArrayClass

    ^true

    "Created: / 20-12-2010 / 22:47:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FloatArray class methodsFor:'queries'!

isJavaReferenceType

    "Java arrays are reference types"
    ^true

    "Created: / 20-12-2010 / 22:30:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FloatArray class methodsFor:'accessing-java'!

javaArrayClass
    ^ JavaArray javaArrayClassFor: self.

    "Created: / 06-12-2011 / 17:29:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!FloatArray class methodsFor:'accessing-java'!

javaComponentClass

    ^ShortFloat

    "Created: / 20-12-2010 / 22:06:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FloatArray class methodsFor:'accessing'!

javaName

    ^'[F'.

    "Modified: / 25-02-2011 / 19:03:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Integer class methodsFor:'queries'!

isJavaPrimitiveType

    ^true

    "Created: / 11-02-2011 / 11:12:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Integer class methodsFor:'accessing'!

javaArrayClass
    ^ SignedIntegerArray

    "Created: / 11-02-2011 / 10:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Integer class methodsFor:'autoboxing support'!

javaBox: anObject
    | wrapper |

    wrapper := (JavaVM classForName: 'java.lang.Integer') new.
    wrapper perform: #'<init>(I)V' with: anObject.
    ^ wrapper

    "Created: / 16-08-2011 / 09:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Integer class methodsFor:'accessing'!

javaName

    ^'int'.

    "Modified: / 25-02-2011 / 18:59:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Integer class methodsFor:'autoboxing support'!

javaUnbox: object onError: errorBlock

    ^self javaUnbox: object onError: errorBlock
          min: "Integer.MIN_VALUE"-2147483648
          max: "Integer.MAX_VALUE" 2147483647

    "Created: / 25-11-2011 / 19:10:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Integer class methodsFor:'autoboxing support'!

javaUnbox: object onError: errorBlock min: min max: max

    | value |

    (#(  'java/lang/Byte'
        'java/lang/Short'
        'java/lang/Integer'
        "'java/lang/Long'" ) includes: object class binaryName) ifFalse:[
        errorBlock value.
    ].

    value := object instVarNamed:#value.
    (value between: min and: max) ifFalse:[
        errorBlock value.
    ].
    ^value

    "Created: / 22-11-2011 / 11:43:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-11-2013 / 00:02:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Integer class methodsFor:'accessing'!

javaWrapperClass
    ^(JavaVM classForName: 'java.lang.Integer')

    "Created: / 24-02-2012 / 19:41:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-05-2013 / 11:21:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LargeInteger class methodsFor:'queries'!

isJavaPrimitiveType

    ^true

    "Created: / 04-02-2011 / 11:55:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LargeInteger class methodsFor:'accessing'!

javaArrayClass
    ^ SignedLongIntegerArray

    "Created: / 11-02-2011 / 10:51:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LargeInteger class methodsFor:'autoboxing support'!

javaBox: anObject
    | wrapper |

    wrapper := (JavaVM classForName: 'java.lang.Long') new.
    wrapper perform: #'<init>(J)V' with: anObject with: nil.
    ^ wrapper

    "Created: / 16-08-2011 / 09:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-11-2013 / 01:21:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LargeInteger class methodsFor:'accessing'!

javaName

    ^'long'.

    "Modified: / 25-02-2011 / 18:59:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LargeInteger class methodsFor:'autoboxing support'!

javaUnbox: object onError: errorBlock

    | value |

    (object class binaryName = 'java/lang/Long') ifFalse:[
        errorBlock value.
    ].

    value := object instVarNamed:#value.
    (value between: "Integer.MIN_VALUE"-9223372036854775808 and: "Integer.MAX_VALUE" 9223372036854775807) ifFalse:[
        errorBlock value.
    ].
    ^value

    "Created: / 22-11-2011 / 11:45:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:42:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LargeInteger class methodsFor:'accessing'!

javaWrapperClass
    ^(Java classForName: 'java.lang.Long')

    "Created: / 24-02-2012 / 19:42:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'queries-java'!

isAbstract
    "For compatibility with Java methods"

    ^false

    "Created: / 22-08-2012 / 13:19:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'queries-java'!

isStatic
    "For compatibility with Java methods"

    ^mclass notNil and:[mclass isMetaclass]

    "Created: / 22-08-2012 / 12:27:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Method methodsFor:'accessing-java'!

javaClass
    "For compatibiliry with JavaMethod"
    ^mclass

    "Created: / 22-08-2012 / 13:20:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^JavaVM _ARRAYLENGTH: self

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'vm support'!

_CHECKCAST: cls
    ^JavaVM _CHECKCAST: self _: cls

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'vm support'!

_INSTANCEOF: cls
    ^JavaVM _INSTANCEOF: self _: cls

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'accessing-Java'!

getJavaLockWord
    "Returns a Java lock word for given object. The returned
     value is
        - either SmallInteger that encodes the thinlock
        - or a fat lock, instance of JavaMonitor
    "

    "/For nonJava objects, always return fatlock

    ^self getJavaMonitor

    "Created: / 26-08-2012 / 14:03:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'accessing-Java'!

getJavaMonitor
    "Returns fat JavaMonitor associated with the receiver"

    ^JavaVM getJavaMonitorFor: self

    "Created: / 26-08-2012 / 18:35:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'testing'!

isGroovyClass
    ^false

    "Created: / 18-02-2012 / 20:29:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'testing'!

isJavaArray

    ^self class isJavaArrayClass

    "Created: / 19-12-2010 / 17:05:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'testing'!

isJavaNameAndType
    "return true, if given object represents name and type struct in java constant pool"

    ^ false.

    "Created: / 10-05-2011 / 12:21:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!Object methodsFor:'testing'!

isJavaPackage
    "return true, if the receiver is a java package.
     False is returned here - the method is only redefined in JavaPackage."

    ^ false

    "Created: / 09-08-2011 / 09:35:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'testing'!

isJavaRef
    "Return true, if given object represents reference in java constant pool"

    ^ false.

    "Created: / 08-04-2011 / 16:12:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 30-08-2013 / 00:41:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'testing'!

isJavaWrapperClass
    "return true, if this is a java wrapper class, i.e, java.lang.Integer, java.lang.Boolean etc."

    ^ false

    "Created: / 01-01-2012 / 17:25:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'testing'!

isSocket
    "return true, if the receiver is some kind of socket;
     false returned here - the method is only redefined in Socket."

    ^ false

    "Created: / 17-08-2012 / 15:32:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'autoboxing support'!

javaBox: anObject

    ^anObject

    "Created: / 15-08-2011 / 10:52:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'autoboxing support'!

javaUnwrap: anObject
    "Unwraps the objects. Possibly call on the wrapped class"

    ^anObject

    "Created: / 10-12-2011 / 19:51:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'autoboxing support'!

javaUnwrapFrom: javaType
    ^ self.

    "Created: / 10-12-2011 / 19:51:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 30-12-2011 / 15:22:06 / kursjan <kursjan@fit.cvut.cz>"
! !

!Object methodsFor:'autoboxing support'!

javaWrap: anObject
    "Wraps the receiver into corresponding Java object"

    ^anObject

    "Created: / 26-12-2011 / 00:57:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object methodsFor:'autoboxing support'!

javaWrapRequired
    "Returns true, if a #javaWrap: has to be called
     prior an instance of Smalltalk object is passed
     as an argument to Java method, whoose formal tyoe
     is the receiver.

     Example:
     Let's say the Java method is declared as

     publid void setCount(int c) { ... }

     and Smalltalk calls

     obj setCount: 0

     then 'Integer javaWrapRequired' should return false as there
     is no need to wrap SmallInt as it represent java int values.
     (Integer is formal type of argument c.

     If the method is declared as:

     publid void setCount(java.lang.Integer c) { ... }

     then 'java.lang.Integer javaWrapRequired' should return true
     as the integer value must be wrapped into an instance of
     java.lang.Integer before it is passed to a Java method.

     "

    ^false

    "Created: / 05-11-2012 / 00:29:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object class methodsFor:'queries'!

isJavaArrayClass

    ^false

    "Created: / 19-12-2010 / 17:05:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object class methodsFor:'queries'!

isJavaClassType

    ^false

    "Created: / 11-02-2011 / 08:08:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object class methodsFor:'queries'!

isJavaReferenceType

    ^false

    "Created: / 20-12-2010 / 21:52:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Object class methodsFor:'queries'!

isJavaType

    ^false

    "Created: / 20-12-2010 / 21:52:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Process methodsFor:'Java protocol'!

clearInterrupted
    JavaVM clearInterrupted: self

    "Created: / 30-11-2011 / 10:44:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-08-2012 / 22:03:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Process methodsFor:'Java protocol'!

isInterrupted

    ^ JavaVM isInterrupted: self.

    "Created: / 30-11-2011 / 12:12:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-08-2012 / 21:56:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Process methodsFor:'queries'!

isParked
    "return true, iff the receiver is parked (by means of sun.misc.Unsafe.park() )"

    ^ (state == #parked)

    "Created: / 16-08-2012 / 22:13:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Process methodsFor:'queries'!

isSleeping
    "return true, iff the receiver is sleeping on Delay"

    ^ (state == #sleep)

    "Created: / 30-11-2011 / 13:35:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!Process methodsFor:'queries'!

isWaiting
    "return true, iff the receiver is waiting on semaphore or something"

    ^ (state == #wait)

    "Created: / 20-11-2011 / 20:55:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!Process methodsFor:'Java protocol'!

javaInterrupt
    self isWaiting ifTrue: [
        self interruptWith: [
            JavaVM throwInterruptedException: 'thread has been interrupted during wait'.
            self terminate
        ].
        ^self
    ].

    self isSleeping ifTrue: [
        self interruptWith: [
            JavaVM throwInterruptedException: 'thread has been interrupted during sleep'.
            self terminate
        ].
        ^self
    ].

    self isParked ifTrue:[
        self setInterrupted.
        JavaVM unpark: self.
        ^self.
    ].

    self setInterrupted

    "Created: / 30-11-2011 / 13:35:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-08-2012 / 22:14:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Process methodsFor:'Java protocol'!

setInterrupted

    JavaVM setInterrupted: self

    "Created: / 30-11-2011 / 10:44:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-08-2012 / 22:03:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'testing'!

isGroovy
    "true iff this is a Groovy language"

    ^ false

    "Created: / 13-04-2012 / 17:47:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProgrammingLanguage methodsFor:'testing'!

isJavaLike
    "true if receiver is kind of Java language (based on Java)"

    ^ false

    "Created: / 13-04-2012 / 17:48:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - compilation - java'!

additionalRules_java_clean_in_bc_dot_mak
    <file: 'bc.mak' target: 'java_clean' extends: 'clean'>

    self javaBundle isNil ifTrue:[ ^ nil ]. "/ No java target for packages without Java code...
^ '
java_clean:
        ant -f java\build.xml clean
'

    "Created: / 04-02-2015 / 07:35:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - compilation - java'!

additionalRules_java_clean_in_make_dot_proto
    <file: 'Make.proto' target: 'java_clean' extends: 'clean'>

    self javaBundle isNil ifTrue:[ ^ nil ]. "/ No java target for packages without Java code...
^ '
java_clean:
        ant -f java/build.xml clean
'

    "Created: / 04-02-2015 / 07:36:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - compilation - java'!

additionalRules_java_compile_in_bc_dot_mak
    <file: 'bc.mak' target: 'java_compile' extends: 'ALL'>

    self javaBundle isNil ifTrue:[ ^ nil ]. "/ No java target for packages without Java code...
^ '
java_compile:
        ant -f java\build.xml compile
'

    "Created: / 04-02-2015 / 07:33:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - compilation - java'!

additionalRules_java_compile_in_make_dot_proto
    <file: 'Make.proto' target: 'java_compile' extends: 'all'>

    self javaBundle isNil ifTrue:[ ^ nil ]. "/ No java target for packages without Java code...
^ '
java_compile:
        ant -f java/build.xml compile
'

    "Created: / 04-02-2015 / 07:36:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file mappings support-Java'!

generateJavaBuildPrereqs
    ^ self generateJavaBuildPrereqsUsingTemplate:

'    <target name="prereqs.%(PREREQ_PACKAGE_DOTTED)" extensionOf="prereqs.main">
        <ant antfile="${TOP}/../%(PREREQ_PACKAGE_SLASHED)/java/build.xml" 
             target="${ant.project.invoked-targets}"
             inheritAll="false"
             useNativeBasedir="true"/> 
    </target>
'

    "Created: / 18-01-2015 / 07:40:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2015 / 07:27:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file mappings support-Java'!

generateJavaBuildPrereqsClasspathPaths
    ^ self generateJavaBuildPrereqsUsingTemplate:

'    <path id="build.classpath.prereqs.%(PREREQ_PACKAGE_DOTTED)">
        <pathelement path="${TOP}/../%(PREREQ_PACKAGE_SLASHED)/java/bin"/>
        <fileset dir="${TOP}/../%(PREREQ_PACKAGE_SLASHED)/java/libs" includes="*.jar"/>  
    </path>
'

    "Created: / 18-01-2015 / 07:40:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2015 / 07:27:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file mappings support-Java'!

generateJavaBuildPrereqsClasspathRefs
    ^ self generateJavaBuildPrereqsUsingTemplate:

'       <path refid="build.classpath.prereqs.%(PREREQ_PACKAGE_DOTTED)"/>
'

    "Created: / 18-01-2015 / 07:40:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file mappings support-Java'!

generateJavaBuildPrereqsUsingTemplate: template
    | mappings |

    mappings := Dictionary new.
    mappings at: 'PACKAGE_SLASHED' put:  (self package copyReplaceAll: $: with: $/).
    mappings at: 'PACKAGE_DOTTED' put: ((self package copyReplaceAll: $: with: $/) replaceAll: $/ with: $.).

    ^ String streamContents:[ :s |
        ((self preRequisitesFor: self package) asArray sort) do:[:each |
            | def |

            def := ProjectDefinition definitionClassForPackage: each createIfAbsent: false.
            def javaBundle notNil ifTrue: [ 
                mappings at: 'PREREQ_PACKAGE_SLASHED' put:  (each copyReplaceAll: $: with: $/).
                mappings at: 'PREREQ_PACKAGE_DOTTED' put: ((each copyReplaceAll: $: with: $/) replaceAll: $/ with: $.).
                s nextPutAll: (template expandPlaceholdersWith: mappings)   
            ]
        ].
    ]

    "Created: / 18-01-2015 / 07:43:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2015 / 07:29:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file generation'!

generate_java_build_auto_dot_xml
    <file: 'java/build.auto.xml' overwrite: true>

    self javaBundle isNil ifTrue:[ ^ nil ].    
    ^self 
        replaceMappings: self java_build_auto_dot_xml_mappings
        in:              self java_build_auto_dot_xml

    "
    stx_libjava_tools generate_java_build_auto_dot_xml
    stx_libjava_experiments generate_java_build_auto_dot_xml

    "

    "Created: / 18-01-2015 / 07:32:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2015 / 16:55:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file generation'!

generate_java_build_dot_xml
    <file: 'java/build.xml' overwrite: false>

    self javaBundle isNil ifTrue:[ ^ nil ].
    ^self 
        replaceMappings: self java_build_dot_xml_mappings
        in:              self java_build_dot_xml

    "
    stx_libjava_tools generate_java_build_auto_dot_xml
    stx_libjava_experiments generate_java_build_auto_dot_xml

    "

    "Created: / 19-01-2015 / 07:37:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2015 / 16:32:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - java'!

javaBundle
    "Defines a Java code bundle provided by this package.
     Used by STX:LIBJAVA"

    ^nil

    "Created: / 15-01-2013 / 16:49:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'code generation'!

javaBundle_code
    "Returns the code of #javaBundle method.
     * If there's a #javaBundle method already exists, then
       return it's code (i.e., do not overwrite it).
     * If there's no such method and package contains java classes, then 
       return default code which can be later modified by user.
     * Otherwise, return nil."

    <method: #javaBundle category: #'description - java' overwrite: false>

    (self searchForClasses contains:[:class | class isJavaClass ]) ifTrue:[
        ^ 'javaBundle
    
    ^ JavaCodeBundle standardPackageBundleFor: self package'
    ] ifFalse:[ 
        ^ nil
    ].
! !

!ProjectDefinition class methodsFor:'description - java'!

javaClassPath
    | bundle |

    bundle := self javaBundle.
    ^ bundle notNil ifTrue:[ bundle classPath ] ifFalse: [ #() ]

    "Created: / 13-12-2011 / 23:48:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2015 / 11:11:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - java'!

javaSourcePath
    | bundle |

    bundle := self javaBundle.
    ^ bundle notNil ifTrue:[ bundle sourcePath ] ifFalse: [ #() ]

    "Created: / 13-12-2011 / 23:49:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-01-2015 / 11:11:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file templates'!

java_build_auto_dot_xml  
    "Template for java/build.auto.xml"
^ '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!!-- This file has been generated by STX:LIBJAVA. Do not edit!! Edit build.xml instead -->
<project>
    <property name="TOP" value="../%(TOP)" />
    <import file="${TOP}/libjava/java/build.common.xml"/>

    <path id="build.classpath.prereqs">
%(BUILD_PREREQS_CLASSPATH_REFS)
    </path>

%(BUILD_PREREQS_CLASSPATH_PATHS)

%(BUILD_PREREQS)

</project>
'

    "Created: / 18-01-2015 / 07:32:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2015 / 07:23:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file mappings'!

java_build_auto_dot_xml_mappings
    ^ self common_mappings
        at: 'TOP' put: (self pathToTopWithSeparator:'/');
        at: 'PACKAGE_SLASHED' put:  (self package copyReplaceAll: $: with: $/);
        at: 'PACKAGE_DOTTED' put: ((self package copyReplaceAll: $: with: $/) replaceAll: $/ with: $.);
        at: 'BUILD_PREREQS_CLASSPATH_REFS'  put: (self generateJavaBuildPrereqsClasspathRefs);
        at: 'BUILD_PREREQS_CLASSPATH_PATHS' put: (self generateJavaBuildPrereqsClasspathPaths);
        at: 'BUILD_PREREQS'                 put: (self generateJavaBuildPrereqs);
        yourself

    "Created: / 18-01-2015 / 07:32:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-01-2015 / 07:21:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file templates'!

java_build_dot_xml  
    "Template for java/build.xml"
^ '<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<project name="%(PACKAGE_DOTTED)" default="compile" basedir=".">
    <import file="build.auto.xml"/>
    <!!-- Put custom build code here, this file is never overwritten by Smalltalk/X -->    
</project>
'

    "Created: / 19-01-2015 / 07:35:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-02-2015 / 08:24:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'file mappings'!

java_build_dot_xml_mappings
    ^ self common_mappings
        at: 'TOP' put: (self pathToTopWithSeparator:'/');
        at: 'PACKAGE_SLASHED' put:  (self package copyReplaceAll: $: with: $/);
        at: 'PACKAGE_DOTTED' put: ((self package copyReplaceAll: $: with: $/) replaceAll: $/ with: $.);
        yourself

    "Created: / 19-01-2015 / 07:37:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ProjectDefinition class methodsFor:'description - actions - java'!

postLoadJavaHook
    "Package post-load hook for Jav packages. When a package
     is loaded from sources (as opposite for binary-compiled by
     stc), it also compiles all Java code (if any)."

    <postLoad>

    | javaDir |

    "/ Do nothing if package is binary-compiled.
    "/ The byteCode isNil test is a clumsy way to check whether the
    "/ package has been binary-compiled or not.
    (self class methodDictionary at:#classNamesAndAttributes) byteCode isNil ifTrue:[ ^ self ].

    "/ Do nothing if package has no Java code...
    self javaBundle isNil ifTrue:[ ^ self ].

    javaDir := self packageDirectory / 'java'.
    ((javaDir / 'build.xml') exists and:[ OperatingSystem canExecuteCommand: 'ant']) ifTrue:[ 
        | topDir antCmd |

        topDir := (Smalltalk getPackageDirectoryForPackage: #'stx:libbasic') directory.
        antCmd := 'ant -DTOP=', topDir pathName.
        (OperatingSystem executeCommand: antCmd inDirectory: javaDir pathName) ifFalse:[ 
            self error: 'Failed to compile Java classes'.
        ].
    ].

    "Created: / 15-06-2015 / 11:31:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Semaphore methodsFor:'waiting'!

parkWithTimeoutMs:milliSeconds
    "Same as #waitWithTimeoutMs: but sets the state to #parked."

    ^ self waitWithTimeoutMs:milliSeconds state: #parked
! !

!Set methodsFor:'javaProtocol'!

java__contains:anObject
         ^ self contains: [:el | anObject = el ]
! !

!ShortFloat class methodsFor:'queries'!

isJavaPrimitiveType

    ^true

    "Created: / 06-02-2011 / 17:21:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ShortFloat class methodsFor:'accessing'!

javaArrayClass
    ^ FloatArray

    "Created: / 11-02-2011 / 10:50:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ShortFloat class methodsFor:'autoboxing support'!

javaBox: anObject
    | wrapper |

    wrapper := (JavaVM classForName: 'java.lang.Float') new.
    wrapper perform: #'<init>(F)V' with: anObject.
    ^ wrapper

    "Created: / 16-08-2011 / 09:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ShortFloat class methodsFor:'accessing'!

javaName

    ^'float'.

    "Modified: / 25-02-2011 / 18:59:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ShortFloat class methodsFor:'autoboxing support'!

javaUnbox: object onError: errorBlock
    (object class binaryName = 'java/lang/Float') ifFalse:[
        errorBlock value.
    ].
    ^object instVarNamed: #value.

    "Created: / 22-11-2011 / 11:52:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:42:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ShortFloat class methodsFor:'accessing'!

javaWrapperClass
    ^(Java classForName: 'java.lang.Float')

    "Created: / 24-02-2012 / 19:42:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedIntegerArray methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^self basicSize

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedIntegerArray methodsFor:'vm support'!

_CHECKCAST: cls
    ^cls == SignedIntegerArray ifTrue:[self] ifFalse:[JavaVM throwClassCastException]

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:11:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedIntegerArray methodsFor:'vm support'!

_INSTANCEOF: cls
    ^SignedIntegerArray == cls ifTrue:[1] ifFalse:[0]

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:11:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedIntegerArray class methodsFor:'testing'!

isInterface

    ^false
! !

!SignedIntegerArray class methodsFor:'queries'!

isJavaArrayClass

    ^true

    "Created: / 06-02-2011 / 15:16:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedIntegerArray class methodsFor:'accessing-java'!

javaArrayClass

    ^JavaArray javaArrayClassFor: SignedIntegerArray

    "Created: / 11-06-2011 / 23:42:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-08-2011 / 22:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedIntegerArray class methodsFor:'accessing'!

javaComponentClass

    ^ Integer

    "Created: / 25-06-2011 / 08:38:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedIntegerArray class methodsFor:'accessing'!

javaName

    ^'[I'.

    "Modified: / 25-02-2011 / 19:03:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedLongIntegerArray methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^self basicSize

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedLongIntegerArray methodsFor:'vm support'!

_CHECKCAST: cls
    ^cls == SignedLongIntegerArray ifTrue:[self] ifFalse:[JavaVM throwClassCastException]

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:14:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedLongIntegerArray methodsFor:'vm support'!

_INSTANCEOF: cls
    ^SignedLongIntegerArray == cls ifTrue:[1] ifFalse:[0]

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:14:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedLongIntegerArray class methodsFor:'testing'!

isInterface

    ^false
! !

!SignedLongIntegerArray class methodsFor:'queries'!

isJavaArrayClass

    ^true

    "Created: / 20-12-2010 / 22:47:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedLongIntegerArray class methodsFor:'queries'!

isJavaReferenceType

    "Java arrays are reference types"
    ^true

    "Created: / 20-12-2010 / 22:30:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedLongIntegerArray class methodsFor:'accessing-java'!

javaArrayClass

    ^JavaArray javaArrayClassFor: SignedLongIntegerArray

    "Modified: / 10-08-2011 / 22:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 26-08-2011 / 18:29:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedLongIntegerArray class methodsFor:'accessing'!

javaComponentClass

    ^LargeInteger

    "Modified: / 25-06-2011 / 08:38:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedLongIntegerArray class methodsFor:'accessing'!

javaName

    ^'[J'.

    "Modified: / 25-02-2011 / 19:03:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedWordArray methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^self basicSize

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedWordArray methodsFor:'vm support'!

_CHECKCAST: cls
    ^cls == SignedWordArray ifTrue:[self] ifFalse:[JavaVM throwClassCastException]

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:14:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedWordArray methodsFor:'vm support'!

_INSTANCEOF: cls
    ^SignedWordArray == cls ifTrue:[1] ifFalse:[0]

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:14:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedWordArray class methodsFor:'queries'!

isJavaArrayClass

    ^true

    "Created: / 20-12-2010 / 22:47:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedWordArray class methodsFor:'queries'!

isJavaReferenceType

    "Java arrays are reference types"
    ^true

    "Created: / 20-12-2010 / 22:30:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedWordArray class methodsFor:'accessing'!

javaComponentClass

    ^JavaShort

    "Modified: / 24-02-2012 / 17:46:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SignedWordArray class methodsFor:'accessing'!

javaName

    ^'[S'.

    "Modified: / 24-02-2012 / 17:46:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SmallInteger methodsFor:'autoboxing'!

javaUnwrapFrom: javaType
    javaType = #boolean ifTrue: [
        ^ self = 1
    ].
    ^ self

    "Created: / 30-12-2011 / 15:22:52 / kursjan <kursjan@fit.cvut.cz>"
! !

!Socket methodsFor:'testing'!

isSocket
    ^true

    "Created: / 17-08-2012 / 15:32:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Socket methodsFor:'special'!

reOpenIfPossible
    "If the socket was listening (server-sockets), try to reopen it"

    listening ifFalse:[ ^ self ].
    [
        self domain:domain type:socketType protocol:protocol reuseAddress:true.
        self bindTo:port address:nil.
        self listenFor: 5
    ] on: OpenError do:[
        "Nothing, socket could not be reopened"
    ].

    "Created: / 17-08-2012 / 15:43:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!String methodsFor:'converting'!

asArrayOfSubstringsSeparatedBy:aSeparator
    "Modified version of asArrayOfSubstrings"

    |substrings start end|

    substrings := OrderedCollection new.
    start := 1.
    [start <= self size] whileTrue:[
	(self at:start) = aSeparator ifFalse:[
	    end := start + 1.
	    [
		end <= self size and:[(self at:end) ~= aSeparator]
	    ] whileTrue:[end := end + 1].
	    substrings add:(self copyFrom:start to:end - 1).
	    start := end - 1
	].
	start := start + 1
    ].
    ^ substrings asArray

    "Created: / 07-02-2011 / 11:18:03 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-02-2011 / 01:08:15 / Marcel Hlopko <hlopik@gmail.com>"
! !

!String class methodsFor:'accessing'!

javaName
    ^ '[C'

    "Created: / 18-01-2013 / 22:27:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UndefinedObject methodsFor:'vm support'!

_ARRAYLENGTH: cls
    ^JavaVM throwNullPointerException

    "Created: / 14-05-2013 / 10:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UndefinedObject methodsFor:'vm support'!

_CHECKCAST: cls
    ^nil

    "Created: / 14-05-2013 / 10:09:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:10:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UndefinedObject methodsFor:'vm support'!

_INSTANCEOF: cls
    ^0

    "Created: / 14-05-2013 / 10:09:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-05-2013 / 11:10:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UndefinedObject class methodsFor:'queries'!

isJavaPrimitiveType

    "void"

    ^true

    "Created: / 21-12-2010 / 22:52:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UndefinedObject class methodsFor:'accessing'!

javaName

    ^'void'.

    "Modified: / 25-02-2011 / 18:59:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Unicode16String class methodsFor:'accessing'!

javaName
    ^ '[C'

    "Created: / 18-01-2013 / 22:27:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing - java'!

javaHome
    "Return path to JAVA_HOME as configured by user. If nil is returned
     from here, `JavaRelease default` is used."

    ^ self at: #javaHome

    "Created: / 13-04-2016 / 20:49:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing - java'!

javaHome: aStringOrNil
    "Set path to JAVA_HOME. `nil` value means to use `JavaRelease default`"

    self at: #javaHome put: aStringOrNil

    "Created: / 13-04-2016 / 20:50:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WordArray class methodsFor:'testing'!

isInterface

    ^false
! !

!WordArray class methodsFor:'queries'!

isJavaArrayClass

    ^true

    "Created: / 20-12-2010 / 22:47:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WordArray class methodsFor:'queries'!

isJavaReferenceType

    "Java arrays are reference types"
    ^true

    "Created: / 20-12-2010 / 22:30:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WordArray class methodsFor:'accessing-java'!

javaArrayClass

    ^JavaArray javaArrayClassFor: WordArray

    "Created: / 11-06-2011 / 23:42:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-08-2011 / 22:46:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WordArray class methodsFor:'accessing-java'!

javaComponentClass

    ^JavaShort

    "Created: / 20-12-2010 / 22:13:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WordArray class methodsFor:'accessing'!

javaName
    ^ '[S'.

    "Modified: / 06-12-2011 / 16:43:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!WrappedMethod methodsFor:'accessing'!

descriptor
    "Returns descriptor object (for wrapped Java methods)"

    | orig |
    orig := self originalMethod.
    ^(orig respondsTo: #descriptor) ifTrue:[
        orig descriptor
    ] ifFalse:[
        self doesNotUnderstand: (Message selector: #descriptor)
    ]

    "Created: / 16-12-2011 / 20:03:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!WrappedMethod methodsFor:'queries'!

isAbstract

    ^self originalMethod isAbstract.

    "Created: / 04-12-2011 / 11:24:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ZipArchive methodsFor:'queries - java support'!

isValidFile: path
    "Return true, if the recevier contains given file. false otherwise.
    "
    ^zipMembersByName includesKey: path

    "Created: / 20-05-2013 / 23:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"

! !

!ZipArchive methodsFor:'reading - java support'!

nextBytes: bytesToRead of: zmember startingAt: pos into: b startingAt: off

    file position: (self dataStartOf: zmember) + startOfArchive + pos.
    ^ file nextBytes: bytesToRead into: b startingAt: off.

    "Created: / 01-05-2011 / 16:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-12-2012 / 05:41:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libjava class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !

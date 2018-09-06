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

CompiledCode variableSubclass:#JavaMethod
	instanceVariableNames:'accessFlags selector javaClass descriptor signature lookupObject
		lineNumberTable localVariableTable source annotations'
	classVariableNames:'SignatureTypeCodes ForceByteCodeDisplay ShowFullSource
		UnresolvedClassSignal A_PUBLIC A_PRIVATE A_PROTECTED A_STATIC
		A_FINAL A_SYNCHRONIZED A_ABSTRACT A_NATIVE A_BREAKPOINT
		A_HASHANDLER A_BRIDGE A_VARARGS A_STRICT A_SYNTHETIC A_RESOLVED
		A_HASFINALLY'
	poolDictionaries:'JavaConstants'
	category:'Languages-Java-Classes'
!

!JavaMethod class methodsFor:'documentation'!

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

!JavaMethod class methodsFor:'initialization'!

initialize
    UnresolvedClassSignal isNil ifTrue:[
        UnresolvedClassSignal := ExecutionError newSignalMayProceed:true.
        UnresolvedClassSignal nameClass:self message:#unresolvedClassSignal.
        UnresolvedClassSignal notifierString:'unresolved class'.
    ].

    ShowFullSource := true.
    ForceByteCodeDisplay := false.

    A_PUBLIC       := 16r0001.
    A_PRIVATE      := 16r0002.
    A_PROTECTED    := 16r0004.
    A_STATIC       := 16r0008.
    A_FINAL        := 16r0010.
    A_SYNCHRONIZED := 16r0020.
    A_BRIDGE       := 16r0040.
    A_VARARGS      := 16r0080.
    A_NATIVE       := 16r0100.
    A_ABSTRACT     := 16r0400.
    A_STRICT       := 16r0800.
    A_SYNTHETIC    := 16r1000.

    A_BREAKPOINT   := 16r10000000.
    A_HASHANDLER   := 16r20000000.
    A_HASFINALLY   := 16r00004000.
    A_RESOLVED     := 16r00000200.

    self flags:(self flags bitOr:Behavior flagJavaMethod).

    SignatureTypeCodes := IdentityDictionary new.
    SignatureTypeCodes at:$B put:#byte.
    SignatureTypeCodes at:$C put:#char.
    SignatureTypeCodes at:$D put:#double.
    SignatureTypeCodes at:$F put:#float.
    SignatureTypeCodes at:$I put:#int.
    SignatureTypeCodes at:$J put:#long.
    SignatureTypeCodes at:$S put:#'unsigned short'.
    SignatureTypeCodes at:$Z put:#boolean.
    SignatureTypeCodes at:$L put:#object.
    SignatureTypeCodes at:$[ put:#array.
    SignatureTypeCodes at:$T put:#typevar.

    ForceByteCodeDisplay := false.

    "
     JavaMethod initialize.
     JavaMethodWithHandler initialize.
     ForceByteCodeDisplay := true.
     ForceByteCodeDisplay := false.
    "

    "Modified: / 16-10-1998 / 01:29:48 / cg"
    "Modified: / 29-03-2016 / 21:05:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reinitialize

    self flags:(self flags bitOr:Behavior flagJavaMethod).

    "Created: / 14-12-2010 / 20:58:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod class methodsFor:'instance creation'!

fromMethod:aJavaMethod
    "create a new javaMethod, copying values from another javaMethod"

    ^ self new fromMethod:aJavaMethod

    "Created: / 16.10.1998 / 01:25:12 / cg"
!

new
    "create a new javaMethod.
     Redefined, since constants are NOT stored in a literalArray,
     but my classes constantTable instead."

    ^ self basicNew:0.

    "Created: / 16.10.1998 / 01:13:02 / cg"
! !

!JavaMethod class methodsFor:'Signal constants'!

unresolvedClassSignal
    "return the signal raised when an unresolved class is referenced"

    ^ UnresolvedClassSignal

    "Created: / 27.1.1998 / 21:50:05 / cg"
! !

!JavaMethod class methodsFor:'accessing'!

showFullSource
    ^ ShowFullSource

    "Created: / 14-09-2013 / 11:56:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod class methodsFor:'misc'!

forceByteCodeDisplay
    ^ ForceByteCodeDisplay

    "Created: 7.4.1997 / 20:11:39 / cg"
!

forceByteCodeDisplay:aBoolean
    ForceByteCodeDisplay := aBoolean

    "
     self forceByteCodeDisplay:true
     self forceByteCodeDisplay:false
    "

    "Created: / 4.2.1998 / 00:22:54 / cg"
!

makeJavaMethod

    self flags:((self flags
                 bitOr:Behavior flagJavaMethod)
                 bitClear:Behavior flagMetaMethod)

    "
        JavaMethod makeJavaMethod
        JavaMethod makeMetaMethod
    "

    "Created: / 23-02-2011 / 12:56:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

makeMetaMethod

    self flags:((self flags
                 bitOr:Behavior flagMetaMethod)
                 bitClear:Behavior flagJavaMethod)
     "
        JavaMethod makeJavaMethod
        JavaMethod makeMetaMethod
    "

    "Created: / 23-02-2011 / 12:56:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaMethod class methodsFor:'signature parsing'!

argSigArrayFromSignature:aSignature
    "given a signature, return a specArray for the arguments"

    |s|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt].

    ^ self argSigArrayFromStream:s.

    "
     JavaMethod argSigArrayFromSignature:'(LObject;)V'
     JavaMethod argSigArrayFromSignature:'(BB)S'
     JavaMethod argSigArrayFromSignature:'(LObject;LObject;II)V'
    "
!

argSigArrayFromStream:s
    "parse an argSpec, return an array of specs - see java doc"

    |argSpec spec|

    spec := #().
    [s atEnd or:[s peek == $)]] whileFalse:[
"/        s peek == Character space ifTrue:[
"/            s next
"/        ] ifFalse:[
            argSpec := self fieldTypeFromStream:s in:nil.
            spec := spec copyWith:argSpec.
"/        ]
    ].
    ^ spec

    "Modified: / 8.1.1998 / 19:10:20 / cg"
!

argSignatureFromArgTypeArray:arr
    | sig |

    sig := ''.
    arr do:
            [:el |
            | jCLass |

            jCLass := el.
            jCLass isJavaClass
                ifFalse:[ jCLass := JavaVM reflection classForJavaClassObject:el ].
            jCLass isJavaClass
                ifTrue:
                    [ sig := sig , jCLass typeName.
                    ]
                ifFalse:[ self halt. ] ].
    ^ sig

    "
     self argSignatureFromArgTypeArray:
 (Array
     with:(JavaVM javaClassObjectForClass:(Java at:'com.sun.java.swing.JComponent')))"

    "Modified: / 13-02-1998 / 14:57:58 / cg"
    "Modified: / 02-03-2011 / 22:49:24 / Marcel Hlopko <hlopik@gmail.com>"
!

argSpecFromSignature:aSignature withName:name
    "given a signature, return a spec"

    |s argSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecFromStream:s in:nil.

    s next ~~ $) ifTrue:[self halt. ^ name].

    ^ name , ' (' , argSpec , ')'

    "
     JavaMethod argSpecFromSignature:'(LObject;)V' withName:'foo'
     JavaMethod argSpecFromSignature:'(BB)S'       withName:'foo'
    "

    "Modified: / 8.1.1998 / 19:05:36 / cg"
!

argSpecFromStream:s in:aPackage
    "parse an argSpec - see java doc"

    |argSpec spec|

    spec := ''.
    [s atEnd or:[s peek == $)]] whileFalse:[
"/        s peek == Character space ifTrue:[
"/            s next
"/        ] ifFalse:[
            argSpec := self fieldTypeFromStream:s in:aPackage.
            spec size ~~ 0 ifTrue:[
                spec := spec , ', '
            ].
            spec := spec , argSpec.
"/        ]
    ].
    ^ spec

    "Created: / 18-03-1997 / 11:06:44 / cg"
    "Modified: / 04-10-2013 / 12:45:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

argSpecWithArgsFromStream:s in:aPackage
    "parse an argSpec - see java doc"

    ^ self argSpecWithArgsFromStream:s in:aPackage argNames:nil

    "Modified: / 8.1.1998 / 19:21:00 / cg"
!

argSpecWithArgsFromStream:s in:aPackage argNames:argNames
    "parse an argSpec - see java doc"

    |argSpec spec argNr nm|

    argNr := 1.
    spec := ''.
    [s atEnd or:[s peek == $)]] whileFalse:[
        argSpec := self fieldTypeFromStream:s in:aPackage.

        (argNames notNil
        and:[argNames size >= argNr
        and:[(nm := argNames at:argNr) notNil]]) ifFalse:[
            nm := 'arg' , argNr printString.
        ].
        argSpec := argSpec , ' ' , nm.

        spec size ~~ 0 ifTrue:[
            spec := spec , ', '
        ].
        spec := spec , argSpec.

        argNr := argNr + 1.
    ].
    ^ spec

    "Created: / 8.1.1998 / 19:20:36 / cg"
    "Modified: / 8.1.1998 / 21:14:33 / cg"
!

fieldTypeFromStream:s in:aPackage
    "parse a fieldTypeSpec - see java doc"

    |typeChar typeSym elType size className nm out nangles |

    typeChar := s next.

    typeSym := SignatureTypeCodes at:typeChar ifAbsent:#unknown.

    typeSym == #unknown ifTrue:[
        ^ typeSym
    ].
    (typeSym == #object or: [typeSym == #typevar]) ifTrue:[
        "Take care about type variables"
        out := String new writeStream.
        [ s peek ~~ $; and:[ s peek ~~ $< ] ] whileTrue:[
            out nextPut: s next.
        ].
        className := out contents.
        "Eat possible type variables"
        (s peek == $<) ifTrue:[
            nangles := 1. s next.
            [  nangles ~~ 0 ] whileTrue:[
                s peek == $< ifTrue:[nangles := nangles + 1].
                s peek == $> ifTrue:[nangles := nangles - 1].
                s next.
            ]
        ].
        s peek ~~ $; ifTrue:[self error: 'Signature corrupted?'].
        s next. "/eat ;


        typeSym == #typevar ifTrue:[^className].
        "/ strip off default
        nm := className.
"/        aPackage notNil ifTrue:[
"/            (nm startsWith:aPackage) ifTrue:[
"/                nm := nm copyFrom:(aPackage size + 2).
"/            ].
"/        ].
        "/ Show only local name, otherwise names are way too long...
        nm := nm copyFrom: (nm lastIndexOf: $/) + 1.

"/        nm := nm copyReplaceAll:$/ with:$..
        ^ nm
    ].

    typeSym == #array ifTrue:[
        s peek isDigit ifTrue:[
            size := Integer readFrom:s.
            elType := self fieldTypeFromStream:s in:aPackage.
            ^ elType , '[' , size printString , ']'
        ].
        elType := self fieldTypeFromStream:s in:aPackage.
        ^ elType , '[]'
    ].

    ^ typeSym

    "Created: / 18-03-1997 / 11:07:56 / cg"
    "Modified: / 18-07-1998 / 22:57:06 / cg"
    "Modified: / 04-10-2013 / 12:42:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numArgsFromDescriptor:descriptor 
    "Given a method descriptor, return the number physical of args (number of arg slots)"

    | i c numArgs |

    "/ The following code is king of ugly, but it is optimized for speed as
    "/ profiling shown that some 10% time was spent in descriptor parsing.
    "/ Fillowing code is written upon assumption we get a proper method
    "/ descriptor (i.e., descriptor, not signature with type parameters).

    numArgs := 0.
    i := descriptor indexOf: $(.
    i ~~ 0 ifTrue:[ 
        i := i + 1.
        [ (c := descriptor at: i) ~~ $) ] whileTrue:[
            c == $D ifTrue:[ 
                numArgs := numArgs + 2.
            ] ifFalse:[ 
                c == $J ifTrue:[ 
                    numArgs := numArgs + 2.
                ] ifFalse:[ 
                    numArgs := numArgs + 1.
                    c == $[ ifTrue:[ 
                        i := i + 1.
                        [ (c := descriptor at: i) == $[ ] whileTrue:[ i := i + 1 ].
                    ].
                    c == $L ifTrue:[ 
                        i := descriptor indexOf: $; startingAt: i + 1.
                        i == 0 ifTrue:[ 
                            self error: 'Invalid descriptor'
                        ].
                    ].
                ].
            ].
            i := i + 1.
        ].
        ^ numArgs
    ].
    self error: 'Invalid descriptor'


    "
     JavaMethod numArgsFromDescriptor:'(LObject;)V'
     JavaMethod numArgsFromDescriptor:'(BB)S'
     JavaMethod numArgsFromDescriptor:'()V'  
     JavaMethod numArgsFromDescriptor:'(Ljava/util/ArrayList<*>;)V'
     JavaMethod numArgsFromDescriptor:'(LObject;J)V'
     JavaMethod numArgsFromDescriptor:'([[LObject;J)V'
     JavaMethod numArgsFromDescriptor:'([[J)V'
    "

    "/ Original (slow) code:
"/    | s |
"/
"/    s := descriptor readStream.
"/    (descriptor includes:$() ifFalse:[
"/        self error:'Invalid signature'
"/    ].
"/    [ s next ~~ $( ] whileTrue.
"/    ^ self numArgsFromStream:s.

    "Modified: / 04-08-2014 / 16:39:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numArgsFromStream:s
    "parse an argSpec - see java doc"

    |n t|

    n := 0.
    [s atEnd or:[s peek == $)]] whileFalse:[
        t := self fieldTypeFromStream:s in:nil.
        "/
        "/ some args count as 2
        "/
        t == #long ifTrue:[
            n := n + 2.
        ] ifFalse:[
            t == #double ifTrue:[
                n := n + 2
            ] ifFalse:[
                n := n + 1.
            ]
        ]
    ].
    ^ n

    "Modified: / 8.1.1998 / 19:10:25 / cg"
!

retValSpecFromSignature:aSignature in:aPackage
    "given a signature, return a spec"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt].

    argSpec := self argSpecFromStream:s in:aPackage.

    s next ~~ $) ifTrue:[self halt].

    retvalSpec := self retvalSpecFromStream:s in:aPackage.

    ^ retvalSpec

    "
     JavaMethod retValSpecFromSignature:'(LObject;)V'
     JavaMethod retValSpecFromSignature:'(BB)S'
    "

    "Created: 18.3.1997 / 11:11:50 / cg"
!

returnTypeFromSignature:aSignature in:aPackage
    "given a signature, return its type as a string"

    |s c|

    s := aSignature readStream.
    (c := s peek) ~~ $( ifTrue:[
        c == $' ifTrue:[
           [s peek ~= $'] whileTrue:[s next].
           s next.
           ^ (self retvalSpecFromStream:s in:aPackage)
        ].
        ^ (self retvalSpecFromStream:s in:aPackage)
    ].

    s next.
    self argSpecFromStream:s in:aPackage.
    s next ~~ $) ifTrue:[self halt. ^ nil].

    ^ (self retvalSpecFromStream:s in:aPackage)

    "
     JavaMethod returnTypeFromSignature:'(LObject;)V'
     JavaMethod returnTypeFromSignature:'(BB)S'
     JavaMethod returnTypeFromSignature:'()J'
     JavaMethod returnTypeFromSignature:'''first''J'
    "

    "Created: / 1.8.1997 / 10:54:31 / cg"
    "Modified: / 8.1.1998 / 19:09:06 / cg"
!

returnsVoidFromSignature:aSignature
    "given a signature, return true if it returns void, false if not"

    ^ (self typeFromSignature:aSignature in:nil) = 'void'

    "
     JavaMethod returnsVoidFromSignature:'(LObject;)V'
     JavaMethod returnsVoidFromSignature:'(BB)S'
    "

    "Modified: / 8.1.1998 / 19:13:53 / cg"
!

retvalSpecFromStream:s in:aPackage
    "parse a retvalSpec - see java doc"

    |spec|

    s atEnd ifTrue:[self halt. ^ #void].
    s peek == $V ifTrue:[^ #void].
    spec := self fieldTypeFromStream:s in:aPackage.
    spec knownAsSymbol ifTrue:[
        ^ spec asSymbol
    ].
    ^ spec

    "Created: / 18.3.1997 / 11:12:19 / cg"
    "Modified: / 7.4.1998 / 22:28:27 / cg"
!

specComponentsWithArgsFromSignature:aSignature withName:name in:aPackage
    "given a signature, return a spec"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecWithArgsFromStream:s in:aPackage.

    s next ~~ $) ifTrue:[self halt. ^ name].

    retvalSpec := self retvalSpecFromStream:s in:aPackage.

    ^ Array with:retvalSpec with:name with:argSpec

    "
     JavaMethod specWithArgsFromSignature:'(LObject;)V' withName:'foo' in:nil
     JavaMethod specComponentsWithArgsFromSignature:'(LObject;)V' withName:'foo' in:nil
    "

    "Created: 18.3.1997 / 11:06:22 / cg"
    "Modified: 1.8.1997 / 11:03:50 / cg"
!

specFromSignature:aSignature withName:name argNames:argNames in:aPackage
    "given a signature, return a spec"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecWithArgsFromStream:s in:aPackage argNames:argNames.

    s next ~~ $) ifTrue:[self halt. ^ name].

    retvalSpec := self retvalSpecFromStream:s in:aPackage.

    ^ retvalSpec , ' ' , name , ' (' , argSpec , ')'

    "
     JavaMethod specFromSignature:'(LObject;)V' withName:'foo' argNames:#('a') in:nil
     JavaMethod specFromSignature:'(BB)S'       withName:'foo' argNames:#('a' 'b') in:nil
    "

    "Created: / 18.3.1997 / 11:06:22 / cg"
    "Modified: / 8.1.1998 / 21:14:43 / cg"
!

specFromSignature:aSignature withName:name in:aPackage
    "given a signature, return a spec"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecFromStream:s in:aPackage.

    s next ~~ $) ifTrue:[self halt. ^ name].

    retvalSpec := self retvalSpecFromStream:s in:aPackage.

    ^ retvalSpec , ' ' , name , ' (' , argSpec , ')'

    "
     JavaMethod specFromSignature:'(LObject;)V' withName:'foo' in:nil
     JavaMethod specFromSignature:'(BB)S'       withName:'foo' in:nil
    "

    "Created: / 18.3.1997 / 11:06:22 / cg"
    "Modified: / 8.1.1998 / 21:06:32 / cg"
!

specTextFromSignature:aSignature in:aPackage withName:name isConstructor: isCtor
    "given a signature, return a spec as boldified text"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecFromStream:s in:aPackage.

    s next ~~ $) ifTrue:[self halt. ^ name].

    ^ isCtor ifTrue:[
        name , ' (' , argSpec , ')'
    ] ifFalse:[
        retvalSpec := self retvalSpecFromStream:s in:aPackage.
        name , ' (' , argSpec , ') : ' , retvalSpec
    ]

"/    ^


    "
     JavaMethod specTextFromSignature:'(LObject;)V' withName:'foo'
     JavaMethod specTextFromSignature:'(BB)S'       withName:'foo'
    "

    "Created: / 04-10-2013 / 12:36:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

specTextFromSignature:aSignature withName:name
    "given a signature, return a spec as boldified text"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecFromStream:s in:nil.

    s next ~~ $) ifTrue:[self halt. ^ name].

    retvalSpec := self retvalSpecFromStream:s in:nil.

    ^ retvalSpec , ' ' , (name allBold) , ' (' , argSpec , ')'

    "
     JavaMethod specTextFromSignature:'(LObject;)V' withName:'foo'
     JavaMethod specTextFromSignature:'(BB)S'       withName:'foo'
    "

    "Modified: / 8.1.1998 / 19:11:20 / cg"
!

specTextWithArgsFromSignature:aSignature withName:name in:aPackage
    "given a signature, return a spec"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecWithArgsFromStream:s in:aPackage.

    s next ~~ $) ifTrue:[self halt. ^ name].

    retvalSpec := self retvalSpecFromStream:s in:aPackage.

    ^ retvalSpec , ' ' , (name allBold) , ' (' , argSpec , ')'

    "
     JavaMethod specWithArgsFromSignature:'(LObject;)V' withName:'foo' in:nil
     JavaMethod specWithArgsFromSignature:'(BB)S'       withName:'foo' in:nil
    "

    "Modified: 20.3.1997 / 12:50:10 / cg"
    "Created: 1.8.1997 / 10:43:57 / cg"
!

specWithArgsFromSignature:aSignature withName:name in:aPackage
    "given a signature, return a spec"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecWithArgsFromStream:s in:aPackage.

    s next ~~ $) ifTrue:[self halt. ^ name].

    retvalSpec := self retvalSpecFromStream:s in:aPackage.

    ^ retvalSpec , ' ' , name , ' (' , argSpec , ')'

    "
     JavaMethod specWithArgsFromSignature:'(LObject;)V' withName:'foo' in:nil
     JavaMethod specWithArgsFromSignature:'(BB)S'       withName:'foo' in:nil
    "

    "Created: 18.3.1997 / 11:06:22 / cg"
    "Modified: 20.3.1997 / 12:50:10 / cg"
!

specWithArgsFromSignature:aSignature withName:name in:aPackage isConstructor: isCtor
    "given a signature, return a spec"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecWithArgsFromStream:s in:aPackage.

    s next ~~ $) ifTrue:[self halt. ^ name].

    retvalSpec := self retvalSpecFromStream:s in:aPackage.

    ^ retvalSpec , ' ' , name , ' (' , argSpec , ')'

    "
     JavaMethod specWithArgsFromSignature:'(LObject;)V' withName:'foo' in:nil
     JavaMethod specWithArgsFromSignature:'(BB)S'       withName:'foo' in:nil
    "

    "Created: / 04-10-2013 / 12:33:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typeFromSignature:aSignature in:package
    "given a signature, return its type as a string"

    |s c|

    s := aSignature readStream.
    (c := s peek) ~~ $( ifTrue:[
        c == $' ifTrue:[
           s next.
           [s peek ~= $'] whileTrue:[s next].
           s next.
           ^ (self retvalSpecFromStream:s in:package)
        ].
        ^ (self retvalSpecFromStream:s in:package)
    ].

    s next.
    self argSpecFromStream:s in:nil.
    s next ~~ $) ifTrue:[self halt. ^ nil].

    ^ (self retvalSpecFromStream:s in:package)

    "
     JavaMethod typeFromSignature:'(LObject;)Ljava/lang/Object'
     JavaMethod typeFromSignature:'(LObject;)Ljava/lang/Object' in:'java.lang'
    "

    "Created: / 1.8.1997 / 10:50:38 / cg"
    "Modified: / 8.1.1998 / 19:09:31 / cg"
! !

!JavaMethod methodsFor:'* As yet uncategorized *'!

annotationIndexOf:aSymbol

    ^nil

    "Created: / 24-02-2012 / 16:06:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'* uncategorized *'!

annotationAt:aSymbol    
    ^ nil "/ There are no annotation is Smalltalk sense...

    "Created: / 17-08-2014 / 08:34:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'accessing'!

accessFlags
    "java calls this the modifiers"

    ^ accessFlags

    "Created: / 9.4.1998 / 17:49:44 / cg"
!

analyzer
    "Returns an analyzer for the method which can be used
     to query some statistics like sent messages or modified classvars"

    ^ JavaMethodAnalyzer analyze: self.

    "Created: / 30-08-2013 / 13:47:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotations
    annotations isNil ifTrue:[
        ^ JavaMethodAnnotationContainer empty
    ].
    ^ annotations

    "Modified: / 04-08-2014 / 16:01:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotations:something
    annotations := something.
!

argSignature
    ^ self class argSigArrayFromSignature:descriptor
!

asByteCodeMethod

    "JavaMethods are always bytecode methods"

    ^self

    "Created: / 18-07-2011 / 20:48:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

comment
    "should access the source here, and parse any method comment"

    ^ nil
!

constantPool
    ^ javaClass constantPool

    "Modified: 16.4.1996 / 12:36:27 / cg"
    "Created: 16.4.1996 / 15:28:50 / cg"
!

containingClass
    ^ javaClass

!

decompiledBytecode
    |s|

    s := '' writeStream.
    JavaDecompiler decompile:self to:s.
    ^ s contents

    "Created: 7.4.1997 / 20:10:37 / cg"
!

decompiledSource
    |s|

    s := '' writeStream.
    self decompileSourceTo:s.
    ^ s contents

    "Modified: 30.7.1997 / 16:27:55 / cg"
!

descriptor

    ^ (JavaDescriptor fromString: descriptor) name: self name

    "Created: / 16-04-1996 / 11:34:29 / cg"
    "Modified: / 06-12-2011 / 21:53:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

descriptorSymbol

    ^descriptor

    "Created: / 16-04-1996 / 11:34:29 / cg"
    "Created: / 06-12-2011 / 23:00:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ensureHasAnnotations
    annotations isNil ifTrue:[
        annotations := JavaMethodAnnotationContainer for:self
    ].
    ^ annotations

    "Created: / 25-02-2011 / 16:02:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-02-2011 / 16:33:00 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 04-08-2014 / 15:55:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exceptionClasses
    "Return a collection of declared exception classes that this method
     throws"
    ^#()

    "Created: / 01-08-2012 / 10:06:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

exceptionHandlerTable
    ^ nil

    "Created: / 16.10.1998 / 01:50:51 / cg"
!

exceptionTable
    ^ nil

    "Created: / 16.10.1998 / 01:51:04 / cg"
!

firstInstructionLineNumber
    ForceByteCodeDisplay == true ifTrue:[ ^ 1].
    lineNumberTable notNil ifTrue:[ ^ lineNumberTable at:2].
    ^ 0.

    "Created: / 17-12-2010 / 17:02:46 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 08-01-2011 / 16:30:16 / Jan Kurs <kurs.jan@post.cz>"
!

getExceptionTable

    ^ nil

    "Created: / 04-02-2011 / 23:07:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getMclass
    ^javaClass

    "Created: / 15-04-2013 / 17:57:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getSource
    ^ source

    "Created: / 13-09-2013 / 01:41:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getSourcePosition
    ^ 1
!

hasLineNumberInformation
    ^ lineNumberTable notNil

    "Created: 16.4.1996 / 12:34:04 / cg"
    "Modified: 16.4.1996 / 12:49:06 / cg"
!

javaByteCode
"/    ^ javaByteCode
    ^ byteCode

    "Created: 16.4.1996 / 14:55:44 / cg"
    "Modified: 1.8.1997 / 00:08:45 / cg"
!

javaClass
    ^ javaClass

    "Modified: 16.4.1996 / 12:36:27 / cg"
    "Created: 16.4.1996 / 14:55:44 / cg"
!

javaExceptionTable
    <resource: #obsolete>

    self obsoleteMethodWarning: 'Use #exceptionClasses  instead'.
    ^ self exceptionClasses

    "Created: / 04-06-2011 / 18:16:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 01-08-2012 / 10:08:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaNumArgs
    ^ self argSignature size.

    "Created: / 14-03-2011 / 15:50:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 02-03-2016 / 00:20:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNumber
    ^ self sourceLineNumber.

    "Created: / 16-04-1996 / 12:34:04 / cg"
    "Modified: / 23-10-2013 / 10:48:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNumberTable
"/    lineNumberTable ifNil:[ lineNumberTable := Dictionary new.].
    ^ lineNumberTable

    "Created: / 16-04-1996 / 12:34:04 / cg"
    "Modified: / 13-12-2010 / 11:06:40 / Jan Kurs <kurs.jan@post.cz>"
!

literalAt:index ifAbsent:exceptionalValue
    "return a literal element"

    "/ JVM does not use per-method literal frame like Smalltalk.
    "/ Therefore, #literalAt:ifAbsent: has now meaning and is not supported
    self shouldNotImplement

    "Created: / 29-07-2016 / 09:48:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

literalAt:index put:newValue
    "change a literal slots value.
     WARNING: dangerous internal interface; only for knowledgable users"

    "/ JVM does not use per-method literal frame like Smalltalk.
    "/ Therefore, #literalAt:put: has now meaning and is not supported
    self shouldNotImplement

    "Created: / 29-07-2016 / 09:46:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

literals
    "return the literals as an array"

    ^ Array streamContents: [ :s | self literalsDo:[:e | s nextPut: e] ]

    "Created: / 29-07-2016 / 09:46:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

literalsDo:aBlock
    "execute a one arg block for each of our literals"

    self analyzer literalsDo: aBlock

    "Created: / 29-07-2016 / 09:41:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

localVariableTable
    ^ localVariableTable

    "
     JavaMethod allInstancesDo:[:m| m localVariableTable notNil ifTrue:[self halt]]
    "
!

mclass
    ^ self javaClass
!

mclass: anObject

    javaClass := anObject

    "Created: / 18-10-2010 / 19:01:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodArgAndVarNames
    ^ "((1 to:self numArgs) collect:[:i | 'arg' , i printString])"
      self methodArgNames
      ,
      "((1 to:self numVars) collect:[:i | 'local' , i printString])"
      self methodVarNames

    "Modified: / 23-11-2010 / 19:32:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodArgAndVarNamesInContext: context
    | pc stop |

    self isNative ifTrue:[
        ^ self methodArgNames
    ].

    context isJavaContext ifTrue:[
        pc := context pc.
    ] ifFalse:[
        "/ It may happen that the context for Java method is not
        "/ a JavaContext. This is true for some code-saver functions
        "/ such as __retInst1(), __retSelf1() and so on. In that case,
        "/ method sould be simple enough to have no nested scopes
        "/ or local variables. Forcing pc := 0 therefore works fine
        pc := 0.
    ].

    localVariableTable isNil ifTrue:[^self methodArgNames , self methodVarNames ].

    stop := context arg1Index - 1 + self numArgs + self numVars.
    stop := stop min: context size.

    ^(1 to: stop) collect:[:i|
        (localVariableTable nameForSlot: i - 1 atPC: pc) ? '<inaccessible>'.
    ].

    "Created: / 18-12-2012 / 18:17:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-11-2013 / 17:28:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodArgAndVarValuesInContext: context
    | pc stop |

    localVariableTable isNil ifTrue:[
        | values |

        values := Array new: context size.
        values replaceFrom: 1  count: context size with: context  startingAt: 1.
        ^ values.
    ].
    context isJavaContext ifTrue:[
        pc := context pc.
    ] ifFalse:[
        "/ It may happen that the context for Java method is not
        "/ a JavaContext. This is true for some code-saver functions
        "/ such as __retInst1(), __retSelf1() and so on. In that case,
        "/ method sould be simple enough to have no nested scopes
        "/ or local variables. Forcing pc := 0 therefore works fine
        pc := 0.
    ].

    stop := context arg1Index - 1 + self numArgs + self numVars.
    stop := stop min: context size.


    ^(1 to: stop) collect:[:i|
        (localVariableTable nameForSlot: i - 1 atPC: pc) notNil ifTrue:[
            context at: i
        ] ifFalse:[
            nil
        ].
    ].

    "Created: / 04-11-2013 / 18:53:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-11-2013 / 17:28:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodArgNames
    |nA "{ Class: SmallInteger }" isStatic|

    isStatic := self isStatic.
    nA := self numArgs.
    ^ 1 to:nA collect: [:argIndex |
            |slot name|

            "/ search for an entry with that index (slot),
            "/ which has is valid at PC 0

            localVariableTable notNil ifTrue:[
                isStatic ifTrue:[
                    slot := argIndex - 1
                ] ifFalse:[
                    slot := argIndex "/+ 1
                ].
                name := localVariableTable nameForSlot:slot atPC:0.
            ].
            name isNil ifTrue:[
                name := 'arg' , argIndex printString
            ].
            name
    ].

    "Modified: / 23-11-2010 / 19:47:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

methodVarNames
    |nV|

    nV := self numVars.
    localVariableTable notNil ifTrue:[
        ^ (self numArgs + 1 to: self numArgs + nV) collect:
            [:argIndex |
                |slot name|
                "/ search for an entry with that index (slot),
                "/ which has is valid at PC 0

                self isStatic ifTrue:[
                    slot := argIndex - 1
                ] ifFalse:[
                    slot := argIndex"/ + 1
                ].
                name := localVariableTable nameForSlot:slot atPC:0.
                name isNil ifTrue:[
                    'local' , argIndex printString
                ] ifFalse:[
                    name
                ].
            ]
    ].
    ^ (1 to:nV) collect:[:i | 'local' , i printString]

    "Created: / 23-11-2010 / 19:28:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ (selector copyButLast:descriptor size) asSymbol

    "Created: 16.4.1996 / 11:34:22 / cg"
!

nameSpaceName

    ^''

    "Created: / 18-10-2010 / 19:10:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numJArgs

    ^self numberOfJavaArgs

    "Created: / 25-10-2011 / 10:50:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numJavaArgs

    ^self numberOfJavaArgs

    "Created: / 25-10-2011 / 10:50:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numberOfJavaArgs

    ^(accessFlags bitAnd: 16r00FF0000) rightShift: 16.

    "Created: / 25-10-2011 / 10:45:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

numberOfJavaArgs: nArgs

    ( nArgs > 16rFF ) ifTrue:[
        ArgumentError raiseRequestWith:self errorString:'too many args method  - ', nArgs printString.
    ].

    accessFlags := accessFlags bitOr:
        ((nArgs bitAnd: 16rFF) bitShift: 16)

    "Created: / 25-10-2011 / 10:43:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

originalMethodIfWrapped
    "return the method the receiver is wrapping - none here"

    ^ self

    "Created: / 22-10-2010 / 11:46:07 / cg"
!

previousVersion
    ^ nil

    "Created: 30.7.1997 / 15:56:18 / cg"
!

previousVersionCode

    ^nil

    "Created: / 18-10-2010 / 20:15:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

retValSignature
    ^ self class retValSpecFromSignature:descriptor in:nil

    "Modified: / 8.1.1998 / 19:06:40 / cg"
!

returnType
    "/ ^ returnType
    ^ self class typeFromSignature:descriptor in:nil.

    "Modified: / 16.10.1998 / 00:17:43 / cg"
!

returnTypeClass
    |cls returnType|

    (returnType := self returnType) isNil ifTrue:[
        self halt.
    ].
    cls := Java at:returnType.
    cls notNil ifTrue:[^ cls].

    returnType == #void ifTrue:[
        ^ nil
    ].
    returnType == #double ifTrue:[
        'warning: no returnTypeClass for double' printCR.
"/        self halt:'no returnTypeClass for double'.
        ^ nil
    ].
    returnType == #float ifTrue:[
        'warning: no returnTypeClass for float' printCR.
"/        self halt:'no returnTypeClass for float'.
        ^ nil
    ].
    returnType == #long ifTrue:[
        'warning: no returnTypeClass for long' printCR.
"/        self halt:'no returnTypeClass for long'.
        ^ nil
    ].
    returnType == #int ifTrue:[
        'warning: no returnTypeClass for int' printCR.
"/        self halt:'no returnTypeClass for int'.
        ^ nil
    ].
    returnType == #boolean ifTrue:[
        'warning: no returnTypeClass for boolean' printCR.
"/        self halt:'no returnTypeClass for boolean'.
        ^ nil
    ].
    self halt.
    ^ nil

    "Created: / 13.2.1998 / 15:08:26 / cg"
    "Modified: / 16.10.1998 / 00:16:07 / cg"
!

returnsDouble
    ^ self returnType == #double

    "Modified: / 16.10.1998 / 00:18:24 / cg"
!

returnsLong
    ^ self returnType == #long

    "Modified: / 16.10.1998 / 00:18:41 / cg"
!

returnsVoid
    ^ self returnType == #void

    "Modified: / 16-10-1998 / 00:18:53 / cg"
    "Modified: / 22-03-2011 / 12:27:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

selector
    "/ could theoretically be extracted from my classes
    "/ methodDictionary via:
    "/  ^ javaClass methodDictionary keyAtValue:self ifAbsent:nil.

    ^ selector

    "Created: / 7.1.1998 / 14:05:11 / cg"
    "Modified: / 16.10.1998 / 13:41:06 / cg"
!

signature
    ^ signature

    "Modified: / 04-12-2011 / 19:39:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source
    | sourceString |

    (self isSynthetic or:[ForceByteCodeDisplay == true]) ifTrue:[
        ^ self decompiledBytecode
    ].

    sourceString := javaClass source.
    sourceString isNil ifTrue:[
        ^ self decompiledSource.
    ].
    ShowFullSource ifTrue:[ ^ sourceString ].
    source notNil ifTrue:[
        ^ source readFrom: sourceString.
    ].


    "/ stx:libjava/tools may not be loaded...
    JavaSourceDocument notNil ifTrue:[
        "/ As a side effect, this fills in source references for all methods.
        "/ see JavaSourceDocument
        | document |

        ((document := self sourceDocument) notNil and:[document sourceTreeOrNilIfParsing notNil]) ifTrue:[
            ^ source readFrom: sourceString.
        ]
    ].
    ^ sourceString

    "Modified: / 04-01-1998 / 13:48:35 / cg"
    "Modified: / 13-12-2010 / 11:06:51 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 14-09-2013 / 12:01:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceDocument
    | doc |
    "/ stx:libjava/tools may not be loaded...
    JavaSourceDocument notNil ifTrue:[
        doc := JavaSourceDocument cachedDocumentFor: javaClass.
        doc isNil ifTrue:[
            doc := JavaSourceDocument for: javaClass.
            JavaSourceDocument cachedDocumentFor: javaClass put: doc.
        ].
        ^ doc
    ]

    "Created: / 07-09-2013 / 02:29:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFilename
    ^ javaClass sourceFile
!

sourceLineNumber
    "Return the line number of method declaration
     withing method's source"

    ^ ShowFullSource ifFalse:[
        "Showing only method's source..."
        source notNil
            ifTrue:[source line0 - source lineH + 1]
            ifFalse:[1].
    ] ifTrue:[
        "Showing full source..."
        source notNil ifTrue:[
            source lineH
        ] ifFalse:[
            self firstInstructionLineNumber - 2.
        ]
    ].

    "Created: / 30-07-1997 / 15:40:45 / cg"
    "Modified: / 13-12-2010 / 23:46:30 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 08-01-2011 / 16:20:40 / Jan Kurs <kurs.jan@post.cz>"
    "Modified: / 11-09-2013 / 03:24:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wrapper

    ^nil

    "Created: / 18-10-2010 / 19:11:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'compiler interface'!

flushCode
    "Flushes jitted code, effectively cause a recompile"
    self code: nil.
    ObjectMemory flushCachesForSelector: selector.

    "Created: / 15-10-2012 / 21:03:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mcompile
    "__mcompile(OBJ aMethod, unsigned char *bytecode, int nBytes, int nArgs, OBJ receiver, OBJ selector, OBJ srchClass, OBJ *pArgsOrNull)"

    | bytecode  nBytes  nArgs  receiver  mySelector  srchClass  pArgsOrNull  retVal |
    bytecode := self byteCode.
    nBytes := self byteCode size.
    nArgs := self numArgs.
    receiver := nil.
    mySelector := self selector.
    srchClass := self mclass.

%{
retVal = __mcompile(self, __ByteArrayInstPtr(bytecode), __intVal(nBytes), __intVal(nArgs), receiver, mySelector, srchClass, pArgsOrNull);


%}.
self halt.

    "Created: / 24-02-2012 / 11:39:13 / m"
    "Modified: / 24-02-2012 / 14:00:04 / Marcel Hlopko <hlopik@gmail.com>"
!

programmingLanguage
    "Returns a programming language of the method"

    "Do not return JavaLanguage unconditionally here.
     Consider another JVM-based languages (such as Groovy)"
    ^javaClass programmingLanguage

    "Created: / 26-10-2010 / 23:42:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateFrom: anotherMethod

    self class allInstVarNames keysAndValuesDo:[:index :name|
        (#(#'code*' #'javaClass') includes: name) ifFalse:[
            self instVarAt: index put: (anotherMethod instVarAt: index)
        ]
    ]

    "Created: / 19-04-2013 / 00:08:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'debugging'!

breakPoint

    <resource: #skipInDebuggersWalkBack>

    BreakPointInterrupt
            raiseRequestWith: self
            errorString:('Breakpoint encountered')       


    "Modified: / 9.1.1998 / 23:01:17 / cg"
    "Modified: / 29-06-2015 / 16:00:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"

!

clearBreakPoint
    | clsInEvent |

    accessFlags := (accessFlags bitClear:A_BREAKPOINT).
    self hasCode ifTrue:[
        MessageTracer unwrapMethod:self
    ] ifFalse:[
        clsInEvent := self isStatic
                        ifTrue:[ javaClass theMetaclass ]
                        ifFalse:[ javaClass ].
        Smalltalk changed:#methodTrap with:{ clsInEvent . selector }
    ]

    "Modified: / 13-11-1998 / 23:31:00 / cg"
    "Modified: / 30-05-2012 / 19:31:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCounting
    ^ false.

    "Created: / 12.1.1998 / 20:02:23 / cg"
!

isCountingMemoryUsage
    ^ false.

    "Created: / 12.1.1998 / 20:03:22 / cg"
!

setBreakPoint
    | clsInEvent |

    accessFlags := (accessFlags bitOr:A_BREAKPOINT).
    self hasCode ifTrue:[
        MessageTracer trapMethod:self
    ] ifFalse:[
        clsInEvent := self isStatic
                        ifTrue:[ javaClass theMetaclass ]
                        ifFalse:[ javaClass ].
        Smalltalk changed:#methodTrap with:{ clsInEvent . selector }
    ].

    "Modified: / 13-11-1998 / 23:30:45 / cg"
    "Modified: / 30-05-2012 / 19:30:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'decompiling'!

decompileSourceTo:aStream
    |argNames|

    byteCode isNil ifTrue:[
        self isPublic ifTrue:[
            aStream nextPutAll:'public '.
        ].
        self isProtected ifTrue:[
            aStream nextPutAll:'protected '.
        ].
        self isPrivate ifTrue:[
            aStream nextPutAll:'private '.
        ].
        self isStatic ifTrue:[
            aStream nextPutAll:'static '.
        ].

        self isNative ifTrue:[
            aStream nextPutAll:'native '.
        ].
        self isAbstract ifTrue:[
            aStream nextPutAll:'abstract '.
        ].
        argNames := #('arg1' 'arg2' 'arg3' 'arg4' 'arg5' 'arg6' 'arg7' 'arg8' 'arg9').
        aStream nextPutAll:(self signatureNameWithArgNames:argNames).
        aStream nextPutAll:';'; cr.
        ^ self
    ].

    "
    JavaDeparser isNil ifTrue:[
        aStream nextPutAll:'// Sorry - no decompiler'.
        ^ self
    ].
    "


"/    self isNative ifFalse:[
"/        self isAbstract ifFalse:[
            aStream nextPutAll:'// source not available...'; cr.
            SignalSet anySignal handle:[:ex |
                ex creator == Object haltSignal ifTrue:[ex reject].
                ex creator == MessageTracer breakpointSignal ifTrue:[ex reject].
                ex creator == Signal noHandlerSignal ifTrue:[ex reject].

                aStream nextPutAll:'error while decompiling:'.
                aStream cr; cr; spaces:4.
                aStream nextPutAll:ex errorString.
                aStream cr.
                aStream nextPutAll:ex suspendedContext printString.
                aStream cr.
                aStream nextPutAll:ex suspendedContext sender printString.
                aStream cr.
                aStream nextPutAll:ex suspendedContext sender sender printString.
                aStream cr.
                aStream nextPutAll:ex suspendedContext sender sender sender printString.
                aStream cr.
                aStream nextPutAll:ex suspendedContext sender sender sender sender printString.
                aStream cr.
                aStream nextPutAll:ex suspendedContext sender sender sender sender sender printString.
                aStream cr.
                aStream nextPutAll:ex suspendedContext sender sender sender sender sender sender printString.
                aStream cr.
                aStream nextPutAll:ex suspendedContext sender sender sender sender sender sender sender printString.
                aStream cr.
                aStream nextPutAll:ex suspendedContext sender sender sender sender sender sender sender sender printString.
                aStream cr.

                "
                JavaByteCodeDisassembler isNil ifTrue:[
                    aStream nextPutAll:'// Sorry - no decompiler'
                ] ifFalse:[
                    JavaByteCodeDisassembler diassemble:self to:aStream.
                ].
                "
                ex return
            ] do:[
                "aStream nextPutAll:(JavaDeparser decompile:self)."
                JavaByteCodeDisassembler diassemble:self to:aStream.
            ].
"/        ].
"/    ].

    "Created: / 30-07-1997 / 16:28:09 / cg"
    "Modified: / 21-12-1999 / 14:31:54 / cg"
    "Modified: / 22-03-2011 / 21:34:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

decompiler
    ^ JavaDecompiler

    "Created: 30.7.1997 / 16:36:48 / cg"
!

isMethod
    "return true, if the receiver is some kind of method;
     true returned here - the method is redefined from Object."

    ^ true

    "Created: / 13.11.1998 / 23:57:40 / cg"
!

originalMethod
    ^ self

    "Created: / 13.1.1998 / 15:03:05 / cg"
! !

!JavaMethod methodsFor:'error handling'!

invalidByteCode: anObject
    "
    Sent by VM when method's bytecode (value `byteCode` slot) is invalid
    such as it's nil or a ByteArray instance
    "
    (anObject isNil and:[ self isAbstract ]) ifTrue:[ 
        JavaVM throwExceptionClassName: 'java.lang.AbstractMethodError' withMessage: ('trying to execute abstract method %1#%2' bindWith: javaClass javaName with: selector).
    ].

    JavaClassFormatError newException
        messageText: 'Invalid method bytecode';
        parameter: (Array with: self with: anObject );
        raise

    "Created: / 25-10-2017 / 23:25:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2017 / 11:39:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidClass: anObject
    "
    Sent by VM when method's class (value `javaClass` slot) is invalid
    such it's nil or not a Java class.
    "
    JavaClassFormatError newException
        messageText: 'Invalid method class';
        parameter: (Array with: self with: anObject );
        raise

    "Created: / 25-10-2017 / 23:25:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2017 / 11:39:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidConstantPool: anObject
    "
    Sent by VM when method's class constant pool is invalid
    such it's nil or not a constant pool.
    "
    JavaClassFormatError newException
        messageText: 'Invalid constant pool:';
        parameter: (Array with: self with: anObject );
        raise

    "Created: / 25-10-2017 / 23:27:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2017 / 11:39:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidConstantPool: anObject index: anInteger
    "
    Sent by VM when constant pool index or entry at
    given index is invalid, such as if it's out of
    bouunds or constant pool entry is nil.
    "
    anInteger > anObject size ifTrue:[ 
        JavaClassFormatError newException
            messageText: 'Constant pool index out of bounds:';
            parameter: (Array with: self with: anObject with: anInteger);
            raise
    ] ifFalse:[ 
        JavaClassFormatError newException
            messageText: 'Invalid constant pool entry';
            parameter: (Array with: self with: anObject with: anInteger);
            raise
    ].

    "Created: / 25-10-2017 / 23:40:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-10-2017 / 11:39:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

wrongNumberOfArguments:numArgsGiven
    "{ Pragma: +optSpace }"

    "this error is triggered by the VM, if a method is called with a wrong number
     of arguments.
     This only applies to #valueWithReceiverXXX and #perform:withArguments: - sends.
     With a normal send, this error cannot happen."

    ^ JavaVM
        throwIllegalArgumentException:(' - %1 got %2 arg(s) where %3 expected'
                        bindWith:self class name
                        with:numArgsGiven
                        with:self numArgs)

    "
     2 perform:#+
    "

    "Modified: / 01-08-1997 / 00:23:10 / cg"
    "Created: / 07-09-2011 / 14:17:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'executing'!

valueWithReceiver:anObject arguments:argArray selector:aSymbol search:aClass sender:virtualSender
    self isStatic ifTrue:[
        anObject == javaClass ifFalse:[
            self error: 'Invalid receiver - only owning class can be a receiver of static method invocation!!'
        ]
    ].
    ^super valueWithReceiver:anObject arguments:argArray selector:aSymbol search:aClass sender:virtualSender

    "Created: / 31-10-2012 / 23:09:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'initialization'!

resolve
    "Called by VM to resolve all references used by this method. When
     successful (i.e., all references has been successfully resolved, a
     A_RESOLVED flag is set (to prevent VM from subsequent calls
     to this method)

     Returns 1 if successfull, 0 if not (at least one reference
     could not been resolved) or -1 when some (unspecified) erorr
     occurs."
    "Marcel, continue here!! And ALWAYS commit ALL the code!! Sigh"

    [
	JavaByteCodePreresolver preresolve: self.
	accessFlags := accessFlags | A_RESOLVED.
        ^1.
    ] on: Error do:[:ex|
        self breakPoint: #mh.  "Marcel, please fix it"
        ^0.
    ].

    "/RETURN 1...OK,
    "/       0...Something could not be resolved
    "/      -1...Some error
    self breakPoint:#mh.
    ^ 1.

    "Created: / 09-02-2012 / 20:59:22 / mh <hlopik@gmail.com>"
    "Modified: / 11-02-2012 / 13:46:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 23-02-2012 / 17:49:09 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 24-02-2012 / 14:46:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

setAccessFlags:flags
    accessFlags := flags.

    "Created: 16.4.1996 / 11:34:14 / cg"
!

setCode:codeBytes maxStack:max_stack maxLocals:max_locals u1:unknown1 u2:unknown2
"/    javaByteCode := codeBytes.
    byteCode := codeBytes.
    "/ numStack := max_stack.
    "/ numLocals := max_locals.
    super numberOfVars:max_locals - self numArgs - (self isStatic ifTrue:[0] ifFalse:[1]).
    super stackSize:max_stack.



"/    self displayString printNL.
"/    '   nStack: ' print. numStack print.
"/    ' nLocal: ' print. numLocals print.
"/    ' u1: ' print. unknown1 print.
"/    ' u2: ' print. unknown2 printNL.

    "Modified: / 01-08-1997 / 00:08:32 / cg"
    "Modified: / 12-10-2012 / 11:46:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setDescriptor:aString

    descriptor := aString asSymbol.

    "Created: / 16-04-1996 / 11:34:29 / cg"
    "Modified: / 16-10-1998 / 00:17:12 / cg"
    "Modified: / 13-08-2011 / 01:21:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 14-08-2011 / 19:41:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setJavaClass:aJavaClass
    javaClass := aJavaClass

    "Modified: 16.4.1996 / 12:36:27 / cg"
    "Created: 16.4.1996 / 15:28:15 / cg"
!

setLineNumberTable:anArrayOfPCtoLineAssociations
    "since this uses up lots of memory, compress it"

    |allBytes allWords idx|

    allBytes := allWords := true.

    anArrayOfPCtoLineAssociations do:[:assoc |
        assoc key > 255 ifTrue:[
            allBytes := false.
            assoc key > 16rFFFF ifTrue:[
                allWords := false.
            ].
        ].
        assoc value > 255 ifTrue:[
            allBytes := false.
            assoc value > 16rFFFF ifTrue:[
                allWords := false
            ].
        ].
    ].
    allBytes ifTrue:[
        lineNumberTable := ByteArray new:(anArrayOfPCtoLineAssociations size * 2).
    ] ifFalse:[
        allWords ifTrue:[
            lineNumberTable := WordArray new:(anArrayOfPCtoLineAssociations size * 2).
        ] ifFalse:[
            lineNumberTable := Array new:(anArrayOfPCtoLineAssociations size * 2).
        ]
    ].

    idx := 1.
    anArrayOfPCtoLineAssociations do:[:assoc |
        lineNumberTable at:idx   put:assoc key.
        lineNumberTable at:idx+1 put:assoc value.
        idx := idx + 2.
    ].

    "Created: 16.4.1996 / 12:34:04 / cg"
    "Modified: 16.4.1996 / 12:49:06 / cg"
!

setLocalVariableTable:anArray
     localVariableTable := anArray.
!

setName:name descriptor:desc
    | numArgs numJArgs returnTypeSignatureChar returnTypeIsPrimitiveArray |

    "/ Force Symbol creation so Smalltalk syntax highlighter will not
    "/ mark them as unknown message (it detects this solely by existence
    "/ of the symbol.
    name asSymbol.

    selector := (name , desc) asSymbol.
    self setDescriptor:desc.

    numJArgs := self class numArgsFromDescriptor:desc.
    (numJArgs > self class maxNumberOfArguments) ifTrue:[
        numArgs := 1.
    ] ifFalse:[
        numArgs := numJArgs.
    ].
    self numberOfArgs:numArgs.
    self numberOfJavaArgs:numJArgs.
    returnTypeSignatureChar := descriptor last.


     "/ for the convenience of the VM, also mirror the return type in
     "/ the flags ...


    returnTypeSignatureChar == $V ifTrue:[
            accessFlags := accessFlags bitOr:ACX_R_VOID
    ] ifFalse:[
        returnTypeIsPrimitiveArray := (descriptor at: (descriptor size - 1)) == $[.
        returnTypeIsPrimitiveArray ifFalse:[
            returnTypeSignatureChar == $J ifTrue:[
                accessFlags := accessFlags bitOr:ACX_R_LONG
            ] ifFalse:[
               returnTypeSignatureChar == $D ifTrue:[
                  accessFlags := accessFlags bitOr:ACX_R_DOUBLE
               ].
            ].
        ].
    ].

    "Created: / 14-08-2011 / 19:41:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-05-2014 / 20:47:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSignature:aString

    signature := aString asSymbol.

    "Created: / 16-04-1996 / 11:34:29 / cg"
    "Modified: / 16-10-1998 / 00:17:12 / cg"
    "Modified (format): / 14-08-2011 / 19:41:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSource:aJavaMethodSourceRef
    self assert: aJavaMethodSourceRef class == JavaSourceRef.
    source := aJavaMethodSourceRef

    "Created: / 07-09-2013 / 01:44:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-09-2013 / 02:19:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'inspecting'!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ Dictionary new
        declareAllNewFrom:(super inspectorExtraAttributes ? #());
        "/add:'-code' -> [ String streamContents:[:s | JavaDecompiler decompile: self to: s] ];
        add:'-code' -> [ String streamContents:[:s | JavaByteCodeDisassembler diassemble: self to: s] ];
        "/add:'-source' -> [ self source ];
        yourself

    "Modified: / 22-03-2011 / 21:13:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'interpretation'!

interpretWithReceiver: receiver

    ^self
        interpretWithReceiver: receiver
        arguments: #()

    "Created: / 24-02-2011 / 22:05:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

interpretWithReceiver: receiver arg: a1

    ^self
        interpretWithReceiver: receiver
        arguments: (Array with: a1)

    "Created: / 24-02-2011 / 22:05:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

interpretWithReceiver: receiver arg: a1 arg: a2

    ^self
        interpretWithReceiver: receiver
        arguments: (Array with: a1 with: a2)

    "Created: / 24-02-2011 / 22:05:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

interpretWithReceiver: receiver arg: a1 arg: a2 arg: a3

    ^self
        interpretWithReceiver: receiver
        arguments: (Array with: a1 with: a2 with: a3)

    "Created: / 24-02-2011 / 22:06:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

interpretWithReceiver:aReceiver arguments:argVector
    "invoked by VM for non-Smalltalk-methods (MetaMethods)"

    ^ JavaByteCodeInterpreter interpret: self receiver: aReceiver arguments: argVector

    "Created: / 17-10-2013 / 01:56:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'methodref interchangability'!

homeMethod
    ^ self
!

method
    ^ self
!

setPackage:newPackage
    newPackage ~= javaClass package ifTrue:[
        self halt:'java method cannot be in a package different from its class'.
    ]
! !

!JavaMethod methodsFor:'misc'!

fromMethod:aJavaMethod
    "copy values from another javaMethod"

    flags := aJavaMethod flags.
    byteCode := aJavaMethod byteCode.
    accessFlags := aJavaMethod accessFlags.
    selector := aJavaMethod selector.
    javaClass := aJavaMethod javaClass.
    descriptor := aJavaMethod instVarNamed:#descriptor.
    signature := aJavaMethod instVarNamed:#signature.
    lineNumberTable := aJavaMethod lineNumberTable.
    localVariableTable := aJavaMethod localVariableTable.
    annotations := aJavaMethod annotations.

    "Modified: / 16-10-1998 / 01:27:19 / cg"
    "Modified: / 14-08-2011 / 19:30:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateClassRefsFrom:oldClass to:newClass
    javaClass == oldClass ifTrue:[
        "/ invalidate
        byteCode := nil.
    ]

    "Created: / 6.1.1998 / 18:19:48 / cg"
! !

!JavaMethod methodsFor:'printing & storing'!

displayString
    javaClass isNil ifTrue:[
        ^ self class name , '(???)'
    ].
    ^ self class name , '(' , javaClass displayString , '::' , self signatureName , ')'

    "Modified: / 25.9.1999 / 23:04:01 / cg"
!

printOn: aStream

    super printOn: aStream.
    aStream nextPut: $(.
    javaClass name printOn: aStream.
    aStream nextPut: $..
    selector printOn: aStream.
    aStream nextPut: $).

    "Created: / 05-12-2011 / 01:30:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printStringForBrowserWithSelector:dummySelector
"/    self isStatic ifTrue:[
"/        ^ 'static ' , self signatureName
"/    ].
"/    self isBreakpointed ifTrue:[
"/        ^ (LabelAndIcon '!! ' , self signatureName
"/    ].

    self name = #'<clinit>' ifTrue:[
        ^ 'static {}'
    ].

    ^ self name = #'<init>' ifTrue:[
        self class specTextFromSignature:descriptor in:javaClass package withName:(javaClass lastName) isConstructor: true
    ] ifFalse:[
        self class specTextFromSignature:descriptor in:javaClass package withName:(self name) isConstructor: false
    ]

    "Created: / 16-10-2013 / 00:52:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printStringForBrowserWithSelector:dummySelector inClass:dummyClass
"/    self isStatic ifTrue:[
"/        ^ 'static ' , self signatureName
"/    ].
"/    self isBreakpointed ifTrue:[
"/        ^ (LabelAndIcon '!! ' , self signatureName
"/    ].

    self name = #'<clinit>' ifTrue:[
        ^ 'static {}'
    ].

    ^ self name = #'<init>' ifTrue:[
        self class specTextFromSignature:descriptor in:javaClass package withName:(javaClass lastName) isConstructor: true
    ] ifFalse:[
        self class specTextFromSignature:descriptor in:javaClass package withName:(self name) isConstructor: false
    ]

    "Created: / 16-10-2013 / 00:55:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectorPrintStringInBrowserFor:dummySelector
    ^ self selectorPrintStringInBrowserFor:dummySelector class: javaClass

    "Created: / 16-10-2013 / 01:02:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectorPrintStringInBrowserFor:dummySelector class: dummyClass
    ^ self printStringForBrowserWithSelector:dummySelector inClass:dummyClass

    "Created: / 16-10-2013 / 01:03:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shortDisplayString
    ^ javaClass name , '::' , self signatureNameWithoutReturnType
!

signatureName
    "return a string to be used when browsing"

    ^ self class specFromSignature:descriptor withName:(self name) in:nil

    "Modified: / 8.1.1998 / 19:15:33 / cg"
!

signatureNameFor:name withArgsIn:aPackage
    "return a string to be used when decompiling"

    ^ name = '<init>' ifTrue:[
        self class specWithArgsFromSignature:descriptor withName: javaClass lastName in:aPackage isConstructor: true.
    ] ifFalse:[
        self class specWithArgsFromSignature:descriptor withName:(self name) in:aPackage isConstructor: false.
    ]

    "Created: / 25-03-1997 / 18:49:45 / cg"
    "Modified: / 04-10-2013 / 12:33:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

signatureNameIn:aPackage
    "return a string to be used when browsing"

    ^ self class specFromSignature:descriptor withName:(self name) in:aPackage

    "Created: 18.3.1997 / 11:11:01 / cg"
!

signatureNameText
    "return a text to be used when browsing"

    ^ self class specTextFromSignature:descriptor withName:(self name)

    "Created: 30.7.1997 / 14:40:29 / cg"
!

signatureNameTextFor:name withArgsIn:aPackage
    "return a text to be used when decompiling"

    ^ self class specTextWithArgsFromSignature:descriptor withName:name in:aPackage

    "Created: 25.3.1997 / 18:49:45 / cg"
    "Modified: 1.8.1997 / 10:44:28 / cg"
!

signatureNameWithArgNames:argNames
    "return a string to be used when browsing"

    |myName|

    myName := self name.
    myName = '<init>' ifTrue:[
        myName := javaClass name
    ].
    ^ self class specFromSignature:descriptor withName:myName argNames:argNames in:nil

    "Created: / 8.1.1998 / 21:04:03 / cg"
    "Modified: / 8.1.1998 / 21:22:38 / cg"
!

signatureNameWithArgNames:argNames in:package
    "return a string to be used when browsing"

    |myName|

    myName := self name.
    myName = '<init>' ifTrue:[
        myName := javaClass name
    ].
    ^ self class specFromSignature:descriptor withName:myName argNames:argNames in:package

    "Modified: / 8.1.1998 / 21:05:52 / cg"
    "Created: / 8.1.1998 / 21:23:03 / cg"
!

signatureNameWithArgsIn:aPackage
    "return a string to be used when browsing"

    ^ self signatureNameFor: self name withArgsIn: aPackage

    "Created: / 20-03-1997 / 12:44:17 / cg"
    "Modified: / 04-10-2013 / 12:34:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

signatureNameWithModifiers
    "return a string to be used when deassembling"

    | result |

    result := self signatureName.
    self isFinal ifTrue: [ result := 'final ' , result ].
    self isStatic ifTrue: [ result := 'static ' , result ].
    self isSynchronized ifTrue: [ result := 'synchronized ' , result ].
    self isPrivate
        ifTrue: [ result := 'private ' , result ]
        ifFalse:
            [ self isProtected
                ifTrue: [ result := 'protected ' , result ]
                ifFalse: [ self isPublic ifTrue: [ result := 'public ' , result ] ] ].
    self isAbstract ifTrue: [ result := 'abstract ' , result ].
    ^ result.

    "Modified: / 08-01-1998 / 19:15:33 / cg"
    "Created: / 22-03-2011 / 16:25:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

signatureNameWithoutReturnType
    "return a string to be used when browsing"

    ^ self class argSpecFromSignature:descriptor withName:(self name)

!

whoString
    ^ javaClass name , '>>' , (self printStringForBrowserWithSelector:nil inClass:nil)

    "Created: / 13-06-2013 / 08:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'queries'!

handlerFor:anException at:pc
    "return an exceptionHandlers pc, for an exception of the given type,
     occurring at pc. Returns nil, if there is none."

    |handlerTable|

    (handlerTable := self exceptionHandlerTable) isNil ifTrue:[^ nil].
    ^handlerTable handlerPCFor:anException at:pc in:self.

    "Created: / 16-10-1998 / 01:18:40 / cg"
    "Modified: / 25-09-1999 / 23:07:01 / cg"
    "Modified: / 06-05-2013 / 21:49:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasEnabledBreakpoints
    ^ self isBreakpointed

    "Created: / 15-03-2016 / 15:33:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasFinally
    ^ (accessFlags bitAnd:A_HASFINALLY) ~~ 0

    "Created: / 28-03-2012 / 20:35:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasFinallyBasedOnExceptionTable
    "Returns true if the exeption table has at least one
     entry for finally block"
    ^false

    "Created: / 28-03-2012 / 23:18:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasHandler
    ^ (accessFlags bitAnd:A_HASHANDLER) ~~ 0

    "Created: / 28-03-2012 / 20:35:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasPrimitiveCode

    ^false

    "Created: / 18-07-2011 / 20:45:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasResource
    ^ false
!

isAbstract
    ^ (accessFlags bitAnd:A_ABSTRACT) ~~ 0
!

isBreakpointed
    ^ (accessFlags bitAnd:A_BREAKPOINT) ~~ 0

    "Modified: / 11.1.1998 / 13:28:43 / cg"
!

isFinal
    ^ (accessFlags bitAnd:A_FINAL) ~~ 0
!

isIgnored
    "not really a java attribute;
     added to allow browsing"

    ^ false.

    "Created: 30.7.1997 / 15:34:33 / cg"
!

isJavaClassRef
    ^ false

    "Created: / 9.11.1999 / 17:16:20 / cg"
!

isJavaConstructor
    ^((selector first) == $<) and:[selector startsWith:'<init>(']

    "Created: / 01-08-2012 / 00:21:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaMethod
    ^ true

    "Created: / 10.11.1998 / 18:24:51 / cg"
!

isJavaStaticInitializer
    ^((selector first) == $<) and:[selector startsWith:'<clinit>(']

    "Created: / 19-09-2012 / 16:26:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNative
    ^ (accessFlags bitAnd:A_NATIVE) ~~ 0
!

isPackagePrivate
    ^ (accessFlags bitAnd:A_PRIVATE | A_PUBLIC | A_PROTECTED) = 0

    "Created: / 05-07-2012 / 10:12:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isPrivate
    ^ (accessFlags bitAnd:A_PRIVATE) ~~ 0
!

isProtected
    ^ (accessFlags bitAnd:A_PROTECTED) ~~ 0
!

isPublic
    ^ (accessFlags bitAnd:A_PUBLIC) ~~ 0
!

isResolved
    "Return true, if the receiver is fully resolved, i.e.,
     if all references used by the method are resolved"

    ^ (accessFlags bitAnd:A_RESOLVED) ~~ 0

!

isStatic
    ^ (accessFlags bitAnd:A_STATIC) ~~ 0
!

isSynchronized
    ^ (accessFlags bitAnd:A_SYNCHRONIZED) ~~ 0
!

isTraced
    ^ false

    "Modified: / 11.1.1998 / 13:28:43 / cg"
    "Created: / 11.1.1998 / 13:38:11 / cg"
!

isUnloaded
    ^ false
!

isUnresolved
    "return true, if the receiver is unresolved;"

    ^ self isResolved not

    "Created: / 06-03-2011 / 22:57:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

isWrapped
    ^ super isWrapped
"/    ^ self isBreakpointed

    "Created: / 11-01-1998 / 13:38:04 / cg"
    "Modified: / 05-11-2013 / 16:19:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineNumberForPC0: pc
    | last |

    lineNumberTable notNil ifTrue: [
        lineNumberTable
            pairWiseDo: [:lPc :lNr |
                lPc >= pc ifTrue: [
                    lPc == pc ifTrue: [
                        ^ lNr
                    ].
                    last isNil ifTrue: [
                        ^ lNr
                    ].
                    ^ last.
                ].
                last := lNr.
            ].
        last notNil ifTrue: [
            ^ last
        ].
        ^ lineNumberTable at: 2
    ].
    ^ nil

    "Modified: / 14.1.1998 / 13:30:54 / cg"
    "Created: / 10.11.1998 / 14:18:22 / cg"
!

lineNumberForPC:pc
    |num text|

    num := nil.

    ForceByteCodeDisplay ifFalse:[
        | line0 |

        line0 := self lineNumberForPC0: pc.
        ShowFullSource ifFalse:[
            source isNil ifTrue:[
                "/ Fetch the source ref...
                self sourceDocument sourceTreeOrNilIfParsing.
                source isNil ifTrue:[
                    ^ line0 - self firstInstructionLineNumber - 2.
                ].
            ].
            ^ line0 - source line0 + 1.
        ].
        ^ line0
    ].

    "/ decompile and look which line the pc falls into

    ForceByteCodeDisplay ifTrue:[
        text := self decompiledBytecode asCollectionOfLines.
    ] ifFalse:[
        text := self decompiledSource asCollectionOfLines.
    ].

    text keysAndValuesDo:[:lineNr :line |
        |nr|

        (line startsWith:'    ') ifFalse:[
            nr := Integer readFrom:line onError:0.
            nr >= pc ifTrue:[
                ^ lineNr
            ]
        ]
    ].
    ^ num

    "Modified: / 14-01-1998 / 13:30:54 / cg"
    "Modified: / 13-09-2013 / 02:11:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messagesSent
    "return a collection of messages sent by this method"
    ^ self analyzer messagesSent

    "Modified: / 31-08-2013 / 10:43:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

overrides: anotherMethod
    "Returns true, if the receiver overwrites anotherMethod.
     This method implements algorithm described in JVM spec, sec. 5.4.2.1"

    anotherMethod isJavaMethod ifFalse:[
        "It is questionable what to return here. Best seems to be
         do following: if anotherMethod belongs to one of my superclasses
         (either JavaObject or Object in current impl), then return true,
         false otherwise"
        ^javaClass inheritsFrom: anotherMethod mclass.
    ].

    "An instance method m1 (self) declared in class C overrides another instance method m2
     (anotherMethod) declared in class A iff all of the following are true:"

    " - m2 has the same name and descriptor as m1. "
    selector == anotherMethod selector ifFalse:[ ^ false ].

    " - C is a subclass of A."
    (javaClass isSubclassOf: anotherMethod javaClass) ifFalse:[ ^ false ].

    "- either:
      - m2 is marked ACC_PUBLIC; or is marked ACC_PROTECTED; or is marked nei-
        ther ACC_PUBLIC nor ACC_PROTECTED nor ACC_PRIVATE and belongs to the
        same runtime package as C, or"

    (anotherMethod isPublic or:[anotherMethod isProtected]) ifTrue:[ ^ true ].
    (anotherMethod isPackagePrivate
        and:[javaClass package == anotherMethod javaClass package])
            ifTrue:[ ^ true ].

    ^false.

    "Created: / 05-07-2012 / 11:04:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
    "in java, class extensions are not possible;
     all methods MUST be in their classes package"

    ^ javaClass package
!

referencesLiteral:aLiteral
    "return true, if this method directly references the given literal directly
     (i.e. a flat search, which does not look deeper into literal arrays)."

    | cp |

    "/ JVM does not use per-method literal frame like Smalltalk but
    "/ per-class constant pool. To avoid decompilation of bytecode to
    "/ see what's actually referenced, do a quick-search through a constant
    "/ pool to quickly rule out methods that cannot possibly refer to it.
    cp := javaClass constantPool.
    (cp includes: aLiteral) ifFalse:[ ^ false ].
    ^super referencesLiteral:aLiteral.
    "
     (CompiledCode compiledMethodAt:#referencesLiteral:) referencesGlobal:#literalsDetect:ifNone:
     (CompiledCode compiledMethodAt:#referencesLiteral:) referencesGlobal:#bla
    "

    "Created: / 29-07-2016 / 09:59:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sends:aSelectorSymbol
    "return true, if this method contains a message-send
     with aSelectorSymbol as selector."

     ^ self analyzer sends: aSelectorSymbol

    "Created: / 09-11-1999 / 15:38:14 / cg"
    "Modified: / 09-11-1999 / 17:06:03 / cg"
    "Modified: / 31-08-2013 / 11:37:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

shouldBeSkippedInDebuggersWalkBack

    ^false

    "Created: / 30-11-2010 / 15:35:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

who
    "return the class and selector of where I am defined in."

    |sel|

    javaClass isNil ifTrue:[^ nil].
    sel := selector.
    "/ sel := javaClass methodDictionary keyAtValue:self ifAbsent:nil.
    sel isNil ifTrue:[^ nil].
    ^ Method::MethodWhoInfo class:javaClass selector:sel.

    "Modified: / 16.10.1998 / 13:42:10 / cg"
! !

!JavaMethod methodsFor:'queries-statistic'!

messagesPossiblySent
    ^ self analyzer messagesPossiblySent

    "Created: / 30-08-2013 / 14:05:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-08-2013 / 17:07:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messagesSentToSelf
    ^ self analyzer messagesSentToSelf

    "Created: / 31-08-2013 / 09:32:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

messagesSentToSuper
    ^ self analyzer messagesSentToSuper

    "Created: / 30-03-2013 / 09:59:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-08-2013 / 17:07:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modifiedClassVars
    ^ #()

    "Created: / 30-08-2013 / 13:16:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modifiedGlobals
    ^ #()

    "Created: / 05-09-2013 / 15:26:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modifiedInstVars
    ^ self analyzer modifiedInstVars

    "Created: / 30-08-2013 / 13:18:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modifiedPoolVars
    ^ #()

    "Created: / 05-09-2013 / 15:25:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readClassVars
    ^ #()

    "Created: / 05-09-2013 / 15:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readGlobals
    ^ self analyzer readGlobals

    "Created: / 05-09-2013 / 15:26:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readInstVars
    ^ self analyzer readInstVars

    "Created: / 05-09-2013 / 15:24:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readPoolVars
    ^ #()

    "Created: / 05-09-2013 / 15:25:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sends:symbol1 or:symbol2
    ^ self analyzer sends:symbol1 or:symbol2

    "Modified: / 30-08-2013 / 17:07:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sendsAny: selectors
    ^ self analyzer sendsAny: selectors

    "Created: / 02-12-2011 / 23:05:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-08-2013 / 17:08:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usedClassVars
    ^ #() "/ No class vars in Java

    "Created: / 30-08-2013 / 13:18:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usedGlobals
    ^ self analyzer usedGlobals

    "Created: / 05-09-2013 / 15:26:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usedInstVars
    ^ self analyzer usedInstVars

    "Created: / 30-08-2013 / 13:18:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

usedPoolVars
    ^ #()

    "Created: / 05-09-2013 / 15:25:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod methodsFor:'signature parsing'!

XXXspecWithArgsFromSignature:aSignature withName:name in:aPackage
    "given a signature, return a spec with args"

    |s argSpec retvalSpec|

    s := aSignature readStream.
    s next ~~ $( ifTrue:[self halt. ^ name].

    argSpec := self argSpecWithArgsFromStream:s in:aPackage.

    s next ~~ $) ifTrue:[self halt. ^ name].

    retvalSpec := self retvalSpecFromStream:s in:aPackage.

    ^ retvalSpec , ' ' , name , ' (' , argSpec , ')'

    "
     JavaMethod specFromSignature:'(LObject;)V' withName:'foo'
     JavaMethod specFromSignature:'(BB)S'       withName:'foo'
    "

    "Created: / 8.1.1998 / 19:17:58 / cg"
! !

!JavaMethod methodsFor:'testing'!

isMethodWithBreakpoints
    ^self isBreakpointed
        or:[(ConfigurableFeatures includesFeature: #VMBreakpointSupport)
            and:[self breakpointTable notEmptyOrNil]]

    "Created: / 11-04-2013 / 14:50:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSynthetic
    ^ (accessFlags bitAnd:A_SYNTHETIC) ~~ 0

    "Created: / 18-10-2010 / 19:09:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethod class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethod.st,v 1.118 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethod.st,v 1.118 2015-03-20 12:08:00 vrany Exp $'
!

version_SVN
    ^ 'Id'
! !


JavaMethod initialize!

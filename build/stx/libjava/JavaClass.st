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

JavaBehavior subclass:#JavaClass
	instanceVariableNames:'classLoader binaryName fields staticFields annotations'
	classVariableNames:'ArgumentConversionErrorSignal OrderOfClassInits'
	poolDictionaries:'JavaConstants JavaVMData'
	category:'Languages-Java-Classes'
!

MethodDictionary variableSubclass:#Attributes
	instanceVariableNames:''
	classVariableNames:'Empty'
	poolDictionaries:''
	privateIn:JavaClass
!

Object subclass:#JavaClassVersionDiedHandler
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaClass
!

!JavaClass class methodsFor:'documentation'!

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
!

examples
"
    (Java at:'java.util.Stack') new inspect
    (Java at:'java.util.Vector') new inspect
"
! !

!JavaClass class methodsFor:'instance creation'!

binaryName: binaryName numStatic: nstatics
    | binaryNameSym meta  cls |

    binaryNameSym := binaryName asSymbol.
    "create the metaclass first"
    meta := JavaMetaclass new.
    meta setSuperclass: self.
    meta instSize: (meta superclass instSize + nstatics).

"/    meta setName:(aString , 'class') asSymbol.
"/    meta setClassVariableString:''.

    meta flags: (meta flags bitOr: Behavior flagJavaClass).

"/    meta setSuperclass:JavaObject class. "then let the new meta create the class"

    cls := meta new.
    cls setSuperclass: JavaObject.
    cls instSize: 0.
    cls flags: 0.
    cls setAccessFlags: 0.

"/    cls setClassVariableString:''.

    cls setInstanceVariableString: ''.
    cls setCategory: #java.
    cls setLockWord.

    cls setBinaryName: binaryNameSym.
    "Make sure `name` slot of Java classes always contain a symbol.
     There's code in the VM which compares class names, therefore having nil
     there causes segfault.

     Also, because __jbindnative() reads class name slot (instead of binaryName),
     temporarily set Class.name slot to its binary name. This is certainly
     kludge, but allows old VM to work with new naming scheme. Will wanish."
    cls setName: binaryNameSym.

    ^ cls

    "Created: / 15-04-1996 / 15:52:55 / cg"
    "Modified: / 03-01-1998 / 22:32:25 / cg"
    "Modified: / 12-04-2015 / 11:23:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name:aString
    self shouldNotImplement

    "Created: 15.4.1996 / 15:52:55 / cg"
! !

!JavaClass class methodsFor:'boxing-unboxing'!

box: stArgumentsCollection to: typesCollection
    " box smalltalk arguments collection to Java arguments "
    ^ stArgumentsCollection with: typesCollection collect: [ :stObject :javaType |
        (JavaTypeBox  typeBoxForJava: javaType) box: stObject.
    ]

    "Created: / 25-09-2011 / 20:20:35 / Jan Kurs <kursjan@fit.cvut.cz>"
!

unbox:jObj returnType: returnType

    "JV@2011-02-04"
    "Hack for primitive types"
    "/    JK: it is hack, but it is fast :)
    (JavaDescriptor baseTypesByTypeName keys includes: returnType) ifTrue:[^jObj].

    ^ (JavaTypeBox typeBoxForJava: returnType) unbox: jObj.

    "Created: / 30-08-2011 / 22:13:41 / Jan Kurs <kursjan@fit.cvut.cz>"
! !

!JavaClass class methodsFor:'class initialization'!

initialize

    ArgumentConversionErrorSignal := Signal new notifierString:'argument conversion error'.

    "Created: / 20-10-2010 / 11:11:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass class methodsFor:'method lookup'!

canConvertArgsToJava:argArray asSpecifiedIn:argSigSpecArray
    "given a smalltalk argument array, return true, if these can be converted to java objects as appropriate."

    argArray
	with:argSigSpecArray
	do:[:arg :type |
		self
		    convertToJava:arg
		    type:type
		    ifFail:[:msg :default| ^ false]].
    ^ true

    "Created: / 5.11.1998 / 18:25:05 / cg"
    "Modified: / 6.11.1998 / 00:45:58 / cg"
!

convertArgsToJava:argArray asSpecifiedIn:argSigSpecArray numArgs:na
    "given a smalltalk argument array, convert to java objects as appropriate.
     Currently, only Strings and booleans are converted."

    |sigIndex newArgIndex newArgArray|

    sigIndex := newArgIndex := 1.

    newArgArray := Array new:na.
    argArray do:[:arg |
	|type newArg|

	type := argSigSpecArray at:sigIndex.
	sigIndex := sigIndex + 1.
	newArg := self convertToJava:arg type:type.
	newArgArray at:newArgIndex put:newArg.
	newArgIndex := newArgIndex + 1.
	(type == #long or:[type == #double]) ifTrue:[
	    newArgIndex > na ifTrue:[
		self halt:'should not happen'
	    ].
	    newArgArray at:newArgIndex put:nil.
	    newArgIndex := newArgIndex + 1.
	]
    ].

    ^ newArgArray

    "Created: / 5.11.1998 / 18:30:57 / cg"
    "Modified: / 6.11.1998 / 00:45:00 / cg"
!

convertToJava:arg type:type
    "given a smalltalk argument, convert to a java object as appropriate."

    ^ self
        convertToJava:arg
        type:type
        ifFail:[:msg :default |
                    ArgumentConversionErrorSignal
                        raiseWith:arg
                        errorString:msg.
                    default
               ]

    "Created: / 06-11-1998 / 00:45:13 / cg"
    "Modified: / 20-10-2010 / 11:08:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

convertToJava: arg type: type ifFail: failBlock
    "given a smalltalk argument, convert to a java object as appropriate.
     Currently, only a few types are converted."

    | expectedCls  f  failValue |

    type == #boolean ifTrue: [
        arg == true ifTrue: [ ^ 1 ].
        arg == false ifTrue: [ ^ 0 ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: 0
    ].
    type == #int ifTrue: [
        arg isInteger ifTrue: [
            (arg between: (16r8000000 * -1) and: 16r7FFFFFFF) ifTrue: [ ^ arg ].
            ^ failBlock value: ('integer range; cannot convert argument to ' , type)
                value: 0.
        ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: 0
    ].
    type == #long ifTrue: [
        arg isInteger ifTrue: [
            (arg "(-1 * 16r800000000000000) -->" between: -576460752303423488
                and: 16r7FFFFFFFFFFFFFFF) ifTrue: [ ^ arg ].
            ^ failBlock value: ('integer range; cannot convert argument to ' , type)
                value: 0
        ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: 0
    ].
    (type == #float) ifTrue: [
        arg isLimitedPrecisionReal ifTrue: [ ^ arg asShortFloat ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: 0.0.
    ].
    (type = 'java.lang.Float') ifTrue: [
        arg isLimitedPrecisionReal ifTrue: [
            f := (Java at: 'java.lang.Float') new.
            f perform: #'<init>(F)V' with: (arg asShortFloat).
            self halt.
            ^ f.
        ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: 0.0.
    ].
    (type = 'java.lang.Double') ifTrue: [
        arg isLimitedPrecisionReal ifTrue: [
            f := (Java at: 'java.lang.Double') new.
            f perform: #'<init>(D)V' with: (arg asFloat).
            self halt.
            ^ f.
        ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: 0.0.
    ].
    (type == #double) ifTrue: [
        arg isLimitedPrecisionReal ifTrue: [ ^ arg asFloat ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: 0.0.
    ].
    (type == #char) ifTrue: [
        arg isCharacter ifTrue: [ ^ arg asciiValue ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: 0
    ].
    (type = 'char[]') ifTrue: [
        arg isString ifTrue: [ ^ arg ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: ''
    ].
    (type = 'int[]') ifTrue: [
        (arg isArray or: [ arg isMemberOf: SignedIntegerArray ]) ifTrue: [ ^ arg ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: ''
    ].
    (type = 'long[]') ifTrue: [
        (arg isArray or: [ arg isMemberOf: SignedIntegerArray ]) ifTrue: [ ^ arg ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: ''
    ].
    (type = 'float[]') ifTrue: [
        (arg isArray or: [ arg isMemberOf: FloatArray ]) ifTrue: [ ^ arg ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: ''
    ].
    (type = 'double[]') ifTrue: [
        (arg isArray or: [ arg isMemberOf: DoubleArray ]) ifTrue: [ ^ arg ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: ''
    ].
    (type endsWith: '[]') ifTrue: [
        (arg isArray or: [ arg isNil ]) ifTrue: [ ^ arg ].
        ^ failBlock value: ('cannot convert argument to ' , type) value: ''
    ].
    expectedCls := JavaVM classForName: type.
    (arg isKindOf: expectedCls) ifTrue: [
        "/ matches class and subclasses
        ^ arg
    ].
    (type = 'java.lang.Object') ifTrue: [
        "/ matches any
        ^ arg
    ].
    (type = 'java.lang.String') ifTrue: [
        arg isString ifTrue: [ ^ Java as_String: arg ].
        failValue := ''
    ].
    arg isNil ifTrue: [
        "/ matches any
        ^ arg
    ].
    self halt.
    ^ failBlock value: ('cannot convert argument to ' , type) value: failValue

    "Created: / 06-11-1998 / 00:46:19 / cg"
    "Modified: / 06-11-2001 / 13:28:29 / cg"
    "Modified: / 17-01-2011 / 10:08:04 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 17-03-2011 / 14:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

convertToSmalltalk:jObj type:type
    "given a java return value, convert to a smalltalk object as appropriate.
     Currently, only a few types are converted."

    "JV@2011-02-04"
    "Hack for primitive types"
    (JavaDescriptor baseTypesByTypeName keys includes: type) ifTrue:[^jObj].
    "jObj is registered for the specified type?"

    "
    (JavaObjectDictionary new reflectionOf: jObj class name)  = (Java classForName: type) ifTrue: [
        ^ jObj
    ].
    "

    type == #boolean ifTrue:[
        jObj == 0 ifTrue:[
            ^ false
        ].
        ^ true
    ].

    type == #void ifTrue:[
        ^ nil
    ].

    (type = 'java.lang.String') ifTrue:[
        ^ Java as_ST_String:jObj
    ].

"/    (type = 'java.lang.Float') ifTrue:[
"/        ^ jObj instVarNamed:'value'
"/    ].
"/    (type = 'java.lang.Double') ifTrue:[
"/        ^ jObj instVarNamed:'value'
"/    ].

    (type == #char) ifTrue:[
        jObj isInteger ifTrue:[
            ^ Character value:jObj
        ].
    ].

    ^ jObj

    "Created: / 06-11-1998 / 00:49:53 / cg"
    "Modified: / 11-11-1998 / 02:08:11 / cg"
    "Modified: / 17-01-2011 / 10:42:56 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 08-04-2011 / 17:04:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupMethod:selector numArgs:nargs in:aClass static:staticMethod
    "lookup a method"

    |method cls sel|

    sel := selector.
    (sel includes:$:) ifTrue:[
	sel := sel copyTo:(sel indexOf:$:)-1
    ].

    sel := sel asSymbolIfInterned.
    sel notNil ifTrue:[
	cls := aClass.

	[cls notNil
	and:[cls ~~ JavaObject
	and:[cls ~~ JavaClass]]] whileTrue:[
	    cls methodDictionary keysAndValuesDo:[:jSel :m |
		|aMethod|

		aMethod := m.
		aMethod isWrapped ifTrue:[
		    aMethod := aMethod originalMethod
		].

		((jSel == sel)
		or:[aMethod name = sel
		or:[aMethod signatureNameWithoutReturnType = sel]])
		ifTrue:[
		    aMethod numArgs == nargs ifTrue:[
			staticMethod == (aMethod isStatic) ifTrue:[
			    ^ m
			]
		    ]
		]
	    ].

	    cls := cls superclass.
	].
    ].
"/ self halt.
    ^ nil

    "Created: / 17.8.1997 / 18:25:47 / cg"
    "Modified: / 16.11.1998 / 16:46:48 / cg"
!

lookupMethods:selector numArgs:nargs in:aClass static:staticMethod
    "lookup methods matching a selector.
     This is a special entry for doesNotUnderstand redirection
     (the caller must select the one method which fits the argument(s) best."

    |methods cls sel|

    sel := selector.
    (sel includes:$:) ifTrue:[
	sel := sel copyTo:(sel indexOf:$:)-1
    ].

    sel := sel asSymbolIfInterned.
    sel notNil ifTrue:[
	cls := aClass.

	[cls notNil
	and:[cls ~~ JavaObject
	and:[cls ~~ JavaClass]]] whileTrue:[
	    cls methodDictionary keysAndValuesDo:[:jSel :aMethod |
		((jSel == sel)
		or:[aMethod name = sel
		or:[aMethod signatureNameWithoutReturnType = sel]])
		ifTrue:[
		    (nargs isNil
		    or:[aMethod numArgs == nargs]) ifTrue:[
			staticMethod == (aMethod isStatic) ifTrue:[
			    methods isNil ifTrue:[
				methods := OrderedCollection new
			    ].
			    methods add:aMethod
			]
		    ]
		]
	    ].

	    cls := cls superclass.
	].
    ].
    ^ methods ? #()

    "Created: / 4.11.1998 / 19:04:51 / cg"
    "Modified: / 4.11.1998 / 19:31:33 / cg"
! !

!JavaClass class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaClass class methodsFor:'signature parsing'!

initialValueFromSignature:aSignature
    "given a signature, return an initializer value"

    |s|

    s := aSignature readStream.
    ^ self initialValueFromStream:s.

    "
     JavaClass initialValueFromSignature:'LObject;'
     JavaClass initialValueFromSignature:'B'
     JavaClass initialValueFromSignature:'I'
    "


! !

!JavaClass class methodsFor:'special'!

deinitClasses

    Smalltalk allClassesDo:
        [:cls|cls isJavaClass ifTrue:[cls deinit]].
    self flushClassesInitOrder.

    "
        JavaClass deinitClasses
    "

    "Created: / 25-10-2010 / 16:47:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flushClassesInitOrder
    OrderOfClassInits := nil

    "Created: / 6.11.2001 / 09:49:49 / cg"
!

orderOfClassInits
    ^ OrderOfClassInits

    "Created: / 12.11.1998 / 15:35:57 / cg"
!

setInstanceVariableStringFromFields:f in:aClass
    |varNames|

    varNames := ''.
    f do:[:aField |
	varNames := varNames , aField name , ' '
    ].
    aClass setInstanceVariableString:varNames.

    "Created: 15.4.1996 / 16:42:52 / cg"
!

startRememberingOrderOfClassInits
    OrderOfClassInits := OrderedCollection new.

    "Created: / 12.11.1998 / 15:26:32 / cg"
    "Modified: / 12.11.1998 / 15:29:10 / cg"
! !

!JavaClass methodsFor:'* uncategorized *'!

includesInterface: interface
    | cls |

    self == interface ifTrue: [ ^ true ].

    cls := self.
    [ cls isJavaClass ] whileTrue:[
        cls interfaces do:[:i|(i includesInterface: interface) ifTrue:[ ^ true ]].
        cls := cls superclass.
    ].
    ^ false.

    "Created: / 21-05-2013 / 00:06:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'accessing'!

allFields
    "Returns all fields, including those inherited from
     a superclass"
    | cls all |

    cls := self.
    all  := OrderedCollection new.
    [ cls isJavaClass ] whileTrue:[
        all addAll: cls fields.
        cls := cls superclass
    ].
    ^all.

    "Created: / 04-04-2012 / 01:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allInterfaces

    | ifaces cls |

    ifaces := Set new.
    cls := self.
    [ cls isJavaClass ] whileTrue:
        [cls interfaces do:[:iface| ifaces add: iface; addAll: iface allInterfaces].
        cls := cls superclass].
    ^ifaces.

    "Created: / 05-02-2011 / 23:51:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

allStaticFields
    "Returns all fields, including those inherited from
     a superclass"
    | cls all |

    cls := self.
    all  := OrderedCollection new.
    [ cls isJavaClass ] whileTrue:[
        all addAll: cls staticFields.
        cls := cls superclass
    ].
    ^all.

    "Created: / 04-04-2012 / 01:37:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotations
    annotations isNil ifTrue:[
        ^ JavaClassAnnotationContainer empty
    ].
    ^ annotations

    "Modified: / 11-01-2015 / 07:47:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotations:something
    annotations := something.
!

binaryName
    "Returns binary name of the class (i.e., name with slashes).
     To get name as seen by programmer, use #javaName"

    ^ binaryName

    "Created: / 08-10-2013 / 19:24:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classLoader
    ^ classLoader
!

classLoader:classLoaderOrNil
    classLoader := classLoaderOrNil.

    "Modified: / 18-02-2012 / 20:21:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compiledMethodAt:name
    "redefined to find the constructor"

    |m|

    m := super compiledMethodAt:name.
    m isNil ifTrue:[
	name = self lastName ifTrue:[
	    ^ super compiledMethodAt:#'<init>()V'
	].
    ].
    ^ m

    "
     JAVA::java::lang::Object compiledMethodAt:#Object
    "

    "Created: / 24.12.1999 / 02:02:50 / cg"
    "Modified: / 24.12.1999 / 02:04:46 / cg"
!

compiledMethodAt:name signature:sig
    "lookup the classes methodDictionary"

    methodDictionary keysAndValuesDo:[:mFullSelector :aMethod |
	aMethod name == name ifTrue:[
	    aMethod signature == sig ifTrue:[
		^ aMethod
	    ]
	]
    ].
    ^ nil

    "Created: 1.8.1997 / 00:01:58 / cg"
!

constantPool
    ^ constantPool
!

declaringClass
    | innerClassesAttr |

    innerClassesAttr := self getAttribute: #InnerClasses.
    innerClassesAttr notNil ifTrue:[
        innerClassesAttr do:[:each |
            | innerClassRef outerClassRef |

            innerClassRef := self constantPool at: each innerClassRefIndex.
            outerClassRef := each outerClassRefIndex ~~ 0 ifTrue:[ self constantPool at: each outerClassRefIndex  ] ifFalse:[ nil ].
            (innerClassRef name = binaryName and:[outerClassRef notNil]) ifTrue:[
                ^ outerClassRef resolve: false.
            ]
        ].
    ].
    ^ nil

    "Created: / 04-08-2014 / 22:42:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2014 / 14:23:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enclosingClass
    "Returns the immediately enclosing class of the underlying
     this class.  If the this class is a top level class this
     method returns nil."

    | enclosingMethodAttr |

    enclosingMethodAttr := self getAttribute: #EnclosingMethod.
    enclosingMethodAttr isNil ifTrue:[
        ^ self declaringClass
    ].
    ^ (self constantPool at: enclosingMethodAttr first) resolve: false.

    "Created: / 13-09-2013 / 01:26:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2014 / 12:59:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enclosingMethod
    | enclosingMethodAttr enclosingClass |

    enclosingMethodAttr := self getAttribute: #EnclosingMethod.
    enclosingMethodAttr isNil ifTrue:[ ^ nil ].
    enclosingMethodAttr second == 0 ifTrue:[ ^ nil ].
    enclosingClass := (self constantPool at: enclosingMethodAttr first) resolve: false.
    ^ enclosingClass compiledMethodAt: (self constantPool at: enclosingMethodAttr second) selector

    "Created: / 13-09-2013 / 01:28:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 03-12-2014 / 13:00:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ensureHasAnnotations
    annotations isNil ifTrue:[
        annotations := JavaAnnotationContainer for:self
    ].
    ^ annotations

    "Created: / 25-02-2011 / 16:02:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2011 / 17:13:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:54:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fields
    ^ fields
!

javaClass

    ^ self

    "Modified: / 22-05-2011 / 13:32:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaComponentClass

    "/ this is really confusing design, should return nil here and only
    "/ overwrite in JavaArray....
    ^self

    "Created: / 20-12-2010 / 22:02:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-05-2011 / 23:26:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 08-11-2013 / 23:07:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaName
    "the javaname - as seen by a java programmer.
     (with '/'s replaced by dots) extract from the fullName"

    ^ binaryName copyReplaceAll:$/ with:$.

    "
     Java allClasses first fullName
     Java allClasses first name
     Java allClasses first javaName
     Java allClasses first javaPackage
     Java allClasses first package
    "
!

javaPackage
    "the javaPackage - as seen by a java programmer.
     (with '/'s replaced by dots) extract from the fullName"

    |components|

    components := binaryName asCollectionOfSubstringsSeparatedBy:$/.
    components size > 1 ifTrue:[
        ^ (components copyButLast:1) asStringWith:$.
    ].
    ^ ''

    "
     Java allClasses first fullName
     Java allClasses first javaPackage
     Java allClasses first package
    "

    "Modified: / 27-03-2015 / 16:19:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaPackageAsDirname
    "the javaPackage - as directory in class path"

    |components|

    components := binaryName asCollectionOfSubstringsSeparatedBy:$/.
    components size > 1 ifTrue:[
        ^ (components copyButLast:1) asStringWith: Filename separator
    ].
    ^ binaryName

    "
     Java allClasses first fullName
     Java allClasses first javaPackage
     Java allClasses first package
    "

    "Created: / 30-11-2010 / 12:17:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaWrapperClass

    binaryName == #'java/lang/String' ifTrue:[ ^ String ].
    self error:'Should not happen'

    "Created: / 20-04-2012 / 20:03:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lastName
    ^ binaryName copyFrom:(binaryName lastIndexOf:$/)+1

    "Created: / 5.11.1998 / 19:16:00 / cg"
!

nameWithoutNameSpacePrefix
    ^ self lastName

    "Created: / 20-01-1997 / 13:05:30 / cg"
    "Modified: / 25-07-2014 / 10:09:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameWithoutPrefix
    ^ self lastName

    "Created: / 20-01-1997 / 13:06:06 / cg"
    "Modified: / 20-04-2012 / 18:35:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

package
    "Return the package symbol of the class as seen by Smalltalk"

    | packageAnnotation p i |

    "/ First, look if the class is annotated by stx.libjava.annotation.Package.
    "/ If so, return annotation's value as package name...

    annotations notNil ifTrue:[
        packageAnnotation := annotations runtimeVisible at: 'Lstx/libjava/annotation/Package;' ifAbsent:[ nil ].
        packageAnnotation notNil ifTrue:[
            ^ packageAnnotation value
        ].
    ].

    ((self getAttribute: #EnclosingMethod) notNil or:[ (self getAttribute: #InnerClasses) notNil ]) ifTrue:[
        | top |

        top := self topEnclosingClass.
        top notNil ifTrue:[ ^ top package ].
    ].

    "/ If not, extract java package name and prepend java:.
    "/ For default package, return java:(default).
    i := binaryName lastIndexOf:$/.
    p := binaryName copyTo:i - 1.
    p isEmpty ifTrue:[
        ^ #'java:(default)'
    ].
    ^ 'java:' , p

    "
     Java allClasses first fullName
     Java allClasses first package
     Java allClasses first javaPackage
    "

    "Modified: / 05-08-2014 / 22:14:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

protectionDomain
    ^ attributes at: #ProtectionDomain ifAbsent:[ nil ]

    "Modified: / 07-12-2014 / 01:39:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

protectionDomain:something
    attributes  := attributes at: #ProtectionDomain putOrAppend: something

    "Modified: / 07-12-2014 / 01:40:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

runtimeVisibleAnnotationsAsBytesOrNil
    annotations isNil ifTrue:[
        ^ nil
    ].
    annotations runtimeVisible isNil ifTrue:[
        ^ nil
    ].
    ^ annotations runtimeVisible bytes

    "Created: / 25-02-2011 / 16:48:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 15:54:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSignature: aSymbol
    attributes := attributes at: #GenericSignature putOrAppend: aSymbol.

    "Created: / 13-08-2011 / 00:30:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:39:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

signatureJ
    "stupid naming, but superclass defines signature too"

    ^ attributes at: #GenericSignature ifAbsent:[ nil ]

    "Created: / 13-08-2011 / 00:30:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:39:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source
    "Returns a source of the class as String or nil of no source is found along the Java's source paths."
    | sourceString stream |
    (sourceString := self sourceString) notNil ifTrue: [ ^ sourceString ].
    ^ [
        stream := self sourceStream.
        stream notNil ifTrue:[
            stream contents withTabsExpanded asString.
        ] ifFalse:[
            nil
        ].
    ] ensure:[
        stream notNil ifTrue:[stream close]
    ].

    "
     (Java at:'java.awt.Frame') source
     (Java at:'ArcTest') source
     (Java at:'ArcCanvas') source
    "

    "Modified: / 30-07-1997 / 14:31:01 / cg"
    "Modified: / 07-12-2014 / 01:32:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 17-02-2015 / 13:43:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceDecompiled
    "Returns a decompiled source code as String."

    | resources | 

    resources := self classResources.

    ^ String streamContents:[:s |
        s nextPutAll: '/**'; cr.
        s nextPutAll: ' * ' ; nextPutAll: (resources string: 'No source has been found along configured source path:'); cr.
        s nextPutAll: ' * ' ; cr.
        Java effectiveSourceDirectories do:[:d | 
            s nextPutAll: ' *     '; nextPutAll: d asString; cr.
        ].
        s nextPutAll: ' * ' ; cr.
        s nextPutAll: ' * ' ; nextPutAll: (resources string: 'You may add more source directories or archives by evaluating:'); cr.
        s nextPutAll: ' * ' ; cr.
        s nextPutAll: ' *     '; nextPutAll: 'Java addToSourceDirectories: ''/path/to/sources''.' ; cr.
        s nextPutAll: ' */'; cr.                                                                       
        JavaDecompiler definitionOf:self on:s
    ]
    "
    JAVA java lang Object sourceDecompiled
    "

    "Created: / 17-02-2015 / 12:07:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceFile
    ^ classFilename

    "Modified: / 07-08-2014 / 12:26:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceStream
    | sourceString |
    ^ (sourceString := self sourceString) notNil
        ifTrue:[ sourceString readStream ]
        ifFalse:[Java classSourceStreamFor: self ]

    "
     (Java at:'java.awt.Frame') source
     (Java at:'ArcTest') source
     (Java at:'ArcCanvas') source
    "

    "Created: / 19-09-2013 / 12:41:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:32:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceString
    ^attributes at: #SourceString ifAbsent: [ nil ]

    "Created: / 19-04-2013 / 09:28:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:32:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

staticFields
    ^ staticFields
!

superinterface

    | ifaces |

    self assert: self isInterface message: 'Type must be an interface'.
    (ifaces := self interfaces) size == 0 ifTrue:[^nil].
    ifaces size = 1 ifTrue:[^ifaces first].

    self error: 'Should not happen!!'.
    ^nil

    "Created: / 04-02-2011 / 12:35:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

theClass

    ^ self

!

topEnclosingClass
    | current enclosing |

    current := enclosing := self enclosingClass.
    [ current notNil ] whileTrue:[
        enclosing := current.
        current := current enclosingClass.
    ].
    ^ enclosing

    "Created: / 13-09-2013 / 11:22:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

topEnclosingMethod
    | current enclosing |

    current := enclosing := self enclosingMethod.
    [ current notNil ] whileTrue:[
        enclosing := current.
        current := current enclosingMethod.
    ].
    ^ enclosing

    "Created: / 13-09-2013 / 11:22:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

typeOfField:aFieldName

    fields do:[:aField |
	aField name = aFieldName ifTrue:[
	    ^ aField type
	]
    ].
    self error:'no such field'

    "
     (JAVA at:#'java/awt/image/ColorModel') typeOfField:'pixel_bits'
    "

    "Modified: 21.1.1997 / 22:48:28 / cg"
!

versions
    "
    Return all existing versions of this class.
    A new version is added when a class is
    updated by runtime code reload and removed when all instances of
        the version die
    "

    ^ attributes at: #Versions ifAbsent: [ nil ]

    "Created: / 14-04-2013 / 12:10:54 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:36:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versions: aWeakArray
    "
    set this class' versions. It is expected that all versions of the
    class will share the same weak array instance.
    "
    attributes :=attributes at:#Versions putOrAppend: aWeakArray.

    "Created: / 14-04-2013 / 12:28:09 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:36:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

versionsArray
    | versions |

    versions := self versions.
    ^ versions isNil ifTrue: [ Array with: self ] ifFalse: [ versions ].

    "Created: / 08-10-2013 / 18:38:52 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:37:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'accessing - java'!

javaMirror
    ^self javaMirrorClass forClass: self.

    "Created: / 01-08-2012 / 00:18:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaMirrorClass
    ^JavaMirror mirrorClassForJavaClass

    "Created: / 31-07-2012 / 17:39:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'adding / removing'!

removeFromSystem
     Java removeClass:self

    "Created: 12.8.1997 / 02:46:51 / cg"
! !

!JavaClass methodsFor:'autoboxing'!

javaBox:anObject
    ^ anObject

    "Created: / 14-08-2011 / 22:58:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaUnwrap: object

    | nm |

    object isNil ifTrue:[ ^ nil ].

    nm := object class binaryName.

    nm == #'java/lang/Byte' ifTrue:[
        ^object instVarNamed: #value.
    ].
    nm == #'java/lang/Short' ifTrue:[
        ^object instVarNamed: #value.
    ].
    nm == #'java/lang/Integer' ifTrue:[
        ^object instVarNamed: #value.
    ].
    nm == #'java/lang/Long' ifTrue:[
        ^object instVarNamed: #value.
    ].
    nm == #'java/lang/Character' ifTrue:[
        ^Character codePoint: (object instVarNamed: #value)
    ].
    nm == #'java/lang/Boolean' ifTrue:[
        ^(object instVarNamed: #value) == 1
    ].
    nm == #'java/lang/String' ifTrue:[
        ^ Java as_ST_String: object
    ].
    nm == #'java/lang/Class' ifTrue:[
        ^ JavaVM classForJavaClassObject: object
    ].

    ^object

    "Created: / 10-12-2011 / 19:54:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-12-2011 / 18:05:29 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 07-11-2013 / 12:50:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaWrap: object

    object isNil ifTrue:[ ^ nil ].

    object class isJavaPrimitiveType ifTrue:[
       (self binaryName == #'java/lang/Object' or:[self == object class javaWrapperClass]) ifTrue:[
            ^object class javaWrapperClass newCleared
                instVarNamed: #value put: object;
                yourself
        ].
    ].

    object isString ifTrue:[
        (self binaryName == #'java/lang/Object' or:[
        self binaryName == #'java/lang/String']) ifTrue:[
            ^ Java as_String: object
        ].
    ].

    ^object

    "Modified: / 12-12-2011 / 18:05:29 / kursjan <kursjan@fit.cvut.cz>"
    "Created: / 24-02-2012 / 19:32:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:43:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'browser interface'!

isVisualStartable
    "return true, if this is an application class,
     which can be started via #open"
    "/ if I have a main() method, I am

    (self compiledMethodAt: #'main([Ljava/lang/String;)V') notNil ifTrue: [
        ^ true
    ].
    (self isSubclassOf: (JavaVM at: 'java/applet/Applet')) ifTrue: [
        ^ true.
    ].
    ^ false
!

open
    "start a thread for my main method"

    "/ if I have a main, call it ...

    (self compiledMethodAt:#'main([Ljava/lang/String;)V') notNil ifTrue:[
	^ self startMain
    ].

    "/ otherwise, create a frame and wrap me;
    "/ as in:

"/    public static void main(String args[]) {
"/        Frame f = new Frame("myName");
"/        mySelf me = new mySelf();
"/
"/        me.init();
"/        me.start();
"/
"/        f.add("Center", me);
"/        f.setSize(300, 300);
"/        f.show();
"/    }

    ^ self startApplet

    "Created: / 15.1.1998 / 17:18:30 / cg"
    "Modified: / 3.11.1998 / 22:51:47 / cg"
! !

!JavaClass methodsFor:'compiler interface'!

browserClass
    "return the browser to use for this class -
     this can be redefined in special classes, to get different browsers"

"/    ^ JavaBrowser
    ^ super browserClass.

    "Modified: / 14.10.1998 / 15:28:38 / cg"
!

syntaxHighlighterClass
    "return the class to use for syntaxHighlighting (prettyPrinting) this class -
     this can be redefined in special classes, to highlight classes with
     Lisp, Prolog, ASN1, Basic :-) or whatever syntax."

    ^ self class == JavaClass ifTrue:[
        super syntaxHighlighterClass
    ] ifFalse:[
        JavaLanguage instance syntaxHighlighterClass
    ]

    "Created: / 15-02-2012 / 01:43:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'compiling'!

recompileMethodsAccessingGlobal:aGlobalKey
    "/ dummy for now

    "Created: / 9.11.1999 / 16:42:09 / cg"
! !

!JavaClass methodsFor:'documentation support'!

htmlDocumentation
    ^ nil "/ replace by access to javadoc-generated documentation later

    "Modified: 22.3.1997 / 14:18:50 / cg"
! !

!JavaClass methodsFor:'exception handling support'!

accepts: signal
    "Return true, iff receicer is a throwable and
     handles given signal (presumably another throwable class)"

    | cls |

    signal isJavaClass ifFalse:[ ^ false ].
    self == signal ifTrue:[ ^ true ].
    cls := signal.
    [ cls ~~ JavaObject ] whileTrue:[
        self == cls ifTrue:[ ^ true ].
        cls := cls superclass.
    ].
    ^false

    "Created: / 18-03-2012 / 14:19:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

creator

    ^self class.

    "Created: / 14-10-2013 / 11:29:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

handlerForSignal:exceptionHandler context:theContext originator:originator
    ^nil

!

handles: anObject

    Transcript showCR:'>>>> JavaClass>>handles: ' , anObject printString.
    Transcript showCR:'     from: ', thisContext sender printString.
    ^false

    "Created: / 18-03-2012 / 14:19:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isControlInterrupt
    ^false

    "Created: / 20-08-2012 / 14:17:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isExceptionCreator

"/    ^false
    ^self isThrowable

    "Created: / 18-03-2012 / 20:34:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isExceptionHandler

"/    ^false
    ^self isThrowable

    "Created: / 18-03-2012 / 14:18:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isQuerySignal

    ^false

    "Created: / 18-03-2012 / 22:18:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isThrowable
    "Returns true, if the receiver is an instance
     of java.lang.Throwable, false otherwise"

    | cls |
    cls := self.
    [ cls ~~ JavaObject ] whileTrue:[
        cls binaryName == #'java/lang/Throwable' ifTrue:[
            ^true
        ].
        cls := cls superclass.
    ].
    ^false

    "Created: / 18-03-2012 / 20:35:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:36:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

parent

    ^nil

    "Created: / 18-03-2012 / 22:19:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

signal

    ^self class.

    "Created: / 05-07-2012 / 08:56:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'executing programs'!

startApplet
    |f me stub top appFrame|

    top := StandardSystemView new.
    appFrame := JavaEmbeddedFrameView new.
    appFrame origin:0.0@0.0 corner:1.0@1.0.
    top addSubView:appFrame.

    appFrame appletIsPreloaded:true.
    appFrame codeURL:'file:/dummy'.
    appFrame codeBaseURL:'file:/dummy'.
    appFrame autoSetupApplet:true.
    appFrame autoStartApplet:true.
    appFrame autoDestroyApplet:true.


    top open.
    ^ self.

    "/ TODO: setup embeddedAppletFrame correctly
    "/ (for getParameter to work ...)

    "/ create a frame and wrap me;
    "/ as in:

"/    public static void main(String args[]) {
"/        Frame f = new Frame("myName");
"/        mySelf me = new mySelf();
"/
"/        me.init();
"/        me.start();
"/
"/        f.add("Center", me);
"/        f.setSize(300, 300);
"/        f.show();
"/    }
    f := (Java at:'java.awt.Frame') basicNew.
    f perform:#'<init>(Ljava/lang/String;)V' with:(Java as_String:self name).
self halt.
    me := self basicNew.
    me perform:#'<init>()V'.
self halt.

    stub := (Java at:'netscape.applet.EmbeddedAppletFrame') new.
    me instVarNamed:'stub' put:stub.
self halt.

    me perform:#'init()V'.
    me perform:#'start()V'.
self halt.

    f perform:#'add(Ljava/lang/String;Ljava/awt/Component;)Ljava/awt/Component;'
	 with:(Java as_String:'Center')
	 with:me.
self halt.
    f perform:#'setSize(II)V' with:300 with:300.
self halt.
    f perform:#'show()V'.
self halt.

    "Modified: / 3.11.1998 / 23:04:41 / cg"
    "/ TODO: setup embeddedAppletFrame correctly
    "/ (for getParameter to work ...)

    "/ create a frame and wrap me;
    "/ as in:

"/    public static void main(String args[]) {
"/        Frame f = new Frame("myName");
"/        mySelf me = new mySelf();
"/
"/        me.init();
"/        me.start();
"/
"/        f.add("Center", me);
"/        f.setSize(300, 300);
"/        f.show();
"/    }
    f := (Java at:'java.awt.Frame') basicNew.
    f perform:#'<init>(Ljava/lang/String;)V' with:(Java as_String:self name).
self halt.
    me := self basicNew.
    me perform:#'<init>()V'.
self halt.

    stub := (Java at:'netscape.applet.EmbeddedAppletFrame') new.
    me instVarNamed:'stub' put:stub.
self halt.

    me perform:#'init()V'.
    me perform:#'start()V'.
self halt.

    f perform:#'add(Ljava/lang/String;Ljava/awt/Component;)Ljava/awt/Component;'
	 with:(Java as_String:'Center')
	 with:me.
self halt.
    f perform:#'setSize(II)V' with:300 with:300.
self halt.
    f perform:#'show()V'.
self halt.

    "Modified: / 3.11.1998 / 23:04:41 / cg"
!

startMain
    "start a thread for my main() method"

    ^ self startMainWithArgumentString:nil

    "Modified: / 30.12.1998 / 20:24:58 / cg"
!

startMainWithArgumentString:aCommandLineString
    "start a thread for my main() method, passing a string with arguments"

    |p|

    p := Java javaProcessForMainOf:self argumentString:aCommandLineString.
    p notNil ifTrue:[
        p resume.
        AbortOperationRequest handle:[:ex |
p == JavaVM javaScreenUpdaterThread ifTrue:[self halt].
p == JavaVM javaEventQueueThread ifTrue:[self halt].
            p terminate.
            ex reject.
        ] do:[
            p waitUntilTerminated
        ].
    ]

    "Modified: / 24.12.1999 / 02:35:04 / cg"
! !

!JavaClass methodsFor:'fileOut'!

basicFileOutDefinitionOn:aStream withNameSpace:nameSpaceBoolean

    | source |
    source := self theNonMetaclass source.
    source notNil ifTrue:[
        aStream nextPutAll: source
    ] ifFalse:[
        JavaDecompiler definitionOf:self on:aStream
    ]

    "Modified: / 22-03-1997 / 14:30:28 / cg"
    "Modified: / 14-12-2011 / 22:22:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOut

    self warn:'fileOut not yet supported'

    "Created: / 22-03-1997 / 14:35:43 / cg"
    "Modified (format): / 12-10-2016 / 00:04:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutAs:filenameString
    "create a file consisting of all methods in myself in
     sourceForm, from which the class can be reconstructed (by filing in).
     The given fileName should be a full path, including suffix.
     Care is taken, to not clobber any existing file in
     case of errors (for example: disk full).
     Also, since the classes methods need a valid sourcefile, the current
     sourceFile may not be rewritten."

    |filename fileExists needRename sameFile s mySourceFileID anySourceRef outStream savFilename|

    self isLoaded ifFalse:[
        ^ FileOutErrorSignal
            raiseRequestWith:self
                 errorString:' - will not fileOut unloaded class: ', self name
    ].

    filename := filenameString asFilename.

    "
     if file exists, copy the existing to a .sav-file,
     create the new file as XXX.new-file,
     and, if that worked rename afterwards ...
    "
    [
        fileExists := filename exists.
        fileExists ifTrue:[
            sameFile := false.

            "/ check carefully - maybe, my source does not really come from that
            "/ file (i.e. all of my methods have their source as string)

            anySourceRef := self sourceString isNil.

            anySourceRef ifTrue:[
                s := self sourceStream.
                s notNil ifTrue:[
                    OperatingSystem isUNIXlike ifTrue:[
                        mySourceFileID := s pathName asFilename info id.
                        sameFile := (filename info id) == mySourceFileID.
                    ] ifFalse:[
                        mySourceFileID := s pathName asFilename asAbsoluteFilename.
                        sameFile := (filename asFilename asAbsoluteFilename) = mySourceFileID.
                    ].
                    s close.
                ] ifFalse:[
                    sameFile := false.
                ].
            ].

            sameFile ifTrue:[
                ^ FileOutErrorSignal
                    raiseRequestWith:filenameString
                    errorString:(' - may not overwrite sourcefile: %1\try again after loading sources in the browser' withCRs bindWith:filenameString)
            ].

            outStream := FileStream newTemporaryIn:filename directory.
            outStream fileName accessRights:filename accessRights.
            needRename := true
        ] ifFalse:[
            "/ another possible trap: if my sourceFileName is
            "/ the same as the written one AND the new files directory
            "/ is along the sourcePath, we also need a temporary file
            "/ first, to avoid accessing the newly written file.

            self instAndClassMethodsDo:[:m |
                |mSrc mSrcFilename|

                (anySourceRef isNil and:[(mSrc := m sourceFilename) notNil]) ifTrue:[
                    mSrcFilename := mSrc asFilename.
                    (mSrcFilename baseName = filename baseName
                     and:[mSrcFilename exists]) ifTrue:[
                        anySourceRef := mSrcFilename.
                    ]
                ]
            ].
            anySourceRef notNil ifTrue:[
                outStream := FileStream newTemporaryIn:filename directory.
                outStream fileName accessRights:anySourceRef accessRights.
                needRename := true
            ] ifFalse:[
                outStream := filename writeStream.
                needRename := false
            ]
        ].
    ] on:FileStream openErrorSignal do:[:ex|
        ^ FileOutErrorSignal
                raiseRequestWith:filename name
                errorString:(' - cannot create file:', filename name)
    ].
    self fileOutOn:outStream.
    outStream syncData; close.

    "
     finally, replace the old-file
     be careful, if the old one is a symbolic link; in this case,
     we have to do a copy ...
    "
    needRename ifTrue:[
        fileExists ifTrue:[
            savFilename := filename addSuffix:'.sav~'.
            filename renameTo:savFilename.
        ].
        outStream fileName renameTo:filename.
        fileExists ifTrue:[
            savFilename delete.
        ].
    ].

    "Created: / 08-08-2014 / 21:41:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:33:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutInto: directory
    "writes itself into the given directory including package hierarchy"

    | packageDir |
    packageDir := directory / self javaPackageAsDirname.
    packageDir recursiveMakeDirectory.
    packageDir / (self lastName , '.java')
        writingFileDo: [:out | self fileOutOn: out ].

    "Created: / 08-12-2012 / 22:32:19 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 09-12-2012 / 09:07:58 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

fileOutMethod:aMethod on:aStream
    "file out aMethod onto aStream. Used for example to write individual changeChunks"

    |cat source privacy|

    self assert: aMethod programmingLanguage isSmalltalk.

    aStream nextPutChunkSeparator.
"/    aStream nextPutAll: 'JAVA'.
"/    (self name tokensBasedOn: $/) do:[:each|
"/        aStream space; nextPutAll: each.
"/    ].
    aStream nextPutAll:'(Java classForName:'''.
    aStream nextPutAll:(self javaName).
    aStream nextPutAll:''')'.

    (privacy := aMethod privacy) ~~ #public ifTrue:[
        aStream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
    ] ifFalse:[
        aStream nextPutAll:' methodsFor:'.
    ].

    cat := aMethod category ? ''.
    aStream nextPutAll:cat asString storeString.
    aStream nextPutChunkSeparator; cr; cr.

    source := aMethod source.
    source isNil ifTrue:[
        FileOutErrorSignal
            raiseRequestWith:self
            errorString:(' - no source for method: ' ,
                         self name , '>>' ,
                         (self selectorAtMethod:aMethod))
    ] ifFalse:[
        aStream nextChunkPut:source.
    ].
    aStream space.
    aStream nextPutChunkSeparator.
    aStream cr

    "Created: / 05-09-2012 / 00:01:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:43:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileOutOn: aWriteStream
aWriteStream nextPutAll: self theNonMetaclass source.

    "Created: / 08-12-2012 / 22:25:28 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClass methodsFor:'interop support'!

perform:aMessage onReceiver:receiver from:sender ifNotFound:aBlock

    <resource: #skipInDebuggersWalkBack>

    | lo method  selector class args|

    selector := aMessage selector.
    args := aMessage arguments.
    class := receiver class.
    lo := class getLookupObject isNil ifTrue: [ JavaLookup instance ] ifFalse: [ class lookupObject ].

    method := lo lookupMethodForSelector: selector
            directedTo: class 
            for: receiver
            withArguments: args
            from: sender
            ilc: nil.

    ^ method isNil ifTrue:[
        aBlock value.
    ] ifFalse:[
        method valueWithReceiver: receiver arguments: args selector: aMessage selector search: receiver class sender: sender
    ].

    "Created: / 19-09-2011 / 23:33:06 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified: / 10-04-2012 / 16:47:31 / kursjan"
    "Modified: / 26-07-2016 / 07:55:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'java initialization'!

classInit
    "Perform the initialization of a class or interface. "

    | m wasBlocked |
    (accessFlags bitAnd: ACX_INITIALIZED) ~~ 0 ifTrue: [ ^ self ].
    lock isNil ifTrue:[ 
        wasBlocked := OperatingSystem blockInterrupts.
        lock isNil ifTrue:[        
            "/ Here we have to be extra careful. We MUST use
            "/ #primitiveNew and NOT #new (which initializes the class
            "/ if not already and invokes default ctor) or #basicNew
            "/ which initializes the class if not already.             
            lock := _java_lang_Object_CLASS primitiveNew.            
        ].
        wasBlocked ifFalse:[OperatingSystem unblockInterrupts].     
    ].
    self synchronized:[
        (((accessFlags bitAnd: ACX_INITIALIZED) == 0) and:[(accessFlags bitAnd: ACX_INITIALIZING) == 0]) ifTrue: [
            accessFlags := accessFlags bitOr: ACX_INITIALIZING.
            superclass ~~ JavaObject ifTrue: [ superclass classInit ].

            "JV@2014-08-04: Flush caches here."
            "/ Class reader does not flush caches, instead caches are flushed
            "/ here, at the very last moment, when a class is actually initialized. This should
            "/ be sufficent as an object cannot be sent a message unless a class is
            "/ initialized first. This saves us a little bit of time when reading classes
            "/ but cost time when initializing the class, so normally this is not much
            "/ of a saving. However, this helps in cases Java class is only read into memory
            "/ and never initialized - that's what JBrowser Workspace does.
            ObjectMemory flushCaches.
            "JV@2011-12-03: Also call initializeStaticFields"
            self initializeStaticFields.
            m := self compiledMethodAt: #'<clinit>()V'.
            m notNil ifTrue: [
                    "/Logger log: ('calling <clinit>()V of %1' bindWith: self name) severity: #trace facility: 'JVM'.
                    OrderOfClassInits notNil ifTrue: [ OrderOfClassInits add: self. ].
                    m
                        valueWithReceiver: self
                        arguments: #()
                        selector: #'<clinit>()V'
                        search: self class
                        sender: nil.
                   "/Logger log: ('calling <clinit>()V of %1 done' bindWith: self name) severity: #trace facility: 'JVM'.
            ].
            accessFlags := accessFlags bitOr:  ACX_INITIALIZED.
            accessFlags := accessFlags bitAnd: ACX_INITIALIZING bitInvert32.
        ].
    ].

    (JavaVM booted and: [JavaVM eagerResolvingEnabled] )ifTrue: [
        JavaClassReader classLoaderQuerySignal answer: classLoader
            do: [ self resolveAll. ]
    ].

    "
     JavaVM instructionTrace:true.
     JavaVM callTrace:true.

     (Java classNamed:'java.lang.String') classInit
     (Java classNamed:'java.lang.System') classInit

     (Java classNamed:'java/io/FileDescriptor') classInit
     (Java classNamed:'java.util.Properties') classInit"

    "Modified: / 12-11-1998 / 15:41:11 / cg"
    "Modified: / 18-08-2011 / 19:37:33 / jv"
    "Modified: / 08-12-2011 / 21:05:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 04-08-2014 / 17:05:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classInitInternal
    "Called by the JIT-compiled code when a class needs to be initialized"

    | m |

    self classInit.
    "Force recompilation"
    (m := thisContext sender method) isJavaMethod ifTrue:[m flushCode].


!

initializeStaticFields
    staticFields isNil ifTrue:[^ self].

    staticFields do:[:f |
        |val type|

        (val := f constantValue) isNil ifTrue:[
            "/ careful: int/long etc. constants must be initialized
            "/ with correct type.
            type := f type.
            type == #long ifTrue:[
                val := 0.
            ] ifFalse:[type == #int ifTrue:[
                val := 0.
            ] ifFalse:[type == #float ifTrue:[
                val := 0.0 asShortFloat
            ] ifFalse:[type == #double ifTrue:[
                val := 0.0
            ] ifFalse:[type == #byte ifTrue:[
                val := 0.
            ] ifFalse:[type == #char ifTrue:[
                val := 0.
            ] ifFalse:[type == #'unsigned short' ifTrue:[
                val := 0.
            ] ifFalse:[type == #boolean ifTrue:[
                val := 0.
            ]]]]]]]].
        ] ifFalse:[
            val class == JavaStringRef2 ifTrue:[
                val := val resolve
            ].
        ].
        self instVarNamed:(f name) put:val.
    ].

    "Modified: / 03-12-2011 / 12:28:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolveAll
    "resolve every ref in constantPool"

    constantPool do: [
        :each |
        (each isJavaRef or: [ each isJavaNameAndType ]) ifTrue: [
            each resolve: false
        ]
    ].

    "Created: / 18-11-2011 / 15:26:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-02-2012 / 17:14:09 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaClass methodsFor:'java instance creation'!

basicNew
    "Create a new cleared JAVA instance. Its instVars are cleared to the
     corresponding typed values; however, constructor is not invoked.

     The class itself is initialized first if necessary, i.e., this method may invoke static initializer of the class."

    self isInitialized ifFalse:[
        self classInit
    ].
    ^self primitiveNew

    "Modified: / 07-12-2014 / 02:11:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

primitiveNew
    "Create a new cleared JAVA instance. Its instVars are cleared to the
     corresponding typed values; however, constructor is not invoked."

    "/ Reimplemented for speed as a C function. That function is
    "/ also called from JIT-compiled code, resulting in 40-50% speedup
    "/ when running Java code
%{
    extern OBJ ___new();
    RETURN ( ___new(self) );
%}.

!



initValueFor:instVarName
    |idx field|

    idx := fields findFirst:[:field | field name = instVarName].
    idx == 0 ifTrue:[
        superclass ~~ JavaObject ifTrue:[
            ^ superclass initValueFor:instVarName
        ].
        ^0 "/lockWord"
    ] ifFalse:[
        field := fields at:idx.
        ^ field initialValue
    ].

    "Modified: / 26-08-2012 / 20:08:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newCleared
    <resource: #obsolete>
    "Use #basicNew"

    ^self basicNew

    "Modified: / 13-11-1998 / 14:10:45 / cg"
    "Modified: / 10-03-2011 / 22:38:40 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-11-2012 / 21:08:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newWith_String:argString
    "create a new instance, preset its fields,
     and call its JAVA init function passing a String arg"

    |newJavaObject|

    newJavaObject := self basicNew.
    newJavaObject
        perform:#'<init>(Ljava/lang/String;)V'
        with:(Java as_String:argString).
    ^ newJavaObject

    "
     ((Java classNamed:'java.lang.ArrayStoreException') newWith_String:'foo') inspect
    "

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 13-11-1998 / 14:17:01 / cg"
    "Modified: / 02-11-2012 / 21:11:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newWith_int:arg
    "create a new instance, preset its fields,
     and call its JAVA init function passing an int arg"

    |newJavaObject|

    newJavaObject := self basicNew.
    newJavaObject perform:#'<init>(I)V' with:arg.
    ^ newJavaObject

    "
     ((Java classNamed:'java.lang.Integer') newWith_int:123) inspect
    "

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 13-11-1998 / 14:17:01 / cg"
    "Modified: / 02-11-2012 / 21:11:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'java instance creation-proxying'!

new
    "create a new instance, preset its fields,
     and call its JAVA init function"

    |newJavaObject|

    newJavaObject := self basicNew.
    newJavaObject initialize.
    ^ newJavaObject

    "
     (Java classNamed:'java.lang.String') basicNew inspect
     (Java classNamed:'java.lang.String') newCleared inspect
     (Java classNamed:'java.lang.String') new inspect
    "

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Modified: / 09-06-2012 / 21:48:36 / Jan Kurs (kursjan@fit.cvut.cz)"
    "Modified: / 02-11-2012 / 21:10:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: arg1
    "create a new instance and call one-arg constructor"

    |newJavaObject|

    newJavaObject := self basicNew.
    newJavaObject perform:#'<init>:' with: arg1.
    ^ newJavaObject

    "
     (Java classNamed:'java.lang.String') basicNew inspect
     (Java classNamed:'java.lang.String') newCleared inspect
     (Java classNamed:'java.lang.String') new inspect
    "

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 17-03-2012 / 15:09:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 21:10:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: arg1 _: arg2
    ^self new: arg1 with: arg2

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 17-03-2012 / 15:12:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: arg1 _: arg2 _: arg3
    ^self new: arg1 with: arg2 with: arg3

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 17-03-2012 / 15:13:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: arg1 _: arg2 _: arg3 _: arg4
    ^self new: arg1 with: arg2 with: arg3 with: arg4

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 17-03-2012 / 15:13:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: arg1 _: arg2 _: arg3 _: arg4 _: arg5
    ^ self
        new: arg1
        with: arg2
        with: arg3
        with: arg4
        with: arg5

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 17-03-2012 / 15:13:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 03-04-2012 / 12:17:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

new: arg1 with: arg2
    "create a new instance and call 2-arg constructor"

    |newJavaObject|

    newJavaObject := self basicNew.
    newJavaObject perform:#'<init>:_:' with: arg1 with: arg2.
    ^ newJavaObject

    "
     (Java classNamed:'java.lang.String') basicNew inspect
     (Java classNamed:'java.lang.String') newCleared inspect
     (Java classNamed:'java.lang.String') new inspect
    "

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 17-03-2012 / 15:12:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 21:10:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: arg1 with: arg2 with: arg3
    "create a new instance and call 3-arg constructor"

    |newJavaObject|

    newJavaObject := self basicNew.
    newJavaObject perform:#'<init>:_:_:' with: arg1 with: arg2 with: arg3.
    ^ newJavaObject

    "
     (Java classNamed:'java.lang.String') basicNew inspect
     (Java classNamed:'java.lang.String') newCleared inspect
     (Java classNamed:'java.lang.String') new inspect
    "

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 17-03-2012 / 15:12:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 21:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: arg1 with: arg2 with: arg3 with: arg4
    "create a new instance and call 4-arg constructor"

    |newJavaObject|

    newJavaObject := self basicNew.
    newJavaObject perform:#'<init>:_:_:_:' with: arg1 with: arg2 with: arg3 with: arg4.
    ^ newJavaObject

    "
     (Java classNamed:'java.lang.String') basicNew inspect
     (Java classNamed:'java.lang.String') newCleared inspect
     (Java classNamed:'java.lang.String') new inspect
    "

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 17-03-2012 / 15:12:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-11-2012 / 21:10:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new: arg1 with: arg2 with: arg3 with: arg4 with: arg5
    "create a new instance and call 4-arg constructor"

    | newJavaObject |
    newJavaObject := self basicNew.
    newJavaObject
        perform: #'<init>:_:_:_:_:'
        with: arg1
        with: arg2
        with: arg3
        with: arg4
        with: arg5.
    ^ newJavaObject

    "
     (Java classNamed:'java.lang.String') basicNew inspect
     (Java classNamed:'java.lang.String') newCleared inspect
     (Java classNamed:'java.lang.String') new inspect"

    "Modified: / 04-11-1998 / 18:04:34 / cg"
    "Created: / 17-03-2012 / 15:12:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 02-04-2012 / 10:52:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-11-2012 / 21:10:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'message sending'!

doesNotUnderstand:aMessage
    | sender |

    "/ When we arrive here, the stack is:
    "/   1 - JavaObject>>doesNotUnderstand: (i.e., this method)
    "/   2 - context for not understood method (created by VM to hold arguments)
    "/   3 - context of method that sent the not understood message
    "/ Hence the `thisContext sender sender below.
    sender := thisContext sender sender.
    ^self
        perform: aMessage
        onReceiver: self
        from: sender
        ifNotFound: [ super doesNotUnderstand: aMessage ].

    "Modified: / 16-11-1998 / 16:50:56 / cg"
    "Modified: / 19-09-2011 / 23:43:56 / Jan Kurs <kursjan@fit.cvut.cz>"
    "Modified (comment): / 01-01-2012 / 19:36:41 / kursjan <kursjan@fit.cvut.cz>"
    "Modified: / 21-03-2016 / 00:59:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupFieldFor:fname static: searchStatic
    "Lookup a field with given name in class and all
     its subclasses, return an instance of JavaField
     or nil, if none is found.

     If searchStatic is true, static fields are searched,
     otherwise it searches inst and interface fields.
    "
    | cls field |

    cls := self.
    [ cls ~~ JavaObject ] whileTrue:[
        searchStatic ifTrue:[
            field := cls findStaticFieldByName: fname.
            field isNil ifTrue:[
                field := cls findInterfaceFieldByName: fname

            ]
        ] ifFalse:[
            field := cls findInstFieldByName: fname
        ].
        field notNil ifTrue:[
            ^ field
        ].
        cls := cls superclass.
    ].
    ^nil.

    "Created: / 26-07-2016 / 20:31:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lookupMethodFor:selector
    |method cls sel queue |

    sel := selector asSymbolIfInterned.
    sel notNil ifTrue:[
        queue := OrderedCollection with: self.
        [ queue isEmpty ] whileFalse:[
            cls := queue removeFirst.
            method := cls compiledMethodAt:sel.
            method notNil ifTrue:[ ^ method ].
            cls isInterface ifFalse:[
                cls superclass notNil ifTrue:[queue add: cls superclass]
            ].
            cls isJavaClass ifTrue:[  
                queue addAll: cls interfaces.
            ].
        ].
    ].
    "/cls ifNotNil:[^super lookupMethodFor: selector].
    ^ nil

    "Modified: / 04-02-2015 / 15:14:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

performStatic:selector
    "send a static message, without args."

    |javaMethod sel|

    sel := selector asSymbolIfInterned.
    sel notNil ifTrue:[
	javaMethod := methodDictionary at:sel.
	javaMethod notNil ifTrue:[
	    javaMethod isStatic ifTrue:[
		^ javaMethod
		    valueWithReceiver:self
		    arguments:#()
	    ]
	].
    ].

    ^ self doesNotUnderstand:(Message selector:selector)

    "Modified: / 15.1.1998 / 00:31:27 / cg"
    "Created: / 12.11.1998 / 16:29:20 / cg"
!

performStatic:selector with:arg
    "send a static message, with one args."

    |javaMethod sel|

    sel := selector asSymbolIfInterned.
    sel notNil ifTrue:[
	javaMethod := methodDictionary at:sel.
	javaMethod notNil ifTrue:[
	    javaMethod isStatic ifTrue:[
		^ javaMethod
		    valueWithReceiver:self
		    arguments:(Array with:arg)
		    selector:selector
		    search:nil
		    sender:nil
	    ]
	].
    ].

    ^ self doesNotUnderstand:(Message selector:selector argument:arg)

    "Modified: / 15.1.1998 / 00:31:27 / cg"
    "Created: / 10.12.1998 / 21:50:29 / cg"
! !

!JavaClass methodsFor:'misc ui support'!

iconInBrowserSymbol

    <resource: #programImage>

    | jle jlre |

    self isInterface ifTrue:[
        self isPrivate ifTrue:[^#javaPrivateInterfaceBrowserIcon].
        self isProtected ifTrue:[^#javaProtectedInterfaceBrowserIcon].
        ^#javaPublicInterfaceBrowserIcon
    ].

    self isEnum ifTrue:[
        self isPrivate ifTrue:[^#javaPrivateEnumBrowserIcon].
        self isProtected ifTrue:[^#javaProtectedEnumBrowserIcon].
        ^#javaPublicEnumBrowserIcon
    ].

    (jle := Java at:'java.lang.Exception') notNil ifTrue:[
        (jlre := Java at:'java.lang.RuntimeException') notNil ifTrue:[
            (self includesBehavior: jlre) ifTrue:[
                ^#javaRuntimeExceptionBrowserIcon
            ]
        ].
        (self includesBehavior: jle) ifTrue:[
            ^#javaExceptionBrowserIcon
        ]
    ].

    self isPrivate ifTrue:[^#javaPrivateClassBrowserIcon].
    self isProtected ifTrue:[^#javaProtectedClassBrowserIcon].
    ^#javaPublicClassBrowserIcon

    "Created: / 20-12-2010 / 19:11:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'printOut'!

printNameInHierarchy
    "return my name as printed in the hierarchy"

    ^ self displayString

    "Modified: 22.3.1997 / 14:16:55 / cg"
!

printOutOn:aStream
    self warn:'printOut not yet supported'

    "Created: 22.3.1997 / 14:36:12 / cg"
!

printOutProtocolOn:aStream
    self warn:'printOut not yet supported'

    "Created: 22.3.1997 / 14:36:28 / cg"
! !

!JavaClass methodsFor:'printing & storing'!

displayString
    ^ self javaName

"/    ^ 'JAVA-' , name .
"/    ^ name , '(Java)'  "/ 'JavaClass(' , name , ')'

    "Created: / 15-04-1996 / 16:02:48 / cg"
    "Modified: / 18-07-1998 / 22:56:30 / cg"
    "Modified: / 08-10-2013 / 19:22:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'private'!

beObsolete
    "Mark the class as obsolete. This means that the this very
     version has been replaced by a newer version and is no longer
     accessible through java class registry"

    accessFlags := accessFlags bitOr: ACX_OBSOLETE

    "Created: / 19-09-2016 / 16:46:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'private accessing'!

addMethod:m name:name signature:signature
    |sel|

    sel := (name , signature) asSymbol.
    self primAddSelector:sel withMethod:m.
    ^ self.

"/    selectorArray isNil ifTrue:[
"/        selectorArray := #().
"/        methodArray := #()
"/    ].
"/    selectorArray := selectorArray copyWith:(name , signature) asSymbol. "/ name.
"/"/    selectorArray := selectorArray copyWith:name asSymbol. "/ name.
"/    methodArray := methodArray copyWith:m

    "Created: / 15-04-1996 / 16:42:52 / cg"
    "Modified: / 04-04-2012 / 01:18:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addSelector:newSelector withMethod:newMethod

    ^super addSelector:newSelector withMethod:newMethod

"/    "redefined to not flush smalltalk caches and send NO smalltalk-class
"/     change notification. Will eventually flush Java caches."
"/
"/    |nargs oldMethod|
"/
"/    oldMethod := self compiledMethodAt:newSelector.
"/    (self primAddSelector:newSelector withMethod:newMethod) ifFalse:[^ false].
"/
"/    ^ true
"/
"/

    "Created: / 20-01-1997 / 13:00:48 / cg"
    "Modified: / 20-04-2012 / 20:27:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setAccessFlags:flags
    accessFlags := flags.

    "Created: 15.4.1996 / 16:42:52 / cg"
!

setAttributes: aSequenceableCollection
    aSequenceableCollection isNil ifTrue:[
        attributes := Attributes empty.
    ] ifFalse:[
        aSequenceableCollection class == Attributes ifTrue:[
            attributes := aSequenceableCollection
        ] ifFalse:[
            attributes := Attributes new: aSequenceableCollection size // 2.
            aSequenceableCollection pairWiseDo:[ :key :value | attributes at: key put: value. ]
        ]
    ]

    "Created: / 13-09-2013 / 00:57:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:57:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setBinaryName: aString
    binaryName := aString asSymbol.

    "Created: / 15-04-1996 / 16:42:52 / cg"
    "Modified: / 05-11-1998 / 19:14:39 / cg"
    "Modified (format): / 09-10-2013 / 00:43:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setFields:f
    | nignored nvals vals names |

    JavaClass setInstanceVariableStringFromFields:f in:self.

    instSize := superclass instSize + f size.
    fields := f.

    f withIndexDo:[:field :index|
        field setClass: self.
        field setIndex: superclass instSize + index.
    ].

    "Now, collect initValues. Ignore the lockword, if any"
    nignored := JavaObject instSize. "/except possible instvars in JavaObject (lockword)
    nvals := self instSize - nignored.
    nvals > 0 ifTrue:[
        vals := Array new: nvals.
        names := self allInstVarNames.
        JavaObject instSize + 1 to: names size do:[:i|
            | val |
            val := self initValueFor: (names at: i).
            val notNil ifTrue:[
                vals at: i - nignored put: val.
                initValues := vals.
            ]
        ].
    ]

    "Created: / 15-04-1996 / 16:42:52 / cg"
    "Modified: / 06-11-1998 / 01:53:01 / cg"
    "Modified: / 02-11-2012 / 21:49:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setInterfaces: aCollection

    super setInterfaces: aCollection.
    aCollection notEmptyOrNil ifTrue:[
        aCollection do:[:ifaceRefIndex|
            (self constantPool at: ifaceRefIndex) name = 'groovy/lang/GroovyObject' ifTrue:[
                self class changeClassTo: GroovyMetaclass.
                self class setSuperclass: GroovyClass.
            ]
        ]
    ]

    "Created: / 20-02-2012 / 22:47:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-11-2014 / 17:03:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setLockWord
    _lockWord_ := 0

    "Created: / 06-12-2013 / 23:00:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSource: aStringOrNil
    self assert: (aStringOrNil isNil or:[aStringOrNil isString]).
    attributes := attributes at:#SourceString putOrAppend: aStringOrNil

    "Created: / 15-04-1996 / 16:42:52 / cg"
    "Created: / 18-02-2012 / 19:10:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2014 / 01:34:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSourceFile:aFilename
    classFilename := aFilename.

    "Created: / 15-04-1996 / 16:42:52 / cg"
    "Modified: / 07-08-2014 / 12:26:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setStaticFields:f
    JavaClass setInstanceVariableStringFromFields:f in:self class.

    staticFields := f.

    "Modified: / 17-08-2011 / 09:26:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setSuperclass:aClass
    |iVars numIvars|

    aClass isNil ifTrue:[
	super setSuperclass:JavaObject
    ] ifFalse:[
	(aClass isMemberOf:JavaUnresolvedClassConstant) ifTrue:[
	    self halt.
	].
	super setSuperclass:aClass.
    ].

    iVars := self instVarNames.
    ((numIvars := iVars size) > 0) ifTrue:[
	(superclass notNil and:[(superclass isMemberOf:JavaUnresolvedClassConstant) not]) ifTrue:[
	    instSize := superclass instSize + numIvars
	] ifFalse:[
	    instSize := numIvars
	]
    ].

    "Created: 15.4.1996 / 16:42:52 / cg"
    "Modified: 22.8.1997 / 15:06:45 / cg"
! !

!JavaClass methodsFor:'private-accessing'!

attributes
    "return the extra class attributes or nil"
    ^ attributes

    "Created: / 13-09-2013 / 00:53:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

attributes:aClassAttributesObject
    self shouldNotImplement

    "Created: / 13-09-2013 / 00:52:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classAttributes
    ^ self attributes

    "Created: / 13-09-2013 / 00:52:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classAttributes:aClassAttributesObject
    self shouldNotImplement.

    "Created: / 13-09-2013 / 00:52:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getAttribute:key
    "get an attribute (by symbolic key)"

    ^ attributes at: key ifAbsent: nil

    "Created: / 13-09-2013 / 00:53:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 22:33:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setAttribute:key to:aValue
    self shouldNotImplement

    "Created: / 13-09-2013 / 00:54:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'private-changes management'!

writingChangeWithTimeStamp:doStampIt do:aBlock

    "No changes for Java classes now"

    "Created: / 14-12-2010 / 18:07:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'queries'!

anonymousClasses
    "Return set of anonymous classes defined in this class. Anonymous classes that 
     are not yet loaded are loaded but not initialized."

    ^ self anonymousClassesIgnoreUnloaded:false

    "Created: / 11-12-2014 / 17:33:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

anonymousClassesIgnoreUnloaded
    "Return set of anonymous classes defined in this class. 
     Those not yet loaded are ommited from the returned set"

    ^ self anonymousClassesIgnoreUnloaded:true

    "Created: / 11-12-2014 / 17:34:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

anonymousClassesIgnoreUnloaded:ignoreUnloaded
    "Return set of anonymous classes defined in this class. If ignoreUnloaded is true,
     anonymous classes that are not loaded will not appear in the returned set.
     If ignoreUnloaded is false and anonynous class is not loaded yet, it is
     loaded but not initialized."

    ^ Array streamContents: [ :stream | self anonymousClassesIgnoreUnloaded: ignoreUnloaded do: [:class | stream nextPut: class ] ]

    "Created: / 11-12-2014 / 17:34:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

anonymousClassesIgnoreUnloaded:ignoreUnloaded do: block
    "Iterate over a set of anonynous classes. If ignoreUnloaded is true,
     anonynous classes that are not loaded will be skipped.
     If ignoreUnloaded is false and anonynous class is not loaded yet, it is
     loaded but not initialized.

     See JVM spec, Section 4.7.6 The InnerClasses Attribute
    "

    | innerClassesAttr |

    innerClassesAttr := self getAttribute:#InnerClasses.
    innerClassesAttr notNil ifTrue:[
        | cp |

        cp := self constantPool.
        innerClassesAttr do:[:each |
            | innerClassRef |

            innerClassRef := cp at: each innerClassRefIndex.
            innerClassRef name ~= binaryName ifTrue:[ 
                each nameIndex == 0"Anonynous class" ifTrue:[ 
                    | innerClass |

                    innerClass := JavaVM classNamed:innerClassRef name definedBy:classLoader.
                    (innerClass isNil and:[ ignoreUnloaded not ]) ifTrue:[ 
                        innerClass := innerClassRef resolve: false.
                    ].   
                    innerClass notNil ifTrue:[ block value: innerClass ].        
                ].
            ].
        ]
    ].

    "Created: / 11-12-2014 / 17:35:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-01-2015 / 09:29:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

canBeSubclassed
    "return true, if its allowed to create subclasses of the receiver."

    self isFinal ifTrue:[^ false].
    self isInterface ifTrue:[^ false].
    ^ true

    "Created: / 5.11.1998 / 23:04:50 / cg"
!

canCacheReferences
    ^ self versions isNil or: [ self versions isEmpty ].

    "Created: / 10-09-2013 / 00:07:40 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

canHaveExtensions
    ^false

    "Created: / 13-04-2012 / 18:55:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

containsMethodsAnnotatedWith:aJavaTypeName
    | methods |

    methods := self selectMethodsAnnotatedWith:aJavaTypeName.
    methods notEmptyOrNil ifTrue:[ ^ true ].
    superclass ~~ JavaObject
        ifTrue:[ ^ superclass containsMethodsAnnotatedWith:aJavaTypeName. ].
    ^ false.

    "Created: / 02-03-2011 / 23:01:14 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 27-04-2014 / 20:58:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasErrors
    "Return true if the class contains compilation errors, false otherwise.

     Normally, classes cannot contain errors - compilation would fail. However, when
     class is compiled in an interactive mode within a browser, compiler is more relaxed
     and produces a class with compilation errors. Then this method returns true."

    | hasErrors1 
"/      hasErrors2 
    |

    hasErrors1 := (accessFlags bitAnd:ACX_HASERRORS) ~~ 0.
"/    hasErrors2 := (binaryName ~= 'stx/libjava/tools/compiler/CompileError'
"/                    and:[ constantPool contains: [:entry | entry isJavaClassRef and:[entry name = 'stx/libjava/tools/compiler/CompileError']]]).
"/    self assert: hasErrors1 == hasErrors2.
    ^ hasErrors1.

    "Created: / 20-09-2016 / 09:20:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 20-09-2016 / 22:50:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasFinalize
    ^ (accessFlags bitAnd:ACX_HASFINALIZE) ~~ 0

    "Created: / 02-11-2012 / 18:50:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasInterface:aJavaInterface
    "return true, if I respond to all methods as
     required by the argument, an aJavaInterface"

    interfaces size > 0 ifTrue:[
	self interfaces do:[:if |
	    aJavaInterface == if ifTrue:[
		^ true
	    ].
	]
    ].
    superclass isJavaClass ifTrue:[
	^ superclass hasInterface:aJavaInterface
    ].
    ^ false.

"/    aJavaInterface methodDictionary keysAndValuesDo:[:sel :mthd |
"/        (self canUnderstand:sel) ifFalse:[
"/            ^ false.
"/        ]
"/    ].
    ^ true

    "Modified: / 28.1.1998 / 01:46:16 / cg"

!

hasMagicAccessRights
    "Classes subclassing from sun.reflect.MagicAccessorImpl are not subject to access rights checks. Another non-documented gem found in openjdk sources :)"

    | magicAccessor |
    magicAccessor := JavaVM classNamed: 'sun.reflect.MagicAccessorImpl' definedBy: nil.
    ^ magicAccessor notNil and: [ self includesBehavior: magicAccessor ].

    "Created: / 18-11-2012 / 16:11:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-05-2013 / 01:23:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

innerClasses
    "Return set of inner classes. Inner classes that are yet loaded, are
     loaded but not initialized."
    ^ self innerClassesIgnoreUnloaded:false

    "Created: / 08-08-2014 / 16:08:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

innerClassesIgnoreUnloaded
    "Return a set of inner classes. Those not yet loaded
     are ommited from the returned set"

    ^ self innerClassesIgnoreUnloaded:true

    "Created: / 08-08-2014 / 16:07:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

innerClassesIgnoreUnloaded:ignoreUnloaded
    "Return a set of inner classes. If ignoreUnloaded is true,
     inner classes that are not loaded will not appear in the returned set.
     If ignoreUnloaded is false and inner class is not loaded yet, it is
     loaded but not initialized."

    ^ Array streamContents: [ :stream | self innerClassesIgnoreUnloaded: ignoreUnloaded do: [:class | stream nextPut: class ] ]

    "Created: / 08-08-2014 / 16:06:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-12-2014 / 15:38:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

innerClassesIgnoreUnloaded:ignoreUnloaded do: block
    "Iterate over a set of inner classes. If ignoreUnloaded is true,
     inner classes that are not loaded will be skipped.
     If ignoreUnloaded is false and inner class is not loaded yet, it is
     loaded but not initialized.

     See JVM spec, Section 4.7.6 The InnerClasses Attribute
    "

    | innerClassesAttr |

    innerClassesAttr := self getAttribute:#InnerClasses.
    innerClassesAttr notNil ifTrue:[
        | cp |

        cp := self constantPool.
        innerClassesAttr do:[:each |
            | outerClassRefIndex outerClassRef |

            outerClassRefIndex := each outerClassRefIndex.
            outerClassRefIndex ~~ 0 ifTrue:[ 
                outerClassRef := cp at: outerClassRefIndex.
                outerClassRef name = self binaryName ifTrue:[ 
                    | innerClassRef innerClass |

                    innerClassRef := cp at: each innerClassRefIndex.
                    innerClass := JavaVM classNamed:innerClassRef name definedBy:classLoader.
                    (innerClass isNil and:[ ignoreUnloaded not ]) ifTrue:[ 
                        innerClass := innerClassRef resolve: false.
                    ].
                    innerClass notNil ifTrue:[ block value: innerClass ].
                ].
            ].
        ].
    ].

    "Created: / 11-12-2014 / 15:37:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 20-01-2015 / 09:29:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isAnonymous

    | innerClassesAttr |

    innerClassesAttr := self getAttribute: #InnerClasses.
    innerClassesAttr notNil ifTrue:[
        innerClassesAttr do:[:each |
            | innerClassRef |

            innerClassRef := self constantPool at: each innerClassRefIndex.
            (innerClassRef name = binaryName) ifTrue:[
                each nameIndex == 0 ifTrue:[ 
                    ^ true
                ].
            ]
        ].
    ].
    ^ false
                
    "
        (Java at:'java.io.Console') isAnonymous
        (Java at:'java.io.Console$1') isAnonymous
        (Java at:'java.io.Console$1$1') isAnonymous
        (Java at:'sun.misc.Launcher$ExtClassLoader') isAnonymous

    "

    "Created: / 18-03-1997 / 17:48:01 / cg"
    "Created: / 07-08-2011 / 15:50:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-12-2014 / 15:53:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isBuiltInClass
    ^JavaVM builtInClassNames includes: binaryName

    "Created: / 22-05-2013 / 20:38:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-12-2013 / 12:46:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isCloneable
    "Return true, if the receiver implements java.lang.Cloneable,
     i.e., if it can be cloned using Object#clone()"

    (accessFlags bitAnd:ACX_CLONEABLE) ~~ 0 ifTrue:[ ^ true ].
    self interfaces do:[:interface |
        interface isCloneable ifTrue:[
            "/ Cache the information here so subsequent call
            "/ call to clone() can make use of fast flag-check
            accessFlags := accessFlags bitOr:ACX_CLONEABLE.
            ^ true.
        ].
    ].
    superclass isCloneable ifTrue:[
        "/ Cache the information here so subsequent call
        "/ call to clone() can make use of fast flag-check
        accessFlags := accessFlags bitOr:ACX_CLONEABLE.
        ^ true.
    ].
    ^ false.

    "Created: / 12-11-2013 / 00:33:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-11-2013 / 11:06:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isFullyResolved
    constantPool do: [:each | (each isJavaRef and: [each isResolved not]) ifTrue: [^false]].
    ^ true.

    "Created: / 08-12-2011 / 20:44:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 02-10-2013 / 21:29:57 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
!

isJavaArrayClass

    ^false

    "Created: / 05-02-2011 / 22:20:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaClass
    ^ self ~~ JavaClass

    "Created: 18.3.1997 / 17:48:01 / cg"
!

isJavaClassType

    ^self isInterface not

    "
        (Java classForName:'java.lang.Class') isJavaClassType
    "

    "Created: / 11-02-2011 / 08:09:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaInterfaceType

    ^self isInterface

    "
        (Java classForName:'java.lang.Class') isJavaInterfaceType
    "

    "Created: / 11-02-2011 / 08:09:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaMethodRef
    ^ false

    "Created: / 9.11.1999 / 15:42:10 / cg"
!

isJavaPrimitiveType

    ^false

    "
        (Java classForName:'java.lang.Class') isJavaPrimitiveType
        ByteArray isJavaPrimitiveType
    "

    "Created: / 21-12-2010 / 23:03:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaReferenceType

    ^true

    "
        (Java classForName:'java.lang.Class') isJavaReferenceType
    "

    "Created: / 20-12-2010 / 21:54:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaType

    ^true

    "
        (Java classForName:'java.lang.Class') isJavaType
    "

    "Created: / 20-12-2010 / 21:53:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isJavaWrapperClass
    "Returns true, iff receiver is one of the Java wrapper classes or String"

    binaryName == #'java/lang/Byte' ifTrue:[^true].
    binaryName == #'java/lang/Short' ifTrue:[^true].
    binaryName == #'java/lang/Integer' ifTrue:[^true].
    binaryName == #'java/lang/Long' ifTrue:[^true].
    binaryName == #'java/lang/Character' ifTrue:[^true].
    binaryName == #'java/lang/Boolean' ifTrue:[^true].
    binaryName == #'java/lang/String' ifTrue:[^true]."/Not really a wrapper, but..."

    ^false.

    "Created: / 26-12-2011 / 22:03:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-10-2013 / 00:43:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isObsolete
    "return true, if the receiver is obsolete
     Java classes are never."

    ^ (accessFlags bitAnd:ACX_OBSOLETE) ~~ 0.

    "Created: / 19-09-2016 / 16:47:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUnresolved
    "return true, if the receiver is unresolved;
     javaClasses are never; JavaUnresolvedClasses are always"

    ^ false

    "Modified: / 07-05-1998 / 12:23:14 / cg"
    "Created: / 06-03-2011 / 22:57:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

nameInBrowser
    "return a nameString as shown in browsers"

    ^ self javaName

    "Modified: / 08-10-2013 / 22:44:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameInSmalltalk
    "Return the name of the class under which it could be found in
     system dictionary (Smalltalk)"

    ^ self nameSpaceName , '::' , self lastName.

    "Modified: / 19-10-1998 / 20:07:24 / cg"
    "Modified: / 14-09-2013 / 22:54:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nameSpaceName
    "Return the name of the class under which it could be found in
     system dictionary (Smalltalk).

     The top namespace is
        (i) either JAVA iff the class is loaded by primordial or ext or system class loader
        (ii) or JAVA_XXXXXXXX where XXXXXXXX is hashcode of the classloader that loaded given class.

     "

    ^ String
        streamContents: [:s |
            | parts |

            s nextPutAll: 'JAVA'.
            classLoader notNil ifTrue: [
                | systemLoader  extLoader |

                systemLoader := JavaVM systemClassLoader.
                systemLoader notNil ifTrue: [
                    classLoader ~~ systemLoader ifTrue: [
                        extLoader := systemLoader instVarNamed: #parent.
                        classLoader ~~ extLoader ifTrue: [
                            "Class was not loaded by primordial nor ext nor system class loader"
                            s
                                nextPut: $_;
                                nextPutAll: (classLoader identityHash printStringRadix: 16 padTo: 8).
                        ]
                    ]
                ]
            ].
            parts := self binaryName asCollectionOfSubstringsSeparatedBy: $/.
            parts
                from: 1
                to: (parts size - 1)
                do: [:aPart |
                    s nextPutAll: '::'.
                    s nextPutAll: aPart
                ].
        ].

    "
     JAVA::java::lang::Object nameInSmalltalk
     JAVA::java::lang::Object nameSpacePath
     JAVA::java::lang::Object name"

    "Created: / 14-09-2013 / 22:53:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 10-10-2013 / 01:00:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

owningClass
    ^ self enclosingClass

    "Created: / 05-08-2014 / 22:35:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

selectMethodsAnnotatedWith:aJavaTypeName
    ^ self methodDictionary values select:
            [:method |
            (method isJavaMethod
                and:[method annotations notNil
                    and:[(method annotations runtimeVisible at:aJavaTypeName ifAbsent:nil) notNil]])].

    "Created: / 02-03-2011 / 23:06:42 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 14-12-2011 / 22:35:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

supportsMethodCategories
    ^ self isJavaClass not

    "Created: / 30.7.1997 / 14:58:58 / cg"
    "Modified: / 7.5.1998 / 12:25:54 / cg"
!

typeName
    ^ 'L' , self fullName , ';'.

    "
     (Java at:'java.util.Stack') typeName"

    "Modified: / 10-02-1998 / 17:13:26 / cg"
    "Modified: / 02-03-2011 / 22:48:40 / Marcel Hlopko <hlopik@gmail.com>"
! !

!JavaClass methodsFor:'queries-protocol'!

equalsOrIsSubclassOf: aJavaClass
    self = aJavaClass ifTrue: [^true].
    ^ self isSubclassOf:aJavaClass.

    "Created: / 30-05-2011 / 23:07:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

includesBehavior: aClass
    ^ (aClass isJavaClass not or: [ aClass isInterface not ])
        ifTrue: [ self name == aClass name or:[ super includesBehavior: aClass ]]
        ifFalse: [self name == aClass name or: [ self allInterfaces includes: aClass ]].

    "Created: / 05-02-2011 / 23:44:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 09-10-2013 / 01:29:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isSubclassOf: aClass

    | cls |
    aClass isNil ifTrue:[^false].
    cls := self.
    [ cls notNil ] whileTrue:[
        "JV-2011-10-20: Q: is one subclass of another if its
         are subclass but loaded using different classloader?"
        cls == aClass ifTrue:[
            ^true
        ].
        cls := cls superclass.
    ].
    ^false

    "Created: / 20-10-2011 / 16:15:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'reflection'!

findInstFieldByName: fieldName
    "tries to find a field in current class (not superclasses)"

    | result |
    result := self fields
                detect: [:each | each name = fieldName ]
                ifNone: [ nil ].
    ^ result.

    "Created: / 07-12-2011 / 23:05:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

findInterfaceFieldByName: fieldName
    | result  seenIfaces  ifaces |
    ifaces := OrderedCollection withAll: self interfaces.
    seenIfaces := Set new.
    [ ifaces notEmpty ] whileTrue: [
        | iface |
        iface := ifaces removeFirst.
        result := iface staticFields
                    detect: [:each | each name = fieldName ]
                    ifNone: [ nil ].
        result notNil ifTrue: [ ^ result ].
        seenIfaces add: iface.
        iface interfaces do: [
            :each |
            (seenIfaces includes: each) not ifTrue: [ ifaces add: each ]
        ]
    ].
    ^ nil.

    "Created: / 07-12-2011 / 23:05:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

findStaticFieldByName: fieldName
    "tries to find a field in current class (not superclasses)"

    | result |
    result := self staticFields
                detect: [:each | each name = fieldName ]
                ifNone: [ nil ].
    ^ result.

    "Created: / 07-12-2011 / 23:05:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lookupFieldByNameAndType: aJavaNameAndType
    | field  cls |
    cls := self.
    [ cls ~~ JavaObject ] whileTrue: [
        field := cls findInstFieldByName: aJavaNameAndType name.
        field notNil ifTrue: [ ^ field ].
        field := cls findStaticFieldByName: aJavaNameAndType name.
        field notNil ifTrue: [ ^ field ].
        field := cls findInterfaceFieldByName: aJavaNameAndType name.
        field notNil ifTrue: [ ^ field ].
        cls := cls superclass.
    ].
    self breakPoint: #mh.
    ^ nil.

    "Created: / 11-04-2011 / 21:27:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-08-2011 / 00:46:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2011 / 23:05:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

lookupStaticFieldByNameAndType: aJavaNameAndType
    | field  cls |
    cls := self.
    [ cls ~= JavaObject ] whileTrue: [
        field := cls findStaticFieldByName: aJavaNameAndType name.
        field notNil ifTrue: [ ^ field ].
        field := cls findInterfaceFieldByName: aJavaNameAndType name.
        field notNil ifTrue: [ ^ field ].
        cls := cls superclass.
    ].
    self breakPoint: #mh.
    ^ nil.

    "Created: / 11-04-2011 / 21:27:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 26-08-2011 / 18:27:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-12-2011 / 23:06:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClass methodsFor:'special'!

asClassPointerRef
"/ self halt.
     ^ self

    "Created: / 10.11.1998 / 02:07:01 / cg"
    "Modified: / 8.1.1999 / 14:11:26 / cg"
!

deinit

    accessFlags := accessFlags bitClear: ACX_INITIALIZED.

    "Created: / 25-10-2010 / 12:28:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deref
	^ self

    "Created: / 10.11.1998 / 02:08:06 / cg"
!

javaArrayClass
    "/ self halt.
    "/  ^ Array

    ^ JavaArray javaArrayClassFor:self

    "Created: / 10-11-1998 / 02:07:32 / cg"
    "Modified: / 08-01-1999 / 14:11:34 / cg"
    "Modified: / 05-07-2012 / 23:24:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'support - refactorings'!

directlyDefinesMethod: aSelector

    ^self methodDictionary includes: aSelector.

    "Created: / 16-03-2011 / 14:21:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

metaclass

    ^self class

    "Created: / 16-03-2011 / 14:22:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'support - sUnit'!

asTestCase
    self isTestletLike
        ifTrue: [^ TestletTestCaseProxy for: self ].
    ^ JUnitTestCaseProxy for: self.

    "Created: / 04-03-2011 / 08:20:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-04-2011 / 17:52:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-05-2011 / 18:59:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

asTestlet
    ^ TestletTestCaseProxy for: self

    "Created: / 29-04-2011 / 16:53:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

buildSuite
    self isTestletLike ifTrue: [ ^(TestletTestCaseProxy for: self) buildSuite ].
^ (JUnitTestCaseProxy for: self) buildSuite

    "Created: / 29-05-2011 / 22:45:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

isJUnitTestCaseLike
    | cls |

    "try JUnit 4.x"
    (self containsMethodsAnnotatedWith: #'Lorg/junit/Test;') ifTrue: [
        ^ true
    ].

    "Try jUnit 3.x"
    cls := self superclass.
    [ cls ~~ JavaObject ] whileTrue:[
        cls binaryName == #'junit/framework/TestCase' ifTrue:[ ^ true ].
        cls := cls superclass.
    ].
    ^false
    "
        JAVA::java::lang::Object isTestCaseLike
        JAVA::stx::libjava::tests::junit::JUnit3Tests isTestCaseLike
    "

    "Created: / 23-10-2011 / 22:04:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2013 / 22:37:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTestCaseLike

    JavaVM booted ifFalse:[ ^ false ].

    ^self isJUnitTestCaseLike or:[ self isTestletLike ]

    "
        JAVA::java::lang::Object isTestCaseLike
        JAVA::stx::libjava::tests::junit::JUnit3Tests isTestCaseLike"

    "Created: / 28-02-2011 / 21:31:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2011 / 23:08:02 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 29-05-2011 / 22:48:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-12-2011 / 23:09:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTestSelector: selector

    "Hack, you're right, blame on me"

    | junit_framework_TestCase m |

    ((selector == #'test(Lgnu/testlet/TestHarness;)V')
        and:[self ~~ (Java at:'gnu.testlet.Testlet')])
            ifTrue:[^true].


    junit_framework_TestCase := Java at:'junit.framework.TestCase'.
    (junit_framework_TestCase notNil and:
        [self includesBehavior:junit_framework_TestCase])
        ifTrue:[^selector startsWith: 'test'].

    m := self lookupSelector: selector.
    ^m notNil 
        "/ It could be a dynamic ProxyMethod which is never a test method            
        and:[m isJavaMethod 
        "/ Sorry for that, but I need this method to be fast..
        and:[m annotations runtimeVisible includesKey: 'Lorg/junit/Test;']].

    "Modified: / 02-03-2011 / 23:08:02 / Marcel Hlopko <hlopik@gmail.com>"
    "Created: / 04-03-2011 / 07:07:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 21-03-2016 / 09:28:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTestletLike

    ^self interfaceNames includes:'gnu.testlet.Testlet'

    "
        self interfaces
    "

    "Modified: / 02-03-2011 / 23:08:02 / Marcel Hlopko <hlopik@gmail.com>"
    "Created: / 29-04-2011 / 17:02:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 13-02-2013 / 09:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass methodsFor:'unwind'!

unwindHandlerInContext: aContext
    "given a context which has been marked for unwind,
     retrieve the handler block. This method is called when ST
     exception raises and stack is unwinding. JavaClass instance
     has an opportunity to clean up monitors"

    ^ JavaVM unwindHandlerForJavaContext: aContext.

    "Created: / 08-11-2011 / 12:25:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClass methodsFor:'versions'!

mergeVersionsWith: aJavaClass
    "
    take both self and aJavaClass and ensure that:
    1) both share the same versions array instance
    2) versions instance includes both self and aJavaClass.
    "

    self markMultipleVersions.
    aJavaClass markMultipleVersions.

    (self versions isNil and: [ aJavaClass versions isNil ]) ifTrue: [
        | versionsArray |

        versionsArray := WeakArray with: self with: aJavaClass.
        versionsArray addDependent: JavaClass::JavaClassVersionDiedHandler new.
        self versions: versionsArray.
        aJavaClass versions: versionsArray.
        ^ self.
    ].
    self versions isNil ifTrue: [
        self versions: aJavaClass versions.
        self versions add: self.
        ^ self.
    ].
    aJavaClass versions isNil ifTrue: [
        aJavaClass versions: self versions.
        self versions add: aJavaClass.
        ^ self.
    ].
    self error: 'merge of two classes both of which have multiple versions not supported'.

    "Created: / 14-04-2013 / 13:44:03 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 21:52:39 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified (format): / 07-12-2014 / 01:30:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass::Attributes class methodsFor:'accessing'!

empty
    ^ Empty

    "Created: / 13-09-2013 / 00:50:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass::Attributes class methodsFor:'documentation'!

documentation
"
    A special container for class attributes allowing
    for dense, memory-efficient storage.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaClass::Attributes class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    Empty := self new:0.

    "Modified: / 13-09-2013 / 00:51:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClass::JavaClassVersionDiedHandler class methodsFor:'documentation'!

history

    "Created: #update:with:from: / 14-04-2013 / 14:04:20 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: #update:with:from: / 02-10-2013 / 21:49:51 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClass::JavaClassVersionDiedHandler methodsFor:'notification'!

update:aParameter with:anArgument from:source

    aParameter = #ElementExpired ifFalse: [
        self error: 'only #ElementExpired updates supported'.
    ].
    self assert: (source notNil and: [ source size >= 1 ]).

    source size = 1 ifTrue: [
        "only one version remaining - we can start caching. Let's change the flag"
        | javaClass |
        javaClass := (source at: 1).
        javaClass markNonMultipleVersions.
    ].

    "Created: / 14-04-2013 / 14:04:20 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 02-10-2013 / 21:49:51 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaClass class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaClass.st,v 1.140 2015-03-20 12:07:59 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClass.st,v 1.140 2015-03-20 12:07:59 vrany Exp $'
!

version_SVN
    ^ 'Id'
! !


JavaClass initialize!
JavaClass::Attributes initialize!

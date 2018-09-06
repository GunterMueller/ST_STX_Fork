"{ Encoding: utf8 }"

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
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

SunRPC::RPCServer subclass:#SmalltalkShareServer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SmallTeam'
!

!SmalltalkShareServer class methodsFor:'documentation'!

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
    a server for remote image access.

    [author:]
        Claus Gittinger

    [start with (server side):]
        SmalltalkShareServer start
        SmalltalkShareServer startUDP

    [start with (client side):]
        |matchArg list|
        matchArg := Dictionary new.
        matchArg at:'classNamePattern' put:'*'.
        matchArg at:'categoryPattern' put:'*'.
        matchArg at:'packagePattern' put:'*'.
        list := SmalltalkShareClient getClasses:matchArg

    [see also:]
        SmalltalkShareClient
"
!

examples
"
    SmalltalkShareServer killAll.
    SmalltalkShareServer initialize

    get it running:

  1) on the server side, evaluate:
        SmalltalkShareServer start
    or,
        SmalltalkShareServer startUDP

  2) (in a terminal), validate rpc-registration with:
        rpcinfo -p

  3) on the client side, evaluate some example from the SmalltalkShareClient class.
"
! !

!SmalltalkShareServer class methodsFor:'spec'!

xdr
    "
     SmalltalkShareServer initDefinitions
     SmalltalkShareClient initDefinitions
    "

    ^ '

const F_MASK_INDEXTYPE = 0x000F;
const F_NOT_INDEXED           =  0;
const F_INDEX_BYTES           =  1;
const F_INDEX_WORDS           =  2;
const F_INDEX_LONGS           =  3;
const F_INDEX_POINTERS        =  4;
const F_INDEX_WEAKPOINTERS    =  5;
const F_INDEX_FLOATS          =  6;
const F_INDEX_DOUBLES         =  7;
const F_INDEX_SIGNEDWORDS     =  8;
const F_INDEX_SIGNEDLONGS     =  9;
const F_INDEX_LONGLONGS       = 10;
const F_INDEX_SIGNEDLONGLONGS = 11;

struct *categoryList {
        string categoryName<>;
        categoryList nextEntry;
};

struct *classNameList {
        string className<>;
        string classCategoryOrEmptyIfSame<>;
        classNameList nextEntry;
};

struct *methodNameList {
        string selector<>;
        string methodCategoryOrEmptyIfSame<>;
        string packageOrEmptyIfSame<>;
        methodNameList nextEntry;
};

struct *classList {
        string className<>;
        string categoryName<>;
        string packageName<>;
        string superclassName<>;
        int flags;
        string instVarNames<>;
        string classVarNames<>;
        string classInstVarNames<>;
        classList nextEntry;
};

struct *methodInfo {
        string category<>;
        string package<>;
        int flags;
        string source<>;
        opaque byteCode<>;
};

struct getClassesArg {
        string classNameMatchPattern<>;
        string categoryMatchPattern<>;
        string packageMatchPattern<>;
};

struct getMethodsArg {
        string className<>;
        bool meta;
};

struct getMethodInfoArg {
        string className<>;
        bool meta;
        string selector<>;
};

program SMALLTALKSHARE {
        version SMALLTALKSHAREVERS {
                void
                null(void) = 0;

                categoryList
                getCategories(void) = 1;

                classNameList
                getClassNames(getClassesArg) = 2;

                classList
                getClasses(getClassesArg) = 3;

                methodNameList
                getMethodNames(getMethodsArg) = 4;

                methodInfo
                getMethodInfo(getMethodInfoArg) = 5;

                void
                sendUpdates(void) = 6;
        } = 1;
} = 200099; 
'
! !

!SmalltalkShareServer methodsFor:'operations'!

getCategories
    |list|

    list := OrderedCollection new.

    Smalltalk allClassCategories do:[:cat |
        |entry|

        entry := Dictionary new.
        entry at:'categoryName' put:cat.
        list add:entry.
    ].
    ^ list
!

getClassNames:getClassNamesArgs
    |arg classNamePattern categoryPattern packagePattern list cat prevCat|

    arg := getClassNamesArgs first.

    classNamePattern := arg at:'classNameMatchPattern'.
    categoryPattern := arg at:'categoryMatchPattern'.
    packagePattern := arg at:'packageMatchPattern'.

    list := OrderedCollection new.

    Smalltalk allClassesDo:[:cls |
        (classNamePattern size = 0 
        or:[classNamePattern match:cls name])
        ifTrue:[
            (categoryPattern size = 0 
            or:[categoryPattern match:cls category])
            ifTrue:[
                (packagePattern size = 0 
                or:[packagePattern match:cls package])
                ifTrue:[
                    list add:cls.
                ]
            ]
        ]
    ].
    list sort:[:a :b | a category < b category].
    list := list 
        collect:
            [:cls |

                |entry|

                cat := cls category.

                entry := Dictionary new.
                entry at:'className' put:cls name.
                cat = prevCat ifTrue:[
                    entry at:'classCategoryOrEmptyIfSame' put:''.
                ] ifFalse:[
                    entry at:'classCategoryOrEmptyIfSame' put:cat.
                ].
                prevCat := cat.
                list add:entry.
            ].
    ^ list
!

getClasses:getClassNamesArgs
    |arg classNamePattern categoryPattern packagePattern list cls|

    arg := getClassNamesArgs first.

    classNamePattern := arg at:'classNameMatchPattern'.
    categoryPattern := arg at:'categoryMatchPattern'.
    packagePattern := arg at:'packageMatchPattern'.

    list := OrderedCollection new.

    classNamePattern includesMatchCharacters ifFalse:[
        cls := Smalltalk at:classNamePattern asSymbol.
        cls notNil ifTrue:[
Transcript showCR:classNamePattern.
            (categoryPattern size = 0 
            or:[categoryPattern match:cls category])
            ifTrue:[
                (packagePattern size = 0 
                or:[packagePattern match:cls package])
                ifTrue:[
                    list add:(self classInfoFor:cls).
                    ^ list
                ]
            ]
        ]
    ].

    Smalltalk allClassesDo:[:cls |
        (classNamePattern size = 0 
        or:[classNamePattern match:cls name])
        ifTrue:[
            (categoryPattern size = 0 
            or:[categoryPattern match:cls category])
            ifTrue:[
                (packagePattern size = 0 
                or:[packagePattern match:cls package])
                ifTrue:[
                    list add:(self classInfoFor:cls).
                ]
            ]
        ]
    ].
    ^ list
!

getMethodInfo:getMethodInfoArgs
    |arg className meta selector class method info|

    arg := getMethodInfoArgs first.

    className := arg at:'className'.
    meta := arg at:'meta'.
    selector := arg at:'selector'.

    class := Smalltalk at:className asSymbol ifAbsent:nil.
    class isNil ifTrue:[ ^ nil].

    class := class theNonMetaclass.
    meta ifTrue:[
        class := class theMetaclass.
    ].
    method := class compiledMethodAt:selector asSymbol.
    method isNil ifTrue:[ ^ nil].

    info := Dictionary new.
    info at:'category' put:method category.
    info at:'package' put:method package.
    info at:'flags' put:method flags.
    info at:'source' put:method source.
    info at:'byteCode' put:method byteCode.

    ^ info.
!

getMethodNames:getMethodNamesArgs
    |arg className meta list prevCat prevPkg class|

    arg := getMethodNamesArgs first.

    className := arg at:'className'.
    meta := arg at:'meta'.

    list := OrderedCollection new.

    class := Smalltalk at:className asSymbol ifAbsent:nil.
    class isNil ifTrue:[ ^ list].
    class := class theNonMetaclass.
    meta ifTrue:[
        class := class theMetaclass.
    ].

    class methodDictionary 
        keysAndValuesDo:
            [:sel :mthd |
                list add:(sel -> mthd)
            ].

    list sort:[:a :b | a key < b key].
    list := list 
        collect:
            [:assoc |

                |sel mthd entry cat pkg|

                sel := assoc key.
                mthd := assoc value.
                cat := mthd category.
                pkg := mthd package.

                entry := Dictionary new.
                entry at:'selector' put:sel.
                cat = prevCat ifTrue:[
                    entry at:'methodCategoryOrEmptyIfSame' put:''.
                ] ifFalse:[
                    entry at:'methodCategoryOrEmptyIfSame' put:cat.
                ].
                prevCat := cat.

                pkg = prevPkg ifTrue:[
                    entry at:'packageOrEmptyIfSame' put:''.
                ] ifFalse:[
                    entry at:'packageOrEmptyIfSame' put:pkg.
                ].
                prevPkg := pkg.

                list add:entry.
            ].

    ^ list
! !

!SmalltalkShareServer methodsFor:'private helpers'!

classInfoFor:aClass
    |classEntry flags|

    classEntry := Dictionary new.
    classEntry at:'className' put:aClass name.
    classEntry at:'categoryName' put:aClass category.
    classEntry at:'packageName' put:aClass package.

    aClass superclass notNil ifTrue:[
        classEntry at:'superclassName' put:aClass superclass name.
    ].

    classEntry at:'instVarNames' put:aClass instanceVariableString.
    classEntry at:'classVarNames' put:aClass classVariableString.
    classEntry at:'classInstVarNames' put:aClass class instanceVariableString.

    "/ the following code should be portable across smalltalk-implementations
    "/ i.e. use query accessors even if the numeric flag values of the underlying
    "/ smalltalk flag bits is the same.

    flags := 0.   "/ F_NOT_INDEXED
    aClass isVariable ifTrue:[
        aClass isBytes ifTrue:[
            flags := 1   "/ F_INDEX_BYTES
        ] ifFalse:[ aClass isWords ifTrue:[
            flags := 2   "/ F_INDEX_WORDS
        ] ifFalse:[ aClass isLongs ifTrue:[
            flags := 3   "/ F_INDEX_LONGS
        ] ifFalse:[ aClass isFloats ifTrue:[
            flags := 6   "/ F_INDEX_FLOATS
        ] ifFalse:[ aClass isDoubles ifTrue:[
            flags := 7   "/ F_INDEX_DOUBLES
        ] ifFalse:[ aClass isSignedWords ifTrue:[
            flags := 8   "/ F_INDEX_SIGNEDWORDS
        ] ifFalse:[ aClass isSignedLongs ifTrue:[
            flags := 9   "/ F_INDEX_SIGNEDLONGS
        ] ifFalse:[ aClass isLongLongs ifTrue:[
            flags := 10  "/ F_INDEX_LONGLONGS
        ] ifFalse:[ aClass isSignedLongLongs ifTrue:[
            flags := 11  "/ F_INDEX_SIGNEDLONGLONGS
        ] ifFalse:[ aClass isWeakPointers ifTrue:[
            flags := 5   "/ F_INDEX_WEAKPOINTERS
        ] ifFalse:[ 
            flags := 4   "/ F_INDEX_POINTERS
        ]]]]]]]]]].
    ].

    classEntry at:'flags' put:flags.
    ^ classEntry
! !

!SmalltalkShareServer methodsFor:'queries'!

portNumbers
    ^ ( 33333 to: 33399 )
! !

!SmalltalkShareServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SmalltalkShareServer.st,v 1.6 2018-01-19 22:52:56 cg Exp $'
! !


"
 COPYRIGHT (c) 1996-2011 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2011 by Jan Vrany, Jan Kurs and Marcel Hlopko
 COPYRIGHT (c) 2015-2016 Jan Vrany
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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

NameSpace subclass:#JavaPackage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support'
!

!JavaPackage class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2011 by Claus Gittinger
 COPYRIGHT (c) 2015-2016 Jan Vrany

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2011 by Jan Vrany, Jan Kurs and Marcel Hlopko
 COPYRIGHT (c) 2015-2016 Jan Vrany
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

!JavaPackage class methodsFor:'initialization'!

initialize

    "Create JAVA namespace (for easy class access)"
    Class withoutUpdatingChangesDo:[
	     self name: #JAVA
    ]

    "Created: / 28-02-2012 / 19:33:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaPackage class methodsFor:'instance creation'!

fullName:fullNameSpaceName
    "given a possibly nested name of a namespace, create all required
     intermediate spaces (if not already existing) and return the
     bottom-level space."

    "/ break it up, check for all intermediate spaces to exist
    "/ create them as required.

    |list thisNamespace|

    (fullNameSpaceName includes:$:) ifTrue:[
        "/ old style
        list := fullNameSpaceName asCollectionOfSubstringsSeparatedByAll:'::'.
    ] ifFalse:[
        "/ new style
        list := fullNameSpaceName asCollectionOfSubstringsSeparatedBy:$..
    ].

    "/ now, look and create 'em

    thisNamespace := nil.
    list do:[:aName |
        |key x|

        key := aName asSymbol.

        thisNamespace isNil ifTrue:[
            (Smalltalk includesKey:key) ifTrue:[
                thisNamespace := Smalltalk at:key.
                thisNamespace notNil ifTrue:[
                    thisNamespace isBehavior ifFalse:[
                         self error:'name conflict: java package ' , aName , ' vs. global with the same name'.
                    ].
                    (thisNamespace ~~ JAVA and:[thisNamespace isJavaPackage not and:[(thisNamespace name startsWith: #'JAVA_') not]]) ifTrue:[
                        self error:'name conflict: non-java package ' , aName , 'aleady exists'.
                    ].
                ]
            ].
            thisNamespace isNil ifTrue:[
                thisNamespace := self name:key
            ].
        ] ifFalse:[
            thisNamespace isNameSpace ifTrue:[
                x := thisNamespace at:key.
            ] ifFalse:[
                thisNamespace isBehavior ifTrue:[
                    x := thisNamespace privateClassesAt:key.
                ].
            ].
            x isNil ifTrue:[
                x :=
                    self subclass:key
                       instanceVariableNames:''
                       classVariableNames:''
                       poolDictionaries:''
                       privateIn:thisNamespace.
                "/ nameSpaces are not in any package (yet)
                x setPackage:nil.
            ].
            thisNamespace := x.
        ].
    ].

    ^ thisNamespace

    "Created: / 08-11-1996 / 13:41:59 / cg"
    "Modified: / 04-01-1997 / 16:50:59 / cg"
    "Modified: / 11-01-2016 / 22:43:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name:aStringOrSymbol
    "create a new nameSpace, named aStringOrSymbol.
     Notice, that the nameSpace is created in the current one -
     don't get confused; we recommend, not to nest them too much."

    |currentNameSpace newNameSpace existing ok nameSym fullName|

    ok := aStringOrSymbol first isLetter.
    ok ifTrue:[
        (aStringOrSymbol
            findFirst:[:ch | (ch isLetterOrDigit or:[ch == $_]) not]
            startingAt:2) ~~ 0
        ifTrue:[
            ok := false.
        ]
    ].
    ok ifFalse:[
        self error:'invalid namespace name:''' , aStringOrSymbol printString , ''' (must be a valid identifier)'.
    ].

    nameSym := aStringOrSymbol asSymbol.

    self == JavaPackage ifTrue:[
        "/ currentNameSpace := Class nameSpaceQuerySignal query.
        currentNameSpace isNil ifTrue:[
            currentNameSpace := Smalltalk
        ].
        fullName := nameSym
    ] ifFalse:[
        currentNameSpace := self.
        fullName := (self name , '::' , nameSym) asSymbol
    ].

    (existing := currentNameSpace at:nameSym) notNil ifTrue:[
        ^ existing
    ].
    newNameSpace := self
        subclass:fullName
        instanceVariableNames:''
        classVariableNames:''
        poolDictionaries:''
        category:'uncategorized namespace'
        inEnvironment:Smalltalk.

    "/ nameSpaces are not in any package
    newNameSpace notNil ifTrue:[newNameSpace setPackage:nil].
    ^ newNameSpace

    "
     NameSpace name:'foo'
     (NameSpace name:'foo') category:'my name space'
     foo at:#bar put:(Metaclass new new)
     (NameSpace name:'foo') name:'bar'
    "
    "
     NameSpace name:'an-invalid++name'
     NameSpace name:'another:invalidName'
     NameSpace name:'another::invalidName'
    "

    "Modified: / 14-09-1997 / 09:46:59 / cg"
    "Modified: / 18-03-1999 / 18:24:13 / stefan"
    "Created: / 28-02-2012 / 19:29:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaPackage class methodsFor:'accessing'!

compiler
    ^ self == JavaPackage ifTrue:[
         super compiler
    ] ifFalse:[
         JavaPackage class basicNew setName: (self name , '::compiler') asSymbol
    ].

    "Created: / 24-09-2013 / 02:33:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source
    ^ self == JavaPackage ifTrue:[
         super source
    ] ifFalse:[
         JavaPackage class basicNew setName: (self name , '::source') asSymbol
    ].

    "Created: / 24-09-2013 / 02:34:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaPackage class methodsFor:'error handling'!

doesNotUnderstand: aMessage
    | sel classOrPackage |

    Java isNil ifTrue:[
        "/ STX:LIBJAVA not loaded
        ^ super doesNotUnderstand: aMessage
    ].

    sel := aMessage selector.
    classOrPackage := self at: sel ifAbsent:[ nil ].
    classOrPackage isNil ifTrue:[
        sel numArgs ~~ 0 ifTrue:[
            super doesNotUnderstand: aMessage
        ] ifFalse:[
            sel first isLowercase ifTrue:[
                classOrPackage := JavaPackage class basicNew setName: (self name , '::' , sel) asSymbol
            ] ifFalse:[
                | fullName |

                self == JAVA
                                ifTrue:[ fullName := sel ]
                                ifFalse:[ fullName := (((self name asCollectionOfSubstringsSeparatedByAll:'::') allButFirst asStringWith:$/) , '/' , sel). ].
"/                classOrPackage := JavaClassAccessor fullName: fullName
                classOrPackage := Java classForName: fullName.
            ]
        ]
    ].
    ^ classOrPackage

    "Created: / 28-02-2012 / 20:21:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 13-11-2014 / 16:53:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaPackage class methodsFor:'fileOut'!

fileOutDefinitionOn:aStream
    "redefined to generate another definition message"

    self == JavaPackage ifTrue:[
        self basicFileOutDefinitionOn: aStream withNameSpace: false.
    ] ifFalse:[
        aStream nextPutAll:('JavaPackage name:' , self name storeString)
    ].

    "Created: / 24-03-2009 / 15:56:17 / karpij1 <karpij1@fel.cvut.cz>"
    "Modified: / 04-12-2011 / 12:19:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaPackage class methodsFor:'printing & storing'!

displayString
    "return a printed represenation - here, a reminder is appended,
     that this is not a regular class"

    self == JavaPackage ifTrue:[
        ^ self name
    ].
    self == JAVA ifTrue:[
        ^ 'JAVA /* Java package root */'
    ].
    ^ self name , ' /* Java package */'

    "Created: / 08-11-1996 / 21:37:24 / cg"
    "Modified: / 20-12-1996 / 15:11:31 / cg"
    "Created: / 28-02-2012 / 19:07:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaPackage class methodsFor:'queries'!

isJavaPackage
    "Anser true, if receiver is a java package. My subclasses are java packages"

    ^self ~~ JavaPackage
        and:[self name ~~ #JAVA
        and:[(self name includes: $:)]]

    "Created: / 04-12-2011 / 12:22:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-09-2013 / 17:52:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNameSpace
    "return true, if the receiver is a nameSpace.
     Unconditionally true here for subclasses - my subclasses are namespaces"

    ^ self ~~ JavaPackage .
!

isRealNameSpace
    "return true, if the receiver is a nameSpace, but not Smalltalk (which is also a class).
     Unconditionally true here for subclasses - my subclasses are namespaces"

    ^ self ~~ JavaPackage .
! !

!JavaPackage class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


JavaPackage initialize!

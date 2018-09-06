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

JavaUnresolvedConstant subclass:#JavaUnresolvedClassConstant
	instanceVariableNames:'nameIndex fullName'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support'
!

!JavaUnresolvedClassConstant class methodsFor:'documentation'!

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

!JavaUnresolvedClassConstant class methodsFor:'instance creation'!

fullName:nm
    |ref|

    ref := Java unresolvedClassRefFor:nm.
    ref notNil ifTrue:[^ ref].

    ref := self new setBinaryName: nm.
    Java rememberUnresolved:ref.
    ^ ref

    "Modified: / 19.10.1998 / 20:18:13 / cg"
!

pool:aPool poolIndex:slotIndex fullName:aString
    ^ self new 
          pool:aPool poolIndex:slotIndex fullName:aString

    "Created: / 4.2.1998 / 22:13:13 / cg"
    "Modified: / 4.2.1998 / 22:13:28 / cg"
!

pool:aPool poolIndex:slotIndex nameIndex:index
    ^ self new 
          pool:aPool poolIndex:slotIndex nameIndex:index

    "Modified: / 4.2.1998 / 22:13:38 / cg"
! !

!JavaUnresolvedClassConstant class methodsFor:'others'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

!JavaUnresolvedClassConstant methodsFor:'* As yet uncategorized *'!

javaClassForNew

    ^self javaClass

    "Created: / 16-03-2011 / 16:09:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaUnresolvedClassConstant methodsFor:'accessing'!

className
    |s nm|

    (fullName startsWith:$[) ifTrue:[
        "/ a ref for newarray or new or checkCast

        s := fullName readStream.
        [ s peek == $[ ] whileTrue:[
            s next.
        ].
        nm := JavaMethod retvalSpecFromStream:s in:nil.
        ^ nm
    ].
    ^ fullName

    "Modified: / 8.1.1998 / 19:11:37 / cg"
!

deref
    |refClassName cls|

    (fullName startsWith:'[L') ifTrue:[
        refClassName := fullName copyFrom:3 to:(fullName indexOf:$;)-1.
        cls := Java at:refClassName.
        cls notNil ifTrue:[
            ^ cls
        ].
        ^ JavaUnresolvedClassConstant basicNew setBinaryName: refClassName
    ].
    (fullName startsWith:'[[C') ifTrue:[
        ^ JavaBuiltInClassPointerRef new nameandType:'[C'.
    ].

    "Created: / 7.4.1997 / 13:38:07 / cg"
    "Modified: / 6.2.1998 / 01:21:01 / cg"
!

fullName
    ^ fullName

!

javaClass
    | cls  clsName |

    "/fullName first == $[ ifTrue:[self halt].
    fullName isNil ifTrue: [
        self preResolve.
        fullName isNil ifTrue: [ self halt. ]
    ].
    (fullName first = $[) ifTrue: [
        cls := (JavaDescriptor fromString: fullName) javaClass
    ] ifFalse: [ cls := JavaVM classForName: fullName ].
    constantPool at: constantPoolIndex put: cls.
    ^ cls

    "old code:"
    "
     (fullName startsWith:$[) ifTrue:[
        self halt.
        clsName := self className.
        (Java classForName:clsName) ifNil:
            [self error: 'Cannot resolve class ' , clsName].
        cls := (JavaDescriptor fromString: fullName) javaClass.
     ] ifFalse:[
        clsName := fullName
     ].
     cls := Java classForName:clsName.
     constantPool at: constantPoolIndex put: cls.
     ^cls"
    "Modified: / 10-11-1998 / 19:29:28 / cg"
    "Modified: / 11-02-2011 / 07:53:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lastName
    | idx |

    idx := fullName lastIndexOf:$/.
    ^ idx isNil ifTrue:[ fullName ] ifFalse:[ fullName copyFrom:idx + 1 ].

    "Created: / 18-10-2010 / 22:20:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 04-08-2014 / 15:50:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ fullName copyReplaceAll:$/ with:$.

    "Created: / 7.2.1997 / 23:44:47 / cg"
    "Modified: / 18.7.1998 / 22:57:47 / cg"
!

pool:aPool poolIndex:slotIndex fullName:aString
    constantPool := aPool.
    constantPoolIndex := slotIndex.
    fullName := aString.

    "Created: / 4.2.1998 / 22:15:22 / cg"
!

pool:aPool poolIndex:slotIndex nameIndex:name_index
    constantPool := aPool.
    constantPoolIndex := slotIndex.
    nameIndex := name_index.

!

setBinaryName: aNameString 
    fullName := aNameString

    "Created: 7.4.1997 / 13:37:45 / cg"
!

smalltalkArrayClass
    (fullName startsWith:'[[') ifTrue:[
        ^ Array
    ].
    (fullName startsWith:'[F') ifTrue:[
        ^ FloatArray
    ].
    (fullName startsWith:'[B') ifTrue:[
        ^ ByteArray
    ].
    self halt.

    "Created: 7.4.1997 / 13:35:25 / cg"
! !

!JavaUnresolvedClassConstant methodsFor:'converting'!

asClassPointerRef
    (fullName startsWith:'[[') ifTrue:[
        ^ JavaClassPointerRef class:Array nameandType:fullName
    ].
    (fullName startsWith:'[F') ifTrue:[
        ^ JavaClassPointerRef class:FloatArray nameandType:fullName
    ].
    (fullName startsWith:'[B') ifTrue:[
        ^ JavaClassPointerRef class:ByteArray nameandType:fullName
    ].
    (fullName startsWith:'[C') ifTrue:[
        ^ JavaClassPointerRef class:String nameandType:fullName
    ].
    self halt.

    "Created: / 7.4.1997 / 13:40:29 / cg"
    "Modified: / 25.1.1998 / 19:56:54 / cg"
! !

!JavaUnresolvedClassConstant methodsFor:'printing & storing'!

displayString
    fullName isNil ifTrue:[
        ^ 'UnresolvedClass(** nil **)'
    ].
    ^ 'UnresolvedClass(' , (fullName copyReplaceAll:$/ with:$.) , ')'

    "Modified: / 18.7.1998 / 22:57:36 / cg"
! !

!JavaUnresolvedClassConstant methodsFor:'queries'!

isJavaClassRef
    ^ true

    "Created: / 9.11.1999 / 17:07:15 / cg"
!

isUnresolvedClass
    ^ true

    "Created: / 20.10.1998 / 17:43:36 / cg"
!

package
    "extract from the fullName"

    |components|

    components := fullName asCollectionOfSubstringsSeparatedBy:$/.
    components size > 1 ifTrue:[
        ^ (components copyButLast:1) asStringWith:$/
    ].
    ^ fullName

    "Created: / 12.11.1998 / 21:11:30 / cg"
! !

!JavaUnresolvedClassConstant methodsFor:'resolving'!

preResolve
    |clsName cls nm ref|

    fullName isNil ifTrue:[
        "/ first, resolve my name ...

        clsName := constantPool at:nameIndex.
        "/ DEBUGGING
        clsName isString ifFalse:[
            self halt:'oops - no class name string in const pool'.
        ].
        fullName := clsName
    ].

    "/ try to resolve the class

    (fullName size == 1) ifTrue:[
            "/ good - this is a primitive
            ref := JavaBuiltInClassPointerRef class:(JavaDescriptor fromString: fullName) javaClass nameandType:fullName.
            constantPool at:constantPoolIndex put:ref.
            ^ ref
    ].

    (fullName includes:$[) ifFalse:[
        cls := Java classNamed:fullName.
        cls notNil ifTrue:[
            "/ good - the class is already loaded.
            constantPool at:constantPoolIndex put:cls.
            ^ cls
        ].
    ] ifTrue:[
        "
            Deal with Sun's malformed class refs generated by
            sun.misc.ProxyGenerator -  it generates
            java/lang/annotation/ElementType[] instead of
            [Ljava/lang/annotation/ElementType[];
            as the spec requires!!
        "
        (fullName last == $] and:[(fullName at: fullName size - 1) == $[]) ifTrue:
            [fullName := '[L', (fullName copyTo: fullName size - 2) , ';'].

        (fullName includes: $L) ifFalse:[
            "/ good - this is a primitive array
            ref := JavaBuiltInClassPointerRef class:(JavaDescriptor fromString: fullName) javaClass nameandType:fullName.
            constantPool at:constantPoolIndex put:ref.
            ^ ref
        ].
    ].


    (fullName startsWith:$[) ifFalse:[
        nm := self className.
        self rememberForResolveWith:nm.            
    ].
    ^ self

    "Created: / 15-04-1996 / 15:51:42 / cg"
    "Modified: / 06-07-1999 / 23:41:04 / cg"
    "Modified: / 11-02-2011 / 10:41:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaUnresolvedClassConstant class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaUnresolvedClassConstant.st,v 1.51 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaUnresolvedClassConstant.st,v 1.51 2015-03-20 12:08:00 vrany Exp $'
!

version_SVN
    ^ 'Id'
! !


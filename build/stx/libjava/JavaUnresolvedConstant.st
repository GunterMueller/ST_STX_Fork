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

Object subclass:#JavaUnresolvedConstant
	instanceVariableNames:'nextUnresolved prevUnresolved constantPool constantPoolIndex'
	classVariableNames:'PatchLists'
	poolDictionaries:''
	category:'Languages-Java-Reader-Support'
!

!JavaUnresolvedConstant class methodsFor:'documentation'!

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

!JavaUnresolvedConstant class methodsFor:'instance creation'!

pool:aPool poolIndex:index
    ^ self new 
        pool:aPool poolIndex:index


! !

!JavaUnresolvedConstant class methodsFor:'queries'!

countUnresolved
    |u cnt|

    cnt := 0.
    PatchLists do:[:patchList |
        u := patchList.
        [u notNil] whileTrue:[
            cnt := cnt + 1.
            u := u nextUnresolved
        ]
    ].
    ^ cnt

    "
     self countUnresolved 
    "
! !

!JavaUnresolvedConstant class methodsFor:'resolving'!

flushPatchLists
    PatchLists := nil
!

patchLists
    "return a collection of patchInfos for unresolved names"

    ^ PatchLists ? #()

    "Created: / 20.10.1998 / 17:40:19 / cg"
!

resolveFor:aJavaClass
    "a JAVA class has been loaded - resolve what can be"

    |patchList unresolved nameSymbol|

"/ 'resolving: ' print. aJavaClass fullName printCR.

    PatchLists isNil ifTrue:[^ self].

    nameSymbol := aJavaClass fullName asSymbol.
    patchList := PatchLists at:nameSymbol ifAbsent:nil.
    patchList notNil ifTrue:[
        PatchLists removeKey:nameSymbol.

        [patchList notNil] whileTrue:[
            unresolved := patchList.
            patchList := unresolved nextUnresolved.

            unresolved prevUnresolved:nil.
            unresolved nextUnresolved:nil.
            unresolved preResolve.
        ]
    ].

!

unresolvedClassNames
    "return a collection of unresolved class names"

    |l|

    PatchLists isNil ifTrue:[^ #()].

    "/ kludge - ignore those primitive classes ...
    l := PatchLists keys 
             select:[:clsName |
                (clsName == #char
                or:[clsName == #float
                or:[clsName == #double
                or:[clsName == #'unsigned short'
                or:[clsName == #long
                or:[clsName == #boolean]]]]]) not
             ].
    ^ l

    "
     self unresolvedClassNames 
    "

    "Modified: 17.8.1997 / 20:06:46 / cg"
! !

!JavaUnresolvedConstant methodsFor:'accessing'!

constantPool
    ^ constantPool

    "Created: 15.4.1996 / 15:59:45 / cg"
!

constantPool:aPool
    constantPool := aPool

    "Created: 7.4.1997 / 16:13:02 / cg"
!

constantPoolIndex
    ^ constantPoolIndex

    "Created: 15.4.1996 / 15:59:45 / cg"
!

nextUnresolved
    ^ nextUnresolved
!

nextUnresolved:anUnresolvedConstant
    nextUnresolved := anUnresolvedConstant
!

pool:aPool poolIndex:i
    constantPool := aPool.
    constantPoolIndex := i

    "Created: 15.4.1996 / 15:59:45 / cg"
!

prevUnresolved:anUnresolvedConstant
    prevUnresolved := anUnresolvedConstant
! !

!JavaUnresolvedConstant methodsFor:'printing & storing'!

displayString
    ^ (self class name) , '( idx= ' , constantPoolIndex printString , ')'


! !

!JavaUnresolvedConstant methodsFor:'queries'!

isJavaMethodRef
    ^ false

    "Created: / 14.11.1999 / 15:51:33 / cg"
!

isUnresolved
    ^ true
!

isUnresolvedClass
    ^ false

    "Created: / 20.10.1998 / 17:43:27 / cg"
!

isUnresolvedMethod
    ^ false

    "Created: / 20.10.1998 / 17:43:07 / cg"
! !

!JavaUnresolvedConstant methodsFor:'resolving'!

preResolve
    self subclassResponsibility.
    ^ self


!

rememberForResolveWith:aFullClassName
    |patchList nameSymbol|

    prevUnresolved notNil ifTrue:[^ self].

    PatchLists isNil ifTrue:[
        PatchLists := IdentityDictionary new.
    ].

    nameSymbol := aFullClassName asSymbol.
    patchList := PatchLists at:nameSymbol ifAbsent:nil.
    patchList isNil ifTrue:[
"/        ('first patch for: ' , aFullClassName) printCR.
    ] ifFalse:[
        patchList prevUnresolved:self.
        nextUnresolved := patchList.
    ].
    PatchLists at:nameSymbol put:self.
    prevUnresolved := #startOfList.

! !

!JavaUnresolvedConstant methodsFor:'special'!

updateClassRefsFrom:oldClass to:newClass

    "Created: 7.8.1997 / 18:21:19 / cg"
! !

!JavaUnresolvedConstant class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaUnresolvedConstant.st,v 1.19 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaUnresolvedConstant.st,v 1.19 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


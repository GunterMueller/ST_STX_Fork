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

Array variableSubclass:#JavaConstantPool
	instanceVariableNames:'owner'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support'
!

!JavaConstantPool class methodsFor:'documentation'!

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

!JavaConstantPool class methodsFor:'special'!

invalidateForClass: internalJavaClassName 
    "Go over all constant pools and call invalidateForClass on all 
     references. (usable when given class was unloaded etc)"
    JavaVM registry allClassesDo: [ :eachClass | 
        eachClass versionsArray do: [ :eachVersion | 
            eachVersion constantPool invalidateForClass: internalJavaClassName.
        ].
    ].

    "Created: / 08-04-2011 / 16:52:52 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 08-10-2013 / 18:43:59 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 09-04-2014 / 18:43:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaConstantPool methodsFor:'accessing'!

owner
    "return owner"

    ^ owner

    "Created: 28.6.1996 / 21:12:22 / cg"
!

owner:something
    "set owner"

    owner := something.

    "Created: 28.6.1996 / 21:12:22 / cg"
! !

!JavaConstantPool methodsFor:'adding'!

at: classRefIndex putClassRefWithNameAt: classNameIndex 
    self at: classRefIndex
        put: (JavaClassRef2 in: self withNameAt: classNameIndex).

    "Created: / 13-05-2011 / 09:48:01 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

at: fieldRefIndex putFieldRefWithClassAt: classRefIndex andNameAndTypeAt: nameAndTypeIndex 
    self at: fieldRefIndex
        put: (JavaFieldRef2 
                in: self
                withNameAndTypeAt: nameAndTypeIndex
                andClassAt: classRefIndex).

    "Created: / 13-05-2011 / 09:08:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

at: interfaceMethodRefIndex putInterfaceMethodRefWithClassAt: classRefIndex andNameAndTypeAt: nameAndTypeIndex 
    self at: interfaceMethodRefIndex
        put: (JavaInterfaceMethodRef2 
                in: self
                withNameAndTypeAt: nameAndTypeIndex
                andClassAt: classRefIndex).

    "Created: / 13-05-2011 / 09:08:50 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

at: methodRefIndex putMethodRefWithClassAt: classRefIndex andNameAndTypeAt: nameAndTypeIndex
    self at: methodRefIndex
        put: (JavaMethodRef2 in: self withNameAndTypeAt: nameAndTypeIndex andClassAt:classRefIndex).

    "Created: / 13-05-2011 / 09:07:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

at: nameAndTypeIndex putNameAndTypeWithNameAt: nameIndex andDescriptorAt: descriptorIndex
    self at: nameAndTypeIndex
        put: (JavaNameAndType2 in: self withNameAt: nameIndex andDescriptorAt: descriptorIndex).

    "Created: / 13-05-2011 / 09:05:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaConstantPool methodsFor:'invalidation'!

invalidate 
    "Invalidate all resolved references. Returns true if at least one ref has 
     been invalidated, false otherwise"
    
    | anyInvalidated |

    anyInvalidated := false.
    self do: [:ref | 
        (ref notNil and: [ ref isString not and: [ ref isNumber not ] ]) ifTrue: [
            anyInvalidated := anyInvalidated | (ref invalidate)
        ].
    ].
    anyInvalidated ifTrue:[ JavaVM flushCachesFor: owner  ].  
    ^ anyInvalidated

    "Created: / 20-01-2014 / 09:43:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidateForClass: binaryName 
    "Invalidate all resolved references to given class.
     Returns true if at least one ref has been invalidated,
     false otherwise"
    
    | anyInvalidated |

    anyInvalidated := false.
    self do: [:ref | 
        (ref notNil and: [ ref isString not and: [ ref isNumber not ] ]) ifTrue: [
            anyInvalidated := anyInvalidated 
                    | (ref invalidateForClass: binaryName)
        ].
    ].
    anyInvalidated ifTrue:[ JavaVM flushCachesFor: owner  ].
    ^ anyInvalidated

    "Created: / 08-04-2011 / 16:11:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 20-01-2014 / 10:15:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaConstantPool methodsFor:'printing & storing'!

displayString
    owner isNil ifTrue:[
        ^ '*** unowned ConstantPool'
    ].
    ^ 'ConstantPool of ' , owner fullName

    "Created: 28.6.1996 / 21:13:41 / cg"
    "Modified: 28.6.1996 / 21:20:26 / cg"
! !

!JavaConstantPool methodsFor:'queries'!

refersToMethod:aJavaMethod

    self error: 'JV@2011-07-26: Update to new resolving scheme!!'.

    self do:[:constItem |
        (constItem == aJavaMethod) ifTrue:[^ true].

    ].
    ^ false

    "Created: / 29-07-1997 / 17:39:19 / cg"
    "Modified: / 26-07-2011 / 18:00:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

refersToMethodNamed:aJavaMethodName

    self error: 'JV@2011-07-26: Update to new resolving scheme!!'.
    
    self do:[:constItem |
        (constItem isKindOf:JavaMethod) ifTrue:[
            constItem name = aJavaMethodName ifTrue:[^ true].
        ] ifFalse:[
            
        ]
    ].
    ^ false

    "Created: / 29-07-1997 / 17:39:24 / cg"
    "Modified: / 16-10-1998 / 01:22:02 / cg"
    "Modified: / 26-07-2011 / 17:54:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaConstantPool methodsFor:'special'!

classReferencesDo:aBlock
    self do:[:constItem |
        constItem isJavaClass ifTrue:[
            aBlock value:constItem
        ] 
    ]

    "Modified: / 7.8.1997 / 19:17:38 / cg"
    "Created: / 4.1.1998 / 00:40:11 / cg"
!

invalidateAll 
    "go over all entries and call invalidate on all references"
    
    self do: 
            [:entry | 
            entry isJavaRef 
                ifTrue: [ entry invalidate] ].

    "Created: / 13-05-2011 / 09:37:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaConstantPool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libjava/JavaConstantPool.st,v 1.22 2015-03-20 12:08:00 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaConstantPool.st,v 1.22 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


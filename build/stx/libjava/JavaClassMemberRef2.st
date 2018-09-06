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

JavaRef2 subclass:#JavaClassMemberRef2
	instanceVariableNames:'classRefIndex nameAndTypeIndex resolvedClass type'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support-new'
!

!JavaClassMemberRef2 class methodsFor:'documentation'!

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

documentation
"
    An abstract base superclass for method refs and field refs.

    [author:]
        Marcel Hlopko <marcel.hlopko@fit.cvut.cz>
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
        classRefIndex ...... index to constant pool to classref describing
                             method's or field's class.
        nameAndTypeIndex ... index to constant pool to name-and-type structure
                             describing name and type of field or name and descriptor
                             of a method.
      !! resolvedClass ...... once a reference is resolved, this slot contains
                             the class to in which this method/field is defined.
                             !!!!!! Used by the VM !!!!!!               
      !! type ............... this slot contains integer of value:
                              - ACX_R_VOID     if method returns void.
                              - ACX_R_DOUBLE   if method returns long / field is of type long
                              - ACX_R_DOUBLE   if method returns double / field is of type double
                              - 0              otherwise.
                             This value is used by both interpreter and JIT compiler to correctly
                             push/pop values onto/from stack. long/double occupies 2 slots (2x 32 bit)
                             !!!!!! Used by the VM !!!!!!               
    [class variables:]

    [see also:]
        JavaFieldRef2
        JavaMethodRef2

"
! !

!JavaClassMemberRef2 class methodsFor:'instance creation'!

in: aJavaConstantPool withNameAndTypeAt: nameAndTypeCPIndex andClassAt: classRefCPIndex 
    ^ self basicNew 
        initializeIn: aJavaConstantPool
        withNameAndTypeAt: nameAndTypeCPIndex
        andClassAt: classRefCPIndex.

    "Created: / 12-05-2011 / 18:36:18 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassMemberRef2 methodsFor:'accessing'!

classRef
    ^ constantPool at: classRefIndex.

    "Modified: / 12-05-2011 / 18:38:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

descriptor
    ^ self nameAndType descriptor.

    "Created: / 08-04-2011 / 15:08:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:39:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

javaClass
    ^ resolvedClass

    "Created: / 20-01-2014 / 15:03:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    ^ self nameAndType name.

    "Created: / 08-04-2011 / 13:54:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:39:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

nameAndType
    ^ constantPool at: nameAndTypeIndex.

    "Created: / 11-04-2011 / 19:57:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:39:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

resolvedClass
    ^ resolvedClass
!

selector
    ^ self nameAndType selector.

    "Created: / 11-04-2011 / 20:38:54 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:39:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

signature
    ^ self nameAndType signature.

    "Created: / 20-05-2011 / 17:10:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassMemberRef2 methodsFor:'comparing'!

= anotherJavaRef

    ^ self class == anotherJavaRef class 
        and:[self classRef = anotherJavaRef classRef
            and:[self nameAndType = anotherJavaRef nameAndType]]

    "Modified: / 30-08-2013 / 17:15:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    ^ self classRef hash bitXor: self nameAndType hash

    "Modified: / 30-08-2013 / 17:14:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassMemberRef2 methodsFor:'initialization'!

initializeIn: aJavaConstantPool withNameAndTypeAt: nameAndTypeCPIndex andClassAt: classRefCPIndex    
    constantPool := aJavaConstantPool.
    classRefIndex := classRefCPIndex.
    nameAndTypeIndex := nameAndTypeCPIndex.
    super initialize.

    "Created: / 12-05-2011 / 18:37:10 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassMemberRef2 methodsFor:'printing'!

displayString
    "superclass JavaRef2 says that I am responsible to implement this method"

    ^ self classRef displayString , '.' , self name

    "Created: / 14-08-2011 / 21:18:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printString
    ^ 'JavaClassContentRef: class=[' , self classRef printString , '] name=[' 
        , self nameAndType printString , ']'.

    "Created: / 10-05-2011 / 14:15:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:40:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaClassMemberRef2 methodsFor:'resolving'!

invalidate
    self classRef invalidate.    
    resolvedClass := nil.
    ^ super invalidate.

    "Created: / 13-04-2011 / 12:21:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 18-05-2011 / 12:41:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 03:02:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidateForClass: class 
    "Invalidate (means call invalidate) reference if it has something to do with given class (e.g Class named internalJavaClassName was unloaded).
     Return true, if reference was invalidated."
    
    (self classRef invalidateForClass: class) ifTrue: [
        self invalidate.
        ^ true
    ].
    ^ false.

    "Modified: / 12-05-2011 / 18:40:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 21-02-2012 / 10:21:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaClassMemberRef2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaClassMemberRef2.st,v 1.2 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


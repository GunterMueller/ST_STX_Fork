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

Object subclass:#JavaNameAndType2
	instanceVariableNames:'constantPool nameIndex descriptorIndex nameCache descriptorCache'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support-new'
!

!JavaNameAndType2 class methodsFor:'documentation'!

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

!JavaNameAndType2 class methodsFor:'instance creation'!

in: aJavaConstantPool withNameAt: arg1 andDescriptorAt: arg2 
    "Create & return a new instance for arg."
    
    ^ self basicNew 
        initializeIn: aJavaConstantPool
        withNameAt: arg1
        andDescriptorAt: arg2

    "Created: / 10-05-2011 / 15:45:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaNameAndType2 methodsFor:'accessing'!

constantPool
^constantPool.

    "Created: / 10-05-2011 / 17:16:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

constantPool: aJavaConstantPool
    constantPool := aJavaConstantPool.

    "Created: / 10-05-2011 / 17:16:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

descriptor
    ^constantPool at: descriptorIndex.

    "Created: / 08-04-2011 / 11:55:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:51:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

name
    ^ constantPool at: nameIndex.

    "Created: / 08-04-2011 / 11:55:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:42:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

owner
    ^ constantPool owner.

    "Created: / 12-05-2011 / 18:43:06 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

owner: javaClass
    constantPool owner: javaClass.

    "Created: / 12-05-2011 / 18:43:12 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

selector    
    ^ (self name , self descriptor) asSymbol.

    "Created: / 11-04-2011 / 21:31:27 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:51:55 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaNameAndType2 methodsFor:'backward compatibility'!

isUnresolved
^false.

    "Created: / 13-05-2011 / 18:43:17 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

signature
^self descriptor.

    "Created: / 13-05-2011 / 18:45:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaNameAndType2 methodsFor:'comparing'!

= aNameAndType 
    self name ~= aNameAndType name ifTrue: [ ^ false ].
    ^ self descriptor = aNameAndType descriptor.

    "Created: / 08-04-2011 / 11:56:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:44:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

hash
    ^ self name hash bitXor: self descriptor hash.

    "Created: / 08-04-2011 / 11:57:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:44:26 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaNameAndType2 methodsFor:'initialization'!

initializeIn: aJavaConstantPool withNameAt: nameCPIndex andDescriptorAt: descriptorCPIndex 
    nameIndex := nameCPIndex.
    descriptorIndex := descriptorCPIndex.
    constantPool := aJavaConstantPool.
    super initialize.

    "Created: / 10-05-2011 / 15:45:00 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaNameAndType2 methodsFor:'logging'!

info: arg 

    Logger log: arg severity: Logger severityINFO facility: 'JVM'

    "Created: / 10-05-2011 / 16:50:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:06:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

warning: arg 

    Logger log: arg severity: Logger severityWARN facility: 'JVM'

    "Created: / 10-05-2011 / 15:01:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 14:06:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaNameAndType2 methodsFor:'printing'!

printString
    ^ 'JavaNameAndType name=' , self name printString , ' descriptor= ' 
        , self descriptor printString.

    "Created: / 10-05-2011 / 14:17:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 12-05-2011 / 18:44:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaNameAndType2 methodsFor:'queries'!

isJavaNameAndType
    "return true, if given object represents name and type struct in java constant pool"

    ^ true.

    "Created: / 10-05-2011 / 12:23:45 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

isNewJavaNameAndType
    "only temporary, to know if name and type is old (claus' version) or new (m version)"
    
    ^ true.

    "Created: / 10-05-2011 / 12:24:16 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaNameAndType2 methodsFor:'resolving'!

invalidate
    "Name and type cannot be invalid..."
    
    ^ false

    "Created: / 20-01-2014 / 10:17:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidateForClass: aSymbol 
    "Name and type cannot be invalid..."
    
    ^ false

    "Created: / 22-02-2012 / 20:50:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preresolve
   self resolve

    "Created: / 15-10-2012 / 23:09:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolve
    nameCache := constantPool at: nameIndex.
    descriptorCache := constantPool at: descriptorIndex.
    (nameCache isNil or: [ descriptorCache isNil ]) 
        ifTrue: [ self breakPoint: #mh ].
    ^self.

    "Created: / 18-05-2011 / 13:19:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

resolve: doClassInit
   ^ self resolve.

    "Created: / 18-05-2011 / 13:19:13 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 23-02-2012 / 17:14:51 / Marcel Hlopko <hlopik@gmail.com>"
!

updateClassRefsFrom: oldOwner to: newOwner 
    self owner = oldOwner ifTrue: [
        self owner: newOwner.
    ].

    "Created: / 10-05-2011 / 16:50:48 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-06-2011 / 18:40:32 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaNameAndType2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaNameAndType2.st,v 1.9 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


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

JavaRefsAndConstantPoolTestCase subclass:#JavaRuntimeConstantPoolTests
	instanceVariableNames:'constantPoolCacheBackup'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tests-RuntimeConstantPool'
!

!JavaRuntimeConstantPoolTests class methodsFor:'documentation'!

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

!JavaRuntimeConstantPoolTests methodsFor:'helpers'!

cleanUpCPCache
    "warning - counting with the fact that cp cache is backed up in setUp and restored in tearDown methods"
    JavaConstantPool allConstantPools: OrderedCollection new.

    "Created: / 13-05-2011 / 09:42:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaRuntimeConstantPoolTests methodsFor:'running'!

setUp
    super setUp.
    constantPoolCacheBackup := JavaConstantPool allConstantPools.

    "Created: / 13-05-2011 / 09:33:39 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

tearDown
    super tearDown.
    JavaConstantPool allConstantPools: constantPoolCacheBackup.

    "Created: / 13-05-2011 / 09:33:53 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 21-03-2016 / 08:52:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRuntimeConstantPoolTests methodsFor:'tests'!

_testConstantPoolCaching
"will be enabled when caching and invalidation is implemented"
    | newConstantPool |
    JavaConstantPool allConstantPools: OrderedCollection new.
    newConstantPool := self getPrettyBigConstantPool.
    self 
        assertTrue: (JavaConstantPool allConstantPools includes: newConstantPool).

    "Created: / 12-04-2012 / 10:16:41 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_testInvalidateAll
    | cp |
    cp := self getPrettyBigConstantPool.
    cp do: [:each | each isJavaRef ifTrue: [ each resolve ] ].
    cp do: [:each | each isJavaRef ifTrue: [ self assertTrue: (each isResolved) ] ].
    cp invalidateAll.
    cp do: [:each | each isJavaRef ifTrue: [ self assertTrue: (each isResolved not) ] ].

    "Created: / 17-11-2012 / 21:44:20 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

_testInvalidateForClass
"will be enabled when caching and invalidation is implemented"
    | cp |
    self cleanUpCPCache.
    cp := self getPrettyBigConstantPool.
    cp do: [:each | each isJavaRef ifTrue: [ each resolve ] ].
    cp do: [:each | each isJavaRef ifTrue: [ self assertTrue: (each isResolved) ] ].
    JavaConstantPool invalidateForClass: 'Ljava/lang/Runnable;'.
    1 to: 13 do: [
        :index | 
        (cp at: index) isJavaRef ifTrue: [ self assertTrue: (cp at: index) isResolved ]
    ].
    14 to: 20 do: [
        :index | 
        (cp at: index) isJavaRef ifTrue: [
            self assertTrue: (cp at: index) isResolved not
        ]
    ].

    "Created: / 12-04-2012 / 10:16:47 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-10-2013 / 21:08:42 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
! !

!JavaRuntimeConstantPoolTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaRuntimeConstantPoolTests.st,v 1.6 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


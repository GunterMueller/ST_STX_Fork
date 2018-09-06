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

JavaClassMemberRef2 subclass:#JavaFieldRef2
	instanceVariableNames:'resolvedOffset'
	classVariableNames:''
	poolDictionaries:'JavaConstants'
	category:'Languages-Java-Reader-Support-new'
!

!JavaFieldRef2 class methodsFor:'documentation'!

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
    A symbolic reference to a field.

    [author:]
        Marcel Hlopko <marcel.hlopko@fit.cvut.cz>
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
      !! resolvedOffset ...... once resolved, this slot contains physical offset
                              of the field within an instance (if instance field)
                              or of the static field withing a class instance
                              (if static field).
                              !!!!!! Used by the VM !!!!!!

    [class variables:]

    [see also:]

"
! !

!JavaFieldRef2 methodsFor:'accessing'!

isJavaFieldRef
^true.

    "Created: / 11-04-2011 / 21:47:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

offset
    ^ resolvedOffset.

    "Created: / 15-05-2011 / 22:26:08 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

resolvedOffset
    ^ resolvedOffset.

    "Created: / 31-01-2014 / 09:15:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    ^ type.

    "Created: / 15-05-2011 / 22:29:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 05-10-2013 / 23:57:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldRef2 methodsFor:'printing & storing'!

printOn:aStream
    super printOn: aStream. 
    aStream nextPut: $(.
    self classRef javaClassName printOn: aStream.
    aStream nextPut:$#.
    aStream nextPutAll: self nameAndType name.  
    aStream nextPut: $).

    "Modified: / 15-08-2014 / 15:30:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldRef2 methodsFor:'private - resolving'!

findInstOffset
    "fieldRef must be resolved before calling me"
    self assert: resolvedClass notNil.
    self assert: resolvedValue notNil.
    ^ resolvedClass instVarIndexFor: self name.

    "Created: / 07-12-2011 / 13:44:59 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

findResolvedValue: doClassInit
    "
    Stores resolved field in valueCache field, fills offset and
    type fields.
    "
    resolvedValue := JavaResolver uniqueInstance
                resolveFieldIndentifiedByRef: self.
    resolvedValue isStatic ifTrue: [ resolvedClass := resolvedValue javaClass ] ifFalse: [
        resolvedClass := self classRef resolve: doClassInit.
    ].
    resolvedClass isNil ifTrue: [ self breakPoint: #mh ].
    self resolveOffset.

    "Modified: / 07-12-2011 / 21:52:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 09-02-2012 / 23:09:18 / mh <hlopik@gmail.com>"
    "Modified: / 12-10-2013 / 17:54:48 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 03:02:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

findStaticOffset
    "fieldRef must be resolved before calling me"
    self assert: resolvedClass notNil.
    self assert: resolvedValue notNil.
    ^ resolvedClass class instVarIndexFor: self name.

    "Created: / 07-12-2011 / 13:45:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

preResolve
    | descriptor |

    descriptor := (constantPool at: nameAndTypeIndex) descriptor.
    type := 0.
    descriptor = 'J' ifTrue:[
        type := ACX_R_LONG.
    ] ifFalse:[
        descriptor = 'D' ifTrue:[
            type := ACX_R_DOUBLE
        ]
    ].

    "Created: / 16-10-2012 / 10:45:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 03:38:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolveOffset
    "fieldRef must be resolved before calling me"

    self assert: resolvedValue notNil.
    self assert: resolvedClass isJavaClass.
    resolvedValue isStatic ifTrue: [ resolvedOffset := self findStaticOffset. ] ifFalse: [
        resolvedOffset := self findInstOffset.
    ].
    self assert: resolvedOffset notNil.

    "Modified: / 07-12-2011 / 21:47:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaFieldRef2 methodsFor:'resolving'!

invalidate

    resolvedOffset := nil.
    ^ super invalidate.

    "Created: / 14-10-2013 / 23:39:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-08-2014 / 14:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaFieldRef2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaFieldRef2.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


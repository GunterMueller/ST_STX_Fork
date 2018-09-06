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

JavaClassMemberRef2 subclass:#JavaMethodRef2
	instanceVariableNames:'selector numArgSlots'
	classVariableNames:''
	poolDictionaries:'JavaConstants'
	category:'Languages-Java-Reader-Support-new'
!

!JavaMethodRef2 class methodsFor:'documentation'!

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
    A symbolic reference to a method.

    [author:]
        Marcel Hlopko <marcel.hlopko@fit.cvut.cz>
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
      !! selector ......... this slot contains a selector of the method,
                           as used by the VM. Used by JIT-compiler.
                           !!!!!! Used by the VM !!!!!!           

      !! numArgSlots ...... this slot number of arguments slots. Usually number of
                           method arguments, but long and double args count for 2.
                           Used by JIT-compiler.
                           !!!!!! Used by the VM !!!!!!           

    [class variables:]

    [see also:]

"
! !

!JavaMethodRef2 methodsFor:'printing'!

displayString
    "superclass JavaRef2 says that I am responsible to implement this method"

    ^ self classRef displayString , '.' , self name , self descriptor

    "Created: / 15-08-2014 / 13:43:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodRef2 methodsFor:'printing & storing'!

printOn:aStream
    "append a printed representation if the receiver to the argument, aStream"

    super printOn:aStream.
    aStream nextPut:$(.
    self classRef name printOn: aStream.
    aStream nextPut:$#.
    self name printOn: aStream.
    aStream nextPut:$).

    "Modified: / 18-01-2014 / 21:24:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodRef2 methodsFor:'private - resolving'!

findResolvedValue: doClassInit
    "Resolve reference and set valueCache."

    resolvedValue := JavaResolver uniqueInstance
                resolveMethodIndentifiedByRef: self.
    resolvedClass := resolvedValue javaClass.
    (doClassInit and:[ resolvedClass isJavaClass ]) ifTrue:[ resolvedClass classInit ].

    "Modified: / 18-05-2011 / 12:44:07 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 09-02-2012 / 23:10:32 / mh <hlopik@gmail.com>"
    "Modified: / 12-10-2013 / 18:07:26 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 03-04-2015 / 16:26:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodRef2 methodsFor:'queries'!

isJavaMethodRef
^ true.

    "Created: / 11-04-2011 / 19:56:35 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMethodRef2 methodsFor:'resolving'!

preResolve
    "Fill in selectorCache and numArgSlotsCache for these are used
     by the JIT-compiler"

    | returnTypeChar nameAndType |

    nameAndType := self nameAndType.
    selector isNil ifTrue: [
        selector := (nameAndType name , nameAndType descriptor) asSymbol
    ].
    numArgSlots := JavaMethod numArgsFromDescriptor:nameAndType descriptor.
    returnTypeChar := nameAndType descriptor last.
    returnTypeChar == $V ifTrue:[
        type  := ACX_R_VOID.
    ] ifFalse:[
        returnTypeChar == $J ifTrue:[
            type := ACX_R_LONG.
        ] ifFalse:[
            returnTypeChar == $D ifTrue:[
                type := ACX_R_DOUBLE.
            ] ifFalse:[
                type := 0.
            ]
        ].
    ].

    "Created: / 15-10-2012 / 23:13:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 03:34:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaMethodRef2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethodRef2.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


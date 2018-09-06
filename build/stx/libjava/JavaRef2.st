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

Object subclass:#JavaRef2
	instanceVariableNames:'resolvedValue constantPool'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support-new'
!

!JavaRef2 class methodsFor:'documentation'!

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
    An abstract superclass for symbolic references in Java class files.
    A reference is either ''unresolved'' (when `resolvedValue` instvar nil)
    or ''resolved'' (when ``resolvedValue`` instvar is not nil).

    IMPORTANT: The exact physical structure of (sub)instances is known
    by the VM and therefore changing number, order or meaning of individual
    instance variables would imply to change the VM accordingly.
    See comments in individual subclasses which instvars are accessed by the VM.

    IMPORTANT: There's a naming convention:
    Slots whose name starts with ''resolved'' are valid only after the reference
    is resolved. Otherwise, they MUST have nil value.
    Other slots MUST be valid once JavaClassReader finishes reading of the 
    .class file.

    [author:]
        Marcel Hlopko <marcel.hlopko@fit.cvut.cz>
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]
      !! resolvedValue ..... resolved value whatever it is (class, method, field...).
                            It also serve as an indicator whether the reference
                            is unresolved (nil value) or resolved (non-nil value).
                            !!!!!! Used by the VM !!!!!!
        constantPool ...... a constant pool to which this reference belongs.

    [class variables:]

    [see also:]
        Subclasses

"
! !

!JavaRef2 class methodsFor:'instance creation'!

new
    "Don't call me directly"

    self shouldNotImplement

    "Modified: / 06-12-2011 / 17:02:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 02-03-2015 / 15:55:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRef2 methodsFor:'accessing'!

constantPool
^constantPool.

    "Created: / 10-05-2011 / 17:16:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

constantPool: aJavaConstantPool
    constantPool := aJavaConstantPool.

    "Created: / 10-05-2011 / 17:16:37 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

isResolved
    ^ resolvedValue notNil.

    "Created: / 08-04-2011 / 11:36:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-04-2011 / 17:39:42 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 31-01-2014 / 02:30:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
^ self subclassResponsibility.

    "Created: / 08-04-2011 / 13:53:30 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

owner
    ^ constantPool owner.

    "Modified: / 12-05-2011 / 18:31:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

owner: javaClass 
    constantPool owner: javaClass.

    "Modified: / 12-05-2011 / 18:32:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

resolvedValue
    ^ resolvedValue
! !

!JavaRef2 methodsFor:'comparing'!

= anotherJavaRef

    ^ self subclassResponsibility.

    "Created: / 08-04-2011 / 12:15:36 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 31-01-2014 / 03:14:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash

    ^ self subclassResponsibility.

    "Created: / 08-04-2011 / 12:15:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 31-01-2014 / 03:14:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRef2 methodsFor:'initialization'!

initialize
    resolvedValue := nil.
    super initialize.

    "Modified: / 08-04-2011 / 17:39:23 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaRef2 methodsFor:'printing'!

displayString

    ^self subclassResponsibility

    "Created: / 14-08-2011 / 21:18:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRef2 methodsFor:'private - resolving'!

findResolvedValue
    self findResolvedValue: true.

    "Modified: / 09-02-2012 / 23:10:09 / mh <hlopik@gmail.com>"
!

findResolvedValue: doInit
    "Resolves reference. If doInit is true, then eventually
     initialize the class"

    self subclassResponsibility

    "Created: / 09-02-2012 / 23:08:15 / mh <hlopik@gmail.com>"
    "Modified: / 10-04-2012 / 09:31:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRef2 methodsFor:'queries'!

isJavaRef
"return true if object represents reference in java constant pool"
^ true.

    "Created: / 08-04-2011 / 16:15:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

isJavaStringRef
    ^ false.

    "Created: / 29-07-2016 / 10:06:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isNewJavaRef
    "only temporary, to know if ref is old (claus' version) or new (m version)"
    
    ^ true.

    "Created: / 10-05-2011 / 12:20:05 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaRef2 methodsFor:'resolving'!

invalidate
    "Invalidate reference. Cache will be cleared and next call to resolve will 
     cause resolving from scratch. Return true if reference was resolved and
     thus invalidates or false otherwise"

    | invalidated |

    invalidated := resolvedValue notNil.
    resolvedValue := nil.
    ^ invalidated

    "Created: / 08-04-2011 / 11:42:43 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 08-04-2011 / 17:39:28 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 07-08-2014 / 14:38:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidateForClass: internalJavaClassName 
    "Invalidates receiver iff it refers (even indirectly)
     to a class ref that has been resolved to given class.
     Returns true, if the receiver has been invalidated,
     false otherwise"
    
    ^ self subclassResponsibility.

    "Created: / 08-04-2011 / 15:59:57 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (comment): / 21-02-2012 / 10:20:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preResolve
    "Pre-resolve some caches. Called when the constant pool
     is loaded. MUST NOT load new nor modify any existing class!!!!!!
     Ask JV for what this is needed"

    "Nothing by default"

    "Created: / 15-10-2012 / 23:13:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolve
    "
     Do it all method - resolves current reference and returns expected element (JavaMethod, JavaField etc.)
     Hides implementation details of the way of dealing with invalidation etc. User should not need to call anything
     else."
    
     ^ self resolve: true.

    "Created: / 08-04-2011 / 11:30:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 23-02-2012 / 17:21:39 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified (format): / 31-01-2014 / 09:08:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

resolve: doClassInit
    "Do it all method - resolves current reference and returns expected element (JavaMethod, JavaField etc.)
     If doClassInit is true, resolved class is initialized (if not already)
     Hides implementation details of the way of dealing with invalidation etc. User should not need to call anything
     else."
    
    self isResolved ifFalse: [
        constantPool owner synchronized:[  
            self isResolved ifFalse:[
                self findResolvedValue: doClassInit.
                JavaVM flushCachesFor: constantPool owner.
            ].
        ]
    ].
    ^ resolvedValue.

    "Created: / 08-04-2011 / 11:30:21 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 09-02-2012 / 23:08:15 / mh <hlopik@gmail.com>"
    "Modified: / 23-12-2013 / 23:02:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRef2 methodsFor:'testing'!

isUnresolved

    ^resolvedValue isNil

    "Created: / 22-05-2011 / 14:01:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaRef2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaRef2.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


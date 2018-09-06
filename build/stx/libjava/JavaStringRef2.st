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

JavaRef2 subclass:#JavaStringRef2
	instanceVariableNames:'valueIndex'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support-new'
!

!JavaStringRef2 class methodsFor:'documentation'!

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
    A java.lang.String literal value.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaStringRef2 class methodsFor:'instance creation'!

in: aJavaConstantPool withValueAt: valueIndex 
    ^ self basicNew initializeIn: aJavaConstantPool withValueAt: valueIndex.

    "Created: / 10-05-2011 / 14:56:15 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 28-09-2012 / 23:01:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaStringRef2 methodsFor:'accessing'!

= another 
    another isJavaRef ifFalse: [ ^ false ].
    constantPool = another constantPool ifFalse: [ ^ false ].
    valueIndex = another valueIndex ifFalse: [ ^ false ].
    ^ true.

    "Created: / 13-05-2011 / 17:19:56 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

findResolvedValue: doClassInit
    | myIndex |

    resolvedValue := 
            JavaVM 
                javaStringObjectForString: (constantPool at: valueIndex)
                interned: true.

    "JV@2012-09-28: Here we replace the reference with the resolved value.
     This is the only exception when a reference gets replaced - this
     helps a JIT compiler since it cannot compile LDC/LDC2 to non-literals.
    "

"/    myIndex := constantPool identityIndexOf: self.
"/    myIndex == 0 ifTrue:[self error:'Constant pool messed up. Should not happen'].
"/    constantPool at: myIndex put: valueCache.
    ^ resolvedValue.

    "Created: / 13-05-2011 / 17:21:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 23-02-2012 / 17:18:21 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 28-09-2012 / 20:15:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hash
    ^ constantPool hash bitXor: valueIndex hash.

    "Created: / 13-05-2011 / 17:20:22 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

invalidateForClass: internalJavaClassName 
    "Invalidates receiver iff it refers (even indirectly)
     to a class ref that has been resolved to given class.
     Returns true, if the receiver has been invalidated,
     false otherwise"
    
    ^ false

    "Created: / 13-05-2011 / 17:22:34 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 22-02-2012 / 20:52:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    "dont use me, I'm here just because marcel was not sure he found and fixed all senders"
    self breakPoint: #mh.
    ^ constantPool at: valueIndex.

    "Created: / 13-05-2011 / 17:23:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

value
    ^ constantPool at: valueIndex.

    "Created: / 13-05-2011 / 17:23:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaStringRef2 methodsFor:'initialization'!

initializeIn: aJavaConstantPool withValueAt: valueCPIndex 
valueIndex := valueCPIndex.
constantPool := aJavaConstantPool.
    super initialize.
! !

!JavaStringRef2 methodsFor:'printing'!

displayString
    "superclass JavaRef2 says that I am responsible to implement this method"
    
    ^ 'StringRef: ' , (constantPool at: valueIndex).

    "Modified: / 03-11-2011 / 12:44:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaStringRef2 methodsFor:'queries'!

isJavaStringRef
    ^ true

    "Created: / 29-07-2016 / 10:06:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaStringRef2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaStringRef2.st,v 1.7 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


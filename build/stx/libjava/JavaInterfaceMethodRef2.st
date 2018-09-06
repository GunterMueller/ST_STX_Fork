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

JavaMethodRef2 subclass:#JavaInterfaceMethodRef2
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Reader-Support-new'
!

!JavaInterfaceMethodRef2 class methodsFor:'documentation'!

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

!JavaInterfaceMethodRef2 methodsFor:'private - resolving'!

findResolvedValue
    "Resolve reference and set valueCache."
    
    resolvedValue := JavaResolver uniqueInstance 
                resolveInterfaceMethodIdentifiedByRef: self.
    resolvedClass := self classRef resolve.

    "Modified: / 18-05-2011 / 12:44:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified (format): / 12-10-2013 / 18:07:51 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 03:01:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

findResolvedValue: doClassInit
    "Resolve reference and set valueCache."
    
    resolvedValue := JavaResolver uniqueInstance resolveInterfaceMethodIdentifiedByRef: self.
    resolvedValue mclass classInit. "/ Apparently, invocation of interface method initializes the interface   
    resolvedClass := self classRef resolve: doClassInit.

    "Modified: / 18-05-2011 / 12:44:44 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 09-02-2012 / 23:10:44 / mh <hlopik@gmail.com>"
    "Modified: / 12-10-2013 / 18:07:47 / Marcel Hlopko <marcel.hlopko@fit.cvut.cz>"
    "Modified: / 31-01-2014 / 03:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaInterfaceMethodRef2 methodsFor:'queries'!

isJavaInterfaceMethodRef
    "we will see if this is expected behavior"
    
    ^ true.

    "Created: / 14-04-2011 / 15:33:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaInterfaceMethodRef2 class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaInterfaceMethodRef2.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


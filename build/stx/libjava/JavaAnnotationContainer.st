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

Object subclass:#JavaAnnotationContainer
	instanceVariableNames:'runtimeVisible runtimeInvisible parent'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Annotations'
!

JavaAnnotationContainer class instanceVariableNames:'empty'

"
 No other class instance variables are inherited by this class.
"
!

!JavaAnnotationContainer class methodsFor:'documentation'!

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

!JavaAnnotationContainer class methodsFor:'instance creation'!

for:parent 
    ^self new initializeFor:parent.

    "Created: / 28-02-2011 / 16:33:00 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 03-03-2011 / 22:49:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!JavaAnnotationContainer class methodsFor:'accessing'!

empty
    empty isNil ifTrue:[
        empty := self new
    ].
    ^ empty.

    "Created: / 03-03-2011 / 22:45:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2011 / 17:43:02 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 04-08-2014 / 15:53:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAnnotationContainer methodsFor:'accessing'!

ensureRuntimeInvisible
    runtimeInvisible size = 0 
        ifTrue: [ runtimeInvisible := JavaAnnotationDictionary new. ].
    ^ runtimeInvisible.

    "Created: / 16-03-2011 / 16:56:38 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ensureRuntimeVisible
    runtimeVisible size = 0
        ifTrue: [ runtimeVisible := JavaAnnotationDictionary new. ].
    ^ runtimeVisible.

    "Created: / 16-03-2011 / 16:56:19 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

runtimeInvisible
    ^ runtimeInvisible
!

runtimeInvisible:something 
    runtimeInvisible := something.
!

runtimeVisible
    ^ runtimeVisible
!

runtimeVisible:something 
    runtimeVisible := something.
! !

!JavaAnnotationContainer methodsFor:'initialization'!

initialize

    "Do not remove this method, is reqired for proper
     initialization of 'empty' containers!!!!!!"

    runtimeVisible := JavaAnnotationDictionary empty.
    runtimeInvisible := JavaAnnotationDictionary empty.

    "Modified: / 16-03-2011 / 17:11:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Created: / 16-03-2011 / 16:50:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeFor: aParent

    self initialize.
    parent := aParent.

    "Modified: / 16-03-2011 / 17:11:03 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
    "Modified: / 16-03-2011 / 16:50:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaAnnotationContainer class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaAnnotationContainer.st,v 1.8 2015-03-20 12:07:59 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


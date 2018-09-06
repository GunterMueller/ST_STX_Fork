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

JavaAnnotationContainer subclass:#JavaMethodAnnotationContainer
	instanceVariableNames:'annotationDefault rawParamAnnotations visibleParameterAnnotations
		invisibleParameterAnnotations'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Annotations'
!

!JavaMethodAnnotationContainer class methodsFor:'documentation'!

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

!JavaMethodAnnotationContainer methodsFor:'accessing'!

default
    ^ annotationDefault

    "Created: / 03-03-2011 / 23:02:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

default:something 
    annotationDefault := something.
!

ensureInvisibleParameterAnnotationsAt: paramIndex 
    ((invisibleParameterAnnotations at: paramIndex) 
        size = 0) 
            ifTrue: 
                [ invisibleParameterAnnotations at: paramIndex
                    put: JavaAnnotationDictionary new ].
    ^ invisibleParameterAnnotations at: paramIndex.

    "Created: / 16-03-2011 / 17:21:58 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

ensureVisibleParameterAnnotationsAt: paramIndex 
    ((visibleParameterAnnotations at: paramIndex) 
        size = 0) 
            ifTrue: 
                [ visibleParameterAnnotations at: paramIndex
                    put: JavaAnnotationDictionary new ].
    ^ visibleParameterAnnotations at: paramIndex.

    "Created: / 16-03-2011 / 17:21:46 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

rawParamAnnotations
    ^ rawParamAnnotations

    "Created: / 01-12-2012 / 22:54:04 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

rawParamAnnotations: something 
    rawParamAnnotations := something.

    "Created: / 01-12-2012 / 22:54:11 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

visibleParameterAnnotations    
    ^ visibleParameterAnnotations

    "Created: / 01-12-2012 / 22:39:33 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMethodAnnotationContainer methodsFor:'initialization'!

initialize
    super initialize.
    visibleParameterAnnotations :=  JavaAnnotationDictionary empty.
    invisibleParameterAnnotations :=  JavaAnnotationDictionary empty.
    annotationDefault := JavaAnnotationDefault empty.

    "Modified: / 28-02-2011 / 16:34:54 / Marcel Hlopko <hlopik@gmail.com>"
    "Created: / 18-03-2011 / 23:50:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-12-2012 / 22:27:49 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
!

initializeFor: javaMethod 
    super initializeFor: javaMethod.
    parent := javaMethod.
    
    visibleParameterAnnotations := Array new: javaMethod javaNumArgs.
    invisibleParameterAnnotations := Array new: javaMethod javaNumArgs.
    1 to: javaMethod javaNumArgs do: [:idx | visibleParameterAnnotations at: idx put: JavaAnnotationDictionary empty.invisibleParameterAnnotations at: idx put: JavaAnnotationDictionary empty. ].
    annotationDefault := JavaAnnotationDefault empty.

    "Modified: / 28-02-2011 / 16:34:54 / Marcel Hlopko <hlopik@gmail.com>"
    "Modified: / 03-03-2011 / 22:48:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-03-2011 / 17:28:51 / Marcel Hlopko <hlopkmar@fel.cvut.cz>"
! !

!JavaMethodAnnotationContainer class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/JavaMethodAnnotationContainer.st,v 1.8 2015-03-20 12:08:00 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ 'Id'
! !


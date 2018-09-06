"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libjava/tools' }"

Object subclass:#JavaLintAnnotation
	instanceVariableNames:'startPosition endPosition line problem'
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Tools-Editor-Lint'
!

!JavaLintAnnotation class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!JavaLintAnnotation class methodsFor:'instance creation'!

from: start to: end problem: problem

    ^self new
        startPosition: start;
        endPosition: end;
        problem: problem;
        yourself.

    "Created: / 16-09-2013 / 10:30:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintAnnotation methodsFor:'accessing'!

endPosition
    ^ endPosition
!

endPosition:anInteger
    endPosition := anInteger.
!

line
    ^ problem getSourceLineNumber

    "Modified: / 16-09-2013 / 13:39:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

problem
    ^ problem
!

problem: p
    problem := p.

    "Created: / 16-09-2013 / 10:32:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

startPosition
    ^ startPosition
!

startPosition:anInteger
    startPosition := anInteger.
! !

!JavaLintAnnotation methodsFor:'comparing'!

< anObject

    anObject isNumber ifTrue:[^startPosition < anObject].
    anObject class == self class ifFalse:[^false].

    ^endPosition < anObject startPosition

    "Created: / 14-02-2010 / 13:39:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

<= aMagnitude
    "return true, if the argument is greater or equal than the receiver"

    ^ (aMagnitude < self) not
!

= anObject

    anObject class == self class ifFalse:[^false].

    ^startPosition == (anObject startPosition) and:
        [endPosition == (anObject endPosition) and:
            [problem = anObject rule]]

    "Created: / 14-02-2010 / 13:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

> aMagnitude
    "return true, if the argument is less than the receiver"

    ^ aMagnitude < self
!

>= aMagnitude
    "return true, if the argument is less or equal than the receiver"

    ^ (self < aMagnitude) not
! !

!JavaLintAnnotation methodsFor:'help'!

helpTextFor: aView
    ^ nil

    "Created: / 16-12-2014 / 02:47:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaLintAnnotation class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


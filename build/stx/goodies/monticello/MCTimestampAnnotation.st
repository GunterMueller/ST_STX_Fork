"{ Package: 'stx:goodies/monticello' }"

Annotation subclass:#MCTimestampAnnotation
	instanceVariableNames:'timestamp'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-St/X support'
!


!MCTimestampAnnotation methodsFor:'accessing'!

key
    "superclass Annotation says that I am responsible to implement this method"

    ^ #mctimestamp:

    "Modified: / 14-09-2010 / 15:34:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

timestamp
    ^ timestamp
!

timestamp:aString
    timestamp := aString.
! !

!MCTimestampAnnotation methodsFor:'printing & storing'!

storeOn:aStream
    "superclass Annotation says that I am responsible to implement this method"

    aStream nextPutAll: '(Annotation mctimestamp: '.
    timestamp storeOn: aStream.
    aStream nextPut: $).

    "Modified: / 14-09-2010 / 15:36:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCTimestampAnnotation methodsFor:'processing'!

annotatesClass:aClass

    "Nothing to do"

    "Modified: / 14-09-2010 / 15:41:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

annotatesMethod:aMethod

    "Nothing to do"

    "Modified: / 14-09-2010 / 15:41:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!MCTimestampAnnotation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCTimestampAnnotation.st,v 1.2 2012-09-11 21:29:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCTimestampAnnotation.st,v 1.2 2012-09-11 21:29:43 cg Exp $'
!

version_SVN
    ^ '§Id: MCTimestampAnnotation.st 12 2010-09-15 13:13:22Z vranyj1 §'
! !

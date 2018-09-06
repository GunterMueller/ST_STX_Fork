"{ Package: 'stx:libjava/examples' }"

"{ NameSpace: Smalltalk }"

Object subclass:#STComparator
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Examples'
!


!STComparator class methodsFor:'initialization'!

initialize

    self lookupObject: JavaLookup instance

    "Created: / 13-05-2012 / 17:24:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!STComparator methodsFor:'comparing'!

compare: o1 and: o2
    ^ o1 = o2 ifTrue:[ 
        0 
    ] ifFalse: [
        o1 < o2 ifTrue:[
            -1
        ] ifFalse:[
            1
        ]            
    ]

    "
        STComparator new compare: 1 and: 1
    "

    "Created: / 21-08-2012 / 10:44:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!STComparator class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/examples/STComparator.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: STComparator.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
! !


STComparator initialize!

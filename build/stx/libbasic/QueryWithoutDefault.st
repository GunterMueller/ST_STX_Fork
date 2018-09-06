"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

Query subclass:#QueryWithoutDefault
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions'
!

!QueryWithoutDefault class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Like a Query, but MUST be handled (i.e. an answer:do: context must 
    be found when a query is asked).
    If unhandled, a NoHandler exception is raised as usual.

    [author:]
        Claus Gittinger

    [see also:]
        Query Warning Signal QuerySignal
"
!

examples
"
                                                                        [exBegin]
    QueryWithoutDefault answer:'hello'
    do:[
        Transcript showCR:(QueryWithoutDefault query)
    ]
                                                                        [exEnd]


                                                                        [exBegin]
    QueryWithoutDefault query
                                                                        [exEnd]
"
! !

!QueryWithoutDefault class methodsFor:'initialization'!

initialize

    NotifierString := 'unhandled query'
! !

!QueryWithoutDefault methodsFor:'default actions'!

defaultAction
    "re-redefined to raise a noHandler error, if no handler was found"

    ^ self noHandler
! !

!QueryWithoutDefault class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic/QueryWithoutDefault.st,v 1.3 2005/01/20 12:26:17 stefan Exp $'
!

version_SVN
    ^ '$Id: QueryWithoutDefault.st 10761 2012-01-19 11:46:00Z vranyj1 $'
! !

QueryWithoutDefault initialize!




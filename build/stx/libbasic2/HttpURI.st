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
"{ Package: 'stx:libbasic2' }"

HierarchicalURI subclass:#HttpURI
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Resources'
!

!HttpURI class methodsFor:'documentation'!

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
! !

!HttpURI class methodsFor:'accessing'!

schemes

    ^ #(http)
! !

!HttpURI methodsFor:'defaults'!

defaultPort

    ^ 80
! !

!HttpURI methodsFor:'stream access'!

contents
    "use HTTPInterface for now"

    |response|

    response := HTTPInterface get:self path 
                    fromHost:self host 
                    port:self port
                    accept:#('*/*')  
                    fromDocument:nil.

    response isErrorResponse 
        ifTrue:[ self error: response responseText ].
    ^ response data

    "
     'http://www.puzzlers.org/pub/wordlists/unixdict.txt' asURI contents
    "
!

readStreamDo:aBlock
    "use HTTPInterface for now"

    |response headerInfo mime|

    response := HTTPInterface get:self path 
                    fromHost:self host 
                    port:self port
                    accept:#('*/*')  
                    fromDocument:nil.

    headerInfo := response headerInfo.
    mime := headerInfo at:'content-type' ifAbsent:nil.
    mime notNil ifTrue:[
        headerInfo at:#MIME put:mime.
    ].
    aBlock value:response data readStream optionalArgument:headerInfo

    "
     'http://www.exept.de/' asURI readStreamDo:[:stream :attributes | 
         self halt
      ].
    "
! !

!HttpURI methodsFor:'testing'!

isAbsolute
    "there is nothing like a relative http URI"

    ^ true
!

isRemote
    "return true, if this is a remote URI"

    ^ true
! !

!HttpURI class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/HttpURI.st,v 1.6 2013-01-20 15:22:18 cg Exp $'
! !


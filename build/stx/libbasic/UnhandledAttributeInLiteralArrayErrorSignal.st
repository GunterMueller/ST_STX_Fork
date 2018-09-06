"
 COPYRIGHT (c) 2016 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Notification subclass:#UnhandledAttributeInLiteralArrayErrorSignal
	instanceVariableNames:'badLiteralArray'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!UnhandledAttributeInLiteralArrayErrorSignal class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2016 by eXept Software AG
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
    notifying when decoding a literal array spec,
    when a non-existing attribute is encountered.
    i.e. a spec-element of the form 
        (Foo attribute: x),
    where atribute is unknown to the Foo class (at cannot decode that)

    (used to be an errorPrint in basicFromLiteralArrayEncoding).
    
        |spec1 spec2|

        UnhandledAttributeInLiteralArrayErrorSignal handle:[:ex |
            Transcript showCR:ex description
        ] do:[
            spec1 := #(#UISpecification #activeHelpKey: #foo) decodeAsLiteralArray.
            spec2 := #(#UISpecification #blabla: #foo) decodeAsLiteralArray.
        ].
        Transcript showCR:spec1.
        Transcript showCR:spec2.
    
    [author:]
        cg
"
! !

!UnhandledAttributeInLiteralArrayErrorSignal class methodsFor:'initialization'!

initialize
    NotifierString := 'unhandled literalArrayEncoding attribute: '.

    "
    self handle:[:ex |
        Transcript showCR:ex 
    ] do:[    
    self raiseWith:'bla'
    ].
    "
! !

!UnhandledAttributeInLiteralArrayErrorSignal methodsFor:'accessing'!

badLiteralArray
    "the literal array containing the unhandled attribute"
    
    ^ badLiteralArray
!

badLiteralArray:something
    badLiteralArray := something.
!

unhandledAttribute
    "the unhandled attribute"
    
    ^ parameter
! !

!UnhandledAttributeInLiteralArrayErrorSignal methodsFor:'printing & storing'!

description
    ^ super description, ' (', parameter printString,')'
! !

!UnhandledAttributeInLiteralArrayErrorSignal class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


UnhandledAttributeInLiteralArrayErrorSignal initialize!

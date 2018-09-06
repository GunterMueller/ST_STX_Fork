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

NotFoundError subclass:#MissingClassInLiteralArrayErrorSignal
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Exceptions-Errors'
!

!MissingClassInLiteralArrayErrorSignal class methodsFor:'documentation'!

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
    raised when decoding a literal array spec,
    when a non-existing class is encountered.
    i.e. a spec-element of the form 
        (ClassNameSymbol args...),
    where ClassNameSymbol refers to a non-existing class

    (used to be a signal in SeqColl).
    
    [author:]
        cg
"
! !

!MissingClassInLiteralArrayErrorSignal class methodsFor:'initialization'!

initialize
    NotifierString := 'Missing class in literal encoding'.
! !

!MissingClassInLiteralArrayErrorSignal methodsFor:'accessing'!

missingClassName
    "the bad class name"
    
    ^ parameter
! !

!MissingClassInLiteralArrayErrorSignal methodsFor:'printing & storing'!

description
    ^ super description, ': ', parameter asString
! !

!MissingClassInLiteralArrayErrorSignal class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


MissingClassInLiteralArrayErrorSignal initialize!

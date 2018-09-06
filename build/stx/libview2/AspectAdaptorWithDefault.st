"
 COPYRIGHT (c) 2012 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

AspectAdaptor subclass:#AspectAdaptorWithDefault
	instanceVariableNames:'defaultValueIfNoSubject'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Models'
!

!AspectAdaptorWithDefault class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2012 by Claus Gittinger
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
    like an AspectAdaptor, but with a default value, if no target is set.
    The normal aspectAdaptor returns nil in that case.

    [author:]
        Claus Gittinger

    [see also:]
        AspectAdaptor ValueHolder Model
"
! !

!AspectAdaptorWithDefault methodsFor:'accessing'!

defaultValueIfNoSubject
    ^ defaultValueIfNoSubject
!

defaultValueIfNoSubject:something
    defaultValueIfNoSubject := something.
! !

!AspectAdaptorWithDefault class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/AspectAdaptorWithDefault.st,v 1.1 2012-03-01 07:59:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libview2/AspectAdaptorWithDefault.st,v 1.1 2012-03-01 07:59:50 cg Exp $'
! !

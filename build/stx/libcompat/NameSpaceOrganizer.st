"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#NameSpaceOrganizer
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-VisualWorks'
!

!NameSpaceOrganizer class methodsFor:'documentation'!

documentation
"
    ST-80 compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    [author:]
        Claus Gittinger
"
! !

!NameSpaceOrganizer class methodsFor:'queries'!

defaultProtocol
    ^ '* as yet unspecified *'
! !

!NameSpaceOrganizer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/NameSpaceOrganizer.st,v 1.4 2015-03-27 13:24:40 cg Exp $'
! !


"{ Package: 'stx:libcompat' }"

"{ NameSpace: V }"

Object subclass:#OLEControlSitePane
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST/V'
!

!OLEControlSitePane class methodsFor:'documentation'!

documentation
"
    Dummy ST-V compatibility class.
    This may be required when existing code has to be ported to ST/X;
    however, it may not be complete and more protocol may be added in the future.
    The code here was created when public domain code (Manchester) had to
    be ported to ST/X and missing classes/methods were encountered, and code added
    by reasoning 'what the original class could probably do there'.

    No Warranty, no functionality: all this class exists for is to allow subclasses
    to be filed in and find some home to allow porting...

    [author:]
        Claus Gittinger
"
! !

!OLEControlSitePane class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/OLEControlSitePane.st,v 1.3 2006-02-22 16:43:14 cg Exp $'
! !

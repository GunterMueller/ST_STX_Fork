"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

Object subclass:#RefactoryBrowserPlatformSupport
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Support'
!


!RefactoryBrowserPlatformSupport class methodsFor:'system queries'!

systemOrganization
    Smalltalk isSmalltalkX ifTrue:[
        "/ stupid incompatibility:
        "/ in ST/X, Smalltalk is a class and #organization returns
        "/ the classes org.
        "/ The systems organization is returned by #systemOrganization.
        ^ Smalltalk systemOrganization
    ].
    ^ Smalltalk organization


! !

!RefactoryBrowserPlatformSupport class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/RefactoryBrowserPlatformSupport.st,v 1.3 2003-09-23 10:46:11 cg Exp $'
! !

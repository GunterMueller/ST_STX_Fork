"{ Encoding: utf8 }"

"{ Package: 'stx:libcompat' }"

"{ NameSpace: Smalltalk }"

Object subclass:#NetNameResolver
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Squeak'
!

!NetNameResolver class methodsFor:'documentation'!

documentation
"
    a facade to make filing in squeak code easier

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!NetNameResolver class methodsFor:'queries'!

localAddressString
    ^ IPSocketAddress localHost
!

localHostName
    ^ OperatingSystem getHostName
    "/ ^ IPSocketAddress localHost hostName
! !

!NetNameResolver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/NetNameResolver.st,v 1.3 2018-05-14 07:05:33 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/NetNameResolver.st,v 1.3 2018-05-14 07:05:33 cg Exp $'
! !


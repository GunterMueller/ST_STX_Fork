"{ Package: 'stx:libcompat' }"

Object subclass:#TimeProfileBrowser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New-Profiler'
!

!TimeProfileBrowser class methodsFor:'documentation'!

documentation
"
    this is just a facade on the Tools:Profiler, with a squeak compatible
    interface, to make squeak test cases work out of the box.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!TimeProfileBrowser class methodsFor:'api'!

onBlock: aBlock
    Tools::Profiler spyOn:aBlock
! !

!TimeProfileBrowser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/TimeProfileBrowser.st,v 1.1 2013-04-17 20:29:04 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/TimeProfileBrowser.st,v 1.1 2013-04-17 20:29:04 cg Exp $'
! !


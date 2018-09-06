"{ Package: 'stx:libcompat' }"

"{ NameSpace: V }"

StandardSystemView subclass:#MainWindow
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-ST/V'
!

!MainWindow class methodsFor:'documentation'!

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

!MainWindow methodsFor:'queries'!

isDialogTopPane
    ^ false
!

owner:aMasterWindow
    "/ ignored
! !

!MainWindow methodsFor:'v protocol'!

addSubpane: aView
    self addSubView:aView
!

postOpenWith:aBuilder
    self halt.
    super postOpenWith:aBuilder.
! !

!MainWindow class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/V__MainWindow.st,v 1.2 2016-08-22 13:40:44 cg Exp $'
!

version_SVN
    ^ '$Id: V__MainWindow.st,v 1.2 2016-08-22 13:40:44 cg Exp $'
! !


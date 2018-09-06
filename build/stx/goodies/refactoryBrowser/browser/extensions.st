"{ Package: 'stx:goodies/refactoryBrowser/browser' }"!

!BrowserEnvironment methodsFor:'environments'!

forPackage: package

     ^self forPackages: (Array with: package)

    "Created: / 16-03-2011 / 23:36:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!BrowserEnvironment methodsFor:'environments'!

forPackages: aCollection
	^ PackageEnvironment onEnvironment: self packages: aCollection
! !

!BrowserEnvironment class methodsFor:'instance creation'!

empty
    ^ EmptyEnvironment new.

    "Created: / 02-04-2014 / 11:31:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_goodies_refactoryBrowser_browser class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/extensions.st,v 1.3 2014-04-02 10:45:08 vrany Exp $'
! !


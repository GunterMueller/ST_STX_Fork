"{ Package: 'stx:goodies/refactoryBrowser/browser' }"

BrowserEnvironmentWrapper subclass:#EmptyEnvironment
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Environments'
!

!EmptyEnvironment class methodsFor:'documentation'!

documentation
"
    This environment is always empty

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!EmptyEnvironment methodsFor:'testing'!

definesClass: aClass
    ^ false

    "Created: / 02-04-2014 / 11:36:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesCategory: aCategory
    ^ false

    "Created: / 02-04-2014 / 11:30:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesClass: aClass
    ^ false

    "Created: / 02-04-2014 / 11:30:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesMethod: aMethod
    ^ false

    "Created: / 02-04-2014 / 11:30:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesProtocol: aProtocol in: aClass
    ^ false

    "Created: / 02-04-2014 / 11:30:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

includesSelector: aSelector in: aClass
    ^ false

    "Created: / 02-04-2014 / 11:30:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isEmpty
    ^ true

    "Created: / 02-04-2014 / 11:31:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!EmptyEnvironment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/EmptyEnvironment.st,v 1.1 2014-04-02 10:48:16 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/browser/EmptyEnvironment.st,v 1.1 2014-04-02 10:48:16 vrany Exp $'
! !


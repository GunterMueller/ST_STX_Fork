"{ Package: 'stx:goodies/sunit/ext/ui' }"!

!ApplicationModel methodsFor:'accessing'!

interactor
    "Return a UI testing interactor for application's main window.
     If application is not opened, raise an error"


    (builder notNil and:[ builder window notNil ]) ifTrue:[ 
        ^ builder window interactor
    ].
    self error:'Window not opened. Try sending #open before calling #interactor'

    "Created: / 20-05-2014 / 12:45:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'accessing'!

interactor
    "Return an UI interactor for this view.
     See SimpleViewInteractor"

    ^ SimpleViewInteractor for: self

    "Created: / 20-05-2014 / 09:15:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SimpleView methodsFor:'accessing'!

interactorClass
    "Returns a interactor class for this view. To be overriden by
     subclasses with specific interactors"

    ^ SimpleViewInteractor

    "Created: / 20-05-2014 / 09:15:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!StandardSystemView methodsFor:'accessing'!

/ aString
    "Returns an interactor for a subview named `aString`"

    ^ self interactor / aString

    "Created: / 20-05-2014 / 09:19:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UndefinedObject methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !


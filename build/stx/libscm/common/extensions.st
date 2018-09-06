"{ Package: 'stx:libscm/common' }"!

!ChangeSet methodsFor:'utilities'!

condenseChangesForPackageAfterCommit:aPackageSymbol
    "remove more changes for aPackageSymbol
     This is invoked when a project is checked into the repository."

    |changesToRemove|

    changesToRemove := self select:[:aChange |
        |removeThis mClass mthd|

        removeThis := false.
        (aChange isMethodChange or:[aChange isMethodRemoveChange]) ifTrue:[
            mClass := aChange changeClass.
            mClass notNil ifTrue:[
                mthd := mClass compiledMethodAt:(aChange selector).
                mthd isNil ifTrue:[
                    removeThis := (mClass package = aPackageSymbol)
                ] ifFalse:[
                    removeThis := (mthd package = aPackageSymbol)
                ]
            ].
        ] ifFalse:[
            (aChange isClassChange) ifTrue:[
                (aChange changeClass notNil) ifTrue:[
                    removeThis := (aChange changeClass package = aPackageSymbol)
                ].
            ].
        ].
        removeThis
    ].

    self condenseChanges:changesToRemove

    "Created: / 21-11-2012 / 01:45:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libscm_common class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !

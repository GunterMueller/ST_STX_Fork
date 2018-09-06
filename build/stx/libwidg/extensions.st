"{ Package: 'stx:libwidg' }"!

!UserPreferences methodsFor:'accessing-prefs-code view'!

assignmentHighlightEmphasis
    ^ Array with:(#backgroundColor -> self assignmentBackgroundColorForNavigationService)

    "Created: / 15-12-2017 / 22:37:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

codeViewTheme

    ^self at:#codeViewTheme ifAbsent: nil

    "
     UserPreferences current codeViewTheme
     UserPreferences current codeViewTheme: nil
     UserPreferences current codeViewTheme: CodeViewTheme new
    "

    "Created: / 11-12-2017 / 14:59:58 / jv"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

codeViewTheme: aCodeViewTheme

    ^self at:#codeViewTheme put: aCodeViewTheme

    "
     UserPreferences current codeViewTheme
     UserPreferences current codeViewTheme: nil
     UserPreferences current codeViewTheme: CodeViewTheme new
    "

    "Created: / 11-12-2017 / 15:00:14 / jv"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

selectorHighlightEmphasis
    ^ Array with:(#backgroundColor -> (self selectorBackgroundColorForNavigationService))

    "Created: / 15-12-2017 / 22:39:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!UserPreferences methodsFor:'accessing-prefs-code view'!

variableHighlightEmphasis
    ^ Array with:(#backgroundColor -> (self variableBackgroundColorForNavigationService))

    "Created: / 15-12-2017 / 22:40:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!stx_libwidg class methodsFor:'documentation'!

extensionsVersion_HG

    ^ '$Changeset: <not expanded> $'
! !

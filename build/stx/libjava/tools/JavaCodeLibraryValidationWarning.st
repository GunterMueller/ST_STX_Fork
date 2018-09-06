"{ Encoding: utf8 }"

"{ Package: 'stx:libjava/tools' }"

"{ NameSpace: Smalltalk }"

Warning subclass:#JavaCodeLibraryValidationWarning
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Support-Libraries'
!

JavaCodeLibraryValidationWarning subclass:#ClassesArchiveInvalid
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaCodeLibraryValidationWarning
!

JavaCodeLibraryValidationWarning subclass:#ClassesDontExist
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaCodeLibraryValidationWarning
!

JavaCodeLibraryValidationWarning subclass:#ClassesNotSpecified
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaCodeLibraryValidationWarning
!

JavaCodeLibraryValidationWarning subclass:#JavaDocArchiveInvalid
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaCodeLibraryValidationWarning
!

JavaCodeLibraryValidationWarning subclass:#JavaDocDoesntExist
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaCodeLibraryValidationWarning
!

JavaCodeLibraryValidationWarning subclass:#SourcesArchiveInvalid
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaCodeLibraryValidationWarning
!

JavaCodeLibraryValidationWarning subclass:#SourcesDontExist
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:JavaCodeLibraryValidationWarning
!

!JavaCodeLibraryValidationWarning class methodsFor:'documentation'!

documentation
"
    A base superclass for JavaCodeLibrary validation warnings.
    See documentation of my private sublcasses for different
    kinds of warnings.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]
        JavaCodeLibrary>>validate

"
! !

!JavaCodeLibraryValidationWarning class methodsFor:'accessing'!

classesArchiveInvalid
    ^ ClassesArchiveInvalid

    "Created: / 19-03-2015 / 11:52:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classesDontExist
    ^ ClassesDontExist

    "Created: / 19-03-2015 / 11:52:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classesNotSpecified
    ^ ClassesNotSpecified

    "Created: / 19-03-2015 / 11:52:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaDoArchiveInvalid
    ^ JavaDocArchiveInvalid

    "Created: / 19-03-2015 / 11:54:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

javaDocDontExist
    ^ JavaDocDoesntExist

    "Created: / 19-03-2015 / 11:53:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcesArchiveInvalid
    ^ SourcesArchiveInvalid

    "Created: / 19-03-2015 / 11:52:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourcesDontExist
    ^ SourcesDontExist

    "Created: / 19-03-2015 / 11:53:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryValidationWarning methodsFor:'accessing'!

library
    ^ parameter

    "Created: / 19-03-2015 / 14:22:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaCodeLibraryValidationWarning::ClassesArchiveInvalid class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCodeLibraryValidationWarning::ClassesDontExist class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCodeLibraryValidationWarning::ClassesNotSpecified class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCodeLibraryValidationWarning::JavaDocArchiveInvalid class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCodeLibraryValidationWarning::JavaDocDoesntExist class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCodeLibraryValidationWarning::SourcesArchiveInvalid class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!JavaCodeLibraryValidationWarning::SourcesDontExist class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !


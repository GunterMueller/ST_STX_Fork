"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

ApplicationModel subclass:#WizardPane
	instanceVariableNames:'prev next'
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-UI-Dialogs'
!

!WizardPane class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.

"
! !

!WizardPane class methodsFor:'others'!

version_CVS
    ^ '$Header$'
! !

!WizardPane methodsFor:'accessing'!

acceptEnabled:aBoolean 
    ^ self wizard acceptEnabled:aBoolean

    "Created: / 24-03-2009 / 19:55:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

goNextEnabled: aBoolean

    ^self wizard goNextEnabled: aBoolean

    "Created: / 24-03-2009 / 19:55:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

goPrevEnabled: aBoolean

    ^self wizard goPrevEnabled: aBoolean

    "Created: / 24-03-2009 / 19:55:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

next
    next ifNil:[ next := self createNext. next prev: self.].
    ^ next

    "Modified: / 02-04-2009 / 17:13:33 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

next:aWizardPane
    next := aWizardPane.
!

prev
    ^ prev
!

prev:aWizardPane
    prev := aWizardPane.
!

task

    ^self wizard task

    "Created: / 24-03-2009 / 19:29:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

wizard

    ^self masterApplication

    "Created: / 24-03-2009 / 14:37:35 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WizardPane methodsFor:'actions'!

enter

    "This method is called whenever a a pane is shown"

    "Created: / 02-04-2009 / 17:07:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

goNext

    self wizard pane: self next

    "Created: / 20-03-2009 / 14:12:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-03-2009 / 14:38:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

goPrev

    self wizard pane: self prev

    "Created: / 20-03-2009 / 14:12:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 24-03-2009 / 14:38:42 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

leave

    "This method is called whenever a a pane is left (via pressing next/prev/accept)"

    "Created: / 02-04-2009 / 17:08:15 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WizardPane methodsFor:'change & update'!

updateButtons
    self
        goPrevEnabled:self canGoPrev;
        goNextEnabled:self canGoNext;
        acceptEnabled:self acceptEnabled.

    "Created: / 24-03-2009 / 19:54:49 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 16:27:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WizardPane methodsFor:'private'!

createNext
    ^ self subclassResponsibility

    "Created: / 21-03-2009 / 10:56:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showMessage: aString

    ^self wizard showMessage: aString

    "Created: / 09-04-2009 / 08:19:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

showProgressWhile: aBlock

    ^self wizard showProgressWhile: aBlock

    "Created: / 24-03-2009 / 14:58:48 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WizardPane methodsFor:'queries'!

acceptEnabled
    ^ false

    "Created: / 21-03-2009 / 12:22:10 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 16:29:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

canGoNext

    ^true

    "Created: / 20-03-2009 / 12:41:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 02-04-2009 / 16:44:52 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

canGoPrev

    ^prev notNil

    "Created: / 20-03-2009 / 12:42:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!WizardPane class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_SVN
    ^ '§Id§'
! !

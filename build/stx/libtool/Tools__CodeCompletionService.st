"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

CodeViewService subclass:#CodeCompletionService
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

!CodeCompletionService class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
              All Rights Reserved

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


!CodeCompletionService class methodsFor:'accessing'!

label
    "Answers a short label - for UI"

    ^'Code Completion'

    "Created: / 07-03-2010 / 14:00:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeCompletionService class methodsFor:'testing'!

isAvailable

    "CodeCompletionService is superseded by SmallSense"

    "^(Smalltalk at:#SmallSenseService) isNil"

    "Sure, it is broken, but we need it!!"
    "JV2011-07-09: And I preferr SmallSense: this should work for both
     unless SmallSense is loaded in your image"

    ^(Smalltalk at:#SmallSenseService) isNil.

    "Created: / 03-04-2011 / 23:08:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-07-2011 / 08:42:52 / cg"
    "Modified: / 27-07-2011 / 11:47:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUsefulFor:aCodeView
    "this filters useful services.
     Redefined to return true for myself - not for subclasses"

    ^ self == Tools::CodeCompletionService

    "Created: / 22-07-2013 / 13:59:54 / cg"
! !

!CodeCompletionService methodsFor:'event handling'!

keyPress: key x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, the event will not be processed
     by the view."

    (view == textView and:[key == #'CodeCompletion']) ifTrue:[
        self complete. 
        ^ true
    ].
    ^ false

    "Created: / 07-03-2010 / 09:36:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeCompletionService methodsFor:'private'!

complete
    |cls|

    codeView languageHolder value isSmalltalk ifFalse:[^self].

    cls := codeView classHolder value.
    cls isNil ifTrue:[
        self showInfo:'No class'.
        ^ self.
    ].
    UserInformation handle:[:ex |
        codeView showInfo:(ex messageText).
        ex proceed.
    ] do:[
        codeView withWaitCursorDo:[
            DoWhatIMeanSupport codeCompletionForLanguage: codeView language class:cls context:nil codeView:textView.
        ]
    ].
    ^ self.

    "Modified: / 04-07-2006 / 18:48:26 / fm"
    "Modified: / 20-11-2006 / 12:30:59 / cg"
    "Created: / 07-03-2010 / 09:37:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeCompletionService class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


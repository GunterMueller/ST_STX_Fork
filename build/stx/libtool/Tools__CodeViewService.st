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

Object subclass:#CodeViewService
	instanceVariableNames:'enabled codeView textView gutterView'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-CodeView'
!

!CodeViewService class methodsFor:'documentation'!

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
!

documentation
"
    A base class for CodeView2 services. A 'service' is an extension
    mechanism for CodeView2. Once plugged in, service gets informed 
    about changes in the text and it also may intercept events.

    See concrete subclasses how to use and implement code services.

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!CodeViewService class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!CodeViewService class methodsFor:'accessing'!

availableServices

    ^self allSubclasses select:
        [:cls|cls isAbstract not and:[cls allRequiredServicesAvailable and:[cls isAvailable]]].

    "
        Tools::CodeViewService availableServices
    "

    "Created: / 07-03-2010 / 13:42:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-07-2011 / 11:49:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label
    "Answers a short label - for UI"

    ^self nameWithoutPrefix

    "Created: / 07-03-2010 / 13:58:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

priority
    "Answers a priority of the service. Services with higher priority
     will get the event notification before ones with lower priority.
     Therefore, a lower-priority service might not get the event if high
     priority service processes it"

    ^ 5

    "Created: / 01-02-2012 / 10:28:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

requiredServices

    "Returns a list of services required for myself to work
     correctly. A list should contain class names of the services
     (as not all services may be loaded in)"

    ^#()

    "Created: / 27-07-2011 / 11:39:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeViewService class methodsFor:'queries'!

allRequiredServicesAvailable

    | cls |

    ^self requiredServices 
        allSatisfy:[:clsName|
            cls := Smalltalk at: clsName.
            cls notNil and:[cls allRequiredServicesAvailable and:[cls isAvailable]]                        
        ].

    "Created: / 27-07-2011 / 11:49:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isUsefulFor:aCodeView
    "this filters useful services.
     must be redefined to return true in subclasses (but each class must do it only
     for itself - not for subclasses"

    ^ false

    "Created: / 22-07-2013 / 13:58:49 / cg"
! !

!CodeViewService class methodsFor:'registering'!

registerIn: aCodeView

    ^self new 
        registerIn: aCodeView;
        yourself.

    "Created: / 07-03-2010 / 13:50:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeViewService class methodsFor:'testing'!

isAbstract

    ^self == Tools::CodeViewService

    "Created: / 07-03-2010 / 13:41:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isAvailable

    ^true

    "Created: / 03-04-2011 / 23:07:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isAvailableFor: applicationClass

    "Returns true if given service may be used in
     given application class."

    ^true

    "Created: / 27-07-2011 / 11:45:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeViewService methodsFor:'accessing'!

annotationAtLine:lineNr
    "return the annotation for a given line - if any"

    ^ nil
!

annotations
    "return my annotations - if any"

    ^ nil
!

application

    ^codeView application

    "Created: / 27-07-2011 / 12:11:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

enabled
    ^ enabled
!

enabled:aBoolean
    enabled ~~ aBoolean ifTrue:[  
        enabled := aBoolean.
        aBoolean ifTrue:[ 
            codeView notNil ifTrue:[ 
                self registerIn: codeView.  
            ].
        ] ifFalse:[ 
            self unregister.
        ].
    ].

    "Modified: / 27-11-2014 / 15:41:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

label

    ^self class label

    "Created: / 07-03-2010 / 14:03:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

service: serviceClassName

    ^codeView services detect:[:service|service class name == serviceClassName] ifNone:[nil]

    "Created: / 05-08-2011 / 11:48:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxHighlighter

    "Returns a syntax highligter class or nil. The highlighting
     process gather all syntaxHighlighterClasses from all services
     and then use them one by one to highlight the text. Individual
     services may override this method to provide additional 
     highliging of the source code"

    ^nil

    "Created: / 05-08-2011 / 10:49:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeViewService methodsFor:'change & update'!

update: aspect with: param from: sender

    "Get updated whenever something changes in the code view.
     Subclasses may override this"

    "Intentionally left blank here"

    "Created: / 06-03-2010 / 19:23:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeViewService methodsFor:'event handling'!

buttonMotion: button x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    ^false

    "Created: / 06-03-2010 / 20:17:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2011 / 13:05:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-08-2011 / 15:57:40 / cg"
!

buttonMultiPress: button x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    ^false
!

buttonPress: button x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    ^false

    "Created: / 06-03-2010 / 20:36:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2011 / 13:06:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-08-2011 / 15:57:36 / cg"
!

buttonRelease: button x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    ^false
!

keyPress:key x:x y:y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    ^false

    "Created: / 06-03-2010 / 20:34:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2011 / 13:06:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-08-2011 / 15:57:28 / cg"
!

keyRelease: key x: x y: y in: view
    "Handles an event in given view (a subview of codeView).
     If the method returns true, it has eaten the event and it will not be processed
     by the view."

    ^false

    "Created: / 06-03-2010 / 20:35:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2011 / 13:06:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-08-2011 / 15:57:33 / cg"
!

linesDeletedFrom: start to: end

    "Created: / 06-07-2011 / 17:14:23 / jv"
!

linesInsertedFrom: start to: end

    "Created: / 06-07-2011 / 17:14:31 / jv"
!

linesModifiedFrom: start to: end

    "Created: / 06-07-2011 / 17:14:36 / jv"
!

viewRealized
    "Sent when a code view has been realized. May be overriden
     by subclasses"

    "Created: / 23-01-2012 / 10:38:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeViewService methodsFor:'help'!

flyByHelpTextAtLine:aLineNr
    |a|

    a := self annotationAtLine:aLineNr.
    a notNil ifTrue:[
        ^ a helpTextFor:codeView.
    ].
    ^ nil
! !

!CodeViewService methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."


    "/ please change as required (and remove this comment)
    "/ enabled := nil.
    "/ codeView := nil.
    "/ textView := nil.

    super initialize.

    "Modified: / 03-09-2010 / 22:29:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeViewService methodsFor:'misc'!

highlightClassVariable:name
    "/ intentionally a noop here - redefine in concrete services
!

highlightInstanceVariable:name
    "/ intentionally a noop here - redefine in concrete services
!

showInfo: aString

    codeView showInfo: aString

    "Created: / 06-03-2010 / 19:34:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 21-01-2012 / 12:44:22 / cg"
! !

!CodeViewService methodsFor:'redrawing'!

drawAnnotationIcon:icon atX:x y:y width:w height:h ascent:fontAscent
    |dy dx|

    dx := ((w - icon width) / 2) rounded.
    dy := ((h - icon height) / 2) rounded.
    icon 
        displayOn:gutterView
        x:x + dx + 2
        y:y - h + dy + 4.

    "Created: / 17-09-2013 / 15:40:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawAnnotationInLine:lineNo in:view atX:x y:yBaseline width:w height:hFont ascent:fontAscent
                from:startCol to:endColOrNil with:fg and:bg
    "common code"

    | lang annotation icon severity |

    annotation :=  self annotationAtLine: lineNo.
    annotation notNil ifTrue:[
        severity := annotation rule severity.
        icon := (severity == #error)
                     ifTrue:[ToolbarIconLibrary smalllintErrorIcon16x16]
                     ifFalse:[
                        (severity == #warning)
                            ifTrue:[ ToolbarIconLibrary smalllintWarningIcon16x16]        
                            ifFalse:[ ToolbarIconLibrary smalllintInformationIcon16x16]].        
        self drawAnnotationIcon:icon atX:x y:yBaseline width:w height:hFont ascent:fontAscent.
    ].
!

drawLine:lineNo in:view atX:x y:y width:w height:hFont ascent:fontAscent 
    from:startCol to:endColOrNil with:fg and:bg

    "Called by both gutterView and textView (well, not yet) to
     allow services to draw custom things on text view.
     Ask JV what the args means if unsure (I'm lazy to document
     them, now it is just an experiment...)"

    "Intentionally left blank, to be overriden by subclasses"

    "Created: / 17-06-2011 / 13:49:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawLine:line
    gutterView redrawLine:line
! !

!CodeViewService methodsFor:'registering'!

registerIn: aCodeView

    "Installs myself in aCodeView"

    codeView := aCodeView.
    codeView addDependent: self.
    textView := aCodeView textView. 
    gutterView := aCodeView gutterView.
    enabled := true.

    "Created: / 06-03-2010 / 19:21:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2011 / 13:07:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unregister

    "Uninstall myself from my codeView"

    codeView removeDependent: self.
    "/ Do not nil out a codeView, required for enable/disable functionality
    textView := nil.
    gutterView := nil.

    "Created: / 06-03-2010 / 19:21:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-11-2014 / 15:42:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeViewService methodsFor:'testing'!

isBreakpointService
    ^ false
!

isEnabled

    ^enabled == true

    "Created: / 07-03-2010 / 13:47:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isLintService
    ^ false
! !

!CodeViewService class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2015-2018 Jan Vrany
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

SimpleView subclass:#CodeView2
	instanceVariableNames:'gutterView textView textViewScroller methodHolder languageHolder
		classHolder browserHolder codeAspect modifiedChannel
		showGutterChannel showAcceptCancelBarChannel modeHolder services
		servicesFromClient syntaxElements currentParseNodeHolder
		currentBlockNodeHolder syntaxElementSelection highlightEmphasis
		diffMode synchronizedCodeViews'
	classVariableNames:'TraceSelectors'
	poolDictionaries:''
	category:'Interface-CodeView'
!

AbstractBackground subclass:#AnnotationShowingScrollerBackground
	instanceVariableNames:'annotations breakpoints textView'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CodeView2
!

SimpleView subclass:#GutterView
	instanceVariableNames:'codeView textView textViewScroller widthAcceptCancel
		widthAnnotations widthDiffInfo numberOfLines acceptColor
		cancelColor diffColor menuHolder currentBlockNodeHolder
		showLineNumbers blockWaitingForPossibleDoubleClick'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CodeView2
!

CodeView subclass:#TextView
	instanceVariableNames:'listOriginal codeView gutterView diffMode deletedLines
		insertedLines lastFirstLine changedLines scrollInProgress
		originDiffText emptyLines changedDiffText suppressNotifications
		reallyModifiedChannel'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CodeView2
!

!CodeView2 class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2010 by Jan Vrany, SWING Research Group. CTU in Prague
 COPYRIGHT (c) 2015-2018 Jan Vrany
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

!CodeView2 class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    TraceSelectors := IdentitySet new.

    "Modified: / 14-02-2010 / 15:36:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 class methodsFor:'debugging'!

trace: aSelector

    TraceSelectors add: aSelector

    "Created: / 14-02-2010 / 09:26:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

untrace: aSelector

    TraceSelectors remove: aSelector ifAbsent:[]

    "Created: / 14-02-2010 / 09:50:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

untraceAll

    TraceSelectors := IdentitySet new

    "Created: / 14-02-2010 / 09:53:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 class methodsFor:'examples'!

example1

    | window codeView |


    window := StandardSystemView new.
    window extent: 300 @ 300.              
    window label: 'CodeView2 example1'.

    codeView := Tools::CodeView2 in: window.
    codeView
        origin: 0.1 @ 0.1
        corner: 0.9 @ 0.9.


    window open.

    "Created: / 02-09-2009 / 21:48:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 class methodsFor:'menu specs'!

debugMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::CodeView2 andSelector:#editMenu_stxStyle
     (Menu new fromLiteralArrayEncoding:(Tools::CodeView2 editMenu_stxStyle)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
              (
               (MenuItem
                  label: 'Inspect View'
                  itemValue: inspectView
                  translateLabel: true
                )
               (MenuItem
                  label: 'Inspect Syntax Elements'
                  itemValue: inspectSyntaxElements
                  translateLabel: true
                )
"/               (MenuItem
"/                  label: 'Inspect Selected Selector'
"/                  itemValue: inspectSelectedSelector
"/                  translateLabel: true
"/                )
               )
              nil
              nil
            )

    "Created: / 08-07-2011 / 13:36:02 / cg"
!

editMenu
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."

    "
     MenuEditor new openOnClass:Tools::CodeView2 andSelector:#editMenu
     (Menu new fromLiteralArrayEncoding:(Tools::CodeView2 editMenu)) startUp
    "

    UserPreferences current eclipseStyleMenus ifTrue:[
        ^ self editMenu_eclipseStyle
    ].
    ^ self editMenu_stxStyle

    "Modified: / 08-07-2011 / 13:23:35 / cg"
!

editMenu_eclipseStyle
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::CodeView2 andSelector:#editMenu_eclipseStyle
     (Menu new fromLiteralArrayEncoding:(Tools::CodeView2 editMenu_eclipseStyle)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            label: 'Implementors...'
            itemValue: browseImplementorsOfIt
            isVisible: hasLanguageToolbox
            submenuChannel: implementorsMenu
            shortcutKey: ImplementorsOfIt
          )
         (MenuItem
            label: 'Senders...'
            itemValue: browseSendersOfIt
            isVisible: hasLanguageToolbox
            submenuChannel: sendersMenu
            shortcutKey: SendersOfIt
          )
         (MenuItem
            label: 'Refactor'
            nameKey: refactor
            isVisible: false
            shortcutKey: Shift
          )
         (MenuItem
            label: '-'
            isVisible: hasLanguage
          )
         (MenuItem
            enabled: canAccept
            label: 'Accept'
            itemValue: accept
            isVisible: isNotReadOnly
            shortcutKey: Accept
          )
         (MenuItem
            label: '-'
            isVisible: isNotReadOnly
          )
         (MenuItem
            enabled: canCut
            label: 'Cut'
            itemValue: cut
            isVisible: isNotReadOnly
            shortcutKey: Cut
          )
         (MenuItem
            enabled: hasSelectionForCopy
            label: 'Copy'
            itemValue: copySelection
            isVisible: true
            shortcutKey: Copy
          )
         (MenuItem
            enabled: isNotReadOnly
            label: 'Paste'
            itemValue: pasteOrReplace
            isVisible: isNotReadOnly
            shortcutKey: Paste
          )
         (MenuItem
            label: '-'
            isVisible: isNotReadOnly
          )
         (MenuItem
            enabled: hasUndoAction
            label: 'Undo'
            itemValue: undo
            isVisible: isNotReadOnly
            shortcutKey: Undo
          )
         (MenuItem
            enabled: hasRedoAction
            label: 'Redo'
            itemValue: redo
            isVisible: isNotReadOnly
            shortcutKey: Redo
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            label: 'Do it'
            itemValue: doIt
            isVisible: true
            shortcutKey: DoIt
          )
         (MenuItem
            label: 'Print it'
            itemValue: printIt
            isVisible: true
            shortcutKey: PrintIt
          )
         (MenuItem
            label: 'Inspect it'
            itemValue: inspectIt
            isVisible: true
            shortcutKey: InspectIt
          )
         (MenuItem
            label: 'Profile it'
            itemValue: profileIt
            isVisible: true
            shortcutKey: InspectIt
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            label: 'Show Gutter'
            nameKey: ShowGutter
            isVisible: true
            indication: showGutterChannel
          )
         (MenuItem
            label: 'More'
            nameKey: More
            isVisible: true
          )
         (MenuItem
            label: 'Services'
            isVisible: true
            submenuChannel: servicesMenu
          )
         (MenuItem
            label: 'Debug'
            isVisible: true
            submenuChannel: debugMenu
          )
         )
        nil
        nil
      )

    "Modified: / 06-02-2018 / 20:09:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editMenu_stxStyle
    "This resource specification was automatically generated
     by the MenuEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the MenuEditor may not be able to read the specification."


    "
     MenuEditor new openOnClass:Tools::CodeView2 andSelector:#editMenu_stxStyle
     (Menu new fromLiteralArrayEncoding:(Tools::CodeView2 editMenu_stxStyle)) startUp
    "

    <resource: #menu>

    ^ 
     #(Menu
        (
         (MenuItem
            enabled: hasUndoAction
            label: 'Undo'
            itemValue: undo
            isVisible: isNotReadOnly
            shortcutKey: Undo
          )
         (MenuItem
            enabled: canDoAgain
            label: 'Again'
            itemValue: again
            isVisible: true
            shortcutKey: Again
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            enabled: canCut
            label: 'Cut'
            itemValue: cut
            isVisible: isNotReadOnly
            shortcutKey: Cut
          )
         (MenuItem
            enabled: hasSelectionForCopy
            label: 'Copy'
            itemValue: copySelection
            isVisible: true
            shortcutKey: Copy
          )
         (MenuItem
            label: 'Paste'
            itemValue: pasteOrReplace
            isVisible: isNotReadOnly
            shortcutKey: Paste
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            label: 'DoIt'
            itemValue: doIt
            isVisible: true
            shortcutKey: DoIt
          )
         (MenuItem
            label: 'PrintIt'
            itemValue: printIt
            isVisible: true
            shortcutKey: PrintIt
          )
         (MenuItem
            label: 'InspectIt'
            itemValue: inspectIt
            isVisible: true
            shortcutKey: InspectIt
          )
         (MenuItem
            label: '-'
            isVisible: true
          )
         (MenuItem
            enabled: canAccept
            label: 'Accept'
            itemValue: accept
            isVisible: isNotReadOnly
            shortcutKey: Accept
          )
         (MenuItem
            label: '-'
            isVisible: isNotReadOnly
          )
         (MenuItem
            label: 'Refactor'
            nameKey: refactor
            isVisible: false
            shortcutKey: Shift
          )
         (MenuItem
            label: 'Services'
            isVisible: false
            submenuChannel: servicesMenu
          )
         (MenuItem
            label: '='
            isVisible: true
          )
         (MenuItem
            label: 'More'
            nameKey: More
            isVisible: true
            shortcutKey: Ctrl
          )
         )
        nil
        nil
      )
! !

!CodeView2 methodsFor:'accessing'!

acceptAction:aBlock

    textView acceptAction: aBlock

    "Modified: / 01-08-2010 / 20:40:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

acceptEnabled:aBoolean

    textView acceptEnabled:aBoolean
!

breakpoints
    |s|

    (s := self breakpointService) notNil ifTrue:[
        ^ s breakpoints
    ].
    ^ nil

    "Created: / 06-07-2011 / 18:05:35 / jv"
    "Modified: / 06-10-2011 / 14:13:53 / cg"
!

browser

    ^self browserHolder value

    "Created: / 07-07-2011 / 12:25:59 / Jan Vrany <jan.vrant@fit.cvut,cz>"
!

codeAspect
    ^ textView codeAspect

    "Modified: / 27-07-2012 / 22:22:27 / cg"
    "Modified: / 27-09-2013 / 10:01:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

codeAspect: aSymbol
    "tell the textView what is shown, so it can adjust the
     syntaxhighlighter.
     See SyntaxHighlighter codeAspectXXX for possible aspects."

    ^ textView codeAspect: aSymbol

    "Modified: / 27-07-2012 / 22:32:19 / cg"
    "Modified: / 27-09-2013 / 10:01:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compilerClass
    ^textView compilerClass

    "Created: / 10-05-2012 / 23:47:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compilerClass: aClass
    textView compilerClass: aClass

    "Created: / 10-05-2012 / 23:47:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contents

    ^textView contents

    "Created: / 14-02-2010 / 22:13:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contents: aStringOrStringCollection

    textView contents: aStringOrStringCollection.
    "/self update:#value with: aStringOrStringCollection from: textView model

    "Modified: / 19-07-2011 / 13:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contents: aStringOrStringCollection clear: clearPrevious
    "Set the contents. If clearPrevous is true, then
     previous original text is cleared and set to given one.
     (so the text is considered not modified)"

    textView contents: aStringOrStringCollection clear: clearPrevious

    "Modified: / 19-07-2011 / 13:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 17-02-2012 / 00:33:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentParseNode
    |sel|

    sel := self syntaxElementSelection.
    sel isNil ifTrue:[^ nil].
    ^ sel node

    "Created: / 21-02-2012 / 14:20:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2014 / 22:06:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

delegate: anObject

    super delegate: anObject.
    self textView delegate: anObject.
    self gutterView delegate: anObject.

    "Created: / 11-05-2012 / 10:29:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diffMode
    ^ diffMode
!

diffMode:aBoolean
    diffMode := aBoolean.
    textView diffMode: aBoolean

    "Modified: / 08-04-2011 / 20:50:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editedLanguage: aProgrammingLanguage
    self languageHolder value: aProgrammingLanguage

    "Created: / 09-04-2014 / 14:49:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editedMethodOrClass:aMethodOrClass
    textView editedMethodOrClass:aMethodOrClass.
    aMethodOrClass isBehavior ifFalse:[
        self methodHolder value:aMethodOrClass
    ].
!

font

    ^textView font

    "Created: / 16-02-2010 / 10:26:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

font: aFont

    ^textView font: aFont

    "Created: / 16-02-2010 / 10:26:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mode

    ^self modeHolder value

    "Created: / 13-06-2011 / 10:49:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mode: aSymbol
    "is this the same as codeAspect ?"

    self assert: (#(expression method) includes: aSymbol).    
    
    ^self modeHolder value: aSymbol

    "Created: / 13-06-2011 / 10:50:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-06-2011 / 16:37:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-07-2012 / 22:19:49 / cg"
!

model

    ^textView model.

    "Created: / 27-07-2011 / 12:47:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

model: aValueModel

    |oldValue newValue|

    textView model notNil ifTrue:[
        oldValue := textView model value.
        textView model removeDependent:self.
    ].
    textView model: aValueModel.
    textView model notNil ifTrue:[
        textView model addDependent:self.
    ].
    newValue := textView model value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:textView model.
    ].

    "Modified: / 17-03-2012 / 16:11:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modified
    "return true if text was modified"

    ^ self modifiedChannel value

    "Modified: / 07-07-2011 / 12:15:43 / Jan Vrany <jan.vrant@fit.cvut,cz>"
!

modified:aBoolean
    "set/clear the modified flag"

    self modifiedChannel value:aBoolean

    "Modified: / 14-02-1997 / 16:44:05 / cg"
    "Modified: / 07-07-2011 / 12:15:39 / Jan Vrany <jan.vrant@fit.cvut,cz>"
!

services
    ^ services ? #()

    "Created: / 05-08-2011 / 10:14:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 06-10-2011 / 14:11:11 / cg"
!

services:aCollectionOfServices
    "allow setting of the services (instances);
     this is needed for FileBrowser, to setup a codeView2 without Smalltalk-specific
     services"

    services notEmptyOrNil ifTrue:[ 
        services do:[:service | service unregister ].
        services := #().
    ].
    servicesFromClient := true.
    services := aCollectionOfServices.
    services notEmptyOrNil ifTrue:[ 
        services do:[:service | service registerIn: self ].
    ].

    "Created: / 06-10-2011 / 14:15:36 / cg"
    "Modified: / 13-06-2014 / 14:12:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

servicesFromClient
    ^ servicesFromClient ? false

    "Modified: / 17-06-2014 / 10:22:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showAcceptCancelBar

    ^showAcceptCancelBarChannel value

    "Created: / 10-10-2011 / 16:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showGutter

    ^showGutterChannel value

    "Created: / 23-06-2010 / 19:37:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

synchronizeWith: aCodeView

    self assert: aCodeView ~= self.
    (synchronizedCodeViews includes: aCodeView) ifTrue:[^self].    
    synchronizedCodeViews := synchronizedCodeViews copyWith: aCodeView.

    "Created: / 06-04-2010 / 14:13:14 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 23-06-2010 / 17:01:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unsynchronizeWith: aCodeView

    self assert: aCodeView ~= self.
    (synchronizedCodeViews includes: aCodeView) ifFalse:[^self].
    synchronizedCodeViews := synchronizedCodeViews copyWithout: aCodeView.

    "Created: / 06-04-2010 / 14:13:14 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 23-06-2010 / 17:01:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 19-03-2012 / 14:25:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'accessing-behavior'!

readOnly:aBoolean
    "ignored here; present for compatibility with some textView subclasses,
     so that UIPainter can handle it in its TextView spec (which contains a
     readOnly field)"

    super readOnly:aBoolean.
    textView readOnly: aBoolean. 
    gutterView readOnly: aBoolean.

    "Created: / 21-02-2014 / 11:45:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'accessing-code component'!

klass
    "the class or the class of the method being shown."

    | v |

    (v := self classHolder value) notNil ifTrue:[^v].
    (v := self method) notNil ifTrue:[^v mclass].

    ^nil

    "Created: / 27-07-2011 / 13:14:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-07-2013 / 13:34:05 / cg"
!

klass: aClass
    "the class or the class of the method being shown"

    "Created: / 27-07-2011 / 13:13:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

language
    "return the value in 'languageHolder', the programmingLanguage of the class
     or method being shown.
     BAD name: confusion with the national language.
     why not call this 'programmingLanguage' ?"

    | v m c |

    (v := self languageHolder value) notNil ifTrue:[^v].
    (m := self method) notNil ifTrue:[^m programmingLanguage].
    (c := self classHolder value) notNil ifTrue:[^c programmingLanguage].

    "/No, no default language, please (for workspaces, etc.).
    "/^SmalltalkLanguage instance
    ^nil

    "Modified: / 07-12-2011 / 16:38:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-07-2013 / 13:34:17 / cg"
!

language: newValue
    "set the value in 'languageHolder', the programmingLanguage of the class
     or method being shown.
     BAD name: confusion with the national language.
     why not call this 'programmingLanguage' ?"

    self languageHolder value: newValue
!

method
    "the method being shown, or nil"

    ^self methodHolder value

    "Created: / 27-07-2011 / 13:12:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method: aMethod
    "the method being shown, or nil"

    ^self methodHolder value: aMethod

    "Created: / 27-07-2011 / 13:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'accessing-look'!

backgroundColor:aColor
    textView backgroundColor:aColor
!

viewBackground:newViewBackground
    textView viewBackground:newViewBackground
! !

!CodeView2 methodsFor:'aspects'!

browserHolder
    browserHolder isNil ifTrue:[
        browserHolder := ValueHolder new
    ].
    ^browserHolder

    "Modified: / 14-02-2010 / 19:27:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:15 / cg"
!

browserHolder:aValueModel
    browserHolder := aValueModel.
!

classHolder
    "return/create the 'classHolder' value holder (automatically generated)"

    classHolder isNil ifTrue:[
        classHolder := ValueHolder with: nil.
        classHolder addDependent:self.
    ].
    ^ classHolder

    "Modified: / 27-07-2011 / 13:15:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

classHolder:aValueModel
    "set the 'classHolder' value holder (automatically generated)"

    |old oldValue newValue|

    classHolder notNil ifTrue:[
        oldValue := classHolder value.
        classHolder removeDependent:self.
    ].
    old := classHolder.
    classHolder := aValueModel.
    classHolder notNil ifTrue:[
        classHolder addDependent:self.
    ].
    newValue := classHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:classHolder.
    ].

    self changed: #classHolder with: old -> classHolder

    "Modified: / 17-06-2014 / 13:10:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentBlockNodeHolder
    "return/create the 'currentBlockNodeHolder' value holder (automatically generated)"

    currentBlockNodeHolder isNil ifTrue:[
        currentBlockNodeHolder := ValueHolder new.
    ].
    ^ currentBlockNodeHolder
!

currentBlockNodeHolder:something
    "set the 'currentBlockNodeHolder' value holder (automatically generated)"

    currentBlockNodeHolder := something.
!

currentParseNodeHolder
    "return/create the 'currentParseNodeHolder' value holder (automatically generated)"

    currentParseNodeHolder isNil ifTrue:[
        currentParseNodeHolder := ValueHolder new.
    ].
    ^ currentParseNodeHolder
!

currentParseNodeHolder:something
    "set the 'currentParseNodeHolder' value holder (automatically generated)"

    currentParseNodeHolder := something.
    gutterView notNil ifTrue:[ gutterView currentBlockNodeHolder: currentBlockNodeHolder ].

    "Modified: / 16-02-2012 / 23:11:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

languageHolder
    languageHolder isNil ifTrue:[
        "/ cg: I don't like the smalltalk default here, because everyone who is not showing ST-code (expecco, filebrowser etc.)
        "/ has to explicitely clear the valueholder. I guess, it is better for the few
        "/ others to explicitely set it, if they do not provide syntaxHighlighter per method
        "/ or class.
        languageHolder := ValueHolder with: nil "SmalltalkLanguage instance".
        languageHolder addDependent:self.
    ].
    ^ languageHolder

    "Modified: / 19-07-2012 / 16:51:04 / cg"
!

languageHolder:aValueModel
    "set the 'languageHolder' value holder (automatically generated)"

    |old oldValue newValue|

    languageHolder notNil ifTrue:[
        oldValue := languageHolder value.
        languageHolder removeDependent:self.
    ].
    languageHolder := aValueModel.
    languageHolder notNil ifTrue:[
        languageHolder addDependent:self.
    ].
    old := languageHolder.
    newValue := languageHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:languageHolder.
    ].

    self changed: #languageHolder with: old -> languageHolder

    "Modified: / 17-06-2011 / 12:56:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-07-2012 / 16:51:08 / cg"
!

methodHolder
    "return/create the 'methodHolder' value holder (automatically generated)"

    methodHolder isNil ifTrue:[
        methodHolder := ValueHolder new.
        methodHolder addDependent:self.
    ].
    ^ methodHolder
!

methodHolder:aValueModel
    "set the 'methodHolder' value holder (automatically generated)"

    |old oldValue newValue|

    methodHolder notNil ifTrue:[
        oldValue := methodHolder value.
        methodHolder removeDependent:self.
    ].
    old := methodHolder.
    methodHolder := aValueModel.
    methodHolder notNil ifTrue:[
        methodHolder addDependent:self.
    ].
    newValue := methodHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:methodHolder.
    ].

    self changed: #methodHolder with: old -> methodHolder

    "Modified: / 17-06-2011 / 12:55:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modeHolder
    "return/create the 'modeHolder' value holder (automatically generated)"

    "is this the codeAspect?"
    modeHolder isNil ifTrue:[
        modeHolder := #expression asValue.
        modeHolder addDependent:self.
    ].
    ^ modeHolder

    "Modified: / 13-06-2011 / 10:52:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 27-07-2012 / 22:22:19 / cg"
!

modeHolder:something
    "set the 'modeHolder' value holder (automatically generated)"

    |oldValue newValue|

    modeHolder notNil ifTrue:[
        oldValue := modeHolder value.
        modeHolder removeDependent:self.
    ].
    modeHolder := something.
    modeHolder notNil ifTrue:[
        modeHolder addDependent:self.
    ].
    newValue := modeHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:modeHolder.
    ].

    self changed: #modeHolder with: modeHolder

    "Modified: / 17-06-2011 / 12:55:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'change & update'!

update:aspect with:param from:sender
    sender == methodHolder ifTrue:[
        textView editedMethodOrClass: methodHolder value.
    ].

    sender == classHolder ifTrue:[
        methodHolder value isNil ifTrue:[
            textView editedMethodOrClass: classHolder value.
        ].
    ].

    sender == languageHolder ifTrue:[
        "/ languageHolder value class == Workflow::ExecutionEditorShellScript::Shell_Language ifTrue:[self halt].
        "/ languageHolder value  == Workflow::ExecutionEditorShellScript::Shell_Language ifTrue:[self halt].
        textView editedLanguage: languageHolder value.
    ].

    sender == modeHolder ifTrue:[
        codeAspect := modeHolder value
    ].

    sender == showGutterChannel ifTrue: [
        self updateGutterVisibility.
        ^self.
    ].

    services do:[:each |
        each isEnabled ifTrue:[
            each update:aspect with:param from:sender
        ]
    ].
    "/ self updateScrollersViewBackground.
    
    super update:aspect with:param from:sender

    "Modified: / 07-07-2011 / 12:07:04 / Jan Vrany <jan.vrant@fit.cvut,cz>"
    "Modified: / 06-10-2011 / 14:14:36 / cg"
    "Modified: / 27-09-2013 / 10:16:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateGutter

    self showGutterChannel value ifTrue:[        
        gutterView invalidate.
    ]

    "Created: / 23-06-2010 / 19:05:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateGutterVisibility

    self showGutterChannel value ifTrue:[        
        textViewScroller origin:(gutterView width @ 0.0) corner:(1.0 @ 1.0).
        gutterView beVisible.
    ] ifFalse:[
        textViewScroller origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        gutterView beInvisible.
    ]

    "Created: / 23-06-2010 / 19:05:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateScrollersViewBackground
    "this changes the scroller's background, to show the positions of
     warnings, for easy location of interesting spots"
     
    |allAnnotations allBreakpoints scroller newBackground verticalScrollBar|

    allAnnotations := OrderedCollection new.
    allBreakpoints := OrderedCollection new.
    services do:[:eachService |
        allAnnotations addAll:(eachService annotations ? #()).
        eachService isBreakpointService ifTrue:[
            allBreakpoints addAll:(eachService breakpoints ? #()).
        ].    
    ].

    verticalScrollBar := textViewScroller verticalScrollBar.
    verticalScrollBar notNil ifTrue:[
        scroller := verticalScrollBar thumb.
    ].

    (allAnnotations isEmpty and:[allBreakpoints isEmpty]) ifTrue:[
        "/ nothing special to show
        scroller notNil ifTrue:[
            scroller viewBackground isColor ifTrue:[^ self].
            scroller initStyle
        ].
    ] ifFalse:[
        "/ yep, there are some annotations
        newBackground := AnnotationShowingScrollerBackground new.
        newBackground textView:textView.
        newBackground annotations:allAnnotations; breakpoints:allBreakpoints.

        scroller notNil ifTrue:[
            scroller viewBackground:newBackground.
        ].
    ].

    scroller notNil ifTrue:[
        scroller invalidate.
    ].
! !

!CodeView2 methodsFor:'channels'!

modifiedChannel
    "return the valueHolder holding true if text was modified"

    ^ textView modifiedChannel
"/    ^ modifiedChannel

    "Modified: / 07-07-2011 / 12:07:26 / Jan Vrany <jan.vrant@fit.cvut,cz>"
!

modifiedChannel:aValueHolder
    "set the valueHolder holding true if text was modified"

    textView modifiedChannel removeDependent:self.
    textView modifiedChannel:aValueHolder.
    textView modifiedChannel addDependent:self.

"/    |prev|
"/
"/    prev := modifiedChannel.
"/    modifiedChannel := aValueHolder.
"/    self setupChannel:aValueHolder for:nil withOld:prev

    "Created: / 30-01-1998 / 14:51:32 / cg"
    "Modified: / 07-07-2011 / 12:07:43 / Jan Vrany <jan.vrant@fit.cvut,cz>"
    "Modified: / 05-09-2011 / 05:13:27 / cg"
!

reallyModifiedChannel
    "return the valueHolder holding true if text was modified"

    ^ textView reallyModifiedChannel

    "Modified: / 07-07-2011 / 12:07:26 / Jan Vrany <jan.vrant@fit.cvut,cz>"
    "Created: / 08-10-2011 / 12:47:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reallyModifiedChannel: aValueModel

    ^ textView reallyModifiedChannel: aValueModel

    "Modified: / 07-07-2011 / 12:07:26 / Jan Vrany <jan.vrant@fit.cvut,cz>"
    "Created: / 08-10-2011 / 12:47:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showAcceptCancelBarChannel

    ^showAcceptCancelBarChannel

    "Created: / 10-10-2011 / 16:23:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showAcceptCancelBarChannel:aValueHolder
    "set the valueHolder holding true if text was modified"

    |prev|

    prev := showAcceptCancelBarChannel.
    showAcceptCancelBarChannel := aValueHolder.
    self setupChannel:aValueHolder for:nil withOld:prev.

    "Created: / 10-10-2011 / 16:24:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showGutterChannel

    ^showGutterChannel

    "Created: / 23-06-2010 / 19:02:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

showGutterChannel:aValueHolder
    "set the valueHolder holding true if text was modified"

    |prev|

    prev := showGutterChannel.
    showGutterChannel := aValueHolder.
    self setupChannel:aValueHolder for:nil withOld:prev

    "Created: / 23-06-2010 / 19:03:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'code services'!

browseMethod: method

    self browseMethod: method label: nil.

    "Created: / 14-02-2010 / 19:41:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

browseMethod: method label: label

    self browser isNil ifTrue: [^NewSystemBrowser openInMethod:method].
    (UserPreferences current alwaysOpenNewTabWhenCtrlClick 
        or:[self browser navigationState modified])  
        ifTrue:
            [self browser 
                spawnFullBrowserInClass: method mclass 
                selector:method selector 
                in:#newBuffer]
        ifFalse:
            [self browser 
                switchToClass: method containingClass 
                selector: method selector].

    "Modified: / 19-02-2008 / 10:15:17 / janfrog"
    "Created: / 19-10-2008 / 08:16:17 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 25-07-2010 / 13:34:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:12 / cg"
!

browseMethods: methods label: label

    methods size = 1 ifTrue:
        [^self browseMethod: methods anyOne label: label].

    self browser 
        ifNil: [NewSystemBrowser browseMethods: methods title: label]
        ifNotNil:[self browser spawnMethodBrowserFor:methods in:#newBuffer label:label]

    "Created: / 26-12-2007 / 11:32:04 / janfrog"
    "Modified: / 19-10-2008 / 08:17:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

extractSelectorAndSelectedText
    textView hasSelection ifTrue:[ 
        ^ self extractSelectorAndSelectedTextFrom:  textView selectionAsString
    ]. 
    syntaxElementSelection notNil ifTrue:[ 
        | node |

        node := syntaxElementSelection node.
        node isSelector ifTrue:[ 
            ^ Array with: node value with: node value
        ].
    ].
    ^ nil

    "Created: / 13-11-2017 / 21:53:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

extractSelectorAndSelectedTextFrom: givenSelectedText
    | selector selectedText compilerClass na |

    selectedText := givenSelectedText.
    compilerClass := self language compilerClass.
    selectedText size > 0 ifTrue:[
        "/ self windowGroup withWaitCursorDo:[
            "/ hack, for now and expecco; must ask the Parser eventually...
            (compilerClass notNil and:[compilerClass includesBehavior:JavaScriptParser]) ifTrue:[
                "/ selector is in one piece anyway
                (selectedText includes:$_) ifFalse:[
                    "/ zero or one args - sigh (need to parse more to figure this out)
                    selector := JavaScriptParser basicNew translatedSmalltalkSelectorFor:selectedText numArgs:1.
                    selectedText := JavaScriptParser basicNew translatedSmalltalkSelectorFor:selectedText numArgs:0.
                ] ifTrue:[
                    "/ count _#s plus one arg - sigh
                    na := (selectedText occurrencesOf:$_) + 1. 
                    selector := JavaScriptParser basicNew translatedSmalltalkSelectorFor:selectedText numArgs:na
                ].
            ] ifFalse:[
                selector := SystemBrowser extractSelectorFrom:selectedText.
            ].
        "/ ]
    ].
    ^Array with: selector with: selectedText

    "Created: / 30-06-2011 / 19:49:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2012 / 09:04:12 / cg"
!

implementorsOf: selector

    selector isNil ifTrue:[^#()].
    ^SystemBrowser
        findImplementorsOf: selector
        in: Smalltalk allClasses
        ignoreCase: false

    "Created: / 26-12-2007 / 11:37:11 / janfrog"
    "Modified: / 18-11-2011 / 14:58:17 / cg"
!

sendersOf: selector
    |senderBlock|

    selector isNil ifTrue:[^#()].
    selector knownAsSymbol ifFalse:[^#()].

    "/ not exact, but much faster (looks for symbol only, does not parse code for real send)
    senderBlock := SystemBrowser searchBlockForSymbol:selector asSymbol.
    senderBlock == false ifTrue:[ ^ #() ].

    ^ SystemBrowser
        allMethodsIn:Smalltalk allClasses
        where:senderBlock.

    "/ exact, but much slower
"/    ^SystemBrowser
"/        findSendersOf: selector
"/        in: Smalltalk allClasses
"/        ignoreCase: false

    "Created: / 26-12-2007 / 11:37:22 / janfrog"
    "Modified: / 30-06-2011 / 19:32:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:19 / cg"
    "Modified: / 04-06-2014 / 11:10:47 / az"
! !

!CodeView2 methodsFor:'delegation'!

doesNotUnderstand: aMessage

    ((textView respondsTo: aMessage selector) 
    and:[(TraceSelectors includes:aMessage selector) not])
        ifTrue:[^aMessage sendTo: textView].
    ^super doesNotUnderstand: aMessage

    "Created: / 13-02-2010 / 23:27:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-02-2010 / 09:53:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelection

    ^textView hasSelection

    "Created: / 14-02-2010 / 09:53:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'delegation-drawing'!

drawLine:lineNo in: view atX:x y:yBaseline width: w height:hFont ascent:aFont
    from:startCol to:endColOrNil with:fg and:bg
    "See the comment in
     CodeViewService>>drawLine:in:atX..."

    self servicesDo:[:each|
        each drawLine:lineNo in:view atX:x y:yBaseline width:w height:hFont ascent:aFont
             from:startCol to:endColOrNil with:fg and:bg
    ]

    "Created: / 17-06-2011 / 13:50:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-10-2011 / 14:14:04 / cg"
    "Modified: / 27-11-2014 / 15:37:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawVisibleLine: visLineNr

    "Created: / 07-03-2010 / 14:44:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawVisibleLine:visLine col:colNr

    "Modified: / 05-11-2007 / 17:35:53 / cg"
    "Modified: / 07-03-2010 / 14:45:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawVisibleLine:visLine from:startCol

    "Modified: / 07-03-2010 / 14:46:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawVisibleLine:visLine from:startCol to:endCol

    "Modified: / 07-03-2010 / 14:46:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'delegation-events'!

buttonMotion: button x:x y:y in: view
    "Delegates events to services. Answers true iff at least
     one service handler method returns true. In that case,
     the event is is NOT processes by the view."

    ^ services 
        contains:[:service |
            service isEnabled and:[ ((service buttonMotion: button x:x y:y in: view) == true) ]
        ].

    "Modified: / 07-03-2010 / 13:53:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-10-2011 / 14:13:57 / cg"
!

buttonMultiPress: button x:x y:y in: view
    "Delegates events to services. Answers true iff at least
     one service handler method returns true. In that case,
     the event is is NOT processes by the view."

    ^ services
        contains:[:service |
            service isEnabled 
            and:[ ((service buttonMultiPress: button x:x y:y in: view) == true) ]
        ].

    "Modified: / 07-03-2010 / 13:53:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-10-2011 / 14:14:00 / cg"
    "Modified (format): / 05-03-2012 / 08:56:02 / cg"
!

buttonPress: button x:x y:y in: view
    "Delegates events to services. Answers true iff at least
     one service handler method returns true. In that case,
     the event is is NOT processes by the view."

    ^ services
        contains:[:service |
            service isEnabled and:[ ((service buttonPress: button x:x y:y in: view) == true) ]
        ].

    "Modified: / 07-03-2010 / 13:53:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-10-2011 / 14:14:00 / cg"
    "Modified (format): / 05-03-2012 / 08:56:02 / cg"
!

buttonRelease: button x:x y:y in: view
    "Delegates events to services. Answers true iff at least
     one service handler method returns true. In that case,
     the event is is NOT processes by the view."

    ^ services 
        contains:[:service |
            service isEnabled and:[ ((service buttonRelease: button x:x y:y in: view) == true) ]
        ].
!

highlightClassVariable:name
    "interface from browser (when a class var is selected)"

    services do:[:each|
        each highlightClassVariable:name
    ].
!

highlightInstanceVariable:name
    "interface from browser (when an inst var is selected)"

    services do:[:each|
        each highlightInstanceVariable:name
    ].
!

keyPress: key x:x y:y in: view
    "Delegates events to services. Answers true iff at least
     one service handler method returns true. In that case,
     the event is is NOT processes by the view."

    ^ services 
        contains:[:service |
            |handledByService|

            handledByService := service isEnabled 
                                and:[ ((service keyPress: key x:x y:y in: view) == true)].
            "/ handledByService ifTrue:[ Transcript showCR:'handled by ',service printString ].
            handledByService
        ].

    "Modified: / 07-03-2010 / 13:54:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-10-2011 / 14:14:11 / cg"
!

keyRelease: key x:x y:y in: view
    "Delegates events to services. Answers true iff at least
     one service handler method returns true. In that case,
     the event is is NOT processes by the view."

    ^ services 
        contains:[:service |
            service isEnabled and:[ ((service keyRelease: key x:x y:y in: view) == true) ]
        ].

    "Modified: / 07-03-2010 / 13:54:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-10-2011 / 14:14:13 / cg"
!

linesDeletedFrom: start to: end

    services do: [:each |
        each isEnabled ifTrue: [
            each linesDeletedFrom: start to: end
        ]
    ].

    "Created: / 06-07-2011 / 17:12:54 / jv"
    "Modified: / 06-10-2011 / 14:14:16 / cg"
    "Modified: / 07-10-2011 / 19:14:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

linesInsertedFrom: start to: end

    services do: [:each |
        each isEnabled ifTrue: [
            each linesInsertedFrom: start to: end
        ]
    ].

    "Created: / 06-07-2011 / 17:12:48 / jv"
    "Modified: / 06-10-2011 / 14:14:20 / cg"
!

linesModifiedFrom: start to: end

    services do: [:each |
        each isEnabled ifTrue: [
            each linesModifiedFrom: start to: end
        ]
    ].

    "Created: / 06-07-2011 / 17:12:58 / jv"
    "Modified: / 06-10-2011 / 14:13:44 / cg"
!

scrollDown: nLines in: view

    view == textView 
        ifTrue:
            ["/my text view scrolled...
            synchronizedCodeViews do:[:codeView|codeView scrollDown: nLines in: view]]
        ifFalse:
            ["/other code view scrolls and I'm notified about that
            textView basicScrollDown: nLines]

    "Created: / 06-04-2010 / 14:02:39 / Jakub <zelenja7@fel.cvut.cz>"
!

scrollTo:origin redraw:doRedraw in: view
    view == textView ifTrue: [
        "/my text view scrolled...
        synchronizedCodeViews do:[:codeView|
            codeView scrollTo:origin redraw:doRedraw in: view.
        ]
    ] ifFalse: [
        "/other code view scrolls and I'm notified about that
        textView basicScrollTo:origin redraw:doRedraw.
    ]

    "Created: / 06-04-2010 / 14:02:39 / Jakub <zelenja7@fel.cvut.cz>"
    "Created: / 19-03-2012 / 17:05:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scrollUp: nLines in: view

    view == textView 
        ifTrue:
            ["/my text view scrolled...
            synchronizedCodeViews do:[:codeView|codeView scrollUp: nLines in: view]]
        ifFalse:
            ["/other code view scrolls and I'm notified about that
            textView basicScrollUp: nLines]

    "Created: / 06-04-2010 / 14:02:39 / Jakub <zelenja7@fel.cvut.cz>"
! !

!CodeView2 methodsFor:'diff mode'!

recomputeDiff:view 
    |t1 t2 pom diffHelper view2|

    t1 := view getNewOriginText.
    synchronizedCodeViews do:[:codeView | 
        view2 := codeView
    ].
    view changedDiffText:false.
    view2 changedDiffText:false.
    t2 := view2 getNewOriginText.
    pom := DiffCodeView2 new.
    (view == textView) ifTrue:[
        diffHelper := pom computeDiffDataForText1:t1 text2:t2.
        (view) contents:(diffHelper text1).
        (view) deletedLines:(diffHelper deleted).
        (view) changedLines:(diffHelper changed).
        (view) originDiffText:t1.
        (view) emptyLines:(diffHelper inserted).
        (view) changedLines:(diffHelper changed).
        (view2) contents:(diffHelper text2).
        (view2) insertedLines:(diffHelper inserted).
        (view2) changedLines:(diffHelper changed).
        (view2) originDiffText:t2.
        (view2) emptyLines:(diffHelper deleted).
    ].

    "Modified: / 22-06-2010 / 23:35:41 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 23-06-2010 / 17:25:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'initialize & release'!

defaultServices
    "/ used to call "CodeViewService availableServices",
    "/ which enumerated all subclasses.
    "/ this is BAD BAD BAD, because it does not allow for additional service
    "/ subclasses to be built for special applications. For example,
    "/ a debugging breakpoint service for a GDB application, a breakpoint service for
    "/ expecco's codeview.

    "/ therefore, the list of services to use in codeView2 is now filtered

    ^ CodeViewService availableServices
        select:[:service | service isUsefulFor:self]

    "Created: / 22-07-2013 / 13:57:40 / cg"
!

initialize
    "Invoked when a new instance is created."
    "Call super initialize"

    super initialize.
     "Now set up some visual properties"
    self level:(styleSheet at:#'codeView2.level' default:-1).
     "Now initialize sub-views"
    showGutterChannel := ValueHolder with: true.
    showGutterChannel addDependent: self.
    "/ toDo: I don't like two options in the settings;
    "/ showAcceptCancelBarChannel := (ValueHolder with: (UserPreferences current showAcceptCancelBarInBrowser)).
    showAcceptCancelBarChannel := ValueHolder with: (UserPreferences current codeView2ShowAcceptCancel).

    "/ these views must be created first, as they refer to each other's channels in their
    "/ initialize methods
    gutterView := CodeView2::GutterView new.
    textViewScroller := HVScrollableView for: CodeView2::TextView in: self.
    textView := textViewScroller scrolledView.

    self initializeGutterView.
    self initializeTextView.
    textView setCodeView:self.
    modifiedChannel := ValueHolder with:false.
    diffMode := false.
    synchronizedCodeViews := #().
    currentParseNodeHolder := ValueHolder new.
    currentBlockNodeHolder := ValueHolder new.

    servicesFromClient := false.
    services := OrderedCollection new.
    self initializeServices.

    "Modified: / 14-12-2009 / 13:59:53 / Jindra <a>"
    "Modified: / 06-04-2010 / 13:56:35 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 06-10-2011 / 14:15:48 / cg"
    "Modified: / 16-02-2012 / 23:05:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeGutterView

    gutterView setCodeView:self.
    gutterView currentBlockNodeHolder: self currentBlockNodeHolder.
    gutterView origin:(0.0 @ 0.0) corner:(gutterView preferredWidth+1 @ 1.0).
    showGutterChannel value ifTrue:[self addSubView: gutterView].

    "Created: / 02-09-2009 / 21:35:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-06-2010 / 19:14:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeServices
    | serviceClasses |

    "/ only do it, if the services have not yet been defined by the user of this view
    "/ (FileBrowser does not want Smalltalk-specific services)
    servicesFromClient ifFalse:[
        serviceClasses := self defaultServices 
                            sort:[:a :b|
                                a priority = b priority 
                                    ifTrue:[a name < b name] 
                                    ifFalse:[a priority > b priority]
                            ].
        serviceClasses do:[:cls|
            self registerService: cls new
        ].
    ].

    "Modified: / 22-07-2013 / 14:02:59 / cg"
    "Modified: / 24-07-2013 / 11:56:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

initializeTextView
    "Initialize textView. gutterView has to be already initialized!!"

    textViewScroller
        origin: ((self showGutter ifTrue:[gutterView width] ifFalse:[0.0]) @ 0.0)
        corner: 1.0@1.0;
        level: 0.
    textView level: 0.

    textView modifiedChannel addDependent: self.

    "Created: / 02-09-2009 / 21:36:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-06-2010 / 19:38:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    services do:[:service | service unregister ].
    services := #().

    textView model notNil ifTrue:[ 
        textView model removeDependent: self.
    ].
    textView modifiedChannel notNil ifTrue:[ 
        textView modifiedChannel removeDependent: self.
    ].
    showGutterChannel removeDependent: self.
    languageHolder notNil ifTrue:[ 
        languageHolder removeDependent: self.
    ].
    classHolder notNil ifTrue:[ 
        classHolder removeDependent: self.
    ].
    methodHolder notNil ifTrue:[ 
        methodHolder removeDependent: self.
    ].
    super release.

    "Created: / 23-06-2014 / 20:16:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 23-06-2014 / 22:18:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'menu actions'!

accept
    textView accept

    "Created: / 07-09-2011 / 21:29:07 / cg"
!

again
    textView again

    "Created: / 16-02-2010 / 19:36:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 22-07-2011 / 17:44:31 / cg"
!

browseImplementorsOfIt

    textView browseImplementorsOfIt

    "Modified: / 30-06-2011 / 19:22:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

browseSendersOfIt

    textView browseSendersOfIt

    "Modified: / 30-06-2011 / 19:22:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

copySelection

    textView copySelection

    "Created: / 16-02-2010 / 19:36:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cut

    textView cut

    "Created: / 16-02-2010 / 19:36:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

doIt

    textView doIt

    "Modified: / 16-02-2010 / 19:38:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspectIt

    textView inspectIt

    "Modified: / 16-02-2010 / 19:38:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspectSelectedSelector

    self error: 'Not yet implemented'

    "Modified: / 14-02-2010 / 15:58:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspectSyntaxElements

    syntaxElements inspect

    "Modified: / 14-02-2010 / 15:57:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspectView

    self inspect

    "Modified: / 25-03-2010 / 17:58:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

pasteOrReplace

    textView pasteOrReplace

    "Created: / 16-02-2010 / 19:37:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

printIt

    textView printIt

    "Modified: / 16-02-2010 / 19:38:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

profileIt

    textView profileIt

    "Created: / 27-08-2010 / 22:12:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

undo

    textView undo

    "Created: / 16-02-2010 / 19:35:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'menus-dynamic'!

debugMenu
    ^ self class debugMenu decodeAsLiteralArray
        receiver:self.
!

editMenu
    | editMenu superEditMenu moreMenu moreMenuItem |

    superEditMenu := textView superEditMenu.

    textView sensor ctrlDown ifTrue:[
        ^superEditMenu
    ].

    "/ install the standard 'more' menu into my own menu
    moreMenu := superEditMenu subMenuAt: superEditMenu numberOfItems.

    editMenu := self class editMenu decodeAsLiteralArray.
    moreMenuItem := editMenu menuItemLabeled: 'More'.
    moreMenuItem submenu: moreMenu asMenu.
    editMenu findGuiResourcesIn: self.
    ^editMenu

    "Created: / 25-12-2007 / 10:10:01 / janfrog"
    "Modified: / 25-12-2007 / 19:50:53 / janfrog"
    "Modified: / 18-10-2008 / 20:31:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-07-2011 / 13:35:31 / cg"
    "Modified: / 07-10-2011 / 17:58:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

implementorsMenu

    | selectorAndSelectedText selector selectedText  implementors |

    selectorAndSelectedText := self extractSelectorAndSelectedText.
    selectorAndSelectedText notNil ifTrue:[
        "/ self windowGroup withWaitCursorDo:[

            selector := selectorAndSelectedText first.
            selectedText := selectorAndSelectedText second.

            (selector notNil and:[selector = selectedText]) ifTrue:[
                implementors := (SystemBrowser 
                                    findImplementorsOf:selectedText "Any: (Array with:selectedText)" 
                                    in:(Smalltalk allClasses) 
                                    ignoreCase:false)

            ] ifFalse:[
                implementors := (SystemBrowser 
                                    findImplementorsOfAny:(Array with:selectedText with: selector) 
                                    in:(Smalltalk allClasses) 
                                    ignoreCase:false)
            ].
        "/ ] 
    ] ifFalse:[
        implementors := #().
    ].

    ^self implementorsMenu: implementors selector: (selector ? selectedText)

    "Modified: / 19-10-2008 / 08:16:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 30-06-2011 / 19:28:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2012 / 09:02:43 / cg"
    "Modified: / 13-11-2017 / 21:54:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

implementorsMenu: implementors selector: selector
    | menu|

    menu := Menu new.
    implementors isEmptyOrNil ifTrue:[
        menu addItem:(MenuItem label:'No implementors found') disable
    ] ifFalse:[
        menu addItem:(MenuItem
                    label:(selector storeString , (' (all implementors) ') asText allItalic)
                    itemValue:[
                        self browseMethods:implementors
                            label:'Implementors of ' , selector storeString
                    ]).

        menu addSeparator.
        (implementors asOrderedCollection sort:[:a :b | a mclass name < b mclass name])
        "implementors" do:[:mth |
            menu
                addItem:(MenuItem label:(selector storeString
                                , (' in ' , mth containingClass nameInBrowser asText allBold))
                        itemValue:[ self browseMethod:mth label: 'Implementor of ' , selector storeString  ])
        ]
    ].
    ^ menu

    "Modified: / 19-10-2008 / 08:16:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 14-02-2010 / 19:39:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-03-2012 / 12:56:56 / cg"
    "Modified: / 14-10-2013 / 10:47:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sendersMenu

    | selectorAndSelectedText selector selectedText  senders |

    selectorAndSelectedText := self extractSelectorAndSelectedText.
    selectorAndSelectedText notNil ifTrue:[    
        "/ self windowGroup withWaitCursorDo:[
            selectorAndSelectedText := self extractSelectorAndSelectedTextFrom:  selectedText.
            selector := selectorAndSelectedText first.
            selectedText := selectorAndSelectedText second.

            (selector notNil and:[selector = selectedText]) ifTrue:[
                senders := (SystemBrowser 
                                findSendersOf:selectedText "Any:(Array with:selectedText)" 
                                in:(Smalltalk allClasses) 
                                ignoreCase:false)

            ] ifFalse:[
                senders := (SystemBrowser 
                                findSendersOfAny:(Array with:selectedText with: selector) 
                                in:(Smalltalk allClasses) 
                                ignoreCase:false)
            ].
        "/ ] 
    ] ifFalse:[
        senders := #().
    ].

    ^self sendersMenu: senders selector: (selector ? selectedText)

    "Modified: / 19-10-2008 / 08:16:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 30-06-2011 / 19:28:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2012 / 09:02:56 / cg"
    "Modified: / 13-11-2017 / 21:54:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sendersMenu: senders  selector: selector
    | menu shownSenderItems numCut sendersSorted|

    menu := Menu new.
    senders isEmptyOrNil ifTrue:[
        menu addItem:(MenuItem label:'No senders found') disable
    ] ifFalse:[
        menu addItem:(MenuItem
                    label:(selector storeString , (' (all senders)') asText allItalic)
                    itemValue:[
                        self browseMethods:senders
                            label:'Senders of ' , selector storeString
                    ]).
        menu addSeparator.
        sendersSorted := senders asOrderedCollection
                            sort:[:a :b | a whoString < b whoString].
        shownSenderItems := (senders size > 20) ifTrue:[sendersSorted copyTo:20] ifFalse:[sendersSorted].
        numCut := senders size - 20.
        shownSenderItems do:[:mth |
            menu
                addItem:(MenuItem label:(mth selector storeString
                                , (' in ' , mth containingClass nameInBrowser asText allBold))
                        itemValue:[ self browseMethod:mth label: 'Sender of ' , selector storeString ])
        ].
        numCut > 0 ifTrue:[
            menu addSeparator.
            menu addItem:(MenuItem label:('... %1 more senders not shown here' bindWith:numCut)) disable
        ].
    ].
    ^ menu

    "Modified: / 19-10-2008 / 08:17:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Created: / 14-02-2010 / 19:40:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-07-2011 / 14:51:54 / jv"
    "Modified: / 07-03-2012 / 12:58:31 / cg"
    "Modified: / 14-10-2013 / 10:47:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

servicesMenu
    |menu item anyService|

    menu := Menu new.
    item := (MenuItem label:(resources string:'Services (experimental)')) enabled:false.
    menu addItem:item.
    menu addSeparator.

    "/ disabled, because this menu is now on the gutter,
    "/ and it makes it hard to show it again, once hidden

"/    item := MenuItem label:(resources string:'Show Gutter').
"/    item indication:(self showGutterChannel).
"/    menu addItem:item.
"/    menu addSeparator.

    anyService := false.
    services do:[:service | 
        |item|

        item := MenuItem label:(resources string:service label).
        item indication:((AspectAdaptor forAspect:#enabled) subject:service).
        item hideMenuOnActivated:false.
        menu addItem:item.
        anyService := true.
    ].

    anyService ifTrue:[
        menu addSeparator.
    ].

    item := MenuItem label:(resources string:'Debug').
    item submenuChannel:[ self debugMenu ].
    menu addItem:item.

    ^ menu

    "Created: / 07-03-2010 / 14:03:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-10-2011 / 14:14:30 / cg"
! !

!CodeView2 methodsFor:'private'!

codeCompletion
    "/ I found this code 3 times (CodeView2, NewSystemBrowser and DebugView) - smell? 
    "/ (can we move that to a utility - probably DoWhatIMeanSupport)

    |cls language|

    cls := self classHolder value.
    cls notNil ifTrue:[
        language := cls programmingLanguage
    ].
    UserInformation handle:[:ex |
        self showInfo:(ex messageText).
        ex proceed.
    ] do:[
        self withWaitCursorDo:[
            DoWhatIMeanSupport codeCompletionForLanguage:language class:cls context:nil codeView:self.
        ]
    ].
    ^ self.

    "Modified: / 04-07-2006 / 18:48:26 / fm"
    "Modified: / 20-11-2006 / 12:30:59 / cg"
    "Modified: / 18-09-2013 / 14:18:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reallyModified
    "check for modified code by comparing the source against
     the codeView's contents.
     That's the true modified value 
     (in case user undid his changes, and the displayed text is actually original)"

    |modified|

    "/ cg: why this? It does not make sense to me.
    "/ either we can depend on what the textView tells me here
    "/ in which case we don't need the code below,
    "/ or we cannot, in which the textView modified query should be removed.
    "/ from tracing, it looks as if the textView modified query is correct all the time.
    "/ Can someone validate/verify this, please?
    textView modified ifTrue:[^true].   

     "/ higher prio to prevent it from being changed while we convert it (by editing)
    Processor activeProcess
        withHigherPriorityDo:[
            modified := textView isTextDifferentFromOriginalSource.
        ].

    ^ modified

    "Created: / 06-02-2010 / 19:59:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 05-06-2012 / 23:55:02 / cg"
!

showInfo: message

    | app |
    (app := self topView application) ifNotNil:
        [(app respondsTo: #showInfo:) ifTrue:
            [app showInfo: message]].

    "Modified: / 13-02-2010 / 23:25:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'private-accessing'!

gutterView

    ^gutterView

    "Created: / 14-02-2010 / 15:21:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxElementSelection
    ^ syntaxElementSelection
!

syntaxElementSelection:anElement
    syntaxElementSelection := anElement.
"/    anElement isNil ifTrue:[
"/        currentParseNodeHolder value: nil.
"/"/        currentBlockNodeHolder value: nil.
"/    ] ifFalse:[
"/        currentParseNodeHolder value: anElement node.
"/"/        currentBlockNodeHolder value: anElement node enclosingBlock.
"/    ]

    "Modified: / 24-09-2013 / 00:14:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxElements
    ^ syntaxElements
!

syntaxElements:aCollection
    aCollection notNil ifTrue:[
        aCollection isSortedCollection ifFalse:[ 
            aCollection sort.
        ].
    ].
    syntaxElements := aCollection.

    "Modified: / 08-08-2014 / 13:18:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textView

    ^textView

    "Created: / 14-02-2010 / 15:21:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textViewScroller

    ^textViewScroller

    "Created: / 14-02-2010 / 15:21:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'realization'!

disableAllServices

    services do:[:service|
        service enabled:false.
    ]
!

enableAllServices

    services do:[:service|
        service enabled:true.
    ]
!

postRealize

    services do:[:service|
        service viewRealized.
    ]

    "Created: / 23-01-2012 / 10:35:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2 methodsFor:'redrawing'!

flash
    textView flash.

    "Created: / 21-02-2014 / 16:57:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flash: aString
    "delegated to my textview"

    textView flash:aString.
!

flash: aString withColor:flashColor
    "delegated to my textview"

    textView flash:aString.
! !

!CodeView2 methodsFor:'services'!

breakpointService
    "that one or nil"

    ^ services detect:[:any| (any isKindOf: BreakpointService)] ifNone:nil
!

lintService
    "prefers the smallsense-lint service over others"

    ^ services 
        detect:[:any| (any isKindOf:SmallSense::SmalltalkLintService)] 
        ifNone:[
            services 
                detect:[:any| (any isLintService)] 
                ifNone:nil
        ]
!

registerService: aCodeViewService

    services add: aCodeViewService.
    aCodeViewService registerIn: self

    "Created: / 06-03-2010 / 19:19:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

servicesDo:aBlock
    services notNil ifTrue:[ 
        services do:[ :service | service isEnabled ifTrue:[ aBlock value: service ] ] 
    ]

    "Modified: / 27-11-2014 / 15:38:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

syntaxHighlightingService
    "that one or nil"

    ^ services detect:[:any| (any isKindOf: CodeHighlightingService)] ifNone:nil
!

unregisterAllServices

    services copy do:[:eachService | self unregisterService:eachService ].
!

unregisterService: aCodeViewService

    services remove: aCodeViewService ifAbsent:[^self].
    aCodeViewService unregister.

    "Created: / 06-03-2010 / 19:21:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 19-07-2012 / 16:34:18 / cg"
! !

!CodeView2 methodsFor:'testing'!

hasOwnScrollbars
    "a hack for codeView2, which behaves like a TextView, but has its own
     scrollbars embedded - sigh (an extra load one).
     This allows for the UIBuilder to avoid creating an extra set around such
     a view (as is the case with TextSpec with scrollbars when using CodeView2)"

    ^ true
!

isCodeView2

    ^true

    "Created: / 20-07-2010 / 15:43:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isTextView

    ^true

    "Created: / 14-02-2010 / 22:13:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::AnnotationShowingScrollerBackground class methodsFor:'documentation'!

documentation
"
    I am a scroller background used to show annotation positions
    (very similar to the DiffTextScrollerBackground).
    I draw little markers at positions where annotations are.

    I need a reference to the textView and the list of annotations.
"
! !

!CodeView2::AnnotationShowingScrollerBackground methodsFor:'accessing'!

annotations:aCollectionOfAnnotations
    annotations := aCollectionOfAnnotations.
!

breakpoints:aCollectionOfBreakpoints
    breakpoints := aCollectionOfBreakpoints.
!

textView:something
    textView := something.
! !

!CodeView2::AnnotationShowingScrollerBackground methodsFor:'drawing'!

fillRectangleX:x y:y width:w height:h in:aScroller
    "I am asked to draw the background of aScroller.
     If any annotation is in that range, draw it"
    
    |overAllHeight drawRect scrollerHeight|

    annotations isEmptyOrNil ifTrue:[
        breakpoints isEmptyOrNil ifTrue:[
            ^ self 
        ].
    ].
    
    scrollerHeight := aScroller height.
    drawRect :=
        [:lineNr :clrInside |
            |clrBorder yThumb|
            
            yThumb := (scrollerHeight * (lineNr / overAllHeight)) rounded.
            (yThumb between:y-5 and:(y + h + 5)) ifTrue:[
                clrBorder := clrInside darkened.
                aScroller paint:clrInside.
                aScroller fillRectangleX:3 y:(yThumb-5 max:0) width:aScroller width-5 height:8.
                aScroller paint:clrBorder.
                aScroller displayRectangleX:3 y:(yThumb-5 max:0) width:aScroller width-5 height:9.
            ].    
        ].
        
    overAllHeight := textView numberOfLines.
    overAllHeight = 0 ifTrue:[ ^ self ].

    annotations notEmptyOrNil ifTrue:[
        annotations do:[:eachAnnotation |
            |lineNr severityColor severity|

            (lineNr := eachAnnotation line) notNil ifTrue:[ 
                severity := eachAnnotation rule severity.
                severity == #error ifTrue:[
                    severityColor := Color red.
                ] ifFalse:[
                    severity == #warning ifTrue:[
                        severityColor := Color yellow.
                    ] ifFalse:[
                        severityColor := Color blue.
                    ].    
                ].    
                drawRect value:lineNr value:severityColor lightened.
            ].
        ].
    ].
    breakpoints notEmptyOrNil ifTrue:[
        breakpoints do:[:eachBreakpoint |
            (eachBreakpoint isVisible and:[eachBreakpoint isEnabled]) ifTrue:[ 
                |lineNr bpntColor|

                (lineNr := eachBreakpoint line) notNil ifTrue:[    
                    bpntColor := eachBreakpoint isTracepoint
                                    ifTrue:[ Color blue lightened]
                                    ifFalse:[ Color red ].
                    drawRect value:lineNr value:bpntColor.
                ].
            ].
        ].
    ].
! !

!CodeView2::AnnotationShowingScrollerBackground methodsFor:'ignored conversion'!

asFormOn:aDevice
    "superclass AbstractBackground says that I am responsible to implement this method"

    ^ self 
!

onDevice:aDevice
    "superclass AbstractBackground says that I am responsible to implement this method"

    ^ self 
! !

!CodeView2::GutterView methodsFor:'accessing'!

menuHolder:aValueThing
    menuHolder := aValueThing
!

setTextView: aTextView

    self assert: textView isNil message:'Attempting to set textView twice'.
    textView := aTextView.

    textView addDependent:self.

    "/ self backgroundPaint: textView backgroundPaint darkened lighter.
    self viewBackground: (View defaultBackgroundColor). "/ textView backgroundPaint darkened lighter.
    self paint: textView paint.
    self font: textView font.

    "Created: / 02-09-2009 / 21:55:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-12-2009 / 15:09:29 / Jindra <a>"
    "Modified: / 09-02-2010 / 20:03:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-08-2011 / 15:15:09 / cg"
!

setTextViewScroller:aScr
    textViewScroller := aScr.

    "Created: / 07-12-2009 / 22:36:31 / Jindra <a>"
!

showLineNumbers:aBoolean
    "can be used to turn off linenumber drawing, 
     in case the gutter is used with another view anf only the other features (breakpoints) are needed"

    showLineNumbers := aBoolean.
! !

!CodeView2::GutterView methodsFor:'accessing-dimensions'!

acceptButtonBottom

    ^(self height * 0.6) ceiling.

    "Created: / 07-10-2011 / 19:53:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

acceptCancelRight
    ^((self paddingLeft) + self usedWidthForAcceptCancel)

    "Created: / 10-09-2013 / 03:00:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-02-2014 / 12:06:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cancelButtonBottom  

    ^(self height * 0.8) ceiling.

    "Created: / 07-10-2011 / 19:54:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

padding

    ^self paddingLeft + self paddingRight 
        + self usedWidthForAcceptCancel    
        + (widthAnnotations ? 0) 
        + (widthDiffInfo ? 0)

    "Created: / 14-02-2010 / 22:28:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-10-2011 / 19:01:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-10-2011 / 20:45:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

paddingLeft

    ^0"px"

    "Created: / 14-02-2010 / 22:27:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-06-2011 / 13:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

paddingRight

    ^3"px"

    "Created: / 14-02-2010 / 22:27:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 16-02-2012 / 22:40:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

preferredExtent
    | font w h |

    explicitExtent notNil ifTrue:[ ^ explicitExtent ].
    preferredExtent notNil ifTrue:[ ^ preferredExtent ].

    font := self font.
    w := (font widthOf:'00') + self padding.
    h := textView notNil 
            ifTrue:[textView height] 
            ifFalse:[font height * 12].

    ^preferredExtent := w @ h

    "Modified: / 16-06-2011 / 14:03:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 26-03-2012 / 11:19:54 / cg"
!

usedWidthForAcceptCancel
    ^ (codeView notNil and:[codeView showAcceptCancelBar]) ifTrue:[widthAcceptCancel ? 0] ifFalse:[0]
! !

!CodeView2::GutterView methodsFor:'actions'!

accept

    textView accept

    "Created: / 07-10-2011 / 20:23:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cancel

    textView cancel

    "Created: / 07-10-2011 / 20:23:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

diff

    "Created: / 07-10-2011 / 20:23:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspectView
    self halt.
!

middleButtonMenu    
    menuHolder notNil ifTrue:[^ menuHolder value].
    codeView isNil ifTrue:[^ nil].
    ^ codeView servicesMenu
! !

!CodeView2::GutterView methodsFor:'aspects'!

currentBlockNodeHolder
    "return/create the 'currentBlockNodeHolder' value holder (automatically generated)"

    currentBlockNodeHolder isNil ifTrue:[
        currentBlockNodeHolder := ValueHolder new.
        currentBlockNodeHolder addDependent:self.
    ].
    ^ currentBlockNodeHolder
!

currentBlockNodeHolder:something
    "set the 'currentBlockNodeHolder' value holder (automatically generated)"

    |oldValue newValue|

    currentBlockNodeHolder notNil ifTrue:[
        oldValue := currentBlockNodeHolder value.
        currentBlockNodeHolder removeDependent:self.
    ].
    currentBlockNodeHolder := something.
    currentBlockNodeHolder notNil ifTrue:[
        currentBlockNodeHolder addDependent:self.
    ].
    newValue := currentBlockNodeHolder value.
    oldValue ~~ newValue ifTrue:[
        self update:#value with:newValue from:currentBlockNodeHolder.
    ].
! !

!CodeView2::GutterView methodsFor:'change & update'!

adjustSizeForLongestLine
    "recompute the required width (longest linenumber present, not shown)"

    |newNumberOfLines longestLineString textW requiredW newWidth|

    showLineNumbers ifFalse:[^ self].

    newNumberOfLines := (textView list size max:textView cursorLine).

    longestLineString := self displayedString:(newNumberOfLines max:99).
    textW := (longestLineString widthOn:self).
    requiredW := textW + self padding.

    ((requiredW > width) or:[requiredW < (width * 3 // 4)]) ifTrue:[
        "/ some hysteresis to avoid quick readjust again
        newWidth := (requiredW "* 1.1") rounded.
        self corner:(newWidth+1 @ 1.0).

        [
            textView removeDependent:self.
            textViewScroller notNil ifTrue:[ textViewScroller origin:(newWidth+1 @ 0.0) corner:(1.0 @ 1.0) ].
        ] ensure:[
            textView addDependent:self.
        ].
        self invalidate.
    ] ifFalse:[
        numberOfLines ~= newNumberOfLines ifTrue:[
            self invalidate
        ]
    ].
!

update:something with:aParameter from:changedObject
    |deltaY numPixels hScrollerHeight|

    (changedObject == textView) ifTrue:[
        ((something == #sizeOfContents)
        or:[ "false "(something == #visibility)"" ]) ifTrue:[
            self adjustSizeForLongestLine.

            "/ (numberOfLines ~= (textView list size max:textView cursorLine)) ifTrue:[
            "/     self invalidate.
            "/ ].
            ^ self.
        ].
        something == #originOfContents ifTrue:[
            aParameter notNil ifTrue:[
                deltaY := aParameter y.
                deltaY = 0 ifTrue:[^ self].

                numPixels := deltaY abs.
                numPixels < (height // 5) ifTrue:[
                    deltaY < 0 ifTrue:[
                        self invalidateX:0 y:0 width:width height:numPixels.
                    ] ifFalse:[
                        hScrollerHeight := 0.
                        (textViewScroller notNil
                        and:[textViewScroller horizontalScrollBar notNil]) ifTrue:[
                            hScrollerHeight := textViewScroller horizontalScrollBar height.
                        ].
                        numPixels := numPixels + 4.
                        self invalidateX:0 y:height-numPixels-hScrollerHeight width:width height:numPixels+hScrollerHeight.
                    ].
                    "/ self repairDamage.
                    ^ self.
                ].
            ].
            self invalidateLines.
            ^ self.
        ].
        "/ something printCR.
    ].

    (changedObject == textView reallyModifiedChannel) ifTrue:[
        self invalidateAcceptCancelBar.
        ^self.
    ].

    super update:something with:aParameter from:changedObject

    "Modified (format): / 15-07-2011 / 20:14:04 / cg"
    "Modified: / 14-02-2014 / 12:08:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::GutterView methodsFor:'event handling'!

buttonMultiPress: btn x: x y: y
    |extraSafeArea|

    Processor removeTimedBlock:blockWaitingForPossibleDoubleClick.
    blockWaitingForPossibleDoubleClick := nil.

    "/ for the embedded accept-cancel bar, if enabled
    (x <= (self paddingLeft + self usedWidthForAcceptCancel)) ifTrue:[
        textView reallyModified ifTrue:[
            (y < self acceptButtonBottom) ifTrue:[
                ^self.
            ].
            (y < self cancelButtonBottom) ifTrue:[
                ^self.            
            ].
        ].
        ^self.
    ].

    false ifTrue:[
        "Do not allow clicking on line numbers..."
        extraSafeArea := "('999' widthOn:self)" 5.
        x < (self width - self paddingRight - widthDiffInfo - extraSafeArea) ifFalse:[^ self].
    ].

    codeView notNil ifTrue:[
        ((x > (self paddingLeft + self usedWidthForAcceptCancel)) or:
            [x < (self width - self paddingRight - widthDiffInfo)]
        ) ifTrue:[
            (codeView buttonMultiPress: btn x:x y:y in: self) ifTrue:[^ self].   "/ event eaten
        ].
    ].
    super buttonMultiPress: btn x: x y: y
!

buttonPress: btn x: x y: y
    blockWaitingForPossibleDoubleClick :=
        [
            self nonMultiButtonPress: btn x: x y: y
        ].
    Processor 
        addTimedBlock:blockWaitingForPossibleDoubleClick 
        for:Processor activeProcess 
        afterMilliseconds:200.
!

nonMultiButtonPress: btn x: x y: y
    "this is now called delayed for a single button press
     (i.e. if there is not other click within some time)"

    |extraSafeArea|

    "/ for the embedded accept-cancel bar, if enabled
    (x <= (self paddingLeft + self usedWidthForAcceptCancel)) ifTrue:[
        textView reallyModified ifTrue:[
            (y < self acceptButtonBottom) ifTrue:[
                self accept.
                ^self.
            ].
            (y < self cancelButtonBottom) ifTrue:[
                self cancel.
                ^self.            
            ].
            self diff.
        ].
        ^self.
    ].

    false ifTrue:[
        "Do not allow clicking on line numbers..."
        extraSafeArea := "('999' widthOn:self)" 5.
        x < (self width - self paddingRight - widthDiffInfo - extraSafeArea) ifFalse:[^ self].
    ].

    codeView notNil ifTrue:[
        ((x > (self paddingLeft + self usedWidthForAcceptCancel)) or:
            [x < (self width - self paddingRight - widthDiffInfo)]
        ) ifTrue:[
            (codeView buttonPress: btn x:x y:y in: self) ifTrue:[^ self].   "/ event eaten
        ].
    ].

    "Created: / 17-06-2011 / 13:02:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 18-05-2012 / 10:56:54 / cg"
!

sizeChanged:how
    super sizeChanged:how.
    "/ self invalidateAcceptCancelBar.
    self invalidate.
    "Created: / 10-09-2013 / 03:19:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::GutterView methodsFor:'help'!

flyByHelpTextAt:aPointOrNil
    |lineNr textCollector services|

    codeView isNil ifTrue:[^ nil].
    aPointOrNil isNil ifTrue:[^ nil].
    
    lineNr := codeView lineAtY:aPointOrNil y.
    lineNr isNil ifTrue:[^ nil].
    
    textCollector := TextStream new.
    
    "/ which service has an annotation for that line
    services := codeView services.
    "/ show lintservice-help first
    services := (services select:[:s | s isLintService])
                ,(services reject:[:s | s isLintService]).
                
    services do:[:eachService |
        |tooltip|
        
        tooltip := eachService flyByHelpTextAtLine:lineNr.
        tooltip notEmptyOrNil ifTrue:[
            textCollector notEmpty ifTrue:[ textCollector cr].
            textCollector nextPutAllText:tooltip.
            tooltip last == Character cr ifFalse:[textCollector cr].
        ].
    ].
    textCollector isEmpty ifTrue:[ ^ nil ].
    ^ textCollector contents.    
! !

!CodeView2::GutterView methodsFor:'initialize & release'!

initialize

    super initialize.

    blockWaitingForPossibleDoubleClick := nil.

    showLineNumbers := true.
    widthAcceptCancel := 16.
    widthAnnotations := "16"8.
    widthDiffInfo := 5.

    UserPreferences current useColorsForColorBlindness ifTrue:[
        acceptColor := Color blue.
    ] ifFalse:[
        acceptColor := Color green.
    ].
    cancelColor := Color red.
    diffColor := Color yellow.

    acceptColor := acceptColor lighter onDevice:device.
    cancelColor := cancelColor lighter lighter onDevice:device.
    diffColor := diffColor lighter lighter onDevice:device.

    self enableMotionEvents.   "/ for per-line tooltips

    "Created: / 16-06-2011 / 13:47:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
    codeView removeDependent: self.  
    textView removeDependent: self.
    currentBlockNodeHolder notNil ifTrue:[
        currentBlockNodeHolder removeDependent: self
    ].
    super release.

    "Created: / 23-06-2014 / 20:47:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setCodeView: aCodeView2

    codeView := aCodeView2.

    codeView addDependent: self.
    codeView reallyModifiedChannel addDependent: self.
    "/ codeView currentBlockNodeHolder addDependent: self. - not needed; currentBlockNodeHolder: does it

    textView := aCodeView2 textView.
    textView addDependent: self.
    "/ do not fetch stuff from others - let others give me things (caller change to send currentBlockNodeHolder: explicitly)
    "/ self currentBlockNodeHolder: codeView currentBlockNodeHolder.
    textViewScroller := aCodeView2 textViewScroller.
    "/ self backgroundPaint: (textView viewBackground "backgroundPaint" blendWith: (Color gray:80)).
    self viewBackground: (View defaultBackgroundColor).

    "Created: / 14-02-2010 / 15:19:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-08-2011 / 15:15:55 / cg"
    "Modified: / 05-04-2012 / 17:46:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::GutterView methodsFor:'queries'!

displayedString: line
    "get text to display in gutter for specified list line number"

    ^(line asString).

    "Created: / 14-12-2009 / 13:37:47 / Jindra <a>"
!

lineColorForLine:line
    "return special color for given line if required, nil otherwise"
    "used only if lineFont returns nil"

    ^nil

    "Created: / 14-12-2009 / 15:01:31 / Jindra <a>"
!

lineDisplayable:line
    "true if this list line can be displayed"
    ^(textView listLineIsVisible:line)

    "Created: / 14-12-2009 / 13:38:23 / Jindra <a>"
!

lineFontForLine:line
    "return special font for given line if required, nil otherwise"

    ^nil

    "Created: / 14-12-2009 / 14:40:17 / Jindra <a>"
!

wantsFocusWithButtonPress
    ^ false.
!

yOfTextViewLine:lineNr
    "defined to allow computation of a line below what is visible in
     the textView (because gutter may become higher than textView, iff
     the textView has a horizontal scrollbar"

    |visibleLineNr "{ Class: SmallInteger }"|

    "/JV: BAD, BAD BAD - check senders, they are not prepared
    "/    to get nil!!
    shown ifFalse:[^ nil].
    lineNr isNil ifTrue:[^ nil].
    visibleLineNr := lineNr - textView firstLineShown + 1.
    ^ textView yOfVisibleLine:visibleLineNr

    "Modified (format): / 28-08-2013 / 12:49:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::GutterView methodsFor:'redrawing'!

invalidateAcceptCancelBar
    | w |

    self usedWidthForAcceptCancel == 0 ifTrue:[^ self].
    w := self acceptCancelRight.
    w == 0 ifTrue:[ ^ self ].

    self
        invalidateX: 0
                  y: 0
              width: w
             height: self height.

    "Created: / 10-09-2013 / 03:07:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2016 / 20:05:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidateDeviceRectangle:aRectangle repairNow:doRepairNow
    ^ super invalidateDeviceRectangle:aRectangle repairNow:doRepairNow
!

invalidateLines

    | x0 |
    x0 := self acceptCancelRight "+ 1".
    self
        invalidateX: x0
                  y: 0
              width: self width - x0
             height: self height.

    "Created: / 10-09-2013 / 03:08:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-02-2014 / 12:19:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawAcceptCancelBarX: x y: y width:w height:h

    | rw acceptRight acceptBottom cancelBottom |

    acceptRight := self acceptCancelRight.
    x >= acceptRight ifTrue:[
        ^self.
    ].
    rw := ((x + w) min: acceptRight) - x.


    textView reallyModified ifFalse:[
        gc fillRectangleX:x y:y width:rw height:h color: self viewBackground
    ] ifTrue:[
        acceptBottom := self acceptButtonBottom.
        cancelBottom := self cancelButtonBottom.
        y < acceptBottom ifTrue:[
            gc fillRectangleX:x y:y width:rw height: ((y + h) min: acceptBottom) color: acceptColor.
        ].
        (y < cancelBottom) ifTrue:[
            gc fillRectangleX:x y: acceptBottom + 1width:rw height: ((y + h) min: cancelBottom) - acceptBottom - 1color: cancelColor.
        ].
        (y + h >= cancelBottom) ifTrue:[
            gc fillRectangleX:x y: cancelBottom + 1 width:rw height: (y + h) - cancelBottom - 1 color: diffColor.
        ]

    ]

    "Created: / 07-10-2011 / 19:44:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 22-02-2016 / 20:09:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawBackgroundX:x y:y width:w height:h
    "redraws gutter background"

    |savPaint|

    "background is filled with background color"
    self 
        clearRectangleX:x
        y:y
        width:w
        height:h. 

    "separator line is drawn in grey"
    savPaint := self paint.
    self paint:Color grey.

    self 
        displayLineFromX:(width - 1)
        y:y
        toX:(width - 1)
        y:(y+h).

    self paint:savPaint.

    "Created: / 14-12-2009 / 13:15:53 / Jindra <a>"
    "Modified: / 14-12-2009 / 15:09:54 / Jindra <a>"
    "Modified: / 17-08-2011 / 15:12:47 / cg"
    "Modified (comment): / 07-10-2011 / 19:37:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawLine:line 

    ^self redrawLine:line cleared: false.

    "Modified: / 17-06-2011 / 14:12:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawLine:line cleared: cleared
    "redraws specified line. Returns width of drawn object. Color of drawn objects should be taken from lineFont, lineColor"
    
    ^ self redrawLine:line cleared:cleared drawServices:true
!

redrawLine:line cleared:cleared drawServices:drawServices
    "redraws specified line. Returns width of drawn object.
     Color of drawn objects should be taken from lineFont, lineColor"

    |lineString yTop yBaseline textViewFont fontAscent fontDescent
     textW requiredW oldFont newFont oldColor newColor 
     myFont myFontAscent myFontDescent|

    shown ifFalse:[ ^ self ]. "/ Do not bother if the view is not shown.
    textView isNil ifTrue:[^ self].     "/ happens when shown in UIPainter
        
    requiredW := self width.
    myFont := gc font.
    textViewFont := textView font.
    
    showLineNumbers ifTrue:[
        lineString := self displayedString:line.

        textW := (lineString widthOn:self).
        requiredW := textW + self padding.

        oldFont := myFont.
        oldColor := gc paint.

        newFont := self lineFontForLine:line.
        newFont isNil ifTrue:[
            newFont := oldFont.
            newColor := self lineColorForLine:line.
            newColor notNil ifTrue:[ gc paint:newColor ].
        ].
        newFont ~~ oldFont ifTrue:[
            "/ ensure that the line number lines are not higher than the text lines
            (newFont heightOn:device) > (textViewFont heightOn:device) ifTrue:[
                newFont := textViewFont.
            ].
            newFont ~~ oldFont ifTrue:[
                self font:newFont.
                myFont := gc font.
            ].
        ].
    ].

    fontAscent := textViewFont ascentOn:device.
    fontDescent := textViewFont descentOn:device.
    myFontAscent := myFont ascent.
    myFontDescent := myFont descent.
    
    yTop := (self yOfTextViewLine:line) ? 0.
    yBaseline := yTop + fontAscent.

    cleared ifFalse:[
        gc 
            clearRectangleX:0 y:(yBaseline - myFontAscent) 
            width:(width - 2) height:(myFontAscent + myFontDescent).
    ].

    "/ cg: this should be done differently: services know about the
    "/ gutter, so they should respond to a special drawGutter message.
    "/ otherwise, some redraws become unusably slow (especially
    "/ with multiple fonts/colors/emphases)...
    drawServices ifTrue:[
        "Let services draw annotations and other stuff"
        codeView notNil ifTrue:[
            codeView
                drawLine:line in:self
                atX:(self acceptCancelRight + 1) y:yBaseline 
                width:widthAnnotations height:(myFont height) ascent:myFontAscent
                from:nil to:nil with:(self paint) and:(self backgroundColor).
        ]
    ].

    showLineNumbers ifTrue:[
        gc displayString:lineString x:(width - widthDiffInfo - textW) y:yBaseline.
        newFont notNil ifTrue:[
            gc font:oldFont.
            gc paint:oldColor
        ] ifFalse:[
            newColor notNil ifTrue:[ gc paint:oldColor ].
        ].
    ].

    "/ If the view has been cleared here, we have also to redraw corresponding portion
    "/ of accept/cancel bar !!
    cleared ifFalse:[
        "/ In that case it was cleared above.
        self redrawAcceptCancelBarX:0 y:(yBaseline - myFontAscent)
             width:width - 2
             height:(myFontAscent + myFontDescent).
    ].
    ^ requiredW.

    "Modified: / 14-12-2009 / 15:30:44 / Jindra <a>"
    "Created: / 17-06-2011 / 14:11:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-07-2012 / 19:05:24 / cg"
    "Modified: / 14-02-2014 / 17:58:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawLinesFrom:start
    "/ cg: obsolete?
    start to: (textView lastLineShown - 1 min: textView list size) do:[:line|
        self redrawLine:line cleared:false drawServices:true.
    ]

    "Created: / 06-07-2011 / 17:25:36 / jv"
    "Modified: / 12-07-2011 / 17:14:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawVisibleLine:line 
    |absLine|

    (absLine := textView visibleLineToListLine:line) notNil ifTrue:[
        self redrawLine:absLine cleared: false.
    ].

    "Modified: / 17-06-2011 / 14:12:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawX:x y:y width:w height:h
    |firstLine lastLine yBot|

    self redrawBackgroundX:x y:y width:w height:h.

    (codeView notNil and:[codeView showAcceptCancelBar]) ifTrue:[    
        self redrawAcceptCancelBarX:x y:y width:w height:h.
    ].

    "/ textview may be nil, if Gutter is shown in the UIPainter!!
    textView notNil ifTrue:[
        numberOfLines := (textView list size max:textView cursorLine).
        yBot := y + h.
        firstLine := textView visibleLineToAbsoluteLine:(textView visibleLineOfY:y).
        lastLine := textView visibleLineToAbsoluteLine:(textView visibleLineOfY:yBot-1).
        lastLine := lastLine min:numberOfLines.

        firstLine to:lastLine do: [:line | 
            self redrawLine:line cleared:true drawServices:true.
        ].
    ]
! !

!CodeView2::TextView methodsFor:'accessing'!

changedDiffText
    ^ changedDiffText
!

changedDiffText:something
    changedDiffText := something.
!

changedLines
    ^ changedLines

    "Created: / 26-04-2010 / 20:30:32 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 26-04-2010 / 21:48:13 / Jakub <zelenja7@fel.cvut.cz>"
!

changedLines:something 
    changedLines := something.

    "Created: / 26-04-2010 / 20:30:19 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 02-05-2010 / 19:13:32 / Jakub <zelenja7@fel.cvut.cz>"
!

codeView
    ^ codeView
!

contents: text

    super contents: text.
    reallyModifiedChannel value: false.

    "Created: / 07-10-2011 / 20:32:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

contents: text clear: clearPrevious

    | savedListOriginal |
    savedListOriginal := listOriginal.
    super contents: text.
    listOriginal := savedListOriginal.
    self updateReallyModified.

    "Created: / 17-02-2012 / 00:35:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

deletedLines
    ^  deletedLines

    "Modified: / 26-04-2010 / 21:48:23 / Jakub <zelenja7@fel.cvut.cz>"
!

deletedLines:something 
    deletedLines := something.

    "Modified: / 26-04-2010 / 21:48:54 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified (format): / 17-07-2012 / 18:56:44 / cg"
!

diffMode
    ^ diffMode
!

diffMode:something
    diffMode := something.
!

emptyLines
    ^ emptyLines
!

emptyLines:something
    emptyLines := something.
!

fontAscent
    ^fontAscent notNil ifTrue:[fontAscent] ifFalse:[super fontAscent]

    "Created: / 19-05-2012 / 14:13:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

insertedLines
    ^  insertedLines

    "Modified: / 26-04-2010 / 21:48:27 / Jakub <zelenja7@fel.cvut.cz>"
!

insertedLines:something 
    insertedLines := something.

    "Modified: / 26-04-2010 / 21:48:59 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified (format): / 17-07-2012 / 18:56:50 / cg"
!

modifiedChannel: aValueHolder

    super modifiedChannel: aValueHolder

    "Created: / 07-07-2011 / 12:27:11 / Jan Vrany <jan.vrant@fit.cvut,cz>"
!

originDiffText
    ^ originDiffText
!

originDiffText:something
    originDiffText := something.
!

reallyModified

    ^self reallyModifiedChannel value

    "Created: / 07-10-2011 / 19:28:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'accessing-colors'!

colorChanged
    ^ Color redByte:240 greenByte: 192 blueByte: 192

    "Modified: / 24-06-2010 / 14:05:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

colorDeleted
    ^ self colorInserted.
    "/^ Color pink

    "Modified: / 24-06-2010 / 14:16:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 07-10-2011 / 20:26:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 17-07-2012 / 18:57:14 / cg"
!

colorInserted
    ^ Color redByte: 239 greenByte: 225 blueByte: 152

    "Modified: / 24-06-2010 / 14:13:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'accessing-contents'!

list:aCollection expandTabs:expand scanForNonStrings:scan includesNonStrings:nonStrings

    super list:aCollection expandTabs:expand scanForNonStrings:scan includesNonStrings:nonStrings.

    listOriginal := aCollection copy.
    reallyModifiedChannel value: false.

    "/JV: used to be notifyLines... but that method
    "/    leaves suppressNotifications to true, which is not what
    "/    we want!!
    self updateReallyModified.
    codeView linesModifiedFrom: 1 to: list size.

    "Created: / 08-10-2011 / 12:23:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-08-2013 / 13:35:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setList:aCollection expandTabs:expandTabs redraw:doRedraw

    super setList:aCollection expandTabs:expandTabs redraw:doRedraw.
    listOriginal := aCollection copy.
    reallyModifiedChannel value: false.

    "/JV: used to be notifyLines... but that method
    "/    leaves suppressNotifications to true, which is not what
    "/    we want!!
    self updateReallyModified.
    codeView linesModifiedFrom: 1 to: list size.

    "Created: / 07-10-2011 / 18:42:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 03-08-2013 / 13:35:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'accessing-look'!

lineSpacing

    ^lineSpacing

    "Modified: / 22-05-1996 / 12:22:29 / cg"
    "Created: / 19-03-2012 / 13:22:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'accessing-state'!

beUnmodified

    self modifiedChannel value: false.
    reallyModifiedChannel value: false.
    listOriginal := list copy.

    "Created: / 08-10-2011 / 12:51:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isModified

    ^self modified

    "Created: / 08-10-2011 / 12:52:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isReallyModified

    ^self reallyModified

    "Created: / 08-10-2011 / 12:52:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'bit blitting'!

copyFrom:aDrawable x:srcX y:srcY toX:dstX y:dstY width:w height:h async:async

    "/ If doing a vertical scroll, optimized Gutter redraw by
    "/ copying gutter's image...
    (scrollInProgress and:[aDrawable == self]) ifTrue:[
        "/ Vertical scroll?
        ((srcY ~= dstY) and:[srcX = dstX]) ifTrue:[
            "/ Do copy in gutter, but not accept-cancel bar!!
            | x0 |

            x0 := gutterView acceptCancelRight.
            gutterView
                copyFrom:gutterView
                       x:x0
                       y:srcY
                     toX:x0
                       y:dstY
                   width:(gutterView width - x0)
                  height:h
                   async:false
        ]
    ].
    ^ super
        copyFrom:aDrawable x:srcX y:srcY toX:dstX y:dstY width:w height:h async:async

    "Modified: / 14-02-2014 / 10:15:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'channels'!

reallyModifiedChannel
    "return the valueHolder holding true if text was really modified.
     This is different from #modified, as the inherited modified flag is cleared
     to trigger another change notification with every keystroke (for the syntaxHighighter).
     This may be (now) considered a very bad hack"

    ^ reallyModifiedChannel

    "Created: / 07-10-2011 / 18:50:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reallyModifiedChannel: aValueModel

    |prev|

    prev := reallyModifiedChannel.
    prev notNil ifTrue:[
        gutterView notNil ifTrue:[
            reallyModifiedChannel removeDependent: gutterView.
        ]
    ].
    reallyModifiedChannel := aValueModel.
    self setupChannel:aValueModel for:nil withOld:prev.
    gutterView notNil ifTrue:[
        reallyModifiedChannel addDependent: gutterView.
    ]

    "Created: / 07-10-2011 / 18:50:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'delegation-events'!

isQuickMenuModifierPressed
    UserPreferences current codeView2QuickSendersAndImplementorsOnControl ifTrue:[
        ^ self sensor ctrlDown
    ].
    ^ self sensor metaDown
!

isQuickMenuModifierReleased
    UserPreferences current codeView2QuickSendersAndImplementorsOnControl ifTrue:[
        ^ self sensor ctrlDown not
    ].
    ^ self sensor metaDown not
! !

!CodeView2::TextView methodsFor:'drawing'!

backgroundForVisibleLine:visLineNr default:bg
    | lineNr |


    diffMode ifTrue:[
        lineNr := self visibleLineToListLine:visLineNr.
        (insertedLines notEmptyOrNil and:[insertedLines includes:lineNr]) ifTrue:[
            ^self colorInserted
        ].
        (changedLines notEmptyOrNil and:[changedLines includes:lineNr]) ifTrue:[
            ^self colorChanged
        ].
        (deletedLines notEmptyOrNil and:[deletedLines includes:lineNr]) ifTrue:[
            ^self colorDeleted
        ].
    ].
    ^ bg

    "Modified: / 17-03-2012 / 12:22:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawFromVisibleLine:startVisLineNr to:endVisLineNr with:fg and:bg
    "draw a visible line range in fg/bg"

    diffMode ifFalse:[
        super drawFromVisibleLine:startVisLineNr to:endVisLineNr with:fg and:bg.
        ^self.
    ].

    startVisLineNr to: endVisLineNr do:[:visLineNr|
        self drawVisibleLine: visLineNr with:fg and:bg
    ]

    "Modified: / 15-12-1999 / 23:19:39 / cg"
    "Created: / 17-03-2012 / 09:44:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawLine:line fromX:x inVisible:visLineNr with:fg and:bg
    super
        drawLine:line
        fromX:x
        inVisible:visLineNr
        with:fg
        and:(self backgroundForVisibleLine:visLineNr default:bg).

    "Created: / 05-04-2010 / 12:07:07 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 02-05-2010 / 18:46:00 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2012 / 10:05:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawLine:lineStringArg inVisible:visLineNr col:col with:fg and:bg
    super
        drawLine:lineStringArg
        inVisible:visLineNr
        col:col
        with:fg
        and:(self backgroundForVisibleLine:visLineNr default:bg).

    "Created: / 05-04-2010 / 11:49:42 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 02-05-2010 / 18:45:56 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2012 / 10:04:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawLine:lineStringArg inVisible:visLineNr from:startCol to:endColOrNil with:fg and:bg
    super
        drawLine:lineStringArg
        inVisible:visLineNr
        from:startCol
        to:endColOrNil
        with:fg
        and:(self backgroundForVisibleLine:visLineNr default:bg).

    "Created: / 05-04-2010 / 11:54:54 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 02-05-2010 / 18:45:52 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2012 / 10:04:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawLine:lineString inVisible:visLineNr from:startCol with:fg and:bg
    super
        drawLine:lineString
        inVisible:visLineNr
        from:startCol
        with:fg
        and:(self backgroundForVisibleLine:visLineNr default:bg).

    "Created: / 05-04-2010 / 11:54:26 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 02-05-2010 / 18:45:48 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2012 / 10:04:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

drawVisibleLine:visLineNr with:fg and:bg
    super
        drawVisibleLine:visLineNr
        with:fg
        and:(self backgroundForVisibleLine:visLineNr default:bg).

    "Created: / 05-04-2010 / 11:49:42 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 02-05-2010 / 18:45:44 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2012 / 10:04:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'editing'!

contentsChanged
    "this one is sent, whenever contents changes its size"

    super contentsChanged.

"/    codeView diffMode ifTrue:[
"/        changedDiffText ifTrue:[
"/            codeView recomputeDiff:self.
"/        ] ifFalse:[
"/            changedDiffText := true.
"/        ].  
"/    ]


    "Created: / 22-06-2010 / 23:13:24 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 01-08-2010 / 20:33:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getNewOriginText
    |i size pole pom text helperText|

    i := 1.
    pole := list.
    size := list size.
    text:=''.
    emptyLines isNil ifTrue:[emptyLines := #()].
    [ i <= size ] whileTrue:[
        pom := emptyLines indexOf:i.
        (pom = 0) ifFalse:[
            helperText := pole at:i.
            (helperText = '') ifFalse:[
                (helperText isNil)ifTrue:[helperText:=''].
                helperText:=helperText,Character cr.
                text := text asString , helperText asString.
            ].
        ] ifTrue:[
            helperText := pole at:i.
            (helperText isNil)ifTrue:[helperText:=''].
            helperText:=helperText,Character cr.
            text := text asString , helperText asString.
        ].
    i:=i+1.
    ].
^text

    "Created: / 22-06-2010 / 22:33:27 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 24-06-2010 / 14:27:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-11-2011 / 14:58:22 / cg"
! !

!CodeView2::TextView methodsFor:'editing-basic'!

basicDeleteCharsAtLine:lineNr fromCol:startCol toCol:endCol
    "delete characters from startCol to endCol in line lineNr"

    super basicDeleteCharsAtLine:lineNr fromCol:startCol toCol:endCol.
    self notifyLinesModifiedFrom: lineNr to: lineNr.

    "Created: / 16-09-2011 / 15:13:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicDeleteFromLine:startLineNr toLine:endLineNr 

    super basicDeleteFromLine:startLineNr toLine:endLineNr.
    self notifyLinesDeletedFrom:startLineNr to:endLineNr.

    "Created: / 28-06-2011 / 09:09:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicDeleteLineWithoutRedraw:lineNr

    super basicDeleteLineWithoutRedraw:lineNr.
    self notifyLinesDeletedFrom: lineNr to: lineNr.

    "Created: / 28-06-2011 / 09:10:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicInsert:aCharacter atLine:lineNr col:colNr
    "insert a single character at lineNr/colNr;
     set emphasis to character at current position"

    super basicInsert:aCharacter atLine:lineNr col:colNr.
    self notifyLinesModifiedFrom: lineNr to: lineNr.

    "Created: / 16-09-2011 / 15:14:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicMergeLine:lineNr removeBlanks:removeBlanks

    super basicMergeLine:lineNr removeBlanks:removeBlanks.
    self notifyLinesDeletedFrom: lineNr + 1 to: lineNr + 1.

    "Created: / 28-06-2011 / 09:13:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicSplitLine:lineNr before:colNr

    super basicSplitLine:lineNr before:colNr.
    self notifyLinesInsertedFrom: lineNr +1 to: lineNr + 1.

    "Created: / 28-06-2011 / 09:14:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

basicWithoutRedrawInsertLines:lines from:start to:end before:lineNr
    super basicWithoutRedrawInsertLines:lines from:start to:end before:lineNr.
    self updateReallyModified.
!

basicWithoutRedrawInsertStringWithoutCRs:aString atLine:lineNr col:colNr
    super basicWithoutRedrawInsertStringWithoutCRs:aString atLine:lineNr col:colNr.
    self updateReallyModified.
! !

!CodeView2::TextView methodsFor:'event handling'!

buttonMotion:button x:x y:y

    (codeView buttonMotion:button x:x y:y in: self) ifFalse:[
        super buttonMotion:button x:x y:y
    ].

    "Created: / 14-02-2010 / 16:23:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2010 / 20:10:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buttonPress: button x: x y: y
    | ctrlDown  |

    (codeView buttonPress:button x:x y:y in: self)
        ifFalse:[super buttonPress:button x:x y:y].
    "
    ((ctrlDown := self sensor ctrlDown) and: [ codeView syntaxElementSelection notNil]) 
        ifTrue: [codeView buttonPressInTextView: button x:x y:y ctrlDown: ctrlDown].
    super 
        buttonPress: button
        x: x
        y: y
    "

    "Created: / 14-02-2010 / 18:12:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2010 / 20:37:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

buttonRelease: button x: x y: y
    (codeView buttonRelease:button x:x y:y in: self)
        ifFalse:[super buttonRelease:button x:x y:y].
!

keyPress:key x:x y:y
    (codeView keyPress:key x:x y:y in: self)
        ifFalse:[super keyPress:key x:x y:y].

    "Modified: / 06-03-2010 / 20:34:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-04-2010 / 09:55:52 / Jakub <zelenja7@fel.cvut.cz>"
!

keyRelease: key x: x y: y

    (codeView keyRelease:key x:x y:y in: self)
        ifFalse:[super keyRelease:key x:x y:y].
    "
    (key = #Control_L) ifTrue:
        [ codeView highlightClear. self redraw ].

    ^ super 
        keyRelease: key
        x: x
        y: y
    "

    "Created: / 14-02-2010 / 16:38:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-03-2010 / 21:04:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'formatting'!

leftIndentForLine:lineNr

    | lang |
    lang := codeView language.
    "Bit hacky here, should ask language some language toolbox
    for formatting helper, that should do it..."
    (lang notNil and:[lang isSmalltalk]) ifTrue:[
        | line lineNo indent |
        lineNo := lineNr.
        [lineNo ~~ 1] whileTrue:[
            lineNo  := lineNo - 1.
            line := self listAt:lineNo.

            line notNil ifTrue:[
                indent := line indexOfNonSeparatorStartingAt:1.
                "beggining od block"
                line notEmptyOrNil ifTrue:[
                    | lastCharIndex lastChar |

                    lastCharIndex := line size.
                    lastChar := nil.
                    [ lastCharIndex > 0 ] whileTrue:[
                        (lastChar := line at: lastCharIndex) isSeparator ifTrue:[ 
                            lastCharIndex := lastCharIndex - 1.
                        ] ifFalse:[ 
                            lastCharIndex := -2. "/ To terminate the loop.
                        ].
                    ].
                    lastCharIndex == -2 ifTrue:[
                        lastChar == $[ ifTrue:[
                            indent := indent + 4.
                        ] ifFalse:[
                            "end of block args"
                            (lastChar == $| and: [line includes: $[]) ifTrue:[
                                indent := indent + 4.
                            ]
                        ].
                    ].
                ].
                indent ~~ 0 ifTrue:[
                    ^ indent - 1
                ]
            ]
        ].
        ^0.
    ].
    ^super leftIndentForLine:lineNr

    "Created: / 10-12-2011 / 11:02:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-07-2014 / 09:38:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'initialization'!

initialize

    super initialize.

    changedDiffText := true.
    diffMode := false.
    suppressNotifications := false.
    reallyModifiedChannel := false asValue.
    scrollInProgress := false.

    self enableMotionEvents.

    "Created: / 23-06-2010 / 17:28:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-07-2011 / 17:46:31 / jv"
    "Modified: / 21-08-2011 / 10:09:29 / cg"
    "Modified: / 14-02-2014 / 10:31:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setCodeView: aCodeView2

    codeView := aCodeView2.
    codeView addDependent: self.
    gutterView := aCodeView2 gutterView.

    "Created: / 14-02-2010 / 15:22:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-06-2011 / 12:43:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setGutterView: aGutterView

    self assert: gutterView isNil message:'Attempting to set gutterView twice'.
    gutterView := aGutterView.
    gutterView setTextView: self.

    "Created: / 02-09-2009 / 21:57:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'menu & menu actions'!

accept

    super accept.
    reallyModifiedChannel value: false.
    listOriginal := list copy.

    "Created: / 07-10-2011 / 19:36:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

cancel

    self list: listOriginal

    "Created: / 08-02-2010 / 09:29:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editMenu

    ^ codeView editMenu

    "Created: / 14-02-2010 / 15:49:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 08-03-2012 / 12:30:22 / cg"
!

searchVariableVisible
    "search variable option in searchbox visible?"

    ^ true

    "Created: / 08-03-2012 / 14:01:51 / cg"
! !

!CodeView2::TextView methodsFor:'notification'!

notifyLinesDeletedFrom: startLine to: endLine

    self updateReallyModified.
    suppressNotifications ifTrue:[^self].
    codeView linesDeletedFrom: startLine to: endLine.
    suppressNotifications := true.

    "Created: / 28-06-2011 / 09:12:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-07-2011 / 17:47:05 / jv"
    "Modified: / 07-10-2011 / 19:20:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notifyLinesInsertedFrom: startLine to: endLine

    self updateReallyModified.
    suppressNotifications ifTrue:[^self].
    codeView linesInsertedFrom: startLine to: endLine.
    suppressNotifications := true.

    "Created: / 28-06-2011 / 09:12:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-07-2011 / 17:47:20 / jv"
    "Modified: / 07-10-2011 / 19:20:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

notifyLinesModifiedFrom: startLine to: endLine

    self updateReallyModified.
    suppressNotifications ifTrue:[^self].
    codeView linesModifiedFrom: startLine to: endLine.
    suppressNotifications := true.

    "Modified: / 06-07-2011 / 17:47:20 / jv"
    "Created: / 16-09-2011 / 15:12:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'private'!

isTextDifferentFromOriginalSource
    "check for modified code by comparing the source against
     the codeViews contents.
     That's the true modified value 
     (in case user undid his changes, and the displayed text is actually original)"

    |different changedSource originalSource 
     lastLineOfChangedSource lastLineOfOriginalSource
     originalL changedL checkIfDifferent|

    "/ possibly call at higher prio to prevent it from being changed while we convert it (by editing)

    different := false.

    "/ cg: don't do that (collecting original/changedSource); 
    "/ for huge files (>8Mb), this makes editing annoying slow (editing a trace output, for example)
"/        changedSource := list ? #().
"/        changedSource := changedSource collect:[:line | line isEmptyOrNil ifTrue:[nil] ifFalse:[line]].
"/        [changedSource size > 0 and:[changedSource last isNil]] whileTrue:[
"/            changedSource := changedSource removeLast.
"/        ].
"/
"/        originalSource := listOriginal ? #() "self model value ? ''".
"/        originalSource := originalSource collect:[:line | line isEmptyOrNil ifTrue:[nil] ifFalse:[line]].
"/        [originalSource size > 0 and:[originalSource last isNil]] whileTrue:[
"/            originalSource := originalSource removeLast
"/        ].
"/        originalSource size ~~ changedSource size ifTrue:[
"/            modified := true.
"/        ] ifFalse:[
"/            | i stopIndex |
"/
"/            i := 1.
"/            stopIndex := originalSource size + 1.            
"/            [ modified not and:[ i < stopIndex ] ] whileTrue:[
"/                | originalL changedL |
"/
"/                originalL := ((originalSource at: i) ? '') string.
"/                changedL :=  ((changedSource  at: i) ? '') string.                
"/                originalL ~= changedL ifTrue:[
"/                    originalL withoutTrailingSeparators ~= changedL withoutTrailingSeparators ifTrue:[
"/                        modified := true.
"/                    ]
"/                ].
"/                i := i + 1.
"/            ]
"/        ].

    list size ~~ listOriginal size ifTrue:[
        ^ true
    ].

    "/ instead, do everything without collecting a new stringcollection.
    changedSource := list ? #().
    lastLineOfChangedSource := changedSource size.
    [lastLineOfChangedSource > 0 and:[(changedSource at:lastLineOfChangedSource) isEmptyOrNil]] whileTrue:[
        lastLineOfChangedSource := lastLineOfChangedSource - 1.
    ].        
    originalSource := listOriginal ? #().
    lastLineOfOriginalSource := originalSource size.
    [lastLineOfOriginalSource > 0 and:[(originalSource at:lastLineOfOriginalSource) isEmptyOrNil]] whileTrue:[
        lastLineOfOriginalSource := lastLineOfOriginalSource - 1.
    ].        

    lastLineOfOriginalSource ~~ lastLineOfChangedSource ifTrue:[
        ^ true.
    ].

    checkIfDifferent :=
        [:lNr |

            lNr > originalSource size ifTrue:[
                originalL := ''.
            ] ifFalse:[
                originalL := ((originalSource at: lNr) ? '') string.
            ].
            lNr > changedSource size ifTrue:[
                changedL := ''.
            ] ifFalse:[
                changedL :=  ((changedSource at: lNr) ? '') string.                
            ].
            originalL ~= changedL ifTrue:[
                originalL withoutTrailingSeparators ~= changedL withoutTrailingSeparators ifTrue:[
                    ^ true.
                ]
            ].
        ].

    "/ do a quick check in the cursor line. This is most likely to be different
    "/ saves comparing all the rest in 99% of cases (while typing)
    (cursorLine notNil and:[cursorLine > 0]) ifTrue:[
        checkIfDifferent value:cursorLine.
    ].

    1 to:lastLineOfOriginalSource do:checkIfDifferent.
    ^ false

    "Modified: / 07-07-2014 / 11:11:57 / jv"
!

superEditMenu

    ^super editMenu

    "Created: / 14-02-2010 / 15:48:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

updateReallyModified
    "check for modified code by comparing the source against
     the codeViews contents.
     That's the true modified value (in case user undid its changes,
     and the displayed text is actually original"

    |modified|

    reallyModifiedChannel isNil ifTrue:[^self].

    "/ JV@2011-10-27: Idea is not to do anything if nobody is interested
    reallyModifiedChannel dependents isEmptyOrNil ifTrue:[^self].
    modified := self isTextDifferentFromOriginalSource.

    reallyModifiedChannel value: modified

    "Created: / 07-10-2011 / 19:16:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 08-10-2011 / 11:10:01 / cg"
    "Modified: / 28-10-2011 / 09:23:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 12-01-2017 / 22:45:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'queries'!

editedClass
    |cls|

    (cls := codeView classHolder value) notNil ifTrue:[
        ^ cls
    ].
    ^ super editedClass
!

editedMethod
    |cls|

    (cls := codeView methodHolder value) notNil ifTrue:[
        ^ cls
    ].
    ^ super editedMethod
!

supportsSyntaxElements
    "syntax elements are a byproduct of the syntax highlighter;
     it is a list of elements, which chain together same-named variables
     and parts of a keyword message's selector.
     These allow for quick forward/backward navigation to the next/prev. occurrence
     of a variable. Be aware that the implementation is buggy, in that it does not
     deal correctly with same-named blockvars of different blocks"

    ^ true
!

syntaxElementAtPosition:position
    "is there is a syntax element at position?
     If so, return the element; otherwise, return nil"

    |syntaxElements el|

    syntaxElements := codeView syntaxElements.
    syntaxElements isEmptyOrNil ifTrue:[^ nil].
    el := syntaxElements detect:[:el | position between:el start and:el stop] ifNone:nil.
    el isNil ifTrue:[^ nil].
    ^ el.

    "Created: / 08-03-2012 / 14:21:52 / cg"
!

syntaxElementForSelectedVariable
    "is there is a syntax element for a variable under the cursor?
     If so, return the element; otherwise, return nil"

    |element startPosition endPosition|

    self selectionAsString isEmptyOrNil ifTrue:[
        "/ ^ nil.
        element := self syntaxElementForVariableUnderCursor.
    ] ifFalse:[
        startPosition := self characterPositionOfLine:selectionStartLine col:selectionStartCol.
        endPosition := self characterPositionOfLine:selectionEndLine col:selectionEndCol.
        element := self syntaxElementAtPosition:startPosition.
    ].
    element isNil ifTrue:[^ nil].
    (element start = startPosition and:[element stop = endPosition]) ifFalse:[^ nil].

    element isNil ifTrue:[^ nil].
    element isVariableOrSelf ifFalse:[^ nil].
    ^ element

    "Created: / 08-03-2012 / 14:21:15 / cg"
!

syntaxElementForSelectorUnderCursor
    "is there is a syntax element for a message selector under the cursor?
     If so, return the element; otherwise, return nil"

    |elementUnderCursor |

    elementUnderCursor := self syntaxElementUnderCursor.
    elementUnderCursor isNil ifTrue:[^ nil].
    elementUnderCursor isSelector ifFalse:[^ nil].
    ^ elementUnderCursor.

    "Created: / 08-03-2012 / 12:44:03 / cg"
!

syntaxElementForVariableUnderCursor
    "is there is a syntax element for a variable under the cursor?
     If so, return the element; otherwise, return nil"

    |elementUnderCursor |

    elementUnderCursor := self syntaxElementUnderCursor.
    elementUnderCursor isNil ifTrue:[^ nil].
    elementUnderCursor isVariableOrSelf ifFalse:[^ nil].
    ^ elementUnderCursor.

    "Created: / 08-03-2012 / 12:44:03 / cg"
!

syntaxElementUnderCursor
    "is there is a syntax element under the cursor?
     If so, return the element; otherwise, return nil"

    ^ self syntaxElementAtPosition:(self characterPositionOfCursor).
! !

!CodeView2::TextView methodsFor:'scrolling'!

basicScrollTo:anOrigin redraw:doRedraw
    | savedScrollIProgress |

    savedScrollIProgress := scrollInProgress. 
    scrollInProgress := true.
    [
        super scrollTo:anOrigin redraw:doRedraw
    ] ensure:[ 
        scrollInProgress := savedScrollIProgress. 
    ].
    "Modified: / 14-02-2014 / 10:12:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

originChanged:delta

    super originChanged:delta.

    "/ gutterView invalidate.

    "Created: / 07-12-2009 / 21:50:49 / Jindra <a>"
!

scrollTo:anOrigin redraw:doRedraw

    codeView scrollTo:anOrigin redraw:doRedraw in: self.
    self basicScrollTo:anOrigin redraw:doRedraw

    "Modified: / 06-04-2010 / 14:04:28 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2012 / 10:06:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Created: / 19-03-2012 / 17:05:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CodeView2::TextView methodsFor:'undo & again'!

nonUndoableDo: aBlock

    super nonUndoableDo: aBlock.
    suppressNotifications := false.

    "Created: / 06-07-2011 / 17:48:27 / jv"
!

undoableDo: aBlock info: into

    super undoableDo: aBlock info: into.
    suppressNotifications := false.

    "Created: / 06-07-2011 / 17:48:49 / jv"
! !

!CodeView2 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


CodeView2 initialize!

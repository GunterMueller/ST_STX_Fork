"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

TextCollector subclass:#Workspace
	instanceVariableNames:'doItAction codeStartPosition errorFgColor errorBgColor
		commentStrings autoDefineWorkspaceVariables simulatedSelf
		autoDefineVariables compilerClass allowValueDrop
		poolsConsideredInDoIts namespaceForDoits editedMethodOrClass
		editedLanguage'
	classVariableNames:'DefaultErrorBackgroundColor DefaultErrorForegroundColor
		DefaultViewBackground DefaultWarningBackgroundColor
		DefaultWarningForegroundColor DoItHistory Sniplets Snippets
		WorkspaceVariables'
	poolDictionaries:''
	category:'Interface-Smalltalk'
!

Workspace comment:''
!

!Workspace class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    a view for editable text which can evaluate expressions.
    I.e. its basically a view for editable text, with added
    'doIt', 'printIt' and 'inspectIt' functions on the popup-menu.

    The action to be performed on doIt is defined by a block,
    which can be defined by the owner of this view.
    (thus you can put a workspace into more complex widgets, and
     control what should happen on 'doIt').

    A useful default action is automatically defined, which simply
    evaluates the selection as a smalltalk expression.
    (but, a lisp or prolog workspace would define its own action,
     to call for another compiler/interpreter  ...)

    Special workspace- and doIt variables:
        workspaces can be configured to automatically define undefined variables
        as either workspace- or doIt variables. When encountering undefined variables,
        the parser asks for an action, which is responded with #workspace or doIt if a
        workspace is the requestor of a doIt. Both are implemented as value holders, and
        the parser will generate code sending value/value: instead of normal assignment.
        Workspace variables are kept in the Workspace class and will both persist between doIts
        and also be visible across workspaces. They are perfect for scripting (and therefore enabled
        by default when stx is started with one of the scripting options).
        DoIt variables are only valid during a single doIt.
        Be aware that when you ask from the outside via workspaceVariableAt:, you'll get a valueHolder.
        This is by purbose, as it allows for easy monitoring and tracing of changes.

    Caveat:
        in this version, Workspace does not yet support doIt in MVC setups.
        For now, simulate this by setting the doItAction, to notify the
        model manually about the doIt.


    [instance variables:]

      doItAction      <Block>         block to evaluate for doIt

      errorFgColor    <Color>         fg-Color to be used when highlighting errors

      errorBgColor    <Color>         bg-Color to be used when highlighting errors

      codeStartPosition               private temporary


    [styleSheet values:]

      codeErrorSelectionForegroundColor     fg color to highlight errors
                                            (default: selection fg)

      codeErrorSelectionBackgroundColor     bg color to highlight errors
                                            (default: selection bg)

    [start with:]
        Workspace open

    [see also:]
        Workspace EditTextView
        Parser ByteCodeCompiler

    [author:]
        Claus Gittinger
"
! !

!Workspace class methodsFor:'accessing'!

sniplets
    <resource: #obsolete>
    self obsoleteMethodWarning.
    ^ self snippets

    "
     Snippets := nil
    "
!

sniplets:something
    <resource: #obsolete>
    self obsoleteMethodWarning.
    self snippets:something
!

snippets
    Snippets isNil ifTrue:[
        Snippets := Dictionary new.
        self initializeDefaultAbbreviations.
    ].
    ^ Snippets

    "
     Snippets := nil
    "
!

snippets:aDictionary
    Snippets := aDictionary.
! !

!Workspace class methodsFor:'defaults'!

defaultCompletionSupportClass
    ^ WorkspaceCompletionSupport

    "Created: / 26-09-2013 / 17:59:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

defaultLabel
    "my default window label"

    ^ 'Workspace'

    "Created: / 16.5.1998 / 16:53:37 / cg"
!

initializeDefaultAbbreviations
    "default snippets/abbreviations. TODO: save/load snippets"

    "flush and reinitialize snippets with:
         Snippets := Dictionary new.
    "
    "after a code change below, update with:
         self initializeDefaultAbbreviations.
    "

    #(
        't'     'true'
        'f'     'false'
        's'     'self'
        'su'    'super'
        'ss'    'super '
        'n'     'nil'
        'y'     'yourself.'

        'in'    'isNil '
        'nn'    'notNil '
        'ie'    'isEmpty '
        'ne'    'notEmpty '
        'ien'   'isEmptyOrNil '
        'nen'   'notEmptyOrNil '

        '[it'    '[nil] ifTrue:[!!'
        '[if'    '[nil] ifFalse:[!!'
        'it'    'ifTrue:[!!'
        'if'    'ifFalse:[!!'
        'itf'   'ifTrue:[!!] ifFalse:[].'
        'int'   'isNil ifTrue:[!!].'
        'inf'   'isNil ifFalse:[!!].'
        'ints'  'isNil ifTrue:[^ self].'
        'infs'  'isNil ifFalse:[^ self].'
        'nnt'   'notNil ifTrue:[!!].'
        'nnf'   'notNil ifFalse:[!!].'
        'iet'   'isEmpty ifTrue:[!!].'
        'net'   'notEmpty ifTrue:[!!].'
        'ief'   'isEmpty ifFalse:[!!].'
        'nef'   'notEmpty ifFalse:[!!].'

        'wt'    'whileTrue:[!!]'
        'wf'    'whileFalse:[!!]'

        'do'    'do:[:each |!!]'
        'd:'    'do:[:each |!!]'
        'kdo'   'keysAndValuesDo:[:eachKey :eachValue |!!]'
        'kvd'   'keysAndValuesDo:[:eachKey :eachValue |!!]'
        'kv:'   'keysAndValuesDo:[:eachKey :eachValue |!!]'
        'k:'    'keysDo:[:eachKey | !!]'
        'dt'    'detect:[:each | !!]'
        'de'    'detect:[:each | !!]'
        'det'   'detect:[:each | !!]'
        'dtn'   'detect:[:each | !!] ifNone:[]'
        'cl'    'collect:[:each | !!]'
        'co'    'collect:[:each | !!]'
        'col'   'collect:[:each | !!]'
        'sl'    'select:[:each | !!]'
        'se'    'select:[:each | !!]'
        'sel'   'select:[:each | !!]'
        'rj'    'reject:[:each | !!]'
        're'    'reject:[:each | !!]'
        'rej'   'reject:[:each | !!]'
        'inj'   'inject:!! into:[:accum :each | ]'

        'ex'    'Error handle:[ex | !!] do:[].'
        '[ sh'  '[ self halt ].'
        '[sh'   '[self halt].'
        'sh'    'self halt.'
        'mt'    'MessageTally spyOn:[!!].'

        'ih'    '!! ifTrue:[ self halt ].'
        'ik'    'includesKey: #'
        'is'    'includesString: #'

        'af'    'asFilename '
        'as'    'asString '
        'aoc'   'asOrderedCollection '

        'np'    'nextPut: '
        'npa'   'nextPutAll: '
        'npl'   'nextPutLine: '

        'ps'    'printString'
        'sr'    'self subclassResponsibility.'

        'ati'   'at:!! ifAbsent: '
        'atip'  'at:!! ifAbsentPut:[ ] '
        'ap'    'at:!! '

        'st'    'Smalltalk'
        'ts'    'Transcript showCR:''!!''.'
        'trs'   'Transcript showCR:''!!''.'
        'abb'   'Workspace snippets inspect.'
        'ws'    'Delay waitForSeconds: 1.'
        'wfs'   'Delay waitForSeconds: 1.'
        'wfm'   'Delay waitForMilliseconds: 1000.'
        'ini'   'initialize\    super initialize.\    '
        'newi'  'new\    ^ super new initialize.'
        'upd'   'update:something with:aParameter from:changedObject\    !!\    ^ super update:something with:aParameter from:changedObject.'
        'OC'    'OrderedCollection'
        'oc'    'OrderedCollection'
        'SC'    'SortedCollection'
        'sc'    'SortedCollection'
        'D'     'Dictionary'
        'ID'    'IdentityDictionary'
        'Id'    'IdentityDictionary'
        'id'    'IdentityDictionary'
        'iD'    'IdentityDictionary'
        'OCn'   'OrderedCollection new.'
        'ocn'   'OrderedCollection new.'
        'SCn'   'SortedCollection new.'
        'IDn'   'IdentityDictionary new'
        'idn'   'IdentityDictionary new'
        'Dn'    'Dictionary new'
        'dn'    'Dictionary new'
        'Sn'    'Set new'
        'sn'    'Set new'
        'A'     'Array'
        'a'     'Array'
        'An'    'Array new:'
        'an'    'Array new:'
        'Aw'    'Array with:'
        'aw'    'Array with:'
        'Aww'   'Array with:!! with:'
        'sww'   'Array with:!! with:'
        'Awww'  'Array with:!! with: with:'
        'awww'  'Array with:!! with: with:'
        'Awwww' 'Array with:!! with: with: with:'
        'awwww' 'Array with:!! with: with: with:'
        'aw2'   'Array with:!! with:'
        'aw3'   'Array with:!! with: with:'
        'aw4'   'Array with:!! with: with: with:'
        '0'     '(0.0 @ 0.0)'
        '1'     '(1.0 @ 1.0)'
        '['     '[:!! ]'
        '('     '(!! )'

        "/ typos...
        'eslf'  'self'
        'slef'  'self'
        'sefl'  'self'
        'elf'   'self'
        'slf'   'self'
        'sef'   'self'

        'iftrue'   'ifTrue'
        'iffalse'  'ifFalse'
        'iftrue:'  'ifTrue:'
        'iffalse:' 'ifFalse:'
    ) pairWiseDo:[:abbrev :text |
        Snippets
            at:abbrev put:text "/ ifPresent:[ self error:'duplicate abbreviation key' ]
    ].

    "Modified: / 30-04-2016 / 19:43:35 / cg"
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'codeErrorSelection.foregroundColor'
		       #'codeErrorSelection.backgroundColor'
		       #'codeView.backgroundColor' )>

    DefaultErrorForegroundColor := StyleSheet colorAt:'codeErrorSelection.foregroundColor'.
    DefaultErrorBackgroundColor := StyleSheet colorAt:'codeErrorSelection.backgroundColor'.
    DefaultViewBackground := StyleSheet colorAt:'codeView.backgroundColor'.
! !

!Workspace class methodsFor:'getting a new Workspace'!

open
    "launch a new workspace"

    |scr topView workspace f|

    topView := StandardSystemView
		label:(self classResources string:(self defaultLabel))
		" minExtent:(100 @ 100)".

    scr := HVScrollableView for:self in:topView.
    scr origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
    workspace := scr scrolledView.

    "/ adjust topViews extent according to my font

    f := workspace font.
    topView extent:((f widthOf:'x') * 40) @ (f height * 10).
    topView open.
    ^ workspace

    "
     Workspace open
    "

    "Modified: / 16.5.1998 / 16:53:53 / cg"
!

openForRemote:hostName
    "launch a new workspace to evaluate expression on some remote machine.
     Entered expressions are sent over to some partner machine, evaluated there,
     and the result is shown here.
     This requires the RemoteObjects package to be loaded."

    |server remoteCompiler workspace|

    RemoteObjectServer isNil ifTrue:[
	self warn:'no remoteObjectServer available'.
	^ nil
    ].

    server := RemoteObjectServer on:hostName.
    remoteCompiler := server get:#Compiler.

    workspace := self open.
    workspace topView
	label:(self classResources string:'Remote Workspace {%1}' with:hostName).

    workspace doItAction:
		[:theCode |
		    remoteCompiler
			evaluate:theCode
			in:nil
			receiver:nil
			notifying:workspace
			logged:true
			ifFail:nil
		]
    "
     Workspace openForRemote:'andi'
    "

    "Modified: / 16.5.1998 / 16:57:38 / cg"
!

openWith:initialText selected:selectedBoolean
    "launch a new workspace with some initial contents"

    |workspace|

    workspace := self open.
    workspace contents:initialText selected:selectedBoolean.
    ^ workspace

    "
     Workspace openWith:'Transcript showCR:''hello world'''
    "
! !

!Workspace class methodsFor:'history'!

clearDoItHistory
    DoItHistory := nil
!

doItHistory
    ^ DoItHistory
!

doItHistorySize
    "the number of remembered doIts"

    ^ 20
!

rememberDoIt:aString
    |string|

    string := aString asString string withoutSeparators.
    (string asCollectionOfWords size <= 1) ifTrue:[
	Error handle:[:ex |
	    "/ unparsable
	    ^ self
	] do:[
	    ((Scanner new scanTokens:string) size <= 1) ifTrue:[
		"it's a variable only"
		^ self
	    ]
	]
    ].

    DoItHistory isNil ifTrue:[
	DoItHistory := OrderedCollection new.
    ].
    DoItHistory remove:string ifAbsent:nil.
    DoItHistory addFirst:string.
    DoItHistory size > self doItHistorySize ifTrue:[
	DoItHistory removeLast
    ].
! !

!Workspace class methodsFor:'queries'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ self == Workspace

    "Created: / 16.5.1998 / 16:59:00 / cg"
    "Modified: / 16.5.1998 / 16:59:39 / cg"
! !

!Workspace class methodsFor:'workspace variables'!

addWorkspaceVariable:name
    "create a new workspace variable"

    |holder|

    holder := self workspaceVariables at:name ifAbsentPut:[ ValueHolder new ].
    ^ holder
!

anyWorkspaceVariableIsDefined
    ^ WorkspaceVariables notEmptyOrNil

    "Created: / 20-04-2005 / 11:57:53 / cg"
!

rememberResultAsWorkspaceVariable:lastResult
    "remember some last result as _0,
     and shift the previous results (i.e. _0 -> _1 -> .. _9)"

    |workspaceVariables|

    workspaceVariables := self workspaceVariables.
    
    9 to:1 by:-1 do:[:h|
        (workspaceVariables includesKey:('_%1' bindWith:h-1)) ifTrue:[
            self workspaceVariableAt:('_%1' bindWith:h)
                 put:(self workspaceVariableAt:('_%1' bindWith:h-1)).
        ].
    ].
    self workspaceVariableAt:'_0' put:lastResult.

    "Modified: / 08-11-2016 / 22:39:41 / cg"
!

removeAllWorkspaceVariables
    "delete all workspace variables"

    WorkspaceVariables := nil


!

removeWorkspaceVariable:name
    "delete a workspace variable"

    WorkspaceVariables notNil ifTrue:[
	WorkspaceVariables removeKey:name ifAbsent:nil.
	WorkspaceVariables := WorkspaceVariables asNilIfEmpty.
    ].
!

workspaceVariableAt:name
    "retrieve a workspace variable's value"

    ^ (self workspaceVariableHolderAt:name) value

    "
     Workspace workspaceVariableAt:'foo' put:1234.
     Workspace workspaceVariableAt:'foo'
    "
!

workspaceVariableAt:name put:aValue
    "set or define a workspace variable"

    (self workspaceVariables at:name ifAbsentPut:[ ValueHolder new]) value:aValue
!

workspaceVariableHolderAt:name
    "retrieve a workspace variable (actually, a holder onto it)"

    WorkspaceVariables isNil ifTrue:[^ nil].
    ^ WorkspaceVariables at:name ifAbsent:nil.

    "
     Workspace workspaceVariableAt:'foo' put:1234.
     Workspace workspaceVariableAt:'foo' put:1234.
    "
!

workspaceVariableNames
    "retrieve the collection of workspace variable names only"

    WorkspaceVariables isNil ifTrue:[^ #()].
    ^ WorkspaceVariables keys

    "Created: / 20-04-2005 / 11:42:45 / cg"
!

workspaceVariables
    "retrieve the collection of workspace variable holders.
     That is a dictionary associating names to values."

    WorkspaceVariables isNil ifTrue:[
	WorkspaceVariables := Dictionary new.
    ].
    ^ WorkspaceVariables

    "Modified: / 20-04-2005 / 11:43:14 / cg"
! !

!Workspace methodsFor:'accessing'!

allowValueDrop:aBoolean
    "if on (the default), any smalltalk value can be dropped and leads to a workspace variable
     holding on to that being defined. Can be turned off, if you don't like this (for standAlone apps)"

    allowValueDrop := aBoolean.

    "Created: / 28-11-2006 / 16:13:02 / cg"
!

autoDefineVariables
    "undefined variables handling:
	are automatically defined as workspace variable if autoDefineVariables is #workspace.
	are automatically defined as doit variable if autoDefineVariables is #doit.
	are left undefined if autoDefineVariables is nil."

    ^ autoDefineVariables
!

autoDefineVariables:nilOrSymbol
    "undefined variables handling:
	are automatically defined as workspace variable if nilOrSymbol is #workspace.
	are automatically defined as doit variable if nilOrSymbol is #doit.
	are left undefined if nilOrSymbol is nil."

    autoDefineVariables := nilOrSymbol.

    "Modified: / 28-11-2006 / 16:21:01 / cg"
!

commentStrings:anArrayOfCommentStrings
    "define the comment strings"

    "/ The argument must be of the form:
    "/    #(
    "/        '"/'
    "/        ('"' '"')
    "/    )
    "/ where simple string elements define the EOL comment sequence,
    "/ and pairs define regular comment opening/closing seqeuences.

    commentStrings := anArrayOfCommentStrings

    "Created: / 9.11.1997 / 01:05:25 / cg"
!

doItAction
    "return the action to be performed when 'doIt' is selected"

    ^ doItAction
!

doItAction:aOneArgBlock
    "define the action to be performed when 'doIt' is selected.
     The block will be evaluated, passing the selection as a String argument.
     A default doItAction is set for you in the initialize method."

    doItAction := aOneArgBlock

    "Modified: 27.2.1996 / 15:31:37 / cg"
!

editedClass
    "for the code completion"

    editedMethodOrClass isNil ifTrue:[^ nil].
    ^ editedMethodOrClass isBehavior 
        ifTrue:[editedMethodOrClass] 
        ifFalse:[editedMethodOrClass mclass]
!

editedLanguage
    |mthd cls|
    
    editedLanguage notNil ifTrue:[
        ^ editedLanguage
    ].
    (mthd := self editedMethod )notNil ifTrue:[
        ^ mthd programmingLanguage.
    ].
    (cls := self editedClass) notNil ifTrue:[
        ^ cls programmingLanguage.
    ].
    ^ nil

    "Modified: / 18-09-2013 / 12:58:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

editedLanguage:aProgrammingLanguageOrNil
    editedLanguage := aProgrammingLanguageOrNil.
    aProgrammingLanguageOrNil notNil ifTrue:[
	commentStrings := aProgrammingLanguageOrNil commentStrings.
    ].
!

editedMethod
    "for the code completion"

    editedMethodOrClass isNil ifTrue:[^ nil].
    ^ editedMethodOrClass isBehavior 
        ifTrue:[nil] 
        ifFalse:[editedMethodOrClass]
!

editedMethodOrClass
    "for the code completion"

    ^ editedMethodOrClass.
!

editedMethodOrClass:aMethodOrClass
    "for the code completion"

    editedMethodOrClass := aMethodOrClass.
!

errorBackgroundColor
    errorBgColor notNil ifTrue:[ ^ errorBgColor ].
    DefaultErrorBackgroundColor notNil ifTrue:[ ^ DefaultErrorBackgroundColor ].
    device hasColors ifTrue:[ ^ Color red ].

    ^ selectionBgColor
!

errorForegroundColor
    errorFgColor notNil ifTrue:[ ^ errorFgColor ].
    DefaultErrorForegroundColor notNil ifTrue:[ ^ DefaultErrorForegroundColor ].
    ^ selectionFgColor
!

nameSpaceForDoits
    "can be used by the embedding application to control doIt execution
     (especially: for tools like expecco, to provide better workspaces"

    ^ namespaceForDoits ? Smalltalk
!

nameSpaceForDoits:aNameSpaceOrNil
    "can be used by the embedding application to control doIt execution
     (especially: for tools like expecco, to provide better workspaces"

    namespaceForDoits := aNameSpaceOrNil.

    "Created: / 26-07-2012 / 23:06:04 / cg"
!

namespaceForDoits:aNameSpaceOrNil
    "can be used by the embedding application to control doIt execution
     (especially: for tools like expecco, to provide better workspaces"

    <resource: #obsolete>

    namespaceForDoits := aNameSpaceOrNil.

    "Created: / 04-03-2012 / 13:34:51 / cg"
!

poolsConsideredInDoIts:aCollectionOfPools
    "can be used by the embedding application to control doIt execution
     (especially: for tools like expecco, to provide better workspaces"

    poolsConsideredInDoIts := aCollectionOfPools.

    "Modified (format): / 04-03-2012 / 13:35:00 / cg"
!

simulatedSelf:anObject
    "define what self is in an evaluation"

    simulatedSelf := anObject
!

warningBackgroundColor
    DefaultWarningBackgroundColor notNil ifTrue:[ ^ DefaultWarningBackgroundColor ].
    device hasColors ifTrue:[ ^ Color orange ].

    ^ selectionBgColor
!

warningForegroundColor
    DefaultWarningForegroundColor notNil ifTrue:[ ^ DefaultWarningForegroundColor ].
    ^ selectionFgColor
! !

!Workspace methodsFor:'compiler interface'!

compilerClass
    ^ compilerClass "? Compiler"

    "Modified: / 19-07-2012 / 17:04:35 / cg"
!

compilerClass:aCompilerClass
    compilerClass := aCompilerClass
!

currentSourceCode
    "special interface to compiler - called by parser
     to get the updated source code after a corrected error"

    ^ self contents
!

wantChangeLog
    "sent by the compiler to ask if a changeLog entry should
     be written. Return true here."

    ^ true
! !

!Workspace methodsFor:'compiler interface-error handling'!

correctableError:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of a correctable error;
     hilight the error (relPos to relEndPos) and show a Box asking for continue/correct/abort;
     this method should return true to the compiler if user wants the error
     to be corrected; false otherwise"

    |action sameForAllHolder possibleFixes 
     doNotShowAgainHolder doNotShowAgainForThisMethodHolder doNotShowAgainForThisReceiverSelectorHolder|

    "/ the declare/correct fixes are here for backward compatibility
    "/ (in previous versions, these two were always offered as fix,
    "/ and compilers which honor the old interface will not anwer the PossibleCorrectionsQuery)
    possibleFixes := Parser possibleCorrectionsQuery query.

    sameForAllHolder := false asValue.

    self highlightingErrorPosition:relPos to:relEndPos do:[
        doNotShowAgainHolder := false asValue.
        doNotShowAgainForThisMethodHolder := false asValue.
        doNotShowAgainForThisReceiverSelectorHolder := false asValue.

        Dialog modifyingBoxWith:[:box |
            |declareButton makeSpaceOnlyOnce|

            (box isKindOf:OptionBox) ifTrue:[ 
                "/ a bad hack for subDialogs... needs fix
                makeSpaceOnlyOnce := [ box addVerticalSpace:10. makeSpaceOnlyOnce := nil ].

                DoNotShowCompilerWarningAgainActionQuery isHandled ifTrue:[
                    makeSpaceOnlyOnce value.
                    box verticalPanel
                        add:(CheckBox
                                label: "addCheckBoxAtBottom:" 'Do not show this dialog again (reenable via Launcher''s settings dialog)'
                                model:doNotShowAgainHolder).
                ].
                DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery isHandled ifTrue:[  
                    makeSpaceOnlyOnce value.
                    box verticalPanel
                        add:(CheckBox
                                label:(resources string:'Do not warn for this receiver>>selector combination (reenable earlier via Launcher''s settings dialog)')
                                model:doNotShowAgainForThisReceiverSelectorHolder).
                ].    
                DoNotShowCompilerWarningAgainForThisMethodActionQuery isHandled ifTrue:[
                    makeSpaceOnlyOnce value.
                    box verticalPanel
                        add:(CheckBox
                                label:(resources string:'Do not warn in this method (for %1 - reenable earlier via Launcher''s settings dialog)' with:ParserFlags perMethodDisableWarningTimeDuration)
                                model:doNotShowAgainForThisMethodHolder).
                ].
                SameForAllNotification isHandled ifTrue:[
                    box addVerticalSpace:10.
                    box addCheckBoxAtBottom:'Same action for all' on:sameForAllHolder
                ].

                declareButton := box buttons at:2.
                declareButton pressAction:declareButton controller releaseAction.
                declareButton controller beTriggerOnDown.
            ]
        ] do:[
            |buttonLabels actions|

            buttonLabels := OrderedCollection new.
            actions := OrderedCollection new.
            buttonLabels add:'Cancel'. actions add:#abort.
            possibleFixes do:[:each |
                buttonLabels add:(each buttonLabel). actions add:each.
            ].
            buttonLabels add:'Continue'. actions add:#continue.

            action := OptionBox
                          request:aString
                          label:(resources string:'Correctable Error')
                          image:(WarningBox iconBitmap)
                          buttonLabels:(resources array:buttonLabels)
                          values:actions
                          default:#continue
                          onCancel:#abort.
        ].
    ].

    sameForAllHolder value ifTrue:[
        SameForAllNotification notify
    ].
    doNotShowAgainHolder value == true ifTrue:[
        DoNotShowCompilerWarningAgainActionQuery actionQuery value
    ].
    doNotShowAgainForThisMethodHolder value == true ifTrue:[
        DoNotShowCompilerWarningAgainForThisMethodActionQuery actionQuery value
    ].
    doNotShowAgainForThisReceiverSelectorHolder value == true ifTrue:[
        DoNotShowCompilerWarningAgainForThisReceiverSelectorActionQuery actionQuery value
    ].

    action == #cancel ifTrue:[
        ^ false
    ].

    action == #abort ifTrue:[
        AbortOperationRequest raise.
        ^ false
    ].
    ^ action

    "Modified: / 28-02-2012 / 10:42:27 / cg"
!

correctableSelectorWarning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of a correctable selector warning;
     hilight the error (relPos to relEndPos) and show a Box asking for continue/correct/abort;
     this method should return true to the compiler if user wants the error
     to be corrected; false otherwise"

    |action doNotShowAgainHolder|

    self highlightingWarningPosition:relPos to:relEndPos do:[
	doNotShowAgainHolder := false asValue.
	Dialog aboutToOpenBoxNotificationSignal handle:[:ex |
	    MessageNotUnderstood catch:[
		(aCompiler notNil and:[DoNotShowCompilerWarningAgainActionQuery isHandled]) ifTrue:[
		    ex box addCheckBoxAtBottom:'Do not show this dialog again (reenable via Launchers Settings Dialog)' on:doNotShowAgainHolder.
		].
	    ].
	] do:[
	    action := OptionBox
		      request:aString
		      label:(resources string:'Warning')
		      image:(WarningBox iconBitmap)
		      buttonLabels:(resources array:#('Cancel' 'Correct...' 'Generate' 'Continue'))
		      values:#(#abort #correct #generate #continue)
		      default:#continue
		      onCancel:#abort.
	].
	doNotShowAgainHolder value == true ifTrue:[
	    DoNotShowCompilerWarningAgainActionQuery actionQuery value
	].
    ].

    action == #generate ifTrue:[
	^ action
    ].

    (action isNil or:[action == #abort]) ifTrue:[
	AbortOperationRequest raise.
	^ false
    ].
    ^ action == #correct

    "Created: / 19-01-2000 / 16:27:28 / cg"
    "Modified: / 28-02-2012 / 10:42:37 / cg"
!

correctableWarning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of a correctable warning;
     hilight the error (relPos to relEndPos) and show a Box asking for continue/correct/abort;
     this method should return true to the compiler if user wants the error
     to be corrected; false otherwise"

    ^ self correctableError:aString position:relPos to:relEndPos from:aCompiler

    "Created: / 02-11-2010 / 13:29:01 / cg"
!

error:aString position:relPos to:relEndPos asWarning:asWarning
    "obsolete - no longer invoked"

    ^ self error:aString position:relPos to:relEndPos from:nil asWarning:asWarning
!

error:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of an error; hilight the error (relPos to relEndPos)
     and show a Box asking for continue/abort.
     Return true for correction, false of not (or not possible)"

    ^ self error:aString position:relPos to:relEndPos from:aCompiler asWarning:false

    "Modified (Comment): / 30-06-2011 / 19:47:36 / cg"
!

error:aString position:relPos to:relEndPos from:aCompiler asWarning:asWarning
    "compiler notifies us of an error; hilight the error (relPos to relEndPos)
     and show a Box asking for continue/abort."

    |answer fg bg|

    fg := asWarning ifTrue:[ self warningForegroundColor ] ifFalse:[ self errorForegroundColor ].
    bg := asWarning ifTrue:[ self warningBackgroundColor ] ifFalse:[ self errorBackgroundColor ].

    self
        highlightingErrorPosition:relPos to:relEndPos
        withForeground:fg andBackground:bg
        do:[
            |box lbl doNotShowAgainHolder doNotShowAgainForThisMethodHolder l1 y1 y2 l2|

"/            Warning isHandled ifTrue:[
"/                Warning raiseErrorString:aString.
"/                ^ false
"/            ].

            lbl := aCompiler isNil ifTrue:['Compiler'] ifFalse:[aCompiler class name].
            asWarning ifTrue:[
                lbl := lbl , ' Warning'
            ] ifFalse:[
                lbl := lbl , ' Error'.
            ].

            "
             ask if we should abort or continue
            "
            Dialog modifyingBoxWith:[:box |
                |makeSpace|

                doNotShowAgainHolder := false asValue.
                doNotShowAgainForThisMethodHolder := false asValue.

                box label:lbl.
                box perform:#image: with:(WarningBox iconBitmap) ifNotUnderstood:[].

                aCompiler notNil ifTrue:[
                    makeSpace := [ box addVerticalSpace:10. makeSpace := nil ].
                    DoNotShowCompilerWarningAgainActionQuery isHandled ifTrue:[
                        makeSpace value.
                        box verticalPanel
                            add:(CheckBox label:'Do not show this dialog again (reenable via Launcher''s settings dialog)'
                                          model:doNotShowAgainHolder).
                    ].
                    DoNotShowCompilerWarningAgainForThisMethodActionQuery isHandled ifTrue:[
                        makeSpace value.
                        box verticalPanel
                            add:(CheckBox label:(resources string:'Do not warn in this method (for %1 - reenable earlier via Launcher''s settings dialog)' with:ParserFlags perMethodDisableWarningTimeDuration)
                                          model:doNotShowAgainForThisMethodHolder).
                    ].
                ].
            ] do:[
                answer := OptionBox
                        request:aString
                        buttonLabels:(resources array:#('Abort'  "'Keep Selected'" 'Continue'))
                        values:#(false "#keepSelected" true)
                        default:(asWarning ifTrue:true ifFalse:false).
                answer := answer ? false.   "/ if escaped
            ].
"/            box := YesNoBox
"/                    title:aString
"/                    yesText:(resources string:'Continue')
"/                    noText:(resources string:'Abort').
"/
"/            box label:lbl.
"/            box image:(WarningBox iconBitmap).
"/
"/            (aCompiler notNil and:[DoNotShowCompilerWarningAgainActionQuery isHandled]) ifTrue:[
"/                doNotShowAgainHolder := false asValue.
"/                box addCheckBox:'Do not show this dialog again (reenable via Launchers Settings Dialog)' on:doNotShowAgainHolder.
"/            ].
"/
"/            "/ answer := box confirm.
"/            answer := box confirm.

            doNotShowAgainHolder value == true ifTrue:[
                DoNotShowCompilerWarningAgainActionQuery actionQuery value
            ].
            doNotShowAgainForThisMethodHolder value == true ifTrue:[
                DoNotShowCompilerWarningAgainForThisMethodActionQuery actionQuery value
            ].

"/            box destroy.
        ].

    answer == #keepSelected ifTrue:[
        self hideCursor.
        "redraw selection in normal color"
        self invalidate.
        AbortOperationRequest raise.
    ].

    "
     do the abort if we have to
    "
    answer ifFalse:[
        "redraw selection in normal color"
        self invalidate.
        AbortOperationRequest raise.
    ].
    ^ false

    "Created: / 24-11-1995 / 22:56:34 / cg"
    "Modified: / 08-03-2012 / 10:24:21 / cg"
!

highlightingErrorLine:lineNr do:aBlock
    "evaluate aBlock while some selection is shown highlighted with error colors."

    |linePosition|

    linePosition := self characterPositionOfLine:lineNr col:1.
    self highlightingErrorPosition:linePosition to:nil do:aBlock
!

highlightingErrorPosition:relPos to:relEndPos do:aBlock
    "evaluate aBlock while some selection is shown highlighted with error colors."

    self
	highlightingErrorPosition:relPos to:relEndPos
	withForeground:(self errorForegroundColor) andBackground:(self errorBackgroundColor)
	do:aBlock
!

highlightingErrorPosition:relPos to:relEndPos withForeground:hilightFg andBackground:hilightBg do:aBlock
    "evaluate aBlock while some selection is shown highlighted with colors passed as args."

    |absPosition oldFg oldBg|

    "
     change color of selection & hide cursor
    "
    oldFg := selectionFgColor.
    oldBg := selectionBgColor.
    selectionBgColor := hilightBg.
    selectionFgColor := hilightFg.
    self hideCursor.

    "
     select the text - relEndPos may be nil in which case the whole line is selected
     we have to adjust the positions given by the compiler, since they
     are relative to the texts start (the compiler did stream-read the code).
    "
    codeStartPosition isNil ifTrue:[codeStartPosition := 1].
    absPosition := codeStartPosition + (relPos ? 1) - 1.
    relEndPos isNil ifTrue:[
	self selectFromCharacterPosition:absPosition.
	"/ self selectLineWhereCharacterPosition:absPosition.
    ] ifFalse:[
	self selectFromCharacterPosition:absPosition to:(codeStartPosition + (relEndPos ? 1) - 1)
    ].
    expandingTop := true.       "/ hack to make the top of the selection visible
    self makeSelectionVisible.

    self flush.

    aBlock ensure:[
	"
	 undo selection color change and show cursor again
	"
	selectionFgColor := oldFg.
	selectionBgColor := oldBg.
	self showCursor.
    ].

    "Modified: / 30-06-2011 / 17:24:04 / cg"
!

highlightingWarningPosition:relPos to:relEndPos do:aBlock
    "evaluate aBlock while some selection is shown highlighted with warning colors."

    self
	highlightingErrorPosition:relPos to:relEndPos
	withForeground:(self warningForegroundColor) andBackground:(self warningBackgroundColor)
	do:aBlock
!

unusedVariableWarning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of a (or some) unused variables;
     hilight the error (relPos to relEndPos) and show a Box asking for continue/correct/abort;
     this method should return true to the compiler if user wants the error
     to be corrected; false otherwise"

    |action doNotShowAgainHolder doNotShowAgainForThisMethodHolder|

    self highlightingWarningPosition:relPos to:relEndPos do:[
        doNotShowAgainHolder := false asValue.
        doNotShowAgainForThisMethodHolder := false asValue.
        Dialog modifyingBoxWith:[:box |
            |makeSpace|

            aCompiler notNil ifTrue:[
                makeSpace := [ box addVerticalSpace:10. makeSpace := nil ].
                DoNotShowCompilerWarningAgainActionQuery isHandled ifTrue:[
                    makeSpace value.
                    box verticalPanel
                        add:(CheckBox
                                label: "addCheckBoxAtBottom:" 'Do not show this dialog again (reenable via Launcher''s settings dialog)'
                                model:doNotShowAgainHolder).
                ].
                DoNotShowCompilerWarningAgainForThisMethodActionQuery isHandled ifTrue:[
                    makeSpace value.
                    box verticalPanel
                        add:(CheckBox
                                label:(resources string:'Do not warn in this method (for %1 - reenable earlier via Launcher''s settings dialog)' with:ParserFlags perMethodDisableWarningTimeDuration)
                                model:doNotShowAgainForThisMethodHolder).
                ].
            ].
        ] do:[
            action := OptionBox
                      request:aString
                      label:(resources string:'Warning')
                      image:(WarningBox iconBitmap)
                      buttonLabels:(resources array:#('Cancel' 'Remove Variable(s)' 'Continue'))
                      values:#(#abort #correct #continue)
                      default:#continue.
            action isNil ifTrue:[ action := #abort].
        ].
        doNotShowAgainHolder value == true ifTrue:[
            DoNotShowCompilerWarningAgainActionQuery actionQuery value
        ].
        doNotShowAgainForThisMethodHolder value == true ifTrue:[
            DoNotShowCompilerWarningAgainForThisMethodActionQuery actionQuery value
        ].
    ].

    action == #abort ifTrue:[
        "/ self halt.
        AbortOperationRequest raise.
        ^ false
    ].
    ^ action == #correct

    "Modified: / 08-03-2012 / 10:23:58 / cg"
!

warning:aString position:relPos to:relEndPos from:aCompiler
    "compiler notifies us of a warning - same behavior as error"

    self error:aString position:relPos to:relEndPos from:aCompiler asWarning:true
! !

!Workspace methodsFor:'drag & drop'!

canDrop:aDropContext
    "if allowValueDrop is true, any text- or file-object can be dropped into workspace
     (printString); otherwise, only ..."

    self isReadOnly ifTrue:[^ false].

    allowValueDrop ifTrue:[^ true].
    ^ super canDrop:aDropContext

"/    ^ aDropContext dropObjects
"/        contains:[:someObject| (someObject isTextObject or:[ someObject isFileObject ])].

    "Created: / 16-08-2005 / 22:01:13 / janfrog"
    "Modified: / 28-11-2006 / 16:18:51 / cg"
!

doDrop:aDropContext
    <resource: #obsolete>
    self obsoleteMethodWarning:'should no longer be reached'.
    self drop:aDropContext

    "Modified: / 28-11-2006 / 16:14:51 / cg"
    "Modified (format): / 28-02-2012 / 11:20:38 / cg"
!

drop:aDropContext
    "Any object can be dropped into workspace..."

    |textObjects nonTextObjects answer text|

    textObjects := aDropContext dropObjects
			    select:[:dropObject | dropObject isTextObject
						  or:[ dropObject isFileObject ]].
    nonTextObjects := aDropContext dropObjects
			    reject:[:dropObject | dropObject isTextObject
						  or:[ dropObject isFileObject ]].

    self dropObjects:textObjects.

    nonTextObjects notEmpty ifTrue:[
	answer := Dialog
		confirmWithCancel:(resources
					string:'Drop as textual representation or as object reference ?')
		labels:(resources array:#('Cancel' 'Reference' 'Name' 'Text'))
		values:#(nil #ref #name #text)
		default:4.
	answer isNil ifTrue:[^ self].
	(answer == #text or:[answer == #name]) ifTrue:[
	    text := String streamContents:[:s |
			nonTextObjects do:[:dropObject |
			    |obj|

			    obj := dropObject theObject.
			    obj isMethod ifTrue:[
				s nextPutAll:(answer == #name ifTrue:[obj selector] ifFalse:[obj source]).
			    ] ifFalse:[
				obj isClass ifTrue:[
				    s nextPutAll:(answer == #name ifTrue:[obj name] ifFalse:[obj source asString])
				] ifFalse:[
				    s nextPutAll:(answer == #name ifTrue:[obj className] ifFalse:[obj printString]) .
				].
			    ].
			].
		    ].
	    self paste:text.
	] ifFalse:[
	    nonTextObjects do:[:dropObject |
		name := Dialog
			request:(resources
				    string:'Name of the new Workspace Variable (refers to the dropped %1):'
				    with:dropObject theObject class name allBold
				 )
			initialAnswer:'droppedObject'
			okLabel:'Add'
			title:'Enter Variable Name'.

		name notEmptyOrNil ifTrue:[
		    Workspace addWorkspaceVariable:name.
		    Workspace workspaceVariableAt:name put:dropObject theObject.
		    self paste:name.
		].
	    ].
	]
    ].

    "Created: / 13-10-2006 / 17:34:07 / cg"
! !

!Workspace methodsFor:'editing'!

commentFrom:line1 to:line2
    "convenient function to comment out a block.
     All lines from line1 to line2 get an end-of-line comment
     in the first col
     (if no eol comment is available, a bracketing comment is used)."

    self commentFrom:line1 to:line2 commentStrings:commentStrings.

    "Created: / 09-11-1997 / 01:05:35 / cg"
    "Modified: / 09-10-2006 / 10:46:44 / cg"
!

commentSelection
    "convenient function to comment out a block.
     All lines from line1 to line2 get an end-of-line comment
     in the first col."

    self commentSelection:commentStrings

    "Created: / 9.11.1997 / 01:05:40 / cg"
    "Modified: / 5.4.1998 / 16:52:23 / cg"
!

uncommentFrom:line1 to:line2
    "convenient function to comment out a block.
     All lines from line1 to line2 get an end-of-line comment
     in the first col.
     (if no eol comment is available, a bracketing comment is removed)"

    self uncommentFrom:line1 to:line2 commentStrings:commentStrings.

    "Created: / 09-11-1997 / 01:05:43 / cg"
    "Modified: / 09-10-2006 / 10:46:59 / cg"
!

uncommentSelection
    "convenient function to comment out a block.
     All lines from line1 to line2 get an end-of-line comment
     in the first col."

    self uncommentSelection:commentStrings

    "Modified: / 7.1.1997 / 20:13:32 / cg"
    "Created: / 9.11.1997 / 01:05:46 / cg"
! !

!Workspace methodsFor:'event handling'!

keyPress:key x:x y:y
    <resource: #keyboard (#DoIt #InspectIt #PrintIt #ReplaceIt
			  #BrowseIt #ImplementorsOfIt #ExpandAbbreviation
			  #CommentSelection #UncommentSelection)>

    (key == #DoIt)      ifTrue:[self doIt. ^ self].
    (key == #InspectIt) ifTrue:[self inspectIt. ^ self].
    (key == #PrintIt)   ifTrue:[self printIt. ^ self].
    (key == #ReplaceIt) ifTrue:[self replaceIt. ^ self].
    (key == #BrowseIt)  ifTrue:[self browseIt. ^ self].
    (key == #ImplementorsOfIt)   ifTrue:[self browseImplementorsOfIt. ^ self].
    (key == #ExpandAbbreviation) ifTrue:[self expandAbbreviation. ^ self].
    (key == #CommentSelection)    ifTrue:[self commentSelection. ^ self].
    (key == #UncommentSelection)  ifTrue:[self uncommentSelection. ^ self].

    super keyPress:key x:x y:y

    "Modified: / 08-11-2007 / 11:29:45 / cg"
! !

!Workspace methodsFor:'executing'!

do:code withValueDo:aBlock
    "helper for doIt, printIt and inspectIt.
     Evaluate the selection and, if all went well, evaluate the argument,
     aBlock with the value.
     Most work is in preparing for proper cleanup in case of abort
     or other exception while the evaluation is performed.
     (restore cursor, selectionColors etc.)"

    |selLine selCol endLine endCol cLine cCol cleanUp executeBlock|

    code notNil ifTrue:[
	code asString withoutSeparators isEmpty ifTrue:[ ^ self ].

	codeStartPosition := self characterPositionOfSelection.

	"
	 remember selection for later - if there is an error,
	 the notification method will highlight it.
	 thus destroying the current selection
	"
	selLine := selectionStartLine.
	selCol := selectionStartCol.
	endLine := selectionEndLine.
	endCol := selectionEndCol.
	cCol := cursorCol.
	cLine := cursorLine.

	"
	 cleanup: restore previous selection and cursor positions
	"
	cleanUp := [
		self selectFromLine:selLine col:selCol toLine:endLine col:endCol.
		cLine notNil ifTrue:[
		    self cursorLine:cLine col:cCol
		].
	].

	"
	 perform the action.
	 Be careful to release the reference to the value;
	 otherwise, we could keep lots of garbage from being freed
	 until the view gets closed
	"
	executeBlock := [
		[
		    AbortOperationRequest handle:[:ex |
			 "/ aBlock value:'** Abortsignal caught **'.
			 ex return
		    ] do:[
			|value|

			doItAction notNil ifTrue:[
			    value := doItAction value:(code asString).
			    cleanUp value. cleanUp := nil.
			    aBlock notNil ifTrue:[
				aBlock value:value.
			    ].
			    value := nil.
			    self class rememberDoIt:code.
			]
		    ]
		] ensure:[
		    cleanUp notNil ifTrue:[
			cleanUp value. cleanUp := nil
		    ].
		]
	    ].
	aBlock isNil ifTrue:[
	    "no action is performed with the result - give the user a visible
	     feedback, that something has been done"
	    self topView withVisibleCursor:Cursor execute do:executeBlock.
	] ifFalse:[
	    self topView withCursor:Cursor execute do:executeBlock.
	].
    ]

    "Modified: / 22.4.1998 / 21:56:13 / ca"
    "Created: / 22.4.1998 / 21:57:05 / ca"
    "Modified: / 26.9.2001 / 17:32:59 / cg"
!

executeDoIt:theCode
    "the core of doIt, printIt, inspectIt, browseIt actions"

    | result compiler |

    "JV@2012-03-19: Changed to reflect value of autoDefineVariables"
    [
	result := ( compiler := (self compilerClass ? Compiler) new )
		currentNameSpace:namespaceForDoits;
		moreSharedPools:poolsConsideredInDoIts;
		evaluate:theCode
		in:nil
		receiver:simulatedSelf
		notifying:self
		logged:true
		ifFail:nil
    ] on: Parser undefinedVariableNotification do:[:ex|
	(ex parser == compiler and:[autoDefineVariables notNil]) ifTrue:[
	    ex proceedWith: #declare
	] ifFalse:[
	    ex proceedWith: nil
	].
    ] on: Parser askForVariableTypeOfUndeclaredQuery do:[:ex|
	autoDefineVariables == #workspace ifTrue:[
	    ex proceedWith:#WorkspaceVariable
	].
	autoDefineVariables == #doIt ifTrue:[
	    ex proceedWith:#DoItTemporary
	].
	ex pass.
    ].
    ^result

    "Modified: / 27-07-2012 / 09:33:39 / cg"
    "Modified: / 24-06-2013 / 15:31:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Workspace methodsFor:'initialization & release'!

initStyle
    "setup viewStyle specifics"

    super initStyle.

    DefaultViewBackground notNil ifTrue:[
	viewBackground := DefaultViewBackground.
	self backgroundColor:viewBackground.
    ].
!

initialize
    super initialize.

    autoIndent := UserPreferences current autoIndentInCodeView.
    scrollWhenUpdating := #beginOfText.
    showMatchingParenthesis := true.
    allowValueDrop := true.

    commentStrings := #(
                        '"/'
                        ('"' '"')
                       ).

    self initializeDoITAction.
    self initializeDragAndDrop.

    "Modified: / 28-11-2006 / 16:11:55 / cg"
!

initializeDoITAction
    "set up the block to be evaluated for doIts.
     This is done here in a separate method to allow easier
     redefinition in subclasses"

    doItAction := [:theCode | self executeDoIt:theCode].
!

initializeDragAndDrop
    |target|

    target := DropTarget
		    receiver:self
		    argument:nil
		    dropSelector:#drop:
		    canDropSelector:#canDrop:.
    self dropTarget:target

    "Created: / 16-08-2005 / 22:03:36 / janfrog"
    "Modified: / 13-10-2006 / 12:37:18 / cg"
! !

!Workspace methodsFor:'menu & menu actions'!

browseClass
    "user selected 'browseClass' from menu; evaluate the code
     and open a browser on the resulting class (if it evaluates to one)"

    ^ self
	do:(self selectionAsString)
	withValueDo:[:result |
	    result isBehavior ifTrue:[
		result browserClass openInClass:result selector:nil
	    ] ifFalse:[
		self warn:'Selection does not evaluate to a class'
	    ]
	].

    "Modified: / 26.9.2001 / 17:37:35 / cg"
!

browseImplementorsOfIt
    "open a browser on the implementors of the selected text,
     or - if I support syntax elements, on the syntax element at the cursor position"

    |selectedText selector browserClass na browser 
     cls node dwim targetClass targetImplClass| 

    selectedText := self selectedTextOrSyntaxElement.
    selectedText notEmptyOrNil ifTrue:[
        self windowGroup withWaitCursorDo:[
            "/ hack, for now and expecco; must ask the Parser eventually...
            ((compilerClass notNil and:[compilerClass includesBehavior:JavaScriptParser])
            or:[ self editedLanguage notNil 
                 and:[ self editedLanguage isSTXJavaScript]]) ifTrue:[
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
            browserClass := UserPreferences systemBrowserClass.

            (selector notNil and:[selector ~= selectedText]) ifTrue:[
                (SystemBrowser
                        findImplementorsOfAny:(Array with:selectedText)
                        in:(Smalltalk allClasses)
                        ignoreCase:false) isEmpty ifTrue:[
                    browser := browserClass browseImplementorsOf:selector
                ] ifFalse:[
                    browser := browserClass browseImplementorsOfAny:(Set with:selector with:selectedText)
                ].
            ] ifFalse:[
                browser := browserClass browseImplementorsOf:(selector ? selectedText)
            ].
            browser notNil ifTrue:[
                "/ if the type of the receiver is known,
                "/ select the targeted method immediately
                (cls := self editedClass) notNil ifTrue:[
                    node := DoWhatIMeanSupport
                                findNodeForInterval:(self selectionStartIndex to:self selectionStopIndex)
                                in:self contents string.
                    (node notNil and:[node isMessage]) ifTrue:[
                        dwim := DoWhatIMeanSupport new.
                        dwim setClass:cls andContext:nil.
                        dwim setSelf: simulatedSelf.
                        targetClass := dwim classOfNode:node receiver.
                        
                        targetClass notNil ifTrue:[
                            targetImplClass := targetClass whichClassImplements:(node selector).
                            targetImplClass notNil ifTrue:[
                                browser selectMethod:(targetImplClass compiledMethodAt:(node selector))
                            ].
                        ].
                    ].    
                ]
            ]
        ]
    ].

    "Created: / 5.11.2001 / 17:32:23 / cg"
    "Modified: / 19.11.2001 / 22:15:17 / cg"
!

browseIt
    "evaluate the code and open a browser on the resulting class (if it evaluates to one),
     or the class of the resulting object (if it does not evaluate to a class).

     Added feature: 
        if selection is of the form class >> selector,  
        immediately switch to that selector."

    |codeToEvaluate el idx selector evaluatedValue classToBrowse gotResult|

    (self selection isEmptyOrNil
        and:[ self supportsSyntaxElements
        and:[ (el := self syntaxElementForVariableUnderCursor) notNil ]])
    ifTrue:[
        codeToEvaluate := el name
    ] ifFalse:[
        codeToEvaluate := (self selectionOrTextOfCursorLine ? '') withoutSeparators.
    ].
    idx := codeToEvaluate indexOf:'»'.
    idx ~~ 0 ifTrue:[
        selector := (codeToEvaluate copyFrom:idx+1) withoutSeparators string.
        (selector startsWith:'#') ifTrue:[
            selector := Symbol readFrom:selector.
        ].
        codeToEvaluate := codeToEvaluate copyTo:idx-1.
    ] ifFalse:[
        idx := codeToEvaluate indexOfSubCollection:'>>'.
        idx ~~ 0 ifTrue:[
            selector := (codeToEvaluate copyFrom:idx+2) withoutSeparators string.
            (selector startsWith:'#') ifTrue:[
                selector := Symbol readFrom:selector.
            ].
            codeToEvaluate := codeToEvaluate copyTo:idx-1.
        ].
    ].
    
    (Parser parseErrorSignal , MessageNotUnderstood) handle:[:ex |
        |className words|

        (classToBrowse := Smalltalk classNamed:codeToEvaluate) isNil ifTrue:[
            "/ handle className selector (for example from messageTally list)
            codeToEvaluate includesSeparator ifTrue:[
                words := codeToEvaluate asCollectionOfWords.
                classToBrowse := Smalltalk classNamed:words first.
                classToBrowse notNil ifTrue:[
                    selector := (words copyFrom:2) asStringWith:''.
                    ((words size > 1) and:[words second = 'class']) ifTrue:[
                        classToBrowse := classToBrowse theMetaclass.
                        selector := (words copyFrom:3) asStringWith:''.
                    ].
                    classToBrowse browserClass openInClass:classToBrowse selector:selector.
                    ^ self.
                ].
            ].

            "/ fallback, if garbage is selected, look for matching classes.
            className := SystemBrowser
                askForClassNameMatching:codeToEvaluate
                inEnvironment:nil
                for:nil.

            className isNil ifTrue:[^ self].
            classToBrowse := Smalltalk classNamed:className.
        ]
    ] do:[
        gotResult := false.

        self
            do:codeToEvaluate
            withValueDo:[:result | evaluatedValue := result. gotResult := true.].

        gotResult ifFalse:[^ self].

        evaluatedValue isNil ifTrue:[
            codeToEvaluate asCollectionOfWords size == 1 ifTrue:[
                codeToEvaluate isUppercaseFirst ifTrue:[
                    Dialog information:(codeToEvaluate allBold , ' is unbound or nil').
                    ^ self.
                ].
            ]
        ].
        classToBrowse := evaluatedValue isBehavior
                        ifTrue:[ evaluatedValue ]
                        ifFalse:[ evaluatedValue class ].
    ].

    classToBrowse browserClass openInClass:classToBrowse selector:selector

    "Modified: / 28-02-2012 / 11:23:06 / cg"
!

browseItsClass
    "user selected 'browseItsClass' from menu; evaluate the code
     and open a browser on the results class"

    ^ self
	do:(self selectionAsString)
	withValueDo:[:result |
			result class browserClass openInClass:result class selector:nil
		    ]

    "Modified: / 26.9.2001 / 17:38:06 / cg"
!

browseReferencesToIt
    "open a browser on all references to the selected global, poolvar or namespace class"

    |nameOfVariable browserClass sym|

    nameOfVariable := self selectedTextOrSyntaxElement.
    nameOfVariable notEmptyOrNil ifTrue:[
        browserClass := UserPreferences systemBrowserClass.
        self windowGroup withWaitCursorDo:[
            |cls nonMeta privateClass|

            (nameOfVariable startsWith:'#') ifTrue:[
                sym := (nameOfVariable copyFrom:2) asSymbolIfInterned.
                browserClass browseForSymbol:sym.
            ] ifFalse:[
                "/ is it a class variable?
                ((cls := self editedClass) notNil
                and:[ ((nonMeta := cls theNonMetaclass) allClassVarNames includes:nameOfVariable) ]) ifTrue:[
                    nonMeta isSharedPool ifTrue:[
                        "/ class is a pool - browse all references to it.
                        browserClass browseReferendsOf:(nonMeta name,':',nameOfVariable)
                    ] ifFalse:[
                        browserClass
                            browseRefsTo:nameOfVariable
                            classVars:true
                            in:(nonMeta whichClassDefinesClassVar:nameOfVariable) withAllSubclasses
                            modificationsOnly:false.
                    ].
                ] ifFalse:[
                    "/ is it a private class?
                    (cls notNil
                    and:[ (privateClass := cls theNonMetaclass privateClassNamed:nameOfVariable) notNil ]) ifTrue:[
                        browserClass browseReferendsOf:(privateClass name)
                    ] ifFalse:[
                        |pool nsClass|

                        "/ is it a pool variable?
                        cls notNil ifTrue:[
                            pool := cls theNonMetaclass sharedPools
                                    detect:[:pool | pool classVarNames includes:nameOfVariable]
                                    ifNone:nil.
                        ].
                        pool notNil ifTrue:[
                            browserClass browseReferendsOf:(pool name,':',nameOfVariable)
                        ] ifFalse:[
                            (cls notNil
                              and:[ cls nameSpace notNil
                              and:[ nameOfVariable knownAsSymbol
                              and:[ cls nameSpace isNameSpace 
                              and:[(nsClass := cls nameSpace at:nameOfVariable asSymbol) notNil
                              and:[ nsClass isBehavior
                            ]]]]]) ifTrue:[
                                "/ a namespace class?
                                browserClass browseReferendsOf:nsClass name
                            ] ifFalse:[
                                "/ an instvar?
                                (cls notNil and:[cls allInstVarNames includes:nameOfVariable]) ifTrue:[
                                    browserClass 
                                        browseInstRefsTo:nameOfVariable 
                                        under:(cls whichClassDefinesInstVar:nameOfVariable) 
                                        modificationsOnly:false
                                ] ifFalse:[
                                    "/ no, assume global
                                    browserClass browseReferendsOf:nameOfVariable
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        ].
    ].

    "Created: / 05-11-2001 / 17:32:23 / cg"
    "Modified: / 30-03-2016 / 20:33:17 / cg"
!

browseSendersOfIt
    "open a browser on the senders of the selected text"

    |selectedText selector|

    selectedText := self selectedTextOrSyntaxElement.
    selectedText notEmptyOrNil ifTrue:[
	self windowGroup withWaitCursorDo:[
	    selector := SystemBrowser extractSelectorFrom:selectedText.
	    (UserPreferences systemBrowserClass)
		browseAllCallsOn:(selector ? selectedText)
	]
    ].

    "Created: / 5.11.2001 / 17:32:23 / cg"
    "Modified: / 19.11.2001 / 22:15:27 / cg"
!

browseSharedPoolOfIt
    "open a browser on the shared pool in which the selected variable is"

    |sel|

    sel := self selectedTextOrSyntaxElement.
    sel notEmptyOrNil ifTrue:[
        sel := sel asSymbol.
        self windowGroup withWaitCursorDo:[
            SharedPool allSubclassesDo:[:eachPool |
                (eachPool includesKey:sel) ifTrue:[
                    eachPool class browse:#initialize
                ].
            ].
        ].
    ].

    "Created: / 15-01-2011 / 14:01:39 / cg"
!

doIt
    "user selected 'doIt' from menu; show a wait-cursor, evaluate the code
     and finally restore cursor; return result of evaluation"

    ^ self
	do:(self selectionOrTextOfCursorLine)
	withValueDo:nil

    "Modified: / 16.5.1998 / 16:45:01 / cg"
!

editMenu
    "return my popUpMenu; that's the superclasses menu
     PLUS st-evaluation items: doIt, printIt and inspectIt."

    <resource: #keyboard (#DoIt #PrintIt #InspectIt
                          #CommentSelection #UncommentSelection
                          #BrowseIt #ImplementorsOfIt
                         )>
    <resource: #programMenu>

    |m sub subsub idx sensor sel2 sel selectedSymbol|

    m := super editMenu.
    ((sensor := self sensor) notNil and:[sensor ctrlDown and:[sensor shiftDown not]]) ifTrue:[
        sub := m.
        m := nil.
    ] ifFalse:[
        sub := m subMenuAt:#others.
    ].

    sub notNil ifTrue:[
        "
         workspaces support #browse, implementors etc. add them after paste.
        "
        sub
            addItemList:#(
                ('-'                                                                        )
                ('Browse It'                    browseIt                BrowseIt            )
                ('Browse Pool'                  browseSharedPoolOfIt                        )
                ('Senders of It'                browseSendersOfIt                           )
                ('Implementors of It'           browseImplementorsOfIt  ImplementorsOfIt    )
                ('References to It'             browseReferencesToIt                        )
"/                ('Classes Containing It in Name'    browseClassesContainingItInName           )
"/                ('Methods Contaníning It in Name'   browseMethodsContainingItInName           )
"/                ('Methods Contaníning It in Source' browseMethodsContainingItInSource         )
                ('-'                                                                )
                ('TimeIt'               timeIt                                      )
                ('SpyOnIt'              spyOnIt                                     ))
          resources:resources
          after:#gotoLine.

        subsub := sub subMenuAt:#tools.
        subsub notNil ifTrue:[
            subsub
                addItemList:#(
                    ('-'                                                                )
                    ('CommentIt'            commentSelection        CommentSelection    )
                    ('UncommentIt'          uncommentSelection      UncommentSelection  ))
                resources:resources
                after:#'indent'.
            subsub
                addItemList:#(
                    ('Inspect Instances'       inspectInstances          nil)       
                )
                resources:resources  

                after:#inspectString.
                
            (self hasSelection not
            or:[ (sel := self selectionAsString asSymbolIfInterned) isNil
            or:[ (Smalltalk at:sel) isBehavior not ]]) ifTrue:[
                sub disable:#inspectInstances
            ].    
        ].

        self hasSelection ifFalse:[
            sub disableAll:#(browseImplementorsOfIt browseSendersOfIt
                             browseReferencesToIt timeIt spyOnIt
                             browseSharedPoolOfIt browseIt inspectInstances).
            self supportsSyntaxElements ifTrue:[
                self syntaxElementForSelectorUnderCursor notNil ifTrue:[
                    sub enableAll:#(browseImplementorsOfIt browseSendersOfIt )
                ] ifFalse:[
                    |el|

                    (el := self syntaxElementForVariableUnderCursor) notNil ifTrue:[
                        (el isGlobal or:[el isInstanceVariable]) ifTrue:[
                            sub enable: #browseReferencesToIt
                        ].
                        el isClass ifTrue:[
                            sub enable:#browseIt
                        ]
                    ]
                ]
            ].
        ] ifTrue:[
            sel := self selectionAsString.
            sel notNil ifTrue:[
                sel asSymbolIfInterned isNil ifTrue:[
                    sel2 := SystemBrowser extractSelectorFrom:sel.
                    sel2 notNil ifTrue:[
                        sel2 := sel2 asSymbolIfInterned.
                    ].
                ].
            ].
            (sel2 isNil and:[sel isNil]) ifTrue:[
                sub disableAll:#(browseImplementorsOfIt browseSendersOfIt).
            ].
            "/ a global or namespace-var selected ?
            sel isNil ifTrue:[
                sub disable:#browseReferencesToIt.
            ] ifFalse:[
                (sel startsWith:'#') ifTrue:[
                    "/ a symbol selected - can search references
                ] ifFalse:[
                    selectedSymbol := sel asSymbolIfInterned.
                    (selectedSymbol notNil
                     and:[(Smalltalk includesKey:selectedSymbol)
                          or:[(NameSpace allNameSpaces contains:[:ns | ns includesKey:selectedSymbol]) ]]
                    ) ifTrue:[
                        "/ a global or namespace var selected
                    ] ifFalse:[
                        |cls|

                        cls := self editedClass.
                        cls notNil ifTrue:[
                            cls := cls theNonMetaclass.
                            ((cls allClassVarNames includes:sel)
                              or:[ (cls theNonMetaclass privateClassNamed:sel) notNil]) ifTrue:[
                                "/ a classvar or private class
                            ] ifFalse:[
                                |pool|
                                "/ is it a pool variable?
                                pool := cls sharedPools
                                        detect:[:pool | pool classVarNames includes:sel]
                                        ifNone:nil.
                                pool isNil ifTrue:[
                                    "/ todo: an instvar selected?
                                    (cls allInstVarNames includes:sel) ifFalse:[
                                        sub disable:#browseReferencesToIt.
                                    ].
                                ].
                            ].
                        ] ifFalse:[
                            sub disable:#browseReferencesToIt.
                        ].
                    ].
                ].
            ].
            (selectedSymbol notNil
             and:[SharedPool allSubclasses contains:[:pool | pool includesKey:selectedSymbol]]) ifFalse:[
                sub disable:#browseSharedPoolOfIt.
            ].
        ].
        self isReadOnly ifTrue:[
            sub disableAll:#(commentSelection uncommentSelection)
        ].
    ].

    m notNil ifTrue:[
        "
         workspaces support #doIt, #printIt and #inspectIt
         add them after paste.
        "
        idx := m indexOf:#paste.
        idx == 0 ifTrue:[idx := m indexOf:#pasteOrReplace].
        idx ~~ 0 ifTrue:[
            m
              addItemList:#(
                ('-'                                )
                ('DoIt'         doIt        DoIt     )
                ('PrintIt'      printIt     PrintIt  )
                ('InspectIt'    inspectIt   InspectIt))
              resources:resources
              after:idx.

        ].

        (self hasSelectionOrTextInCursorLine) ifFalse:[
            |lNr line|

            lNr := self cursorLine.
            line := self listAt:lNr.
            line isEmptyOrNil ifTrue:[
                m disableAll:#(printIt doIt inspectIt browseIt)
            ].
        ].
        self isReadOnly ifTrue:[
            m disable:#printIt
        ].
    ].

    ^ m ? sub.

    "Modified: / 22-04-1998 / 21:49:06 / ca"
    "Modified: / 20-12-2011 / 11:22:20 / cg"
!

inspectInstances
    |nameOfVariable cls insts|
    
    nameOfVariable := self selectedTextOrSyntaxElement.
    nameOfVariable isEmptyOrNil ifTrue:[^ self].
    nameOfVariable := nameOfVariable asSymbolIfInterned.
    nameOfVariable isNil ifTrue:[^ self].
    cls := Smalltalk at:nameOfVariable.
    cls isNil ifTrue:[^ self].
    cls isBehavior ifFalse:[^ self].
    insts := cls allInstances.
    insts isEmpty ifTrue:[
        Dialog information:(resources string:'No instances of %1' with:nameOfVariable).
        ^ self.
    ].    
    insts inspect.
!

inspectIt
    "user selected 'inspectIt' from menu; use doIt to evaluate the code
     and start an inspector on the result"

    |shifted|

    shifted := self sensor shiftDown.

    ^ self
	do:(self selectionOrTextOfCursorLine)
	withValueDo:[:result | shifted ifTrue:[result basicInspect] ifFalse:[result inspect] ]

    "Modified: / 16.5.1998 / 16:44:56 / cg"
!

printIt
    "user selected 'printIt' from menu; use doIt to evaluate the code
     and insert result of evaluation into my text.
     If the text is readOnly, do nothing."

    self isReadOnly ifTrue:[
        self beep.
        ^ self.
    ].
    self
        undoableDo:[
            self
                do:(self selectionOrTextOfCursorLine)
                withValueDo:[:result |
                    |s printer lang|

                    self cursorLine:selectionEndLine col:(selectionEndCol + 1).
                    "/ give the language a chance to generate a printString for that value
                    lang := self editedLanguage.
                    (lang notNil and:[(printer := lang valuePrinterClass) notNil]) ifTrue:[
                        s := printer printStringForPrintItOf:result
                    ] ifFalse:[
                        result isProtoObject ifTrue:[
                            s := result displayString.
                        ] ifFalse:[
                            (result isInteger
                             and:[ result > 10
                             and:[ InspectorView defaultIntegerDisplayRadix ~= 10]]) ifTrue:[
                                s := result displayString , ' "',(result radixPrintStringRadix: InspectorView defaultIntegerDisplayRadix),'"'.
                            ] ifFalse:[
                                s := result printStringForPrintIt "old: displayString" "very old: printString"
                            ].
                        ]
                    ].
                    
                    self withAutoIndent:false do:[ 
                        "/ if the returned string starts with a newLine,
                        "/ insert as a bunch of lines after the cursor line.
                        (s size > 0 and:[s startsWith:(Character cr)]) ifTrue:[
                            |cursorLine cursorCol lines|
                            
                            cursorLine := self cursorLine.
                            cursorCol := self cursorCol.
                            lines := s asStringCollection copyFrom:2.
                            self insertLines:lines before:cursorLine+((cursorCol == 1) ifTrue:0 ifFalse:1).
                            self selectFromLine:cursorLine+1 toLine:cursorLine+lines size.
                        ] ifFalse:[    
                            self insertSelectedStringAtCursor:s 
                        ]
                    ]
                ]
        ]
        info:'PrintIt'

    "Modified: / 08-03-2012 / 16:14:34 / cg"
!

profileIt
    "user selected 'profileIt' from menu; show a wait-cursor, profile the code
     and finally restore the cursor. Open a visual profiler on the sample data."

    self spyOnItUsing:Tools::Profiler
!

replaceIt
    "like printIt, but replace the selection with the result, instead of
     pasting it after the selection."

    self isReadOnly ifTrue:[
	self beep.
	^ self
    ].

    self
	undoableDo:[
	    self
		do:(self selectionOrTextOfCursorLine)
		withValueDo:[:result |
		    self replaceSelectionBy:(result displayString "printString")
		].
		undoSupport actionInfo:'ReplaceIt'.
	]
	info:'ReplaceIt'

    "Created: / 08-11-2007 / 11:31:54 / cg"
!

spyOnIt
    "user selected 'spyOnIt' from menu; show a wait-cursor, evaluate the code
     and finally restore the cursor. Show profile data on the Transcript"

    self spyOnItUsing:MessageTally
!

spyOnItUsing:aProfiler
    "common code for spyOnIt / profileIt.
     Show a wait-cursor, evaluate the code with profier on it,
     and finally restore the cursor. Show profile data as per profiler"

    |code codeToRun|
        
    codeToRun := self selectionOrTextOfCursorLine.
    (codeToRun isEmptyOrNil or:[codeToRun isBlank]) ifTrue:[^ self].
    
    compilerClass == (Smalltalk at:#Compiler) ifFalse:[
        "sigh - this measurement will include the time to compile - sigh"
        aProfiler spyDetailedOn:[ self doIt ].
        ^ self.
    ].

    code := aProfiler name,' spyDetailedOn:[' , codeToRun, ']'.
    self do:code withValueDo:[:value| ].
!

timeIt
    "user selected 'timeIt' from menu; show a wait-cursor, evaluate the code
     and finally restore cursor; return result of evaluation"

    |code|

    compilerClass == (Smalltalk at:#Compiler) ifFalse:[
        "sigh - this measurement will include the time to compile - sigh"
        [ self doIt ] benchmark:'execution time: '.
        ^ self.
    ].

    code := '[' , self selectionAsString, '] benchmark:''execution time: '''.
    self do:code withValueDo:[:value | ].

    "Modified: / 22-04-1998 / 22:03:51 / ca"
    "Modified (format): / 02-06-2012 / 00:38:51 / cg"
! !

!Workspace methodsFor:'misc'!

expandAbbreviation
    "after receiving an Alt-shift key-event, look for the string before the
     cursor, find an abbrev for it and expand."

    |expandedString abortExpandAction oldSelectionStartLine oldSelectionStartCol oldSelectionEndLine oldSelectionEndCol oldCursorLine oldCursorCol
     newCursorPos replStartCol|

    oldCursorLine := self cursorLine.
    oldCursorCol := self cursorCol.
    oldSelectionStartLine := self selectionStartLine.
    oldSelectionStartCol := self selectionStartCol.
    oldSelectionEndLine := self selectionEndLine.
    oldSelectionEndCol := self selectionEndCol.

    abortExpandAction :=
	[
	    self
		selectFromLine:oldSelectionStartLine col:oldSelectionStartCol
		toLine:oldSelectionEndLine col:oldSelectionEndCol.
	    self cursorLine:oldCursorLine col:oldCursorCol.
	].

    expandedString := self selectAbbreviationKeyBeforeCursor. "/ returns the new string AND selects the key
    expandedString isNil ifTrue:[
	abortExpandAction value.
	^ self
    ].
    newCursorPos := expandedString indexOf:$!!.
    newCursorPos ~~ 0 ifTrue:[
	expandedString := expandedString copyWithout:$!!.
    ].
    replStartCol := self selectionStartCol.
    self
	undoableDo:[
	    self replaceSelectionBy: expandedString
	]
	info:'Replace'.

    newCursorPos == 0 ifTrue:[
	"/ cursor already fine (at the end)
    ] ifFalse:[
	self cursorCol:replStartCol+newCursorPos-1
    ]
!

findAbbreviationKeyBeforeCursor
    "after receiving an Alt-shift key-event, look for the string before the
     cursor, find an abbrev for it, return the key and the abbreviation for it.
     If none is found, return nil"

    |snippets keys minMax maxKeyLen minKeyLen stringBeforeCursor|

    snippets := self class snippets.
    keys := snippets keys.

    minMax := (keys collect:[:k | k size]) minMax.
    minKeyLen := minMax first.
    maxKeyLen := minMax second.

    stringBeforeCursor := self lineStringBeforeCursor.
    maxKeyLen := maxKeyLen min:stringBeforeCursor size.

    maxKeyLen to:minKeyLen by:-1 do:[:keyLen |
        |lCharactersBeforeCursor expandedString|

        lCharactersBeforeCursor := stringBeforeCursor last:keyLen.
        expandedString := snippets at:lCharactersBeforeCursor ifAbsent:nil.
        expandedString notNil ifTrue:[
            ^ { lCharactersBeforeCursor . expandedString withCRs }
        ].
    ].
    ^ nil.

    "Modified: / 29-10-2010 / 10:22:38 / cg"
!

selectAbbreviationKeyBeforeCursor
    "after receiving an Alt-shift key-event, look for the string before the
     cursor, find an abbrev for it, select it and return the abbreviation for it.
     If none is found, do not select and return nil"

    |keyAndSnippet snippet key|

    (keyAndSnippet := self findAbbreviationKeyBeforeCursor) notNil ifTrue:[
	key := keyAndSnippet first.
	snippet := keyAndSnippet second.
	self selectFromLine:cursorLine col:cursorCol-key size toLine:cursorLine col:cursorCol-1.
	^ snippet
    ].
    ^ nil.

    "Modified: / 29-10-2010 / 10:22:38 / cg"
!

selectedTextOrSyntaxElement
    |selectedText el|

    selectedText := self selectionAsString.
    selectedText isEmptyOrNil ifTrue:[
        el := self syntaxElementUnderCursor.
        el notNil ifTrue:[ selectedText := el value ].
    ].
    ^ selectedText
!

syntaxElementForSelectorUnderCursor
    "we do not support syntax elements, but subclasses may do"

    ^ nil
!

syntaxElementUnderCursor
    "we do not support syntax elements, but subclasses may do"

    ^ nil
! !

!Workspace methodsFor:'queries'!

isWorkspace
    "back-query from the compiler to ask if this is an interactive view
     (for error feedback)"

    ^ true

    "Modified (comment): / 07-03-2012 / 17:52:59 / cg"
!

showLineLimitInMenu
    ^ false.
! !

!Workspace class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


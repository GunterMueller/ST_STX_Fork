"
 COPYRIGHT (c) 1995 by AEG Industry Automation
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic3' }"

"{ NameSpace: Smalltalk }"

Object subclass:#HistoryManager
	instanceVariableNames:'historyMode fullHistoryUpdate'
	classVariableNames:'TheOneAndOnlyInstance EnforcedUserName'
	poolDictionaries:''
	category:'System-Changes-History'
!

Object subclass:#HistoryLine
	instanceVariableNames:'date time user what firstPositionInSourceCode type'
	classVariableNames:'Quote Separator ModifiedString DeletedString IndentString
		UseGECOS CreatedString AddedString EnforcedUserName
		FormattedString CommentedString VariableRenamedString'
	poolDictionaries:''
	privateIn:HistoryManager
!

!HistoryManager class methodsFor:'documentation'!

copyright 
"
 COPYRIGHT (c) 1995 by AEG Industry Automation
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    This class is part of the HistoryManagerProject.
    It helps to keep track of changes made to methods.

    All Methods and Classes in the system get a HistroyLine which 
    contains a timestamp and the name of the changing user. 
    This is acually the Unix loginname.

    The Manager registers itself to get notifications 
    on change, intercepts them and appends a historyLine to the methods
    code.

    The HistoryManager can be turned on/off from a private.rc script,
    or via the Launcher menu.

    The method's history line is filtered, to only contain one
    entry per modifying user, containing the date of the last change.
    If fullHistoryMode is on, the classes history-ethod is also updated for
    every change (containing every change).
    Full mode is enabled via:
        HistoryManager fullHistoryUpdate:true
    or via the Launchers compilation-settings dialog.

    claus:
        I changed things to avoid depending on every class in the system.
        Now also catch Smalltalk change messages, related to class changes.

    [author:]
        Robert Sailer - AEG

    [see also:]
        HistoryLine

    [start with:]
         HistoryManager activate
         HistoryManager deactivate

"
! !

!HistoryManager class methodsFor:'initialization'!

enforcedUserName
    ^ EnforcedUserName
!

enforcedUserName:aStringOrNil
    EnforcedUserName := aStringOrNil

    "
     self enforcedUserName:'fm'
     self enforcedUserName:nil
    "
!

initMe
    "setup theOneAndOnly instance of myself (if not already present"

    ^self new.

    "Modified: 14.8.1995 / 09:02:00 / robert"
    "Modified: 20.4.1996 / 20:33:44 / cg"
!

initialize
    "add myself as a dependent of ObjectMemory to be told about image restarts"

    ObjectMemory addDependent: self.

    "Modified: / 14-08-1995 / 09:09:06 / robert"
    "Modified: / 05-07-2006 / 17:36:47 / cg"
! !

!HistoryManager class methodsFor:'instance creation'!

new
    "because there can be only ONE HistoryManager, new must me redefiend"

    TheOneAndOnlyInstance isNil ifTrue:[
        TheOneAndOnlyInstance := self basicNew initialize.
        HistoryLine initialize.
    ].

   ^ TheOneAndOnlyInstance

"

    HistoryManager new.
"

    "Modified: / 11-08-1995 / 17:01:29 / robert"
    "Modified: / 04-12-2011 / 08:54:22 / cg"
! !

!HistoryManager class methodsFor:'accessing'!

fullHistoryUpdate
    "return true, if the historyManagement does full updates"

    TheOneAndOnlyInstance isNil ifTrue:[^ false].
    ^ TheOneAndOnlyInstance fullHistoryUpdate

    "Modified: / 27.8.1995 / 00:32:12 / claus"
    "Created: / 24.10.1997 / 02:24:34 / cg"
    "Modified: / 29.10.1997 / 15:48:22 / cg"
!

fullHistoryUpdate:aBoolean
    "set/clear, full updates"

    TheOneAndOnlyInstance isNil ifTrue:[^ self].
    TheOneAndOnlyInstance fullHistoryUpdate:aBoolean

    "Modified: / 27.8.1995 / 00:32:12 / claus"
    "Created: / 24.10.1997 / 02:24:58 / cg"
    "Modified: / 29.10.1997 / 15:48:36 / cg"
!

instance
    "return the one and only historyManager instance"

    ^ TheOneAndOnlyInstance

    "Modified: 20.4.1996 / 20:31:18 / cg"
!

isActive 
    "return true, if the historyManagement is activated"

    ^ TheOneAndOnlyInstance notNil

    "Modified: 27.8.1995 / 00:32:12 / claus"
    "Modified: 20.4.1996 / 20:31:32 / cg"
! !

!HistoryManager class methodsFor:'activation / deactivation'!

activate
    "activate the HistoryManagement"

    self new   "/ creating an instance activates me

    "
     HistoryManager activate
    "

    "Modified: 20.4.1996 / 20:31:46 / cg"
!

deactivate
    "deactivate the HistoryManagement"

    |mgr|

    mgr := TheOneAndOnlyInstance.
    mgr notNil ifTrue:[
        mgr releaseDependencies.
    ].
    TheOneAndOnlyInstance := nil.

    "
     HistoryManager deactivate
    "

    "Modified: 8.1.1997 / 23:09:08 / cg"
! !

!HistoryManager class methodsFor:'change & update'!

update:what with:aParameter from:changedObject
    "intercepts system restart - reinstall mySelf as dependent of all classes"

    (what == #restarted) ifTrue:[
        TheOneAndOnlyInstance notNil ifTrue:[
            "
             smalltalk is about to restart from an Image -
            "
"/            'HistoryManager initialize (via update)' infoPrintNL.
            self initMe.
        ]
    ].

    "Modified: 27.8.1995 / 16:33:02 / claus"
    "Modified: 20.4.1996 / 20:33:02 / cg"
    "Created: 15.6.1996 / 15:25:53 / cg"
! !

!HistoryManager class methodsFor:'helpers'!

codeForInitialHistoryMethodIn:aClass
    "create an initial (empty) history method"

    |histStream|

    histStream := '' writeStream.
    histStream nextPutLine:'history'.
    histStream nextPutLine:(HistoryLine newCreated printString).
    ^ histStream contents
!

createInitialHistoryMethodIn:aClass
    <resource: #obsolete>
    "create an initial (empty) history method"

    self obsoleteMethodWarning.
    SmalltalkCodeGeneratorTool
        compile:(self codeForInitialHistoryMethodIn:aClass)
        forClass:aClass 
        inCategory:'documentation'.

    "Created: / 24-10-1997 / 02:41:43 / cg"
    "Modified: / 31-01-2011 / 18:28:51 / cg"
!

getAllHistoriesFrom:someString
    "returns anArray of HistoryLines from a string.
     Usually, the argument is a methods source code."

    |position aReadWriteStream firstFound nextFound  aHistoryString rcOC h|

    rcOC := OrderedCollection new.

    someString isNil ifTrue:[
        ^ rcOC
    ].

    "read begining from the end and look there for the first comment character. If there's none return"

    position := someString size.
    firstFound := false.
    nextFound := false.

    someString reverseDo:[ :aChar|
        position := position - 1.
        aChar == $" ifTrue:[
            firstFound ifTrue:[
                firstFound := false.
                nextFound := true.
            ] ifFalse:[
                aReadWriteStream := ReadWriteStream on: (someString species) new.
                firstFound := true.
                nextFound := false.
            ].
        ].
        (firstFound and: [nextFound not]) ifTrue:[
            "now collect all up to the next comment character"
            aChar == $" ifFalse:[     
                aReadWriteStream nextPut: aChar.
            ].
        ].
        nextFound ifTrue:[
            "End reached - now try to make a HistoryLine"
            aHistoryString := (aReadWriteStream contents) reverse.
            "
                Transcript showCR: aHistoryString.
            "
            h := HistoryLine fromString: aHistoryString at: position.
            h notNil ifTrue:[
                rcOC add:h.
            ].
"/            (aHistoryString startsWith: 'Modified:') ifTrue:[
"/                "a history line was found - now make a NewInstance of HistoryLine"
"/                rcOC add: ( HistoryLine fromString: aHistoryString at: position).
"/            ].
            nextFound := false.
        ].
    ].

    ^rcOC reverse  "the OrderedCollection with HistoryLines in the right order"

    "Modified: / 21-12-1993 / 18:32:30 / M.Noell"
    "Modified: / 09-08-1995 / 22:45:30 / R.Sailer"
    "Modified: / 08-09-1995 / 17:54:33 / claus"
    "Modified: / 18-09-2006 / 20:48:19 / cg"
!

getLastHistoryLineFrom:someString
    "returns the last HistoryLine, if no HistoryLine available, return nil"

    |hist|

    hist := self getAllHistoriesFrom: someString.
    hist isEmpty ifTrue: [ ^ nil].
    ^ hist last

    "Created: 19.1.1996 / 13:08:57 / werner"
!

withoutHistoryLines:someString
    "given some methods sourceString, return a copy without any
     history lines"

    | pos sourceCode previousHistories |

    someString isNil ifTrue:[^ someString].

    previousHistories := self getAllHistoriesFrom:someString.

    "extract source body."
    previousHistories isEmpty ifTrue: [
        sourceCode := someString withoutSeparators.
    ] ifFalse: [
        pos := (previousHistories first) firstPositionInSourceCode.
        sourceCode := (someString copyFrom: 1 to: pos - 1) withoutSeparators.
    ].

    ^ sourceCode

    "
     HistoryManager withoutHistoryLines:nil  
     HistoryManager withoutHistoryLines:''  
     HistoryManager 
        withoutHistoryLines:(HistoryManager class 
                                compiledMethodAt:#withoutHistoryLines:) source
    "

    "Created: 5.3.1996 / 15:11:12 / cg"
    "Modified: 30.4.1996 / 10:57:35 / cg"
! !

!HistoryManager methodsFor:'accessing'!

fullHistoryUpdate
    "return the fullHistoryUpdate; 
     if true, the classes history method is also updated."

    ^ fullHistoryUpdate

    "Modified: 11.08.1995 / 16:52:12 / robert"
!

fullHistoryUpdate:aBoolean
    "set the fullHistoryUpdate; 
     if true, the classes history method is also updated."

    fullHistoryUpdate := aBoolean.

    "Modified: 11.08.1995 / 16:52:12 / robert"
!

historyMode
    "return historyMode"

    ^ historyMode

    "Modified: 11.08.1995 / 16:51:56 / robert"
!

historyMode:something
    "set historyMode"

    historyMode := something.

    "Modified: 11.08.1995 / 16:52:12 / robert"
! !

!HistoryManager methodsFor:'change & update'!

update:something with:someArgument from:changedObject
    "arrive here, whenever any class changed somehow.
     (something contains aSymbol describing what happened)"

    |selector oldMethod changedClass whatChange|

    something == #methodCoverageInfo ifTrue:[^ self].
    something == #methodTrap ifTrue:[^ self].

    "/
    "/ no action, if disabled
    "/
    historyMode ifFalse:[
        ^ self
    ].

    "/
    "/ no action, if changeFile update is locked
    "/ (since then, this may be a recompile or fileIn)
    "/
    (Class updateChangeFileQuerySignal query) ifFalse:[ 
"/        Transcript showCR: '* noChange in history'. 
        ^ self 
    ].
    Class updateHistoryLineQuerySignal query ifFalse:[ 
"/        Transcript showCR: '* noChange in history'. 
        ^ self 
    ].

    "                  
     definition, instance / classVariables of a class have changed
    "
    (something == #definition) ifTrue:[
        "/ it is a class definition that has changed
        "/ add a line to the history method; if present
        self updateAfterClassChange:'class definition' in:changedObject.
        ^ self
    ].

    "this is a sub item of #definition"    
    (something == #classVariables) ifTrue:[
        self updateAfterClassChange:'class variables' in:changedObject.
        ^ self
    ].    

    "/
    "/ new Class creation
    "/
    ((changedObject == Smalltalk) and:[something == #newClass]) ifTrue:[
        "/ 
        "/  add myself as dependents in order to get future change notifications
        "/ 
        fullHistoryUpdate == true ifTrue:[
            someArgument theMetaclass compilerClass == Compiler ifFalse:[^ self].
            self createHistoryMethodFor:someArgument.
            self addHistory:#creation with:nil toHistoryMethodOf:someArgument.
        ].

        "/ claus: old implementation

"/        someArgument addDependent: self.
"/        someArgument class addDependent: self.   "for class methods"

        ^ self
    ].

    "/ changed methods
    "/ for backward compatibility, still handle the
    "/ classes own change notification.
    "/ (only if I am a dependent of all classes)

    changedObject isBehavior ifTrue:[
        changedClass := changedObject.
        changedClass theMetaclass compilerClass == Compiler ifFalse:[^ self].

        something == #methodDictionary ifTrue:[
            whatChange := #methodDictionary.

            someArgument isArray ifTrue:[
                selector := someArgument at:1.
                oldMethod := someArgument at:2
            ] ifFalse:[
                selector := someArgument
            ].
        ].

        something == #methodInClassRemoved ifTrue:[
            fullHistoryUpdate == true ifTrue:[
                changedClass := someArgument at:1.
                selector := someArgument at:2.
                self addHistory:#deletion with:('#' , selector) toHistoryMethodOf:changedClass.
            ].
            ^ self.
        ].

        something == #comment ifTrue:[
            whatChange := #comment.
        ].
    ].

    "/ the new mechanism; I only need to depend upon
    "/ Smalltalk, to get all method changes

    (changedObject == Smalltalk and:[something == #methodInClass]) ifTrue:[
        changedClass := someArgument at:1.
        selector := someArgument at:2.
        oldMethod := someArgument at:3.
        whatChange := #methodDictionary.
    ].

    changedClass notNil ifTrue:[
        changedClass theMetaclass compilerClass == Compiler ifFalse:[^ self].

        whatChange == #methodDictionary ifTrue:[
            "/ ok; it is a changed method
            self updateAfterMethodChange:selector from:oldMethod in:changedClass.
            ^self
        ]. 

        whatChange == #comment ifTrue:[
            "the classes comment - we are no longer interested in that one"
            ^ self.
        ].

        whatChange == #classDefinition ifTrue:[
            "/ it is a class definition that has changed
            "/ add a line to the history method; if present
            self updateAfterClassChange:'class definition' in:changedClass.
            ^self
        ].
    ].
"/    Transcript show: 'unhandled change: ', something printString;cr.

    ^self

    "Created: / 30-06-2011 / 16:43:46 / cg"
!

updateAfterClassChange:whatChange in:aClass 
    "/ it is a class definition that has changed
    "/ add a line to the history method; if present
    "/        Transcript show: 'Class definition: ', changedClass printString;cr.
    
    fullHistoryUpdate == true ifTrue:[
        "/ check for the programming-language...
        aClass theMetaclass compilerClass == Compiler ifFalse:[
            ^ self
        ].
        self 
            addHistory:#modification
            with:whatChange
            toHistoryMethodOf:aClass.
    ].

    "Modified (Format): / 30-06-2011 / 16:27:23 / cg"
    "Created: / 30-06-2011 / 16:28:22 / cg"
!

updateAfterMethodChange:selector from:oldMethod in:changedClass
    |newSource newSourceWithoutHistory newHistories newMethod newTree newComments
     oldSource oldSourceWithoutHistory oldHistories oldTree oldComments
     renamedVariables
     whatChange pos|

    changedClass theMetaclass compilerClass == Compiler ifFalse:[^ self].
    (oldMethod notNil and:[oldMethod compilerClass ~~ Compiler]) ifTrue:[^ self].

    "/ ok; it is a changed method

    "/
    "/ fetch sourceString of the method
    "/
    newSource := changedClass sourceCodeAt:selector.
    newSource isNil ifTrue:[
        "method has been deleted"
"/                Transcript showCR: 'method has been deleted'.
        fullHistoryUpdate == true ifTrue:[
            self addHistory:#deletion with:('#' , selector) toHistoryMethodOf:changedClass.
        ].
        ^ self.
    ].
    newHistories := self class getAllHistoriesFrom:newSource.

    newMethod := changedClass compiledMethodAt:selector.
    newMethod compilerClass == Compiler ifFalse:[^ self].

    oldMethod isNil ifTrue:[
        whatChange := #creation.
        newHistories := OrderedCollection new.
    ] ifFalse:[
        whatChange := #modification.

        oldSource := oldMethod source.
        oldSource notNil ifTrue:[
            (oldSource asString withTabsExpanded = newSource asString withTabsExpanded) ifTrue:[
                 "/ no change (accepted same code again ?)
                ^ self
            ].

            oldHistories := self class getAllHistoriesFrom:oldSource.
            oldHistories notEmptyOrNil ifTrue: [
                "/ compare source without history...
                pos := (oldHistories first) firstPositionInSourceCode.
                oldSourceWithoutHistory := (oldSource copyFrom:1 to:pos - 1) withoutSeparators.
            ] ifFalse:[
                oldSourceWithoutHistory := oldSource
            ].

            newHistories notEmptyOrNil ifTrue: [
                "/ compare source without history...
                pos := (newHistories first) firstPositionInSourceCode.
                newSourceWithoutHistory := (newSource copyFrom:1 to:pos - 1) withoutSeparators.
            ] ifFalse:[
                newSourceWithoutHistory := newSource
            ].

            (oldSourceWithoutHistory asString withTabsExpanded = newSourceWithoutHistory asString withTabsExpanded) ifTrue:[
                 "/ no change (except for history lines)
                UserPreferences current historyManagerAllowEditOfHistory ifFalse:[
                    newMethod source: oldSource.
                ].
                ^ self
            ].

            RBParser notNil ifTrue:[
                "/ same structure?
                oldTree := RBParser parseMethod:oldSourceWithoutHistory onError:[:aString :pos | nil].
                newTree := RBParser parseMethod:newSourceWithoutHistory onError:[:aString :pos | nil].
                (oldTree notNil 
                and:[newTree notNil
                and:[oldTree equalTo:newTree withMapping:(renamedVariables := Dictionary new)]]) ifTrue:[
                    "/ only formatting?
                        (renamedVariables keysAndValuesSelect:[:k :v | k ~= v]) isEmpty ifTrue:[
                        "/ only formatting...
                        whatChange := #formatted.
                        oldComments := oldTree allComments.
                        newComments := newTree allComments.
                        (oldComments size ~= newComments size
                        or:[ oldComments with:newComments contains:[:ca :cb | ca characters ~= cb characters]]) ifTrue:[
                            whatChange := #commented.
                        ].
                    ] ifFalse:[
                        renamedVariables := renamedVariables associations select:[:assoc | assoc key ~= assoc value].
                        "/ should figure out, if only local vars have been renamed;
                        "/ could make it a nicer modified(var names) then
                        "/ renamedVariables halt.    
                    ]
                ]
            ]
        ]
    ].

    "/
    "/ don't add historylines to documentation methods on the class side...
    "/
    (changedClass isMeta 
    and:[newMethod category = 'documentation']) ifFalse:[
        "/
        "/ update the history line-comment in
        "/ the methods source
        "/            
        newSource := self addHistory:whatChange with:nil to:oldHistories inSource:newSource filter:true.
        newMethod source: newSource.
        "/ Transcript showCR: 'history updated / added'.
    ].

    fullHistoryUpdate == true ifTrue:[
        self addHistory:whatChange with:('#' , selector) toHistoryMethodOf:changedClass.
    ].

    "Created: / 30-06-2011 / 16:51:19 / cg"
    "Modified: / 02-10-2012 / 13:22:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!HistoryManager methodsFor:'initialization'!

exclude
    "public - return an exclusionlist for some smalltalk classes which should not be notified or historisized"

    | oc |
        
    oc := OrderedCollection new.
    oc add: self.

    ^oc

    "Modified: 11.08.1995 / 17:02:18 / robert"
!

initialize
    "public - make me depend on all smalltalk classes (except the exclusionList)
     to be notified later about changes. This intercepts source installation and allows
     be to patch the source-string with a historyLine."

    |exclusionlist|

    super initialize.
    historyMode := true.
    fullHistoryUpdate := false.
    exclusionlist := self exclude.

    "/ old implementation:
    "/ made myself a dependent of all classes ...

"/    Smalltalk allClassesDo:[:aClass|
"/        "all classes should send a notification if changed"
"/        "aClass = self " false ifFalse: [
"/            (exclusionlist includes: aClass) ifFalse:[
"/                aClass addDependent: self.
"/                aClass class addDependent: self.   "for class methods"
"/            ].
"/        ].
"/    ].

    "/ old implementation:
    "/ Smalltalk also sends class-change notifications ...

    Smalltalk addDependent:self.

    ^self

    "Modified: 11.8.1995 / 17:12:51 / robert"
    "Modified: 8.1.1997 / 23:07:14 / cg"
!

releaseDependencies
    "no longer depend on class changes"

    "/ old implementation:
    "/ made myself a dependent of all classes ...

"/    Smalltalk allClassesDo:[:aClass |
"/        aClass removeDependent:self.
"/        aClass class removeDependent:self.
"/    ].

    "/ new implementation:
    "/ Smalltalk also sends class-change notifications ...

    Smalltalk removeDependent:self.
! !

!HistoryManager methodsFor:'updateHistory'!

addHistory:what with:argument to:someString filter:doFilter
    "private - add a historyLine at end to the sourceCode;
     check for multiple lines of the same user and merge into one.
     What may be one of #modification or #creation, to choose among
     'Modified' or 'Created' lines."

    |previousHistories|

    "Check whether we want a history to be added"    
    historyMode ifFalse:[
        ^ someString
    ].

    previousHistories := self class getAllHistoriesFrom:someString.
    ^ self addHistory:what with:argument to:previousHistories inSource:someString filter:doFilter

    "Modified: / 30-06-2011 / 16:54:27 / cg"
    "Modified (Format): / 30-06-2011 / 18:17:58 / cg"
!

addHistory:what with:argument to:previousHistories inSource:someString filter:doFilter
    "private - add a historyLine at end to the sourceCode;
     check for multiple lines of the same user and merge into one.
     What may be one of #modification or #creation, to choose among
     'Modified' or 'Created' lines."

    |histories histLines pos wStream sourceCode newLine |

    "Check whether we want a history to be added"    
    historyMode ifFalse:[
        ^ someString
    ].

    newLine := HistoryLine new.

    what == #creation ifTrue:[
        newLine isForCreation.
    ] ifFalse:[ what == #deletion ifTrue:[
        newLine isForDeletion.
    ] ifFalse:[ what == #addition ifTrue:[
        newLine isForAddition.
    ] ifFalse:[ what == #modification ifTrue:[
        newLine isForModification.
    ] ifFalse:[ what == #formatted ifTrue:[
        newLine isForFormatted.
    ] ifFalse:[ what == #commented ifTrue:[
        newLine isForCommented.
    ] ifFalse:[ what == #variableRenamed ifTrue:[
        newLine isForVariableRenamed
    ] ifFalse:[ 
        self breakPoint:#cg
    ]]]]]]].
    argument notNil ifTrue:[
        newLine what:argument
    ].

    "extract source body."
    histories := self class getAllHistoriesFrom:someString.
    histories isEmpty ifTrue: [
        sourceCode := someString withoutSeparators.
    ] ifFalse: [
        pos := (histories first) firstPositionInSourceCode.
        sourceCode := (someString copyFrom: 1 to: pos - 1) withoutSeparators.
    ].

    "add the actual user's historyLine."

    "JV@2012-04-03: Add previous histories if we are updating
     existing method (avoids having bogus entries when taking
     existing method as template and then accepting with a different
     selector and/or in a different class"
    what == #creation ifTrue:[
        histLines := OrderedCollection new.
    ] ifFalse:[
        histLines := (previousHistories ? histories).
    ].
    histLines add:newLine.

    doFilter ifTrue:[
        "Filtering historyLines (each user with one entry)."
        histLines := HistoryLine filterHistoryLines: histLines.
    ].

    "create new method body with added historyLine"
    wStream := WriteStream on: (sourceCode species) new.
    wStream nextPutAll: sourceCode; cr.

    "append the historyLines to the source"
    wStream cr.
    histLines do: [:hl |
       wStream nextPutLine:hl printString.
    ].

    ^ wStream contents.

    "Modified: / 30-06-2011 / 17:07:18 / cg"
    "Modified: / 03-04-2012 / 16:35:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 31-07-2012 / 13:31:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

addHistory:what with:arg toHistoryMethodOf:aClass
    "private - add a historyLine at end of the classes history methods
     source - if there is one"

    |meta historyMethod oldSource newSource|

    meta := aClass theMetaclass.

    historyMethod := meta compiledMethodAt: #history.
    historyMethod notNil ifTrue:[
        oldSource := historyMethod source.
        oldSource notNil ifTrue:[
            newSource := self 
                            addHistory:what
                            with:arg
                            to:oldSource
                            filter:true. 
            historyMethod source:newSource.
        ]
    ]

    "Created: / 12-10-1996 / 20:31:50 / cg"
    "Modified: / 01-09-2004 / 19:04:18 / janfrog"
    "Modified: / 13-07-2006 / 17:42:03 / cg"
!

createHistoryMethodFor:aClass
    "private - create a history method"

    |meta|

    meta := aClass theMetaclass.

    (Class updateChangeFileQuerySignal, Class updateChangeListQuerySignal) answer:false do:[
        Compiler
            compile:'history' 
            forClass:meta 
            inCategory:'documentation'
    ].

    "Modified (Format): / 30-06-2011 / 17:11:38 / cg"
    "Modified (Format): / 30-06-2011 / 17:11:42 / cg"
    "Modified (Format): / 30-06-2011 / 17:11:45 / cg"
    "Modified (Format): / 30-06-2011 / 17:11:47 / cg"
! !

!HistoryManager::HistoryLine class methodsFor:'converting'!

convertStringToDate: aString
    "kludge"

    | day month year words firstNumber |

    "delete delimiter from the date string"
    words := aString asCollectionOfSubstringsSeparatedByAny:'.-/'.

    "/ figure out if european or yyyy-mm-dd format
    firstNumber := Number readFromString:(words at: 1).
    firstNumber > 1900 ifTrue:[
        year := firstNumber.
        month := Number readFrom:(words at: 2 ) onError:nil.
        day := Number readFromString:(words at: 3 ).
    ] ifFalse:[
        day := firstNumber.
        month := Number readFrom:(words at: 2 ) onError:nil.
        year := Number readFromString:(words at: 3 ).
        (year between:0 and:99) ifTrue:[
            year := UserPreferences current twoDigitDateHandler value:year.
        ].
    ].
    month isNil ifTrue:[
        month := Date indexOfMonth:(words at:2) language:#en.
        month == 0 ifTrue:[
            month := Date indexOfMonth:(words at:2).
        ].
        month == 0 ifTrue:[
            self halt:'invalid month in history line'.
            ^ Date today.
        ].
    ].

    ^ Date  year:year month:month day:day.

    "
     HistoryLine convertStringToDate:'18.10.1995' 
     HistoryLine convertStringToDate:'18.10.95'    
     HistoryLine convertStringToDate:'18.10.01'    
     HistoryLine convertStringToDate:'2001-03-01'    
    "

    "Modified: / 23-08-1995 / 21:28:58 / robert"
    "Modified: / 16-09-1997 / 14:35:03 / stefan"
    "Created: / 06-03-2007 / 17:04:34 / cg"
    "Modified (Comment): / 30-06-2011 / 18:37:09 / cg"
!

convertStringToTime: aString
   "kludge"

    |h m s|

    h := Number readFromString:(aString copyFrom:1 to:2) onError:[^ Time now].
    m := Number readFromString:(aString copyFrom:4 to:5) onError:[^ Time now].
    aString size >= 8 ifTrue:[
        s := Number readFromString:(aString copyFrom:7 to:8).
    ] ifFalse:[
        s := 0.
    ].

    ^Time hours:h minutes:m seconds:s.

    "
     HistoryLine convertAStringToATime:'18:23:15' 
    "

    "Modified: / 15-08-1995 / 18:56:18 / robert"
    "Created: / 06-03-2007 / 17:05:03 / cg"
! !

!HistoryManager::HistoryLine class methodsFor:'documentation'!

copyright 
"
 COPYRIGHT (c) 1995 by AEG Industry Automation
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    The class HistoryLine is part of the HistoryManagerProjcet.

    HistoryLine knows how to compose and parse comment lines which are
    used to keep track of changes. These historyLines are added at the end of
    a methods source code and to the special history classmethod.

    HistoryLine and HistoryManager where generously provided by AEG for inclusion into the
    ST/X class delivery.

    [see also:]
        HistoryManager

    [author:]
        Robert Sailer - AEG
"
!

examples
"
    HistoryLine initialize.

    HistoryLine new.

    HistoryLine for: 'R.Sailer'.    for integration purposes ONLY

    HistoryLine deleted.
"
!

version
    ^ '$Header$'
! !

!HistoryManager::HistoryLine class methodsFor:'filtering'!

filterHistoryLines:aCollectionOfHistoryLines
    "check the collection against multiple occurrence of the same user,
     and remove all but the youngest (per user)."

    |newCollection skipNext|

    skipNext := false.
    newCollection := OrderedCollection new.
    aCollectionOfHistoryLines keysAndValuesDo:[:index :histLine |
        |skip|

        skip := skipNext.
        skipNext := false.
        histLine isKindOfModified ifTrue:[
            aCollectionOfHistoryLines do: [:anotherHistLine |
                (anotherHistLine isCreated and: [anotherHistLine user = histLine user])
                ifTrue: [
                    (self timeIsShortFrom:histLine to:anotherHistLine) ifTrue: [skip := true]
                ]
            ].

            skip ifFalse: [
               "/ if there is another one, skip this
                aCollectionOfHistoryLines from:index+1 do:[:anotherHistLine |
                    (anotherHistLine isKindOfModified 
                    and:[anotherHistLine user = histLine user
                    and:[anotherHistLine what = histLine what]])
                    ifTrue:[
                        "/ don't replace a modified by a modified format
                        (histLine isModified not or:[anotherHistLine isModified]) ifTrue:[
                            skip := true
                        ] ifFalse:[
                            "/ remove next comment/format modification if this is a modified
                            (histLine isModified and:[anotherHistLine isModified not]) ifTrue:[
                                (self timeIsShortFrom:histLine to:anotherHistLine) ifTrue: [skip := true]
                            ].
                        ].
                    ]
                ].
            ]
        ] ifFalse:[
            "/ filter out multiple created messages
            "/ (this only occurs if a method was copied from ClassA to ClassB)
            histLine isCreated ifTrue:[
                aCollectionOfHistoryLines from:index+1 do:[:anotherHistLine |
                    (anotherHistLine isCreated 
                    and:[(anotherHistLine what = histLine what)
                    and:[anotherHistLine user = histLine user]]) 
                        ifTrue:[skip := true]
                ].
                skip ifFalse:[
                    "/ create followed by a modification, within the historyManagerModificationLimit:
                    "/ skip the modified message
                    (index+1) == aCollectionOfHistoryLines size ifTrue:[
                        | anotherHistLine |
                        anotherHistLine := aCollectionOfHistoryLines at:index+1.
                        (anotherHistLine isKindOfModified and:[anotherHistLine user = histLine user]) 
                            ifTrue:[skipNext := (self timeIsShortFrom:histLine to:anotherHistLine)]
                    ].
                ].
            ].
        ].
        skip ifFalse:[
            newCollection add:histLine.
        ]
    ].
    ^ newCollection.

    "Modified: / 08-09-1995 / 17:20:40 / claus"
    "Modified: / 20-06-2004 / 16:36:00 / masca"
    "Modified: / 01-09-2004 / 20:20:42 / janfrog"
    "Modified: / 05-07-2011 / 23:09:01 / cg"
    "Modified: / 08-10-2012 / 14:59:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

modificationLimit
    "Answer the number of seconds between creation and
     modifcation of a method within which the modification
     line won't be added."

    ^ 3600 "/one hour

    "Created: / 20.6.2004 / 16:32:35 / masca"
    "Modified: / 2.9.2004 / 15:33:09 / janfrog"
!

timeIsShortFrom:histLine1 to:histLine2
    |t1 t2|

    t1 := (Timestamp fromDate: histLine1 date andTime: histLine1 time).
    t2 := (Timestamp fromDate: histLine2 date andTime: histLine2 time).
    ^ (t1 secondDeltaFrom:t2) abs < self modificationLimit

    "Created: / 30-06-2011 / 18:23:04 / cg"
! !

!HistoryManager::HistoryLine class methodsFor:'initialization'!

initialize
    "setup class variables"

    Quote isNil ifTrue:[
        Quote := '"'.
        Separator := '/'.
        ModifiedString := 'Modified:'.
        DeletedString := 'Deleted:'.
        CreatedString := 'Created:'.
        AddedString := 'Added:'.
        FormattedString := 'Modified (format):'.
        CommentedString := 'Modified (comment):'.
        VariableRenamedString := 'Modified (variable name):'.
        IndentString := '    '.
        UseGECOS := false.
    ]

    "
     HistoryLine initialize
    "

    "Modified: / 23-08-1995 / 22:14:03 / robert"
    "Modified: / 30-06-2011 / 12:28:43 / cg"
! !

!HistoryManager::HistoryLine class methodsFor:'instance creation'!

fromString: aString
    "parses the argument, aString; 
     create & return a new Instance with the values" 

    ^ self fromString: aString at: 0.

    "
     HistoryLine fromString: 'Modified: 01.12.93 / 18:32:30 / M.Noell'
     HistoryLine fromString: 'Created: 01.12.93 / 18:32:30 / M.Noell'
    "

    "Modified: 23.8.1995 / 22:14:13 / robert"
    "Modified: 20.4.1996 / 20:24:47 / cg"
!

fromString: aString at: position
    "parses the String and creates a new Instance with the values. 
     The positionvalue is normally used to remove the HistoryLines from the sourceCode.
     Claus: return nil, if the string is not a valid historyString."

    |inst array type aTime aDate userName idx what|

    inst := self basicNew.  

    array := aString asCollectionOfWords.
    array size < 5 ifTrue:[^ nil].

    array := array collect:[:word | word withoutSpaces].
    type := array at:1.

    "/ kludge for the 'Modified (what)' strings
    ((array at:2) startsWith:'(') ifTrue:[
        type := type , ' ' , (array at:2).
        array := (Array with:type) , (array copyFrom:3)
    ].

    "
     Modified [(detail)] / Deleted / Created
        [what]
        Separator
        date asString
        Separator
        time asString
        Separator
        UserName ...
    "

    ((Array 
        with:ModifiedString
        with:DeletedString
        with:CreatedString
        with:AddedString
        with:FormattedString 
        with:CommentedString 
        with:VariableRenamedString
    ) includes:type) ifFalse:[^ nil].

    inst type:type.

    "/ sigh backward compatibility ...

    (array at:2) first isDigit ifTrue:[
        "/ date follows ...
        idx := 2
    ] ifFalse:[
        idx := array indexOf:Separator startingAt:2.
        idx == 0 ifTrue:[
            "/ not a valid history string
            ^ nil
        ].

        idx ~~ 2 ifTrue:[
            what := (array copyFrom:2 to:(idx-1)) asStringWith:(Character space).
            inst what:what.
        ].

        idx := idx + 1.
    ].
    aDate := self convertStringToDate: (array at: idx).
    inst date: aDate.
    (array at:idx+1) ~= Separator ifTrue:[^ nil].
    idx := idx + 2.

    aTime := self convertStringToTime: (array at: idx).
    inst time: aTime.
    (array at:idx+1) ~= Separator ifTrue:[^ nil].
    idx := idx + 2.

    "the user's name may be more that one word"
    userName := (array copyFrom:idx) asStringWith:Character space.

    inst user:userName.
    inst firstPositionInSourceCode:position.

    ^ inst

    "
     HistoryLine fromString: 'Modified: 21.12.93 / 18:32:30 / R.Sailer'
     HistoryLine fromString: 'Created: 21.12.1993 / 18:32:30 / Felicitas Gabriele Felger'
     HistoryLine fromString: 'Deleted: 21.12.93 / 18:32:30 / Astrid Weisseise'
     HistoryLine fromString: 'Deleted: foo bar / 21.12.93 / 18:32:30 / Astrid Weisseise'
    "

    "Modified: / 23-08-1995 / 22:24:47 / robert"
    "Modified: / 19-09-1995 / 14:14:48 / claus"
    "Modified: / 30-06-2011 / 16:09:16 / cg"
    "Modified (Comment): / 30-06-2011 / 19:08:22 / cg"
!

new
    "get a new history line. 
     Preinitialize it as a modified-Line for the current user"    

    ^ self type:ModifiedString what:nil
!

newCreated
    "public - get a new created-Line for the current user"    

    ^ self type:CreatedString what:nil

    "
     HistoryLine newCreated
    "

    "Modified: 23.8.1995 / 22:14:24 / robert"
    "Modified: 24.10.1997 / 00:18:30 / cg"
! !

!HistoryManager::HistoryLine class methodsFor:'private'!

currentUserName
    "return the current users name - 
     that's either the userInfos-gecos field, or the users login name."

    |nm|

    (nm := HistoryManager enforcedUserName) notNil ifTrue:[
        ^ nm
    ].

    (nm := UserPreferences current historyManagerSignature) notNil ifTrue:[
        ^ nm
    ].

    UseGECOS == true ifTrue:[
        ^ OperatingSystem getFullUserName.
    ].
    ^ (OperatingSystem getLoginName).

    "
     HistoryLine currentUserName
    "

    "Modified: / 15-07-1996 / 12:43:14 / cg"
    "Modified: / 20-06-2006 / 13:26:49 / User"
    "Modified: / 08-07-2011 / 10:24:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type:type what:what
    "private - for integration purposes only"

    | inst |

    inst := self basicNew.
    inst date: Date today.
    inst time: Time now.
    inst firstPositionInSourceCode: 0.
    inst user:(self currentUserName).
    inst type:type.    
    inst what:what.    

    ^ inst

    "Modified: 23.08.1995 / 21:35:44 / robert"
! !

!HistoryManager::HistoryLine methodsFor:'accessing'!

date
    "return the date"

    ^ date

    "Modified (Format): / 30-06-2011 / 16:23:15 / cg"
!

date:something
    "set the date"

    date := something.

    "Modified: 20.4.1996 / 20:22:16 / cg"
!

firstPositionInSourceCode
    "return firstPositionInSourceCode"

    ^ firstPositionInSourceCode
!

firstPositionInSourceCode:something
    "set firstPositionInSourceCode"

    firstPositionInSourceCode := something.
!

isForAddition
    type := AddedString
!

isForCommented
    type := CommentedString

    "Created: / 30-06-2011 / 12:24:22 / cg"
!

isForCreation
    type := CreatedString
!

isForDeletion
    type := DeletedString
!

isForFormatted
    type := FormattedString

    "Created: / 30-06-2011 / 12:24:11 / cg"
!

isForModification
    type := ModifiedString
!

isForVariableRenamed
    type := VariableRenamedString

    "Created: / 30-06-2011 / 12:24:36 / cg"
    "Modified (Format): / 30-06-2011 / 12:28:27 / cg"
!

time
    "return the time"

    ^ time

    "Modified: 20.4.1996 / 20:22:04 / cg"
!

time:something
    "set the time"

    time := something.

    "Modified: 20.4.1996 / 20:21:58 / cg"
!

type
    "return the type"

    ^ type

    "Modified: 20.4.1996 / 20:21:54 / cg"
!

type:something
    "set the type"

    type := something.

    "Modified: 20.4.1996 / 20:21:39 / cg"
!

user
    "return the user"

    ^ user

    "Modified: 20.4.1996 / 20:21:45 / cg"
!

user:something
    "set the user"

    user := something.

    "Modified: 20.4.1996 / 20:21:48 / cg"
!

what
    "return the what-changed info"

    ^ what

    "Modified: 20.4.1996 / 20:21:54 / cg"
    "Created: 24.10.1997 / 00:20:33 / cg"
!

what:someStringOrSelector
    "set the what-changed info"

    what := someStringOrSelector

    "Modified: 20.4.1996 / 20:21:54 / cg"
    "Created: 24.10.1997 / 00:21:00 / cg"
! !

!HistoryManager::HistoryLine methodsFor:'comparing'!

= aHistoryLine
    "compares two instances of HistoryLine"

    (aHistoryLine user = self user) ifTrue:[
        (aHistoryLine date = self date) ifTrue:[
            (aHistoryLine time = self time) ifTrue:[
                (aHistoryLine type = self type) ifTrue:[
                    (aHistoryLine what = self what) ifTrue:[
                        ^ true
                    ]
                ]
            ]
        ]
    ].

    ^ false

"
    | h1 h2 |

    h1 := HistoryLine for: OperatingSystem getLoginName.
    h2 := h1 copy.

    h1 = h2 ifTrue:[
        InfoBox new title: 'users are equal'; show.
    ].

    h2 := HistoryLine for: OperatingSystem getLoginName.
    h1 = h2 ifFalse:[
        InfoBox new title: 'users are not equal'; show.
    ].
"

    "Modified: 23.8.1995 / 22:26:40 / robert"
    "Modified: 24.10.1997 / 00:22:09 / cg"
!

hash
    "return a hash key for the receiver"

    ^user hash        

"
    Check hashCode

    |h1 h2 oc |

    h1 := HistoryLine new hash.
    h2 := HistoryLine new hash.
    oc := OrderedCollection new.
    oc add: h1.
    oc add: h2.
    ^oc

    using hash in a set:

    | h1 h2 aSet oc |
    h1 := HistoryLine new hash.
    h2 := HistoryLine new hash.
    oc := OrderedCollection new.
    oc add: h1.
    oc add: h2.
    aSet := oc asSet.
    ^aSet
"

    "Modified: 23.08.1995 / 22:26:44 / robert"
!

sameDate: aHistoryLine
    "returns true if aUserName = user in preperation for a SortedCollection of HistoryLines"

    ^aHistoryLine date = date

"
    | h1 h2 |

    h1 := HistoryLine new.
    h2 := h1 copy.

    (h1 sameDate: h2)  ifTrue:[
	InfoBox new title: 'Dates are equal'; show.
    ].

    h2 := HistoryLine for: 'R.Sailer'.
    h2 date: (Date day: 12 month: 6 year:1981).
    (h1 sameDate: h2) ifFalse:[
	InfoBox new title: 'users are not equal'; show.
    ].

"

    "Modified: 23.08.1995 / 22:26:47 / robert"
!

sameType: aHistoryLine
    "returns true if the Type = type in preperation for a SortedCollection of HistoryLines"

    ^aHistoryLine type = type

"
    | h1 h2 |

    h1 := HistoryLine new.
    h2 := h1 copy.

    (h1 sameType: h2)  ifTrue:[
	InfoBox new title: 'Types are equal'; show.
    ].

    h2 := HistoryLine createdBy: 'R.Sailer'.
    (h1 sameType: h2) ifFalse:[
	InfoBox new title: 'Types are not equal'; show.
    ].

"

    "Modified: 23.08.1995 / 22:26:49 / robert"
!

sameUser: aHistoryLine
    "returns true if aUserName = user in preperation for a SortedCollection of HistoryLines"

    ^aHistoryLine user = user


"
    | h1 h2 |

    h1 := HistoryLine new.
    h2 := h1 copy.

    (h1 sameUser: h2)  ifTrue:[
	InfoBox new title: 'users are equal'; show.
    ].

    h2 := HistoryLine for: 'R.Sailer'.
    (h1 sameUser: h2) ifFalse:[
	InfoBox new title: 'users are not equal'; show.
    ].

"

    "Modified: 23.08.1995 / 22:26:51 / robert"
!

sameWhat: aHistoryLine
    "returns true if the what = type in preperation for a SortedCollection of HistoryLines"

    ^aHistoryLine what = what

    "Created: 24.10.1997 / 00:21:46 / cg"
! !

!HistoryManager::HistoryLine methodsFor:'printing & storing'!

printOn:aStream
    "return a printed representation of a HistoryLine as a string"

    aStream nextPutAll:IndentString.
    aStream nextPutAll:Quote.
    aStream nextPutAll:type.
    what notNil ifTrue:[
        aStream space.
        aStream nextPutAll:what.
    ].
    aStream space; nextPutAll:Separator; space.
    date printOn:aStream language:#en.
    aStream space; nextPutAll:Separator; space.
    time print24HourFormatOn:aStream. 
    aStream space; nextPutAll:Separator; space.
    aStream nextPutAll:user.
    aStream nextPutAll:Quote.

    "
     self new printOn:Transcript
    "

    "Modified: / 24.10.1997 / 02:07:23 / cg"
    "Modified: / 20.1.1998 / 12:58:53 / stefan"
! !

!HistoryManager::HistoryLine methodsFor:'queries'!

isCreated
    "returns true if the bodytext is CreatedString"

    ^type = CreatedString

"

        HistoryLine new isModified
        (HistoryLine for: 'R.Sailer') isCreated 
        (HistoryLine createdBy: 'R.Sailer') isCreated 
        HistoryLine deleted isModified 
        (HistoryLine deletedBy: 'M.Noell') isModified 
        
"

    "Modified: 23.8.1995 / 22:30:23 / robert"
    "Modified: 20.4.1996 / 20:20:36 / cg"
!

isDeleted
    "returns true if the bodytext is DeletedString"

    ^type = DeletedString

"

        HistoryLine deleted isDeleted
        HistoryLine new isDeleted



"

    "Modified: 20.4.1996 / 20:20:32 / cg"
!

isKindOfModified
    "returns true if the bodytext is ModifiedString"

    ^ self isModified 
        or:[ type = CommentedString
        or:[ type = FormattedString
        or:[ type = VariableRenamedString ]]]

    "
        HistoryLine new isModified
        (HistoryLine for: 'R.Sailer') isModified 
        HistoryLine deleted isModified 
        (HistoryLine deletedBy: 'M.Noell') isModified 
    "

    "Created: / 30-06-2011 / 17:15:12 / cg"
!

isModified
    "returns true if the bodytext is ModifiedString"

    ^type = ModifiedString

    "
        HistoryLine new isModified
        (HistoryLine for: 'R.Sailer') isModified 
        HistoryLine deleted isModified 
        (HistoryLine deletedBy: 'M.Noell') isModified 
    "

    "Modified: 20.4.1996 / 20:20:29 / cg"
! !

!HistoryManager class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


HistoryManager initialize!
HistoryManager::HistoryLine initialize!

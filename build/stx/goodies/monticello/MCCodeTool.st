"{ Package: 'stx:goodies/monticello' }"

MCTool subclass:#MCCodeTool
	instanceVariableNames:'items'
	classVariableNames:''
	poolDictionaries:''
	category:'SCM-Monticello-UI'
!

MCCodeTool comment:'MCCodeTool is an abstract superclass for those Monticello browsers that display code.
It contains copies of the various CodeHolder methods that perform the various menu operations in the method list.
'
!


!MCCodeTool methodsFor:'menus'!

adoptMessageInCurrentChangeset
	"Add the receiver's method to the current change set if not already there"

	self selectedClassOrMetaClass ifNotNilDo: [ :cl |
		self selectedMessageName ifNotNilDo: [ :sel |
			ChangeSet current adoptSelector: sel forClass: cl.
			self changed: #annotations ]]
!

browseFullProtocol
	"Open up a protocol-category browser on the value of the receiver's current selection.    If in mvc, an old-style protocol browser is opened instead.  Someone who still uses mvc might wish to make the protocol-category-browser work there too, thanks."

	| aClass |

	(Smalltalk isMorphic and: [Smalltalk includesKey: #Lexicon]) ifFalse: [^ self spawnFullProtocol].
	(aClass _ self selectedClassOrMetaClass) ifNotNil:
		[(Smalltalk at: #Lexicon) new openOnClass: aClass inWorld: ActiveWorld showingSelector: self selectedMessageName]
!

browseMessages
	"Present a menu of the currently selected message, as well as all messages sent by it.  Open a message set browser of all implementors of the selector chosen."

	self systemNavigation browseAllImplementorsOf: (self selectedMessageName ifNil: [ ^nil ])
!

browseMethodFull
	"Create and schedule a full Browser and then select the current class and message."

	| myClass |
	(myClass _ self selectedClassOrMetaClass) ifNotNil:
		[Browser fullOnClass: myClass selector: self selectedMessageName]
!

browseSendersOfMessages
	"Present a menu of the currently selected message, as well as all messages sent by it.  Open a message set browser of all senders of the selector chosen."

	self systemNavigation browseAllCallsOn: (self selectedMessageName ifNil: [ ^nil ])
!

browseVersions
	"Create and schedule a message set browser on all versions of the 
	currently selected message selector."

	| class selector compiledMethod |
	class _ self selectedClassOrMetaClass.
	selector _ self selectedMessageName.
	compiledMethod _ class compiledMethodAt: selector ifAbsent: [ ^self ].
	VersionsBrowser
		browseVersionsOf: compiledMethod
		class: class theNonMetaClass
		meta: class isMeta
		category: self selectedMessageCategoryName
		selector: selector
!

classHierarchy
	"Create and schedule a class list browser on the receiver's hierarchy."

	self systemNavigation  spawnHierarchyForClass: self selectedClassOrMetaClass
		selector: self selectedMessageName	"OK if nil"
!

classListMenu: aMenu 

	aMenu addList: #(
		-
		('browse full (b)'			browseMethodFull)
		('browse hierarchy (h)'		classHierarchy)
		('browse protocol (p)'		browseFullProtocol)
"		-
		('printOut'					printOutClass)
		('fileOut'					fileOutClass)
"		-
		('show hierarchy'			methodHierarchy)
"		('show definition'			editClass)
		('show comment'			editComment)
"
"		-
		('inst var refs...'			browseInstVarRefs)
		('inst var defs...'			browseInstVarDefs)
		-
		('class var refs...'			browseClassVarRefs)
		('class vars'					browseClassVariables)
		('class refs (N)'				browseClassRefs)
		-
		('rename class ...'			renameClass)
		('copy class'				copyClass)
		('remove class (x)'			removeClass)
"
		-
		('find method...'				findMethodInChangeSets)).
							
	^aMenu
!

copySelector
	"Copy the selected selector to the clipboard"

	| selector |
	(selector _ self selectedMessageName) ifNotNil:
		[Clipboard clipboardText: selector asString]
!

fileOutMessage
	"Put a description of the selected message on a file"

	self selectedMessageName ifNotNil:
		[Cursor write showWhile:
			[self selectedClassOrMetaClass fileOutMethod: self selectedMessageName]]
!

findMethodInChangeSets
	"Find and open a changeSet containing the current method."

	| aName |
	(aName _ self selectedMessageName) ifNotNil: [
		ChangeSorter browseChangeSetsWithClass: self selectedClassOrMetaClass
					selector: aName]
!

methodHierarchy
	"Create and schedule a method browser on the hierarchy of implementors."

	self systemNavigation methodHierarchyBrowserForClass: self selectedClassOrMetaClass
		selector: self selectedMessageName
!

methodListKey: aKeystroke from: aListMorph 
	aKeystroke caseOf: {
		[$b] -> [self browseMethodFull].
		[$h] -> [self classHierarchy].
		[$O] -> [self openSingleMessageBrowser].
		[$p] -> [self browseFullProtocol].
		[$o] -> [self fileOutMessage].
		[$c] -> [self copySelector].
		[$n] -> [self browseSendersOfMessages].
		[$m] -> [self browseMessages].
		[$i] -> [self methodHierarchy].
		[$v] -> [self browseVersions]}
		 otherwise: []
!

methodListMenu: aMenu
	"Build the menu for the selected method, if any."
	
	self selectedMessageName ifNotNil: [
	aMenu addList:#(
			('browse full (b)' 						browseMethodFull)
			('browse hierarchy (h)'					classHierarchy)
			('browse method (O)'					openSingleMessageBrowser)
			('browse protocol (p)'					browseFullProtocol)
			-
			('fileOut (o)'							fileOutMessage)
			('printOut'								printOutMessage)
			('copy selector (c)'						copySelector)).
		aMenu addList: #(
			-
			('browse senders (n)'						browseSendersOfMessages)
			('browse implementors (m)'					browseMessages)
			('inheritance (i)'						methodHierarchy)
			('versions (v)'							browseVersions)
		('change sets with this method'			findMethodInChangeSets)
"		('x revert to previous version'				revertToPreviousVersion)"
		('remove from current change set'		removeFromCurrentChanges)
"		('x revert & remove from changes'		revertAndForget)"
		('add to current change set'				adoptMessageInCurrentChangeset)
"		('x copy up or copy down...'				copyUpOrCopyDown)"
"		('x remove method (x)'					removeMessage)"
		"-"
		).
	].
"	aMenu addList: #(
			('x inst var refs...'						browseInstVarRefs)
			('x inst var defs...'						browseInstVarDefs)
			('x class var refs...'						browseClassVarRefs)
			('x class variables'						browseClassVariables)
			('x class refs (N)'							browseClassRefs)
	).
"
	^ aMenu
!

openSingleMessageBrowser
	| msgName mr |
	"Create and schedule a message list browser populated only by the currently selected message"

	(msgName _ self selectedMessageName) ifNil: [^ self].

	mr _ MethodReference new
		setStandardClass: self selectedClassOrMetaClass
		methodSymbol: msgName.

	self systemNavigation 
		browseMessageList: (Array with: mr)
		name: mr asStringOrText
		autoSelect: nil
!

perform: selector orSendTo: otherTarget 

	"Selector was just chosen from a menu by a user. If can respond, then  
	perform it on myself. If not, send it to otherTarget, presumably the  
	editPane from which the menu was invoked."

	(self respondsTo: selector)
		ifTrue: [^ self perform: selector]
		ifFalse: [^ super perform: selector orSendTo: otherTarget]
!

printOutMessage
	"Write a file with the text of the selected message, for printing by a web browser"

	self selectedMessageName ifNotNil: [
		self selectedClassOrMetaClass fileOutMethod: self selectedMessageName
							asHtml: true]
!

removeFromCurrentChanges
	"Tell the changes mgr to forget that the current msg was changed."

	ChangeSet current removeSelectorChanges: self selectedMessageName 
			class: self selectedClassOrMetaClass.
	self changed: #annotations
! !

!MCCodeTool methodsFor:'subclassResponsibility'!

annotations
	"Build an annotations string for the various browsers"
	^''
!

selectedClass
	"Answer the class that is selected, or nil"
	self subclassResponsibility
!

selectedClassOrMetaClass
	"Answer the class that is selected, or nil"
	self subclassResponsibility
!

selectedMessageCategoryName
	"Answer the method category of the method that is selected, or nil"
	self subclassResponsibility
!

selectedMessageName
	"Answer the name of the selected message"
	self subclassResponsibility
! !

!MCCodeTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/monticello/MCCodeTool.st,v 1.2 2012-09-11 21:20:58 cg Exp $'
! !

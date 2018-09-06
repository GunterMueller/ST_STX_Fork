"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"



ApplicationModel subclass:#ShellView
	instanceVariableNames:'task directory commands currentCommand numberOfMaxLines'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support'
!

!ShellView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"


!

documentation
"
    [author:]
        Thomas Zwick
"


! !

!ShellView class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:ShellView andSelector:#windowSpec
     ShellView new openInterface:#windowSpec
     ShellView open
    "

    <resource: #canvas>

    ^
     
       #(#FullSpec
          #window: 
           #(#WindowSpec
              #name: 'unnamed canvas'
              #layout: #(#LayoutFrame 252 0 229 0 551 0 497 0)
              #label: 'unnamed canvas'
              #min: #(#Point 10 10)
              #max: #(#Point 1152 864)
              #bounds: #(#Rectangle 252 229 552 498)
              #usePreferredExtent: false
          )
          #component: 
           #(#SpecCollection
              #collection: 
               #(
                 #(#TextEditorSpec
                    #name: 'fileContentsView'
                    #layout: #(#LayoutFrame 0 0 0 0.0 0 1 -22 1)
                    #model: #valueOfFileContents
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #miniScrollerHorizontal: true
                )
                 #(#SequenceViewSpec
                    #name: 'shellOutputView'
                    #layout: #(#LayoutFrame 0 0.0 0 0.0 0 1.0 -22 1.0)
                    #model: #selectionOfShellOutput
                    #style: #(#FontDescription #courier #medium #roman 12)
                    #hasHorizontalScrollBar: true
                    #hasVerticalScrollBar: true
                    #doubleClickSelector: #listDoubleClicked:
                    #useIndex: true
                    #sequenceList: #listOfShellOutput
                )
                 #(#ActionButtonSpec
                    #name: 'fileNameButton'
                    #layout: #(#LayoutFrame 0 0.0 -22 1 -60 1.0 0 1.0)
                    #model: #toggleViews
                )
                 #(#ActionButtonSpec
                    #name: 'saveButton'
                    #layout: #(#LayoutFrame -60 1 -22 1 0 1.0 0 1.0)
                    #label: 'Save'
                    #model: #saveFileContents
                )
                 #(#ActionButtonSpec
                    #name: 'stopButton'
                    #layout: #(#LayoutFrame 0 0 -22 1 0 1.0 0 1)
                    #label: 'Stop'
                    #model: #terminateTask
                )
                 #(#InputFieldSpec
                    #name: 'commandInputField'
                    #layout: #(#LayoutFrame 0 0 -22 1 0 1.0 0 1)
                    #model: #valueOfCommand
                    #type: #string
                    #acceptOnReturn: false
                    #acceptOnTab: false
                )
              )
          )
      )
! !

!ShellView methodsFor:'accessing'!

directory

    ^directory ? (directory := Filename currentDirectory asAbsoluteFilename name) 
!

directory: aDirectory

    |dir|
    (directory ~= (dir := aDirectory asFilename asAbsoluteFilename name))
    ifTrue:
    [
        directory := dir.
        self listOfShellOutput
                at: self listOfShellOutput size
                put: self getDirectoryTextString
    ]
!

numberOfMaxLines

    ^numberOfMaxLines ? (numberOfMaxLines := 500)
!

numberOfMaxLines: anInteger

    numberOfMaxLines := anInteger
! !

!ShellView methodsFor:'accessing - views'!

commandInputField

    ^builder componentAt: #commandInputField
!

fileContentsView

    ^builder componentAt: #fileContentsView
!

fileNameButton

    ^builder componentAt: #fileNameButton
!

saveButton

    ^builder componentAt: #saveButton
!

shellOutputView

    ^builder componentAt: #shellOutputView
!

stopButton

    ^builder componentAt: #stopButton
! !

!ShellView methodsFor:'actions'!

executeCommand: aCommand

    |s|       
    aCommand isNil | task notNil | directory isNil ifTrue: [^nil].
    aCommand isString ifTrue: [^self executeCommands: (Array with: aCommand)].
    aCommand key size = 0 ifTrue: [^aCommand key: ''].

    self valueOfCommand value: ''.
    self listOfShellOutput
        at: self listOfShellOutput size
        put: self getDirectoryTextString, (Text string: aCommand key color: Color blue).

    aCommand key trimBlanks = 'clear'
    ifTrue: 
    [
        self shellOutputView raise.
        ^self listOfShellOutput contents: (Array with: self getDirectoryTextString).
    ].

    (((s := aCommand key readStream) nextWord = 'cd') and: [(s next = Character space) | s atEnd])
    ifTrue:
    [
        s := s upToEnd trimBlanks.

        s size = 0
        ifTrue:
        [
            s := Filename homeDirectory
        ]
        ifFalse: 
        [
            s first = $/
                ifTrue: [s := s asFilename]
                ifFalse: [s := self directory asFilename constructDirectory: s]
        ].
        (s exists and: [s isDirectory])
        ifTrue:
        [
            directory := s name.
            ^self listOfShellOutput contents: (Array with: self getDirectoryTextString).
        ].
    ].

    self stopButton raise.
    self shellOutputView raise.

    self
        execute: aCommand key
        exit:
        [
            self commandInputField raise.
            aCommand value: true. 
            self executeNextCommand.
            self append: self getDirectoryTextString
        ].
! !

!ShellView methodsFor:'aspects'!

listOfShellOutput

    |holder|
    (holder := builder bindingAt:#listOfShellOutput) isNil ifTrue:[
        builder aspectAt:#listOfShellOutput put:(holder :=  List new).
        holder add: self getDirectoryTextString
    ].  
    ^holder
!

selectionOfShellOutput

    |holder|              
    (holder := builder bindingAt:#selectionOfShellOutput) isNil ifTrue:[
        builder aspectAt:#selectionOfShellOutput put: (holder := 1 asValue)
    ]. 
    ^holder
!

valueOfCommand

    |holder|
    (holder := builder bindingAt:#valueOfCommand) isNil ifTrue:[
        builder aspectAt:#valueOfCommand put:
            (holder :=  AspectAdaptor new subject: self; forAspect: #currentCommand).
    ].
    ^ holder       
!

valueOfFileContents

    |holder|
    (holder := builder bindingAt:#valueOfFileContents) isNil ifTrue:[
        builder aspectAt:#valueOfFileContents put:(holder :=  ValueHolder new).
    ].
    ^holder    
! !

!ShellView methodsFor:'callbacks'!

listDoubleClicked: anLineIndex

    |stream streamAtLine possibleFileName selectedFileName fileFound|
    possibleFileName := ''.
    stream := (self listOfShellOutput at: anLineIndex) string readStream.
    fileFound := false.
    [stream atEnd | fileFound]
    whileFalse: 
    [                
        possibleFileName := possibleFileName, stream next.
        (("((selectedFileName := possibleFileName) asFilename exists) or:"
        (selectedFileName := directory, Filename separator, possibleFileName) asFilename exists)
         and: [selectedFileName asFilename isDirectory not])
        ifTrue:
        [   
            |possibleLineIndex listSize lineNumber|   
            fileFound := true.  
            self openFile: selectedFileName.
            [stream atEnd | lineNumber notNil]
            whileFalse: 
            [            
                lineNumber := Integer readFrom: stream nextAlphaNumericWord onError: nil.
            ].
            lineNumber := lineNumber ? 1.
            listSize := self fileContentsView list size.
            (lineNumber between: 1 and: listSize)
            ifTrue:
            [          
                self fileContentsView selectLine: lineNumber
            ].
            lineNumber > listSize
            ifTrue:
            [          
                self fileContentsView selectLine: listSize
            ].
        ].
    ]

! !

!ShellView methodsFor:'initialization'!

initialize
    super initialize.
    self createBuilder

    "Created: / 20.6.1998 / 15:30:48 / cg"
! !

!ShellView methodsFor:'private'!

append:anElement

    anElement notNil
    ifTrue:
    [   
        self listOfShellOutput size > self numberOfMaxLines
        ifTrue:
        [
            self listOfShellOutput contents: (self listOfShellOutput copyFrom:
                self listOfShellOutput size - (self numberOfMaxLines//5)
                to: self listOfShellOutput size)
        ].
        self listOfShellOutput add: anElement.
        self selectionOfShellOutput value: self listOfShellOutput size.
    ]
           
!

execute: cmd exit:exitAction

    |outStream|
    self terminateTask.
    outStream:= PipeStream readingFrom: cmd errorDisposition:#inline inDirectory: directory.
    task :=
    [          
        [      
            outStream canReadWithoutBlocking
            ifTrue:
            [
                outStream readWait.
                self append: (outStream upTo: Character cr).
            ].
        ] doWhile:[outStream atEnd not]
    ] forkAt: Processor userBackgroundPriority.

    task addExitAction:
    [
        task := nil.
        outStream shutDown.
        exitAction value
    ]
!

executeNextCommand

    self executeCommand: (commands detect: [:str| str value = false] ifNone: nil)

!

getDirectoryTextString

    ^Text string: ('[',self directory, '] > ') emphasis: #bold
!

listDirectory: dir

    |s match d|   
    match := (dir name copy reverse upTo: Filename separator) reverse.

    s := dir name copy reverse readStream.
    s through: Filename separator.
    s := s upToEnd reverse.
    dir name = Filename separator asString ifTrue: [s := Filename separator asString].

    ((d := dir) isDirectory or:
    [((d := s asFilename) isDirectory or:
    [(d := directory asFilename construct: s) isDirectory])])

     ifTrue: [        
    d directoryContents do:
    [:dirEntry|      
        ((match, '*') match: dirEntry) ifTrue: [self append:dirEntry]
    ].
    self append: self getDirectoryTextString
    ]
! !

!ShellView methodsFor:'selection'!

currentCommand

    ^currentCommand
!

currentCommand: aString

    self commandInputField crAction: [self executeCommands: (Array with: currentCommand)].
    self commandInputField entryCompletionBlock:[:contents |
        |newString|
        newString := Filename 
                        filenameCompletionFor:contents 
                        directory:directory asFilename
                        directoriesOnly:false 
                        filesOnly:false 
                        ifMultiple:
                            [:dir |
                                self listDirectory: dir.
                                self commandInputField flash.
                            ].            
        self commandInputField contents:newString.
        self commandInputField cursorToEndOfLine.
    ].
    currentCommand := aString.
    self listOfShellOutput size > 0
    ifTrue:
    [
        self listOfShellOutput
            at: self listOfShellOutput size
            put: self getDirectoryTextString, currentCommand
    ].

! !

!ShellView methodsFor:'user actions'!

executeCommands: aStingCollection

    commands := aStingCollection collect: [:str| str->false].

    self executeNextCommand
!

openFile: aFileName

    |fileName|
    task isNil & (((fileName := aFileName asFilename) exists)
    or: [(fileName := directory asFilename construct: fileName) exists])
    ifTrue:
    [        
        self fileNameButton raise; sizeFixed: true;label: fileName name.
        self fileContentsView raise.
        self saveButton raise.
        Stream readErrorSignal
        handle:
        [:ex|
            self warn: 'Reading file contents failed!!'.
            self toggleViews.
        ]
        do:
        [
            self valueOfFileContents value: fileName contentsOfEntireFile
        ]
    ]  
!

saveFileContents

    self fileContentsView saveAs: self fileNameButton label
!

terminateTask

    task notNil ifTrue:
    [ 
        task terminate.
        task := nil
    ]   
!

toggleViews

    self fileNameButton label isEmpty
    ifFalse:
    [
        task notNil
            ifTrue: [self stopButton raise]
            ifFalse: [self commandInputField raise].
        self shellOutputView raise.
        self fileNameButton sizeFixed: true; label: ''.
        self valueOfFileContents value: ''.
    ]
    ifTrue:
    [         
        self fileNameButton raise.
        self infoLabel raise.
        self fileContentsView raise
    ]
! !

!ShellView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

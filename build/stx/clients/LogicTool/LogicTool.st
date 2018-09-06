"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"
"{ Package: 'stx:clients/LogicTool' }"

"{ NameSpace: Demos }"

Object subclass:#LogicTool
	instanceVariableNames:'topView logicView menu commandPanel gridSize gridShown
		openErrorBox createErrorBox nameEnterBox subEnterBox openBox
		saveBox currentFileName resources'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-LogicTool'
!

!LogicTool class methodsFor:'documentation'!

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

 This is a demo example:

 THIS SOFTWARE IS PROVIDED BY THE CONTRIBUTOR ``AS IS'' AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED.  IN NO EVENT SHALL THE CONTRIBUTOR BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
"


!

documentation
"
    opens a logicView in a topView, with menu & panel

    This is a very old example - one of the first working ST/X demos.
    I would do it different today.
    Do not take this as an example for 'good' programming style.
    -----------------------------------------------------------

    [author:]
        Claus Gittinger (spring/summer 89)

    [start with:]
        LogicTool open
"
! !

!LogicTool class methodsFor:'defaults'!

listOfObjectClasses
    |list|
    list := OrderedCollection new.
    list add:Low.
    list add:High.
    list add:Input.
    list add:Output.
    list add:Inverter.
    list add:AndGate2.
    list add:NandGate2.
    list add:OrGate2.
    list add:NorGate2.
    list add:ExorGate2.
    list add:AndGate3.
    ^ list
! !

!LogicTool class methodsFor:'startup'!

open
    "startup a LogicTool window with empty contents"

    ^ self new open

    "LogicTool open"
!

openOn:aFileName
    "startup a LogicTool window, initialize contents from aFileName"

    ^ self new open openFile:aFileName

    "LogicTool openOn:'aFileName'"
! !

!LogicTool methodsFor:'menu definition'!

initMenu
    menu labels:(resources array:#('file' 
				   'edit' 
"
				   'form' 
"
				   'simulation'
"
				   'debugging'
"
				  )).

    menu at:(resources string:'file')
	    putLabels:(resources array:#('new' 
					 'open ...' 
					 'circuits ...'
					 '-' 
					 'save' 
					 'save as ...' 
					 '-' 
					 'print'
					 '-' 
					 'quit'))
	    selectors:#(doNew
			doOpen
			addSubCircuit
			nil
			doSave
			doSaveAs
			nil
			doPrint
			nil
			finish)
	     receiver:self.

    menu at:(resources string:'edit')
	    putLabels:(resources array:#('copy' 
					'cut' 
					'paste'
					'-'
					'disconnect'
					'-'
					'group'
					'-'
					'name it'))
	    selectors:#(copySelection
			deleteSelection
			pasteSelection
			nil
			disconnect
			nil
			group
			nil
			nameIt)
	     receiver:self.

"
    menu at:(resources string:'form')
	    putLabels:(resources array:#('grid on' 
					 'grid size' 
					 'show grid'))
	    selectors:#(gridOn gridSize showGrid)
	     receiver:self.
"
    menu at:(resources string:'simulation')
	    putLabels:(resources array:#('start'
					 'show values'))
	    selectors:#(startSimulation showValues)
	     receiver:self.

"
    menu at:(resources string:'debugging')
	    putLabels:(resources array:#('logic-probe'
					 '-'
					 'logic-analyzer'))
	    selectors:#(showProbe
			nil
			showAnalyzer)
	     receiver:self.
"
! !

!LogicTool methodsFor:'startup'!

open 
    |proto aString frame panelWidth|

    gridSize := 4.
    gridShown := false.
    resources := ResourcePack for:self class.


    topView := StandardSystemView
                 label:(self class name)
                 icon:(Image fromFile:('bitmaps/' , self class name , '.xbm') resolution:100)
                 minExtent:(100 @ 100).

    menu := PullDownMenu in:topView.

    self initMenu.

    "create a proto button to get its dimension"

    proto := Button label:(Input icon).
    panelWidth := (proto width + 5) * 2 + 10.

    commandPanel := PanelView
                        origin:(5 @ (menu height + 5))
                        extent:[panelWidth
                                @
                                (topView height - menu height - 10)]
                        in:topView.
    proto := nil.
"/    commandPanel layout:#top.

    frame := HVScrollableView for:LogicView in:topView.
    frame origin:[(commandPanel left + commandPanel width + 5)
                  @
                  (menu height + 5)].
    frame extent:[(topView width - commandPanel width - 10)
                  @
                  (topView height - menu height - 10)].

    logicView := frame scrolledView.

    (self class listOfObjectClasses) do:[:elClass |
        Button label:(elClass icon)
             action:[logicView createObjectWithClass:elClass]
                 in:commandPanel
    ].

    openErrorBox := WarningBox new.
    createErrorBox := WarningBox new.

    openBox := FileSelectionBox
                    title:(resources string:'open file')
                    "pattern:'*.logic'"
                    action:[:fileName | self openFile:fileName].

    saveBox := FileSelectionBox
                    title:(resources string:'save file')
                    "pattern:'*.logic'"
                    action:[:fileName | self saveAs:fileName].

    nameEnterBox := EnterBox
                        title:(resources string:'enter name')
                        action:[:aString | self nameIt:aString].

    subEnterBox := EnterBox
                        title:(resources string:'select sub-circuit')
                        action:[:aString | self addSubCircuitFromFile:aString].
    topView open

    "Modified: 24.1.1997 / 18:00:44 / cg"
! !

!LogicTool methodsFor:'user interaction'!

addSubCircuit
    subEnterBox show
!

addSubCircuitFromFile:aFileName
    |aStream aSubCircuit|
    aStream := FileStream readonlyFileNamed:aFileName.
    aStream isNil ifTrue:[
	openErrorBox title:(resources string:'file %1 not found or not readable' with:aFileName).
	openErrorBox show
    ] ifFalse:[
	aSubCircuit := aStream fileIn.
	aStream close.
	logicView add:aSubCircuit
    ]
!

connect
    |editMenu|

    editMenu := menu menuAt:(resources string:'edit').
    editMenu labelAt:5 put:(resources string:'disconnect').
    editMenu selectorAt:5 put:#disconnect.
    logicView connect
!

copySelection
    logicView copySelection
!

deleteSelection
    logicView deleteSelection
!

disconnect
    |editMenu|

    editMenu := menu menuAt:(resources string:'edit').
    editMenu labelAt:5 put:(resources string:'connect').
    editMenu selectorAt:5 put:#connect.
    logicView disconnect
!

doNew
    logicView removeAll
!

doOpen
    "self openFile:'.Draw'"
    openBox show
!

doPrint
    ^ self
!

doSave
    currentFileName notNil ifTrue:[
	self saveAs:currentFileName
    ] ifFalse:[
	saveBox show
    ]
!

doSaveAs
    saveBox show
!

finish
    topView destroy.
    openErrorBox destroy.
    createErrorBox destroy.
    nameEnterBox destroy.
    subEnterBox destroy.
    openBox destroy.
    saveBox destroy
!

gridOff
    |formMenu|

    formMenu := menu menuAt:(resources string:'form').
    formMenu labelAt:1 put:(resources string:'grid on').
    formMenu selectorAt:1 put:#gridOn.
    logicView grid:(1 @ 1)
!

gridOn
    |formMenu|

    formMenu := menu menuAt:(resources string:'form').
    formMenu labelAt:1 put:(resources string:'grid off').
    formMenu selectorAt:1 put:#gridOff.
    logicView grid:(gridSize @ gridSize)
!

gridSize
    (gridSize == 4) ifTrue:[
	gridSize := 8
    ] ifFalse:[
	gridSize := 4
    ].
    gridShown ifTrue:[
	logicView grid:(gridSize @ gridSize)
    ]
!

group
    logicView group
!

hideAnalyzer
!

hideGrid
    |formMenu|

    formMenu := menu menuAt:(resources string:'form').
    formMenu labelAt:3 put:(resources string:'show grid').
    formMenu selectorAt:3 put:#showGrid.
    logicView hideGrid.
    gridShown := false
!

hideProbe
    |debuggingMenu|

    debuggingMenu := menu menuAt:(resources string:'debugging').
    debuggingMenu selectorAt:1 put:#showProbe.
    logicView hideProbe
!

hideValues 
    |simulationMenu|

    simulationMenu := menu menuAt:(resources string:'simulation').
    simulationMenu selectorAt:2 put:#showValues.
    simulationMenu labelAt:2 put:(resources string:'show values').
    logicView  hideValues
!

nameIt
    nameEnterBox showAtPointer
!

nameIt:aName
    logicView nameSelection:aName
!

openFile:aFileName
    |aStream|
    aStream := FileStream readonlyFileNamed:aFileName.
    aStream isNil ifTrue:[
	openErrorBox title:(resources string:'file %1 not found or not readable' with:aFileName).
	openErrorBox show
    ] ifFalse:[
	logicView fileInContentsFrom:aStream.
	aStream close
    ]
!

pasteSelection
    logicView pasteBuffer
!

saveAs:aFileName
    |aStream|
    aStream := FileStream newFileNamed:aFileName.
    aStream isNil ifTrue:[
	createErrorBox title:(resources string:'cannot create file %1' with:aFileName).
	createErrorBox show
    ] ifFalse:[
	logicView storeContentsOn:aStream.
	aStream close
    ].
    currentFileName := aFileName
!

showAnalyzer
!

showGrid
    |formMenu|

    formMenu := menu menuAt:(resources string:'form').
    formMenu labelAt:3 put:(resources string:'hide grid').
    formMenu selectorAt:3 put:#hideGrid.
    logicView showGrid.
    gridShown := true
!

showProbe
    |debuggingMenu|

    debuggingMenu := menu menuAt:(resources string:'debugging').
    debuggingMenu selectorAt:1 put:#hideProbe.
    logicView showProbe
!

showValues
    |simulationMenu|

    simulationMenu := menu menuAt:(resources string:'simulation').
    simulationMenu selectorAt:2 put:#hideValues.
    simulationMenu labelAt:2 put:(resources string:'hide values').
    logicView showValues
!

startSimulation
    |simulationMenu|

    simulationMenu := menu menuAt:(resources string:'simulation').
    simulationMenu selectorAt:1 put:#stopSimulation.
    simulationMenu labelAt:1 put:(resources string:'stop').
    logicView startSimulation
!

stopSimulation
    |simulationMenu|

    simulationMenu := menu menuAt:(resources string:'simulation').
    simulationMenu selectorAt:1 put:#startSimulation.
    simulationMenu labelAt:1 put:(resources string:'start').
    logicView stopSimulation
! !

!LogicTool class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/LogicTool/LogicTool.st,v 1.11 2013-07-09 21:03:47 cg Exp $'
! !


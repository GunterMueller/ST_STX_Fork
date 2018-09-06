"
 COPYRIGHT (c) 1993 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Smalltalk }"

InspectorView subclass:#ContextInspectorView
	instanceVariableNames:'inspectedContext names showingTemporaries argsOnly contextSize
		workspaceVariableNamesInDoIts'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Inspector'
!

!ContextInspectorView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1993 by Claus Gittinger
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
    a modified Inspector for Contexts (used in the Debugger)
    TODO:
        when expressions are evaluated in myself, the inst-var
        names are not known by the expression evaluator.
        This has to be fixed 
        (actual work is to be done in the Parser to allow passing of a context ...)

    [author:]
        Claus Gittinger

    [see also:]
        Context DebugView
"
! !

!ContextInspectorView methodsFor:'accessing'!

inspect:aContext
    "set the context to be inspected"

    |methodHomeContext method homeNames rec sel 
     m blockNode 
     numVarsInSource numVarsInContext isDoIt
     numArgs numVars n tempNames realTempNames 
     oldSelection oldSelectedName hCon keepList newList|

    oldSelection := selectionIndex.
    oldSelection notNil ifTrue:[
        oldSelectedName := (self listEntryAt:oldSelection).
        oldSelectedName notNil ifTrue:[
            oldSelectedName := oldSelectedName string
        ]
    ].

    keepList := ((aContext == inspectedContext)
                "/ care for contexts which change size
                "/ (after the locals & stack-setup)
                and:[ contextSize == inspectedContext size 
                "/ care for JavaContexts whose set of visible variables
                "/ may change during method execution ( nested block locals... )
                and:[ aContext isJavaContext not 
                ]]).

    keepList ifTrue:[
        "/ assume that the list remains unchanged;
        "/ this is no longer true, if some inst-slot has changed (bullet colors)
        UserPreferences current showTypeIndicatorInInspector ifTrue:[
            newList := self fieldList.
            newList ~= listView list ifTrue:[
                listView list:newList. 
            ]    
        ].
    ] ifFalse:[
        hasMore := argsOnly := false.
        inspectedObject := object := nil.
        inspectedContext := object := aContext.
        contextSize := inspectedContext size.

        workspaceVariableNamesInDoIts := nil.
        aContext isNil ifTrue:[
            names := nil.
            listView list:nil. 
            ^ self
        ].

        methodHomeContext := aContext methodHome.
        (methodHomeContext isNil) ifTrue:[
            "its a cheap block's context"
            rec := aContext receiver.
            sel := aContext selector.
            homeNames := OrderedCollection new.
            isDoIt := false.
        ] ifFalse:[
            rec := methodHomeContext receiver.
            sel := methodHomeContext selector.

            "/ #doIt needs special handling below
            isDoIt := (sel == #doIt) or:[sel == #doIt:].
            method := methodHomeContext method.

            (method notNil and:[method isWrapped]) ifTrue:[
                "/ in a wrapped context, locals are something different
                argsOnly := true.

                m := method originalMethod.
                m notNil ifTrue:[
                    method := m.
                ] ifFalse:[
                    argsOnly := true.
                ].
            ].

            method notNil ifTrue:[
                argsOnly ifFalse:[
                    homeNames := method methodArgAndVarNamesInContext: methodHomeContext.

                    "/ did it already allocate its locals ?
                    "/                 |-----------------------------| care about Java contexts where this is first arg
                    (homeNames size > (methodHomeContext arg1Index - 1 + methodHomeContext numArgs + methodHomeContext numVars)) ifTrue:[
                        argsOnly := true.
                    ].
                ].
                argsOnly ifTrue:[
                    homeNames := method methodArgNames
                ].

                "/ there is one case, where the above is by purpose:
                "/ the #doIt - method, which has been given an invalid source.
                "/ Care for this here.
                isDoIt ifTrue:[
                    homeNames := #().
                ] ifFalse:[
                    "/ check
                    numVarsInContext := methodHomeContext argsAndVars size.
                    numVarsInSource := homeNames size.

                    numVarsInSource > 0 ifTrue:[
                        numVarsInContext < numVarsInSource ifTrue:[
                            "/ the methods source does not correctly reflect
                            "/ the number of args&vars in the context.
                            "/ either outDated, or somehow strange.
                            "/ (happens with wrapped methods, which are not
                            "/  what they look)

                            numVarsInSource > numVarsInContext ifTrue:[
                                homeNames := homeNames copyTo:numVarsInContext.
                            ] ifFalse:[
                                numVarsInContext >= methodHomeContext numArgs ifTrue:[
                                    homeNames := homeNames copyTo:methodHomeContext numArgs
                                ] ifFalse:[
                                    homeNames := nil
                                ]    
                            ]
                        ]
                    ]
                ]
            ].

            "
             create dummy names for method vars (if there is no source available)
            "
            homeNames isNil ifTrue:[
                homeNames := OrderedCollection new.
                1 to:methodHomeContext numArgs do:[:index |
                    homeNames add:('mArg' , index printString)
                ].
                argsOnly ifFalse:[
                    1 to:methodHomeContext numVars do:[:index |
                        homeNames add:('mVar' , index printString)
                    ].
    "/                showingTemporaries ifTrue:[
    "/                    1 to:methodHomeContext numTemps do:[:index |
    "/                        homeNames add:('mTmp' , index printString)
    "/                    ]
    "/                ]
                ]
            ].
            showingTemporaries ifTrue:[
                homeNames := homeNames asOrderedCollection.
                1 to:methodHomeContext numTemps do:[:index |
                    homeNames add:('mTmp' , index printString)
                ]
            ].

            n := homeNames size.
            n < (((argsOnly or:[methodHomeContext isJavaContext]) ifTrue:[0] ifFalse:[ methodHomeContext numVars]) + methodHomeContext numArgs) ifTrue:[
                "/ its a context which includes locals from
                "/ inlined sub-blocks.
                "/ First, generate synthetic varNames ...

                homeNames := homeNames asOrderedCollection.
                tempNames := OrderedCollection new.
                n to:(methodHomeContext numVars + methodHomeContext numArgs - 1) do:[:inlinedTempIdx |
                    tempNames add:('*t' , (inlinedTempIdx - n + 1) printString)
                ].

                "/ now, see if we can find out more
                "/ (fails, if source is not available)

                method notNil ifTrue:[
                    (isDoIt and:[tempNames size > 0]) ifTrue:[
                        "/ special for #doIt
                        "/ my source is found in the method.
                        blockNode := Compiler
                                        blockAtLine:aContext lineNumber
                                        in:nil
                                        orSource:('[' , method source , '\]') withCRs
                                        numArgs:numArgs 
                                        numVars:numVars.
                    ] ifFalse:[
                        blockNode := Compiler 
                                        blockAtLine:methodHomeContext lineNumber
                                        in:method
                                        orSource:nil
                                        numArgs:numArgs
                                        numVars:numVars.
                    ].

                    realTempNames := OrderedCollection new.
                    [blockNode notNil] whileTrue:[
                        blockNode variables notNil ifTrue:[
                            realTempNames := (blockNode variables collect:[:aVar | aVar name]) , realTempNames.
                        ].
                        blockNode arguments notNil ifTrue:[
                            realTempNames := (blockNode arguments collect:[:aVar | aVar name]) , realTempNames.
                        ].
                        "/
                        "/ hidden temps used for loop.
                        "/
                        blockNode invocationSelector == #timesRepeat ifTrue:[
                            realTempNames := realTempNames asOrderedCollection.
                            realTempNames addFirst:'*loopStop*'
                        ] ifFalse:[
                            blockNode invocationSelector == #to:do: ifTrue:[
                                realTempNames := realTempNames asOrderedCollection.
                                realTempNames addFirst:'*loopStop*'
                            ]
                        ].
                        blockNode := blockNode home.
                    ].
                    tempNames 
                            replaceFrom:1 to:(tempNames size min:realTempNames size)
                            with:realTempNames.
                ].
                homeNames addAll:tempNames.
            ].
            isDoIt ifTrue:[
                "/ care for workspace- and doIt vars
                method notNil ifTrue:[
                    |p names wsNames|

                    wsNames := Workspace workspaceVariableNames.
                    wsNames notEmptyOrNil ifTrue:[
                        p := Parser new source:method source; parseMethodBody; yourself.
                        names := (Set withAll:p readGlobals) addAll:p modifiedGlobals; yourself.
                        workspaceVariableNamesInDoIts := (names select:[:nm | wsNames includes:nm] ) 
                                                            asOrderedCollection sort.
                    ].
                ].
            ].
        ].

        "
         stupid: should find the block via the contexts
         method-home and put real names in here
        "
        aContext isBlockContext ifTrue:[
            names := self namesOfBlockContext:aContext.
            hCon := aContext home.
            [hCon == methodHomeContext] whileFalse:[
                names addAll:(self namesOfBlockContext:hCon).
                hCon := hCon home.
            ].
            names addAll:homeNames.
        ] ifFalse:[
            names := homeNames.
        ].

        listView list:(self fieldList). 

        workspace contents:nil.
        self setDoitActionIn:workspace for:aContext.
    ].

    oldSelectedName notNil ifTrue:[
        |idx|

        idx := listView list findFirst:[:entry | (entry ? '') string = oldSelectedName].
        idx ~~ 0 "(names includes:oldSelectedName)" ifTrue:[
            listView selectElement:oldSelectedName.
            self showSelection:idx.
        ]
    ].

    "Modified: / 03-06-2012 / 11:56:59 / cg"
    "Modified: / 05-11-2013 / 15:44:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

namesOfBlockContext:aContext
    |numArgs numVars argAndVarNames argNames varNames tmpNames names|

    numArgs := aContext numArgs.
    numVars := aContext numVars.

    (numArgs + numVars) > 0 ifTrue:[
        argAndVarNames := aContext argAndVarNames.
        argAndVarNames notEmptyOrNil ifTrue:[
            argNames := argAndVarNames copyTo:numArgs.
            varNames := argAndVarNames copyFrom:numArgs+1.
        ].
    ].

    names := OrderedCollection new.

    argNames isNil ifTrue:[
        argNames := (1 to:numArgs) collect:[:i | 'arg' , i printString].
    ].

    names addAll:argNames.
    varNames isNil ifTrue:[
        varNames := (1 to:numVars) collect:[:i | 'var' , i printString].
    ] ifFalse:[
        varNames size ~~ numVars ifTrue:[
            varNames := varNames asOrderedCollection.
            varNames size+1 to:aContext numVars do:[:i |
                varNames add:('var' , i printString)
            ]
        ]
    ].

    names addAll:varNames.

    showingTemporaries ifTrue:[
        tmpNames := (1 to:(aContext numTemps)) collect:[:i | 'tmp' , i printString].
        names addAll:tmpNames.
    ].

    ^ names
!

release
    "release inspected object"

    inspectedContext := nil.
    names := nil.
    super release

    "Modified: 14.12.1995 / 21:49:43 / cg"
! !

!ContextInspectorView methodsFor:'initialization'!

initialize
    super initialize.
    showingTemporaries := false.

! !

!ContextInspectorView methodsFor:'menu'!

fieldMenu
    "return a popUpMenu for the left (fields) pane"

    <resource: #programMenu >

    |items m sel|

    items := #(
                   ('Copy Name or Key'      #doCopyKey)
                   ('-')
                   ('Inspect'               #doInspect)
                   ('BasicInspect'          #doBasicInspect)
             ).
    NewInspector::NewInspectorView notNil ifTrue:[
        items := items , #(
                       ('Inspect Hierarchical'         #doNewInspect           )
                ).
    ].
    items := items , #(
                   ('-')
                   ('Browse'                #browse)
              ).

    sel := self selection.

    (sel isSymbol) ifTrue:[
        items := items , #(
                       ('Browse Implementors'           #browseImplementorsOfSymbolValue)
              ).
    ].

    Error 
        handle:[:ex| ]
        do:[
            (sel isBlock or:[sel isContext]) ifTrue:[
                items := items , #(
                               ('Browse Block''s Home'           #browseHome)
                      ).
            ].
            (sel isMethod) ifTrue:[
                items := items , #(
                               ('Browse Method''s Class'         #browseMethodsClass)
                         ).
            ].
        ].

    sel isProtoObject ifFalse:[
        items := items , (self optionalStreamSelectionItems).
        items := items , (self optionalFilenameSelectionItems).
    ].

    items := items , #(
               ('-')
              ).

    showingTemporaries ifFalse:[
        items := items , #(
                       ('Show Temporaries'      #showTemporaries)
                  )
    ] ifTrue:[
        items := items , #(
                       ('Hide temporaries'      #hideTemporaries)
                  )
    ].

    items := items , (self numberBaseItems).
    items := items , (self sortOrderItems).

    m := PopUpMenu
          itemList:items
          resources:resources.

    selectionIndex isNil ifTrue:[
        m disableAll:#(doInspect doBasicInspect browse browseHome browseImplementorsOfSymbolValue)
    ] ifFalse:[
        sel isBlock ifFalse:[
            m disable:#browseHome
        ].
        sel class hasImmediateInstances ifTrue:[
            m disableAll:#(showReferences doNewInspect)
        ].
    ].
    ^ m

    "Modified: / 20-07-2012 / 10:51:12 / cg"
! !

!ContextInspectorView methodsFor:'private'!

defaultLabel
    ^ 'Locals'

    "
     ContextInspectorView openOn:thisContext sender
    "

    "Modified: 28.6.1996 / 16:07:49 / cg"
!

displayStringForValue:someValue 
    "return the values displayString"

    |sel|

    sel := self listEntryAt:selectionIndex.
    (sel startsWith:'-all local vars') ifTrue:[
        ^ self stringWithAllLocalValues
    ].
    (sel startsWith:'-all workspace vars') ifTrue:[
        ^ self stringWithAllWorkspaceValues
    ].

    ^ super displayStringForValue:someValue

    "Modified: / 16-05-2012 / 17:55:33 / cg"
!

fieldList
    "generate a list of names (& pseudo names) to be shown on the left side"

    |list|

    inspectedContext isNil ifTrue:[ ^ #() ].

    names size == 0 ifTrue:[
        (inspectedContext isBlockContext and:[inspectedContext home isNil]) ifTrue:[
            "/ hack to guide beginners
            ^ { '>> no home in cheap block <<' withColor:Color gray }
        ].
        list := #()
    ] ifFalse:[
        list := { '-','all local vars' allItalic } 
                , (names keysAndValuesCollect:
                        [:idx :nm | self listEntryForName:nm value:(self valueAtIndex:idx) ]
                  )
    ].

    workspaceVariableNamesInDoIts notEmptyOrNil ifTrue:[
        list := list 
                , { '-','all workspace vars' allItalic} 
                , (workspaceVariableNamesInDoIts keysAndValuesCollect:
                        [:idx :nm | self listEntryForName:nm value:(Workspace workspaceVariableAt:nm) ]
                  )
    ].

    ^ list

    "Modified: / 16-05-2012 / 18:54:59 / cg"
    "Modified: / 25-02-2014 / 15:10:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSelfEntry
    ^ false

    "Created: 14.12.1995 / 19:29:47 / cg"
!

setDoitActionIn:aWorkspace for:aContext
    aWorkspace 
        doItAction:[:theCode |
            Compiler 
                evaluate:theCode
                in:aContext
                receiver:nil
                notifying:aWorkspace
                logged:true 
                ifFail:nil
        ]
!

stringWithAllLocalValues
    "when clicked on '-all local vars'"

    ^ self stringWithAllNames:names andValues:((1 to:names size) collect:[:i| (self valueAtIndex:i)])
!

stringWithAllNames:names andValues:values
    "helper for '-all local vars' and '-all workspace vars'"

    |outStream  maxLen varString|

    outStream := CharacterWriteStream new.
    maxLen := (names collect:[:eachName | eachName size]) max.

    names with:values do:[:eachName :eachValue |
        outStream nextPutAll:((eachName , ' ') paddedTo:maxLen+1 with:$.).
        outStream nextPutAll:' : '.

        [
            |s|

            s := CharacterWriteStream new.
            s writeLimit:100000.
            eachValue displayOn:s.
            varString := s contents.
        ] on:Error do:[:ex |
            varString := ('*** Error in displayString (%1)***' bindWith:ex description)
        ].

        (varString includes:Character cr) ifTrue:[
            varString := varString copyTo:(varString indexOf:Character cr)-1.
            varString := varString , '...'.
        ].
        outStream nextPutAll:varString.
        outStream cr.
    ].
    ^ outStream contents
!

stringWithAllWorkspaceValues
    "when clicked on '-all workspace vars'"

    ^ self 
        stringWithAllNames:workspaceVariableNamesInDoIts 
        andValues:(workspaceVariableNamesInDoIts collect:[:nm| Workspace workspaceVariableAt:nm])
!

valueAtIndex:varIdx
    "helper - return the value of the selected entry"

    |methodHomeContext hCon theContext values|

    inspectedContext isNil ifTrue:[^ nil].

    "/ argsOnly := false.
    theContext := inspectedContext.
    methodHomeContext := theContext methodHome.

    theContext isBlockContext ifTrue:[
        values := Array withAll:(theContext argsAndVars).
        (showingTemporaries and:[theContext numTemps ~~ 0]) ifTrue:[
            values := values , theContext temporaries
        ].
        hCon := theContext home.
        [hCon == methodHomeContext] whileFalse:[
            values := values , hCon argsAndVars.
            (showingTemporaries and:[theContext numTemps ~~ 0]) ifTrue:[
                values := values , hCon temporaries
            ].
            hCon := hCon home.
        ].

        methodHomeContext notNil ifTrue:[
            values := values , methodHomeContext args.
            argsOnly ifFalse:[
                values := values , methodHomeContext vars.
                (showingTemporaries and:[methodHomeContext numTemps ~~ 0])ifTrue:[
                    values := values , methodHomeContext temporaries
                ]
            ].
        ].
    ] ifFalse:[
        argsOnly ifTrue:[
            values := methodHomeContext args
        ] ifFalse:[
            values := methodHomeContext argsAndVars
        ].
        (showingTemporaries and:[methodHomeContext numTemps ~~ 0])ifTrue:[
            values := values , methodHomeContext temporaries
        ]

    ].
    
    varIdx > values size ifTrue:[
        |wsIndex|

        workspaceVariableNamesInDoIts notNil ifTrue:[
            wsIndex := varIdx - values size - 1.
            wsIndex <= workspaceVariableNamesInDoIts size ifTrue:[
                ^ Workspace workspaceVariableAt:(workspaceVariableNamesInDoIts at:wsIndex).
            ].
        ].
        ^ '** oops - could not find value **'
    ].

    ^ values at:varIdx.

    "Modified: / 13.1.1998 / 15:55:16 / cg"
!

valueAtLine:lineNr
    "helper - return the value of the selected entry"

    |varIdx l|

    inspectedContext isNil ifTrue:[^ nil].

    varIdx := lineNr.
    l := self listEntryAt:lineNr.
    l isNil ifTrue:[ ^nil].

    (l startsWith:'>>') ifTrue:[
        "/ a comment (hack)
        ^ self valueForCommentLine:(self listEntryAt:lineNr)
    ].
    (l startsWith:$-) ifTrue:[
        (l ~= '-') ifTrue:[
            ^ self valueForSpecialLine:(self listEntryAt:lineNr)
        ].
    ].
    ^ self valueAtIndex:(varIdx - 1). "/ for the special var

    "Modified: / 16-05-2012 / 17:55:57 / cg"
!

valueForCommentLine:line
    "/ a hack to guide beginners
    (line startsWith:'>> no home') ifTrue:[
        ^ 'Cheapblocks do not refer to any variable in
their defining outer context 
(i.e. they only refer to self and arguments).
Therefore, they do not keep a reference to the outer context.
This is a compiler optimization, leading to a slight inconvenience here.'
    ].

    ^ nil
!

valueForSpecialLine:line
    (line startsWith:'-all local vars') ifTrue:[
        ^ inspectedObject
    ].
    (line startsWith:'-all workspace vars') ifTrue:[
        ^ workspaceVariableNamesInDoIts collect:[:nm | Workspace workspaceVariableAt:nm].
    ].

    self error:'unknown special line'.

    "Created: / 31.10.2001 / 09:17:45 / cg"
! !

!ContextInspectorView methodsFor:'user actions'!

hideTemporaries
    "do not show contexts temporaries"

    showingTemporaries := false.
    self inspect:inspectedContext

    "Modified: 14.12.1995 / 19:24:44 / cg"
!

showTemporaries
    "show contexts temporaries"

    showingTemporaries := true.
    self inspect:inspectedContext

    "Modified: 14.12.1995 / 19:24:49 / cg"
!

valueAtLine:lineNr put:newValue
    "helper - return the value of the selected entry"

    |indexOfFirstNonSpecial contextIndex|

    inspectedContext isNil ifTrue:[^ self].

    "/ count the special lines
    indexOfFirstNonSpecial := self fieldList findFirst:[:l | (l string startsWith:'-') not].
    indexOfFirstNonSpecial == 0 ifTrue:[
        ^ self
    ].

    contextIndex := lineNr - indexOfFirstNonSpecial + 1.

    "yes, you can do that with a context"
    inspectedContext at:contextIndex put:newValue.
! !

!ContextInspectorView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


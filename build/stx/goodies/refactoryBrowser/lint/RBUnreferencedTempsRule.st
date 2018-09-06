"
 Copyright (C) 2014 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

RBBlockLintRule subclass:#RBUnreferencedTempsRule
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Block Rules'
!

RBProgramNodeVisitor subclass:#VariableSearcher
	instanceVariableNames:'scopeTemps scopeArgs scopeTempNames scopeArgNames
		remainingScopeTemps remainingScopeTempNames unreferenced'
	classVariableNames:''
	poolDictionaries:''
	privateIn:RBUnreferencedTempsRule
!

!RBUnreferencedTempsRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2014 Claus Gittinger

 Permission is hereby granted, free of charge, to any 
 person obtaining a copy of this software and associated 
 documentation files (the 'Software'), to deal in the 
 Software without restriction, including without limitation 
 the rights to use, copy, modify, merge, publish, distribute, 
 sublicense, and/or sell copies of the Software, and to 
 permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall 
 be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
"
! !

!RBUnreferencedTempsRule methodsFor:'accessing'!

group
        ^ 'Unnecessary Code'
!

name         
    ^ 'Temporary not used'
!

rationale
    ^ self 
        appendSearchStringsResultAs:'Unused variables:' 
        toRationale: 
'Check for unreferenced temporaries. 
If a variable is not used in a method, it can be removed.'.
!

severity
        ^ SeverityInformation
! !

!RBUnreferencedTempsRule methodsFor:'displaying'!

infoInToolTip
    "by default, show the name and the group of the rule in the tooltip;
     redefined here to show up to 3 names of unreferenced temps."

    |info strings more foo bar baz bla|

    info := super infoInToolTip.
    
    "/ append the unreferenced temps
    (result notNil and:[(strings := result searchStrings) notEmptyOrNil]) ifTrue:[
        more := ''.
        strings size > 3 ifTrue:[ more := ',...' ].
        ^ info,' (',((strings copyToMax:3) asStringWith:', '),more,')'.
    ].    
    ^ info 
! !

!RBUnreferencedTempsRule methodsFor:'running'!

checkMethod: aContext 
    |tree visitor src method|

    src := aContext sourceCode.
    "a quick rejector, to avoid many parses (because parsing is very slow)"
    (src includes:$|) ifFalse:[^ self].

    method := aContext compiledMethod.

    "/ if there is primitive C code, don't apply this rule.
    "/ (to avoid false positives, if var is accessed inside the unparsed C code)
    (src includesString:'%{') ifTrue:[
        ^ self.
    ].
    "/ don't check the template method
    (src = SmalltalkLanguage instance methodTemplate) ifTrue:[
        ^ self
    ].
    
    tree := aContext parseTree.
    visitor := VariableSearcher new.
    tree acceptVisitor:visitor.

    visitor unreferenced do:[:eachUnreferenced |
        result 
            addClass: aContext selectedClass
            selector: aContext selector;
            addSearchAction:(RBEnvironmentStringSelectAction 
                                selectFrom:eachUnreferenced start 
                                to:eachUnreferenced stop 
                                inMethod:method);
            "/ for now, these are kept for the rationale
            addSearchString: eachUnreferenced name.
    ].

    "Modified (format): / 25-11-2016 / 08:20:27 / cg"
! !

!RBUnreferencedTempsRule::VariableSearcher methodsFor:'accessing'!

unreferenced
    ^ unreferenced ? #()
! !

!RBUnreferencedTempsRule::VariableSearcher methodsFor:'visiting'!

acceptBlockNode:aBlockNode
    |body|

    body := aBlockNode body.
    self 
        processScopeWithArguments:aBlockNode arguments 
        locals:body temporaries 
        body:body
!

acceptMethodNode:aMethodNode
    scopeTempNames := OrderedCollection new.
    scopeArgNames := OrderedCollection new.
    remainingScopeTempNames := OrderedCollection new.
    
    self 
        processScopeWithArguments:aMethodNode arguments
        locals:aMethodNode temporaries
        body:aMethodNode body.
        
"/    |remaining args temps tempNames|
"/
"/    scopeArgs add:(args := aMethodNode arguments).
"/    scopeArgNames add:(args collect:[:v | v name]).
"/    scopeTemps add:(temps := aMethodNode temporaries).
"/    scopeTempNames add:(tempNames := temps collect:[:v | v name]).
"/    remainingScopeTemps add:temps copy.
"/    remainingScopeTempNames add:tempNames copy.
"/    
"/    "/ do not visit the arguments
"/    aMethodNode body statements do: [:each | self visitNode: each].
"/
"/    scopeArgs removeFirst.
"/    scopeTemps removeFirst.
"/    (remaining := remainingScopeTemps removeFirst) notEmpty ifTrue:[
"/        unreferenced isNil ifTrue:[
"/            unreferenced := OrderedCollection new.
"/        ].
"/        unreferenced addAll:remaining.
"/    ].
!

acceptVariableNode:aNode
    |variableName varNames argNames|

    variableName := aNode name.
    
    scopeTempNames size to:1 by:-1 do:[:scopeIndex |
        varNames := scopeTempNames at:scopeIndex.
        (varNames includes:variableName) ifTrue:[
            "/ remove it from the name list; token list will be cleaned up at the end
            (remainingScopeTempNames at:scopeIndex) remove:variableName ifAbsent:[].
            ^ self
        ].
        argNames := scopeArgNames at:scopeIndex.
        (argNames includes:variableName) ifTrue:[
            ^ self
        ].
    ].    
        
"/    found := false.
"/    1 to:scopeTemps size do:[:i |
"/        |args vars remaining|
"/
"/        found ifFalse:[
"/            args := scopeArgs at:i.
"/            vars := scopeTemps at:i.
"/            remaining := remainingScopeTemps at:i.
"/
"/            "/ cg: here args are searched first; seems wrong to me,
"/            "/ as in theory, locals are inner to the args.
"/            "/ in practice, you'd get a warning (local hides argument)
"/            "/ when accepting, but you may proceed...
"/            (args contains:[:n | n name = aVariableName]) ifFalse:[
"/                |nd|
"/
"/                nd := vars detect:[:n | n name = aVariableName] ifNone:nil.
"/                nd notNil ifTrue:[
"/                    remaining removeIdentical:nd ifAbsent:[].
"/                    found := true.
"/                ]
"/            ]
"/        ].
"/    ].
!

processScopeWithArguments:arguments locals:temporaries body:body
    |tempNames remainingNames foo|

    scopeArgNames add:(arguments collect:[:v | v name]).  
    scopeTempNames add:(tempNames := temporaries collect:[:v | v name] as:Set).  
    remainingScopeTempNames add:tempNames copy.
"/ foo
    "/ do not visit the arguments
    body statements do: [:each | self visitNode: each].

    scopeArgNames removeLast.
    scopeTempNames removeLast.
    remainingNames := remainingScopeTempNames removeLast.

    remainingNames notEmpty ifTrue:[
        unreferenced isNil ifTrue:[
            unreferenced := OrderedCollection new.
        ].
        temporaries 
            select:[:node | remainingNames includes:node name]
            thenDo:[:remainingNode |
                unreferenced add:remainingNode
            ].    
    ].
! !

!RBUnreferencedTempsRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

RBLintRule subclass:#RBBasicLintRule
	instanceVariableNames:'result'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint'
!

!RBBasicLintRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) Original SmallLint Authors
 Copyright (C) The Squeak Team
 Copyright (C) The Pharo Team
 Copyright (C) 2011-2013 Jan Vrany (porting, Smalltalk/X rules & tweaks)
 Copyright (C) 2011-2013 Claus Gittinger (porting, Smalltalk/X rules & tweaks)

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

!RBBasicLintRule class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == RBBasicLintRule.
! !

!RBBasicLintRule methodsFor:'accessing'!

appendSearchStringsResultAs:what makingActionString:aBlockMakingAnActionString toRationale:aRationale
    "for better information in a rationale (after the search),
     return aRationale with the found strings appended to it (as html)"
     
    |strings|

    result notNil ifTrue:[
        (strings := result searchStrings) notEmptyOrNil ifTrue:[
            ^ String streamContents:[:s |
                s nextPutAll:aRationale. 
                s nextPutAll:'<p>'.
                s nextPutAll:what; nextPutAll:' '.
                strings 
                    do:[:each |
                        s nextPutAll:'"<B>'.
                        s nextPutAll:(aBlockMakingAnActionString value:each).
                        s nextPutAll:'</B>"'.
                    ]
                    separatedBy:[
                        s nextPutAll:', '
                    ].
            ]        
        ].
    ].
    ^ aRationale
!

appendSearchStringsResultAs:what toRationale:aRationale
    "for better information in a rationale (after the search),
     return aRationale with the found strings appended to it (as html)"
     
    ^ self 
        appendSearchStringsResultAs:what
        makingActionString:[:string | string] "/ generates the string as-is
        toRationale:aRationale    
!

filteredResult
        "Be very careful when filtering results not to introduce new items and not to lose the dedicated browser environments. Try the following steps in order:
        
        - If this is a selector environment use the set-operations of the refactoring browser.
        - If this is a class environment, remove the classes that have a filter annotation in any of its methods.
        - If this is a variable environment, remove the classes and all its variables that have a filter annotation in any of its methods.
        - Otherwise return the unfiltered environment."

        | filter |

        result isEmptyOrNil ifTrue: [ ^ result ].

        filter := PragmaEnvironment
                onEnvironment: BrowserEnvironment new
                keywords: #( lint: lint:rationale: lint:rationale:author: lint:author: 
                             ignoreLintRule: ignoreLintRule:rationale: 
                             ignoreLintRule:rationale:author: ignoreLintRule:author: ).
        filter condition: 
            [ :pragma |
                |pragmaArguments firstPragmaArgument|

                pragmaArguments := pragma arguments.
                firstPragmaArgument := pragmaArguments first.
                firstPragmaArgument = self name
                    or: [ firstPragmaArgument = self group
                    or: [ firstPragmaArgument = self class name ] ] 
            ].

        result isSelectorEnvironment ifTrue: [ ^ result & filter not ].

        result isClassEnvironment ifTrue: [ 
            filter classesDo: [ :class | result removeClass: class ] 
        ] ifFalse: [
            (result isKindOf: VariableEnvironment) ifTrue: [
                filter classesDo: [ :class |
                    class classVarNames do: [ :var | result removeClass: class classVariable: var ].
                    class instVarNames do: [ :var | result removeClass: class instanceVariable: var ] 
                ] 
            ] 
        ].
        ^ result

    "Modified (format): / 19-11-2016 / 12:37:02 / cg"
!

problemCount
    result isNil ifTrue:[^ 0].
    ^ result problemCount

    "Modified: / 19-11-2016 / 12:32:43 / cg"
!

result
	^ result
! !

!RBBasicLintRule methodsFor:'converting'!

skippedInLiteralEncoding

    ^super skippedInLiteralEncoding , #( result )

    "Created: / 27-02-2013 / 09:33:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBBasicLintRule methodsFor:'helpers'!

appendVariableNamesFromResultToRationale:rationaleMessage
    "extract instance- and class-variables from the result,
     and append to the given rationaleMessage.
     Common code used by rationale of readNotWritten and unref'd vars rules"

    |msg cls action classes instVars classVars classInstVars collector appendThem|

    result notNil ifTrue:[
        collector := 
            [:dict |
                |c|
                dict isEmpty ifTrue:[
                    ''
                ] ifFalse:[
                    dict keys size == 1 ifTrue:[
                        dict values first asOrderedCollection sort.
                    ] ifFalse:[
                        dict keysAndValuesCollect:[:cls :names |
                            (names asOrderedCollection sort
                                collect:[:nm | nm,' (',(cls isBehavior ifTrue:[cls name] ifFalse:[cls]),')'])
                                    asStringCollection
                                        asString
                        ].
                    ]
                ]
            ].
        instVars := collector value:result instanceVariables.
        classVars := collector value:result classVariables.
        "/ classInstVars := collector value:result classInstanceVariables.
    ].

    msg := rationaleMessage.

    classes := result classes.
    classes size == 1 ifTrue:[
        cls := classes anElement.
        action := '"doit: UserPreferences systemBrowserClass openInClass:',cls name,' selector:nil"'.
    ] ifFalse:[
        classes size > 1 ifTrue:[
            action := '"doit: UserPreferences systemBrowserClass browseClasses:{',
                        ((classes asArray collect:[:c | c name]) asStringWith:' . '),'}"'.
        ] ifFalse:[
            action := '"doit: UserPreferences systemBrowserClass open"'.
        ].
    ].

    appendThem := [:vars :what |
        vars notEmptyOrNil ifTrue:[
            msg := msg , '\<P>',what,' variable(s): '.
            msg := msg , '<ul>'.
            vars do:[:each | 
                msg := msg , '<li>
                                <A
                                    ACTION=',action,' 
                                    INFO="Click to browse">
                                <code>',each,'</code>
                                </A>'
            ].
            msg := msg , '\</ul>'.
        ].
    ].

    appendThem value:instVars value:'Affected Instance'.
    appendThem value:classVars value:'Affected Class'.
    appendThem value:classInstVars value:'Affected Class Instance'.

    ^ msg withCRs

    "Created: / 07-03-2012 / 18:26:09 / cg"
!

appendVariableNamesFromResultsSearchStringsToRationale:rationaleMessage
    "extract names from the result's searchStrings,
     and append to the given rationaleMessage.
     Common code used by rationale of var ref'd once (and maybe other) rules"

    |msg cls action vars appendThem|

    result notNil ifTrue:[
        vars := result searchStrings.
    ].

    msg := rationaleMessage.

    result classes size == 1 ifTrue:[
        cls := result classes anElement.
        action := '"doit: UserPreferences systemBrowserClass openInClass:',cls name,' selector:nil"'.
    ] ifFalse:[
        result classes size > 1 ifTrue:[
            action := '"doit: UserPreferences systemBrowserClass browseClasses:{',
                        ((result classes asArray collect:[:c | c name]) asStringWith:' . '),'}"'.
        ] ifFalse:[
            action := '"doit: UserPreferences systemBrowserClass open"'.
        ].
    ].

    appendThem := [:vars :what |
        vars notEmptyOrNil ifTrue:[
            msg := msg , '\<P>',what,' variable(s): '.
            msg := msg , '<ul>'.
            vars do:[:each | 
                msg := msg , '<li>
                                <A
                                    ACTION=',action,' 
                                    INFO="Click to browse">
                                <code>',each,'</code>
                                </A>'
            ].
            msg := msg , '\</ul>'.
        ].
    ].

    appendThem value:vars value:'Affected Local'.

    ^ msg withCRs

    "Created: / 07-03-2012 / 18:26:09 / cg"
! !

!RBBasicLintRule methodsFor:'initialization'!

initialize
	super initialize.
	self resetResult
	
! !

!RBBasicLintRule methodsFor:'private'!

failedClassesInto:aStream 
    result notNil ifTrue:[
        result classesInto:aStream.
    ].

    "Created: / 10-01-2009 / 15:14:23 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 13-01-2009 / 16:53:28 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 19-11-2016 / 12:04:58 / cg"
!

failedMethodsInto:aStream 
    result isNil ifFalse:[
        result methodsInto:aStream.
    ].

    "Created: / 08-01-2009 / 09:46:48 / Jiri Bazant <bazanj2@fel.cvut.cz>"
    "Modified: / 12-01-2009 / 23:19:05 / Jiri Bazant <bazanj2@fel.cvut.cz>"
! !

!RBBasicLintRule methodsFor:'running'!

resetResult
	result := self resultClass new.
	result label: self name
! !

!RBBasicLintRule methodsFor:'testing'!

isEmpty
    ^ result isNil or:[result isEmpty]

    "Modified: / 19-11-2016 / 12:04:36 / cg"
! !

!RBBasicLintRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


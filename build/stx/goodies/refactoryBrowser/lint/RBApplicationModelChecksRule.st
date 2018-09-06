"
 Copyright (C) 2013 Claus Gittinger

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

RBBlockLintRule subclass:#RBApplicationModelChecksRule
	instanceVariableNames:'missingHelpKeysPerMethod missingGettersPerMethod
		missingSettersPerMethod missingClassesPerMethod
		missingGettersPerClass missingSettersPerClass
		missingHelpKeysPerClass missingClassesPerClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBApplicationModelChecksRule class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2013 Claus Gittinger

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

!RBApplicationModelChecksRule methodsFor:'accessing'!

group
    ^ 'Bugs - Smalltalk/X'
!

name
        ^ 'Aspect mismatches in Application'
!

rationale
    |s|

    s := 'Checks aspect definitions in specs against implemented methods in the application.
Reports missing aspect methods. 
<P>
Only gives hints, and may report false positives if the application
does fancy tricks to provide aspects 
(such as using a dictionary of aspects or redefining <CODE>doesNotUnderstand:</CODE>).'.

"/    result notNil ifTrue:[
"/        missingGettersPerMethod notEmptyOrNil ifTrue:[
"/            s := s , '<p><b>Missing Getters</b>: ', (missingGettersPerMethod asStringCollection asStringWith:', ')
"/        ].
"/        missingSettersPerMethod notEmptyOrNil ifTrue:[
"/            s := s , '<p><b>Missing Setters</b>: ', (missingSettersPerMethod asStringCollection asStringWith:', ')
"/        ].
"/        missingHelpKeysPerMethod notEmptyOrNil ifTrue:[
"/            s := s , '<p><b>Missing Help Keys</b>: ', (missingHelpKeysPerMethod asStringCollection asStringWith:', ')
"/        ].
"/    ].

    ^ s
!

rationaleWithAnchorForClass:aClass
    "called by the smallint browser, when a linted class is called."
    
    |s missingGetters missingSetters missingHelpKeys missingClassNames|

    s := self rationale.
    result notNil ifTrue:[
        (missingGetters := missingGettersPerClass at:aClass theNonMetaclass ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Getters</b>: ', (missingGetters asStringCollection asStringWith:', ')
        ].
        (missingGetters := missingGettersPerClass at:aClass theMetaclass ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Getters</b>: ', (missingGetters asStringCollection asStringWith:', ')
        ].
        (missingSetters := missingSettersPerClass at:aClass theNonMetaclass ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Setters</b>: ', (missingSetters asStringCollection asStringWith:', ')
        ].
        (missingSetters := missingSettersPerClass at:aClass theMetaclass ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Setters</b>: ', (missingSetters asStringCollection asStringWith:', ')
        ].
        (missingHelpKeys := missingHelpKeysPerClass at:aClass theNonMetaclass ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Help Keys</b>: ', (missingHelpKeys asStringCollection asStringWith:', ')
        ].
        (missingHelpKeys := missingHelpKeysPerClass at:aClass theMetaclass ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Help Keys</b>: ', (missingHelpKeys asStringCollection asStringWith:', ')
        ].
        (missingClassNames := missingClassesPerClass at:aClass theNonMetaclass ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Globals</b>: ', (missingClassNames asStringCollection asStringWith:', ')
        ].
        (missingClassNames := missingClassesPerClass at:aClass theMetaclass ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Globals</b>: ', (missingClassNames asStringCollection asStringWith:', ')
        ].

    ].

    ^ s
!

rationaleWithAnchorForMethod:aMethod
    "called by the smallint browser, when a linted method is called."
    
    |s missingGetters missingSetters missingHelpKeys missingClassNames|

    s := self rationale.
    result notNil ifTrue:[
        (missingGetters := missingGettersPerMethod at:aMethod ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Getters</b>: ', (missingGetters asStringCollection asStringWith:', ')
        ].
        (missingSetters := missingSettersPerMethod at:aMethod ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Setters</b>: ', (missingSetters asStringCollection asStringWith:', ')
        ].
        (missingHelpKeys := missingHelpKeysPerMethod at:aMethod ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Help Keys</b>: ', (missingHelpKeys asStringCollection asStringWith:', ')
        ].
        (missingClassNames := missingClassesPerMethod at:aMethod ifAbsent:nil) notNil ifTrue:[
            s := s , '<p><b>Missing Globals</b>: ', (missingClassNames asStringCollection asStringWith:', ')
        ].
    ].

    ^ s
!

resultClass
    "I will return a set methods where inconsistencies are found"

    ^ SelectorEnvironment
! !

!RBApplicationModelChecksRule methodsFor:'running'!

checkClass:aContext
    "collect used aspect symbols and used helpkeys;
     check if they are all present"
     
    |cls metaclass aspectSelectors 
     allUsedAspects allUsedHelpKeys allUsedCallbacks
     addAspect addHelpKey addCallback checkAccessors checkGetter hSpec
     specMethods checkedClass checkedMethod missingHelpKeys
     helpKeysPerMethod|

    ((cls := aContext selectedClass theNonMetaclass) isSubclassOf:ApplicationModel) ifTrue:[
        metaclass := cls theMetaclass.
        checkedClass := cls theNonMetaclass.

        missingHelpKeysPerMethod isNil ifTrue:[ missingHelpKeysPerMethod := Dictionary new ].
        missingGettersPerMethod isNil ifTrue:[ missingGettersPerMethod := Dictionary new ].
        missingSettersPerMethod isNil ifTrue:[ missingSettersPerMethod := Dictionary new ].

        missingHelpKeysPerClass isNil ifTrue:[ missingHelpKeysPerClass := Dictionary new ].
        missingGettersPerClass isNil ifTrue:[ missingGettersPerClass := Dictionary new ].
        missingSettersPerClass isNil ifTrue:[ missingSettersPerClass := Dictionary new ].
        
        missingClassesPerMethod isNil ifTrue:[ missingClassesPerMethod := Dictionary new ].
        missingClassesPerClass isNil ifTrue:[ missingClassesPerClass := Dictionary new ].

        helpKeysPerMethod := Dictionary new.
        
        checkAccessors := 
            [:mthd :sel |     
                |getter setter|
                
                self debuggingCodeFor:#cg is:[
                    self assert:sel isSymbol.
                ].
                
                self assert:sel isSymbol. 
                getter := sel.  
                setter := (sel,':') asSymbol.  
                allUsedAspects add: getter.
                allUsedAspects add: setter.
                (cls canUnderstand:getter) ifFalse:[
                    "/ (methodsPerMissing at:getter ifAbsentPut:[Set new]) add:mthd.
                    "/ (missingPerMethod at:mthd ifAbsentPut:[Set new]) add:getter.
                    (missingGettersPerMethod at:checkedMethod ifAbsentPut:[Set new]) add:getter.
                    (missingGettersPerClass at:checkedClass ifAbsentPut:[Set new]) add:getter.
                    self addClass:checkedMethod mclass selector:checkedMethod selector to:result.
                ].
                (cls canUnderstand:setter) ifFalse:[
                    "/ (methodsPerMissing at:setter ifAbsentPut:[Set new]) add:mthd.
                    "/ (missingPerMethod at:mthd ifAbsentPut:[Set new]) add:setter.
                    (missingSettersPerMethod at:checkedMethod ifAbsentPut:[Set new]) add:setter.
                    (missingSettersPerClass at:checkedClass ifAbsentPut:[Set new]) add:setter.
                    self addClass:checkedMethod mclass selector:checkedMethod selector to:result.
                ].
            ].

        checkGetter := 
            [:mthd :getter | 
                self assert:getter isSymbol. 
                (cls canUnderstand:getter) ifFalse:[
                    (cls isMeta or:[ (cls theMetaclass canUnderstand:getter) not ]) ifTrue:[
                        "/ (methodsPerMissing at:getter ifAbsentPut:[Set new]) add:mthd.
                        "/ (missingPerMethod at:mthd ifAbsentPut:[Set new]) add:getter.
                        (missingGettersPerMethod at:checkedMethod ifAbsentPut:[Set new]) add:getter.
                        (missingGettersPerClass at:checkedClass ifAbsentPut:[Set new]) add:getter.
                        self addClass:checkedMethod mclass selector:checkedMethod selector to:result.
                    ].
                ].
            ].

        allUsedAspects := Set new.
        allUsedHelpKeys := Set new.
        allUsedCallbacks := Set new.

        addAspect := [:mthd :sym | 
                allUsedAspects add: sym.
                checkGetter value:mthd value:sym
            ].

        addCallback := [:mthd :sym |
                allUsedCallbacks add: sym.
                checkGetter value:mthd value:sym
            ].

        addHelpKey := 
            [:mthd :sym |
                allUsedHelpKeys add: sym.
                (helpKeysPerMethod at:mthd ifAbsentPut:[Set new]) add:sym.
            ].


        "/ aspect selectors from the plugin spec should all be supported by
        "/ both getter and setter methods
        (metaclass canUnderstand:#aspectSelectors) ifTrue:[
            aspectSelectors := cls aspectSelectors 
                collect:[:selOrArray | selOrArray isArray ifTrue:[selOrArray first]
                                                          ifFalse:[selOrArray]].
            checkedMethod := metaclass compiledMethodAt:#aspectSelectors.  "/ could be nil, if inherited                                             
            aspectSelectors do:[:eachSel | 
                |mthd|

                mthd := metaclass lookupMethodFor:eachSel.
                mthd notNil ifTrue:[
                    checkAccessors value:mthd value:eachSel
                ]
            ].
        ].

        "/ aspects used in spec methods
        specMethods := SystemBrowser findResource:#menu in:(Array with:cls).
        specMethods do:[:eachMenuSpecMethod |
            |menu|
            
            checkedMethod := eachMenuSpecMethod.                                              
            menu := self saveGetResourceFromMethod:eachMenuSpecMethod.
            menu allItemsDo:[:item |
                item itemValue isSymbol ifTrue:[ addCallback value:eachMenuSpecMethod value: (item itemValue) ].
                item indication isSymbol ifTrue:[ addAspect value:eachMenuSpecMethod value: (item indication) ].
                item submenuChannel isSymbol ifTrue:[ addAspect value:eachMenuSpecMethod value: (item submenuChannel) ].
                item choice isSymbol ifTrue:[ addAspect value:eachMenuSpecMethod value: (item choice) ].
                item enabled isSymbol ifTrue:[ addAspect value:eachMenuSpecMethod value: (item enabled) ].
                item isVisible isSymbol ifTrue:[ addAspect value:eachMenuSpecMethod value: (item isVisible) ].
                item activeHelpKey isSymbol ifTrue:[ addHelpKey value:eachMenuSpecMethod value: (item activeHelpKey) ].
            ].
        ].
        specMethods := SystemBrowser findResource:#canvas in:(Array with:cls).
        specMethods do:[:eachWindowSpecMethod |
            |uiSpec|
            
            checkedMethod := eachWindowSpecMethod.                                              
            uiSpec := self saveGetResourceFromMethod:eachWindowSpecMethod.
            Error handle:[:ex |
                "/ self halt.
                Transcript showCR:'xxx:',ex description.
            ] do:[    
                uiSpec do:[:eachWidgetSpec |
                    MessageNotUnderstood handle:[:ex |
                        Transcript showCR:'xxx'.
                        ((ex selector == #do:) and:[ex receiver isNil]) ifTrue:[ex proceed].
                        ex reject.
                    ] do:[    
                        (eachWidgetSpec actionSelectors) do:[:sel | addCallback value:eachWindowSpecMethod value:sel].
                        (eachWidgetSpec aspectSelectors) do:[:sel | addAspect value:eachWindowSpecMethod value:sel].
                        (eachWidgetSpec valueSelectors) do:[:sel | addAspect value:eachWindowSpecMethod value:sel].
                        eachWidgetSpec activeHelpKey isSymbol ifTrue:[ addHelpKey value:eachWindowSpecMethod value: (eachWidgetSpec activeHelpKey) ].
                    ].
                ].
            ].
        ].
        specMethods := SystemBrowser findResource:#tableColumns in:(Array with:cls).
        specMethods do:[:eachTableColumnSpecMethod |
            |tableSpec|
            
            checkedMethod := eachTableColumnSpecMethod.                                              
            tableSpec := self saveGetResourceFromMethod:eachTableColumnSpecMethod decodeAsLiteralArray:false.
            self halt.
            "/ self halt.
        ].

        specMethods := SystemBrowser findResource:#tabList in:(Array with:cls).
        specMethods do:[:eachTabListSpecMethod |
            |tabListSpec|
            
            checkedMethod := eachTabListSpecMethod.                                              
            tabListSpec := self saveGetResourceFromMethod:eachTabListSpecMethod.
            self halt.
        ].

        "/ help keys should all be present
        missingHelpKeys := allUsedHelpKeys.
        (metaclass canUnderstand:#helpPairs) ifTrue:[ 
            hSpec := cls helpPairs.
            checkedMethod := metaclass compiledMethodAt:#helpPairs.
            missingHelpKeys := missingHelpKeys reject:[:eachKey | (hSpec includesKey:eachKey) ].
        ].
        (metaclass canUnderstand:#helpSpec) ifTrue:[ 
            hSpec := cls helpSpec.
            checkedMethod := metaclass compiledMethodAt:#helpSpec.
            missingHelpKeys := missingHelpKeys reject:[:eachKey | (hSpec includesKey:eachKey) ].
        ].
        (metaclass canUnderstand:#flyByHelpSpec) ifTrue:[ 
            hSpec := cls flyByHelpSpec. 
            checkedMethod := metaclass compiledMethodAt:#flyByHelpSpec.
            missingHelpKeys := missingHelpKeys reject:[:eachKey | (hSpec includesKey:eachKey) ].
        ].
        self assert:(missingHelpKeys conform:#isSymbol).
        missingHelpKeys notEmpty ifTrue:[
            "/ add the help-spec method to the list    
            checkedMethod isNil ifTrue:[
                self addClass:metaclass selector:#helpSpec to:result.
            ] ifFalse:[    
                self addClass:metaclass selector:checkedMethod selector to:result.
            ].
            missingHelpKeysPerMethod at:checkedMethod put:missingHelpKeys.
            missingHelpKeysPerClass at:checkedClass put:missingHelpKeys.
            "/ add the missing information
            helpKeysPerMethod keysAndValuesDo:[:method :helpKeys |
                |missingHere|
                
                missingHere := helpKeys select:[:key | missingHelpKeys includes:key].
                missingHere notEmpty ifTrue:[
                    missingHelpKeysPerMethod at:method put:missingHere.
                ].
            ].
        ].
    ].

"/    missingPerMethod keysAndValuesDo:[:mthd :badAspects |
"/        self addClass:mthd mclass selector:mthd selector to:result.
"/    ].
"/
"/    missingClassesPerMethod keysAndValuesDo:[:mthd :badGlobalNames |
"/        self addClass:mthd mclass selector:mthd selector to:result.
"/    ].
"/
"/    allMissingAspects do:[:sel |
"/        self addClass:cls selector:sel to:result.
"/    ].

    "/ result searchStrings addAll:allMissingAspects.
    "/ result searchStrings addAll:allMissingClasses.
!

saveGetResourceFromMethod:resourceMethod
    |cls selector litSpec resource|

    cls := resourceMethod mclass.
    selector := resourceMethod selector.

    cls isMeta ifTrue:[
        litSpec := cls theNonMetaclass perform:selector.
    ] ifFalse:[
        "/ sigh - need an instance to call the method
        litSpec := cls basicNew perform:selector.
    ].    
    
    MissingClassInLiteralArrayErrorSignal handle:[:ex |
        ex missingClassName isSymbol ifFalse:[self halt].
        (missingClassesPerMethod at:resourceMethod ifAbsentPut:[Set new]) add:ex missingClassName.
        (missingClassesPerClass at:cls ifAbsentPut:[Set new]) add:ex missingClassName.
        self addClass:cls selector:selector to:result.
        ex proceed.
    ] do:[    
        resource := litSpec decodeAsLiteralArray.
    ].    

    ^ resource
!

saveGetResourceFromMethod:resourceMethod decodeAsLiteralArray:decode
    ^ self saveGetResourceFromMethod:resourceMethod decodeAsLiteralArray:true
! !

!RBApplicationModelChecksRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


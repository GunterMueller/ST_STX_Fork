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

RBParseTreeLintRule subclass:#RBMissingTranslationInResourceFileRule
	instanceVariableNames:'lastClass resourcesPerLanguage missingLanguages combinations'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBMissingTranslationInResourceFileRule class methodsFor:'documentation'!

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

!RBMissingTranslationInResourceFileRule methodsFor:'accessing'!

group
    ^ 'Bugs - Smalltalk/X'
!

name
    missingLanguages notEmptyOrNil ifTrue:[
        |allLangs|

        allLangs := Set new.
        missingLanguages keysAndValuesDo:[:eachString :setOfMissingLangsPerString | 
            allLangs addAll:setOfMissingLangsPerString
        ].
        allLangs := allLangs collect:[:l | '"',l,'"'].
        ^ 'Missing translations in resource file(s): %1' 
                bindWith:(allLangs asOrderedCollection sort asStringWith:', ')
    ].
    ^ 'Missing translations in resource file(s)'

    "Modified: / 25-11-2016 / 16:44:53 / cg"
!

rationale
    |s allLanguages missingStringsSorted definitions|

    s := WriteStream on:(String new:200).

    s nextPutAll: 'Checks if for a given UI string, translations exist in the most common
language resource files. I.e. if you specify that a string should be translated
via: <code><pre>    (resources string:''foo'')</pre></code> 
then the resource files for the
class or package should contain national language translations for ''foo''.
<P>
Currently, we assume that the program is written in english, and translations are present
for at least german, french, italian, spanish and your current language.
<P>
Never ever write a GUI directly in english or in your native language,
as adding national language translations afterwards will be much more expensive.'.

    missingLanguages notEmptyOrNil ifTrue:[
        definitions := 
            String streamContents:[:s |
                missingLanguages keysAndValuesDo:[:eachString :languages | 
                    s nextPutAll:(eachString storeString).
                    s space.
                    s nextPutLine:(eachString storeString).
                ].
            ].

        s nextPutLine:'<UL><LI>'.
        s nextPutLine:('<A INFO="Click to show template translations to be pasted into the resource file"
   ACTION="doit: WorkspaceApplication default openWithText: %1 ">
Show template to be pasted into resource file</A>' 
                                    bindWith:(HTMLUtilities escapeCharacterEntities: "escape:"definitions storeString)).
        s nextPutLine:'</LI></UL>'.

        allLanguages := Set new.
        missingLanguages do:[:eachMissingSet | allLanguages addAll:eachMissingSet].
        allLanguages := allLanguages asSortedCollection.

        s nextPutLine:'<P>Missing: '.
        s nextPutLine:'<TABLE border>'.
        s nextPutLine:'<TR>'.
        s nextPutAll:'<TH>String</TH>'.
        allLanguages do:[:lang |
            |rsrcs fn langFile|

            rsrcs := (resourcesPerLanguage at:lang).
            rsrcs notNil ifTrue:[
                rsrcs := rsrcs projectPack.
                (rsrcs notNil and:[rsrcs packsFileName notNil]) ifTrue:[
                    fn := rsrcs packsFileName asFilename.
                    langFile := fn directory / (lang , '.rs').
                    langFile exists ifTrue:[ fn := langFile ].
                ]
            ].
            s nextPutAll:'<TH>'.
            fn notNil ifTrue:[
                s
                    nextPutAll:('<A INFO="Click to open filebrowser on the resource file"');
                    nextPutAll:(' ACTION="doit: FileBrowser default openOn:''%1''">' bindWith:fn pathName);
                    nextPutAll:lang;
                    nextPutAll:'</A>'.
            ] ifFalse:[
                s nextPutAll:lang.
            ].
            s nextPutAll:'</TH>'
        ]. 
        s nextPutLine:'</TR>'.

        missingStringsSorted := missingLanguages keys asSortedCollection.
        missingStringsSorted do:[:string |
            |missingLanguagesPerString|

            missingLanguagesPerString := missingLanguages at:string.
            s 
                nextPutAll:'<TR>';
                nextPutAll:'<TD align="left">';
                nextPutAll:string;
                nextPutAll:'</TD>'.
            allLanguages do:[:lang |
                (missingLanguagesPerString includes:lang) ifTrue:[
                    s nextPutAll:'<TD>MISSING</TD>'.
                ] ifFalse:[
                    s nextPutAll:'<TD> </TD>'.
                ].
            ].
            s nextPutLine:'</TR>'.
        ].
        s nextPutLine:'</TABLE>'.
    ].
    ^ s contents.

    "Modified: / 25-11-2016 / 16:39:41 / cg"
! !

!RBMissingTranslationInResourceFileRule methodsFor:'checking'!

checkMethod: aContext 
    "a quick rejector, to avoid many parses (because parsing is very slow)"
    (aContext sourceCode includes: $') ifFalse:[^ self]. 
    ^ super checkMethod:aContext
!

isTranslationPresentFor:string inClass:class inLanguage:language
    |resources|

    class == lastClass ifFalse:[
        lastClass := nil.
        resourcesPerLanguage := nil "flush cached resources"
    ].
        
    resourcesPerLanguage isNil ifTrue:[
        resourcesPerLanguage := Dictionary new.
    ].
    resources := resourcesPerLanguage at:language ifAbsent:nil.
    resources isNil ifTrue:[
        "/ only one at a time - to avoid restoring the wrong language, in case two such operations
        "/ run in parallel and interleave.
        self class synchronized:[
            | myProcess oldPrefs newPrefs lang terr |

            lang := terr := language.
            (lang includes:$_) ifTrue:[
                terr := lang copyFrom:4.
                lang := lang copyTo:2.
            ].
            oldPrefs := UserPreferences current.
            newPrefs := UserPreferences new.
            myProcess := Processor activeProcess.
            newPrefs language: lang; languageTerritory: terr.                
            [
                UserPreferences setCurrent:[ Processor activeProcess == myProcess ifTrue:[ newPrefs ] ifFalse:[ oldPrefs value ] ].
                ResourcePack flushCachedResourcePacks.
                resources := ResourcePack for:class cached:false.
            ] ensure:[
                 UserPreferences setCurrent: oldPrefs.
            ].
        ].    
        resourcesPerLanguage at:language put:resources.
        lastClass := class.
    ].
    (resources at:string default:nil) notNil ifTrue:[^ true].

    "/ missing
    ^ false.

    "Modified: / 28-11-2017 / 10:50:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

translationsMissingForString:aString inClass:aClass 
    "return the languages, for which translations are missing"

    |languages nonMeta missingLanguages|

    nonMeta := aClass theNonMetaclass.

    languages := aClass isNil 
                    ifTrue:[ #('en') ]
                    ifFalse:[ nonMeta projectDefinitionClass supportedLanguages ].
                        
    missingLanguages := languages 
            reject:[:eachLanguage | 
                eachLanguage = 'en' or:[
                    (self 
                        isTranslationPresentFor:aString
                        inClass:nonMeta
                        inLanguage:eachLanguage)
                ]
            ].
    "/ Transcript show:'missing: '; showCR:missingLanguages.        
    ^ missingLanguages        

    "Modified: / 24-02-2015 / 13:38:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBMissingTranslationInResourceFileRule methodsFor:'initialization'!

initialize
        super initialize.
        self matcher
                matchesAnyOf: #(
                        '(`@rcvr nlsText:`#label)'
                        '(`@rcvr nlsText:`#label with:`@arg1)'
                        '(`@rcvr nlsText:`#label with:`@arg1 with:`@arg2)'
                        '(`@rcvr nlsText:`#label with:`@arg1 with:`@arg2 with:`@arg3)'
                        '(`@rcvr nlsText:`#label withArgs:`@args)'
                        '(`@rcvr nlsTranslated:`#label)'
                        '(`@rcvr nlsTitle:`#label)'
                        '(`@rcvr nlsTtitle:`#label with:`@arg1)'

                        '(`@rcvr informationTranslated:`#label)'
                        '(`@rcvr informationTranslated:`#label with:`@arg1)'

                        '(`@resources string:`#label)'
                        '(`@resources string:`#label with:`@arg1)'
                        '(`@resources string:`#label with:`@arg1 with:`@arg2)'
                        '(`@resources string:`#label with:`@arg1 with:`@arg2 with:`@arg3)'
                        '(`@resources string:`#label with:`@arg1 with:`@arg2 with:`@arg3 with:`@arg4)'
                        '(`@resources string:`#label with:`@arg1 with:`@arg2 with:`@arg3 with:`@arg4 with:`@arg5)'
                        '(`@resources string:`#label with:`@arg1 with:`@arg2 with:`@arg3 with:`@arg4 with:`@arg5 with:`@arg6)'
                        '(`@resources string:`#label with:`@arg1 with:`@arg2 with:`@arg3 with:`@arg4 with:`@arg5 with:`@arg6 with:`@arg7)'
                        '(`@resources string:`#label withArgs:`@args)'

                        '(`@resources stringWithCRs:`#label)'
                        '(`@resources stringWithCRs:`#label with:`@arg1)'
                        '(`@resources stringWithCRs:`#label with:`@arg1 with:`@arg2)'
                        '(`@resources stringWithCRs:`#label with:`@arg1 with:`@arg2 with:`@arg3)'
                        '(`@resources stringWithCRs:`#label with:`@arg1 with:`@arg2 with:`@arg3 with:`@arg4)'
                        '(`@resources stringWithCRs:`#label with:`@arg1 with:`@arg2 with:`@arg3 with:`@arg4 with:`@arg5)'
                        '(`@resources stringWithCRs:`#label with:`@arg1 with:`@arg2 with:`@arg3 with:`@arg4 with:`@arg5 with:`@arg6)'
                        '(`@resources stringWithCRs:`#label with:`@arg1 with:`@arg2 with:`@arg3 with:`@arg4 with:`@arg5 with:`@arg6 with:`@arg7)'
                        '(`@resources stringWithCRs:`#label withArgs:`@args)'

                        '(`@resources string:`#label default:`#def)'
                        '(`@resources string:`#label default:`#def with:`@arg1)'
                        '(`@resources string:`#label default:`#def with:`@arg1 with:`@arg2)'
                        '(`@resources string:`#label default:`#def with:`@arg1 with:`@arg2 with:`@arg3)'
                        '(`@resources string:`#label default:`#def with:`@arg1 with:`@arg2 with:`@arg3 with:`@arg4)'
                        '(`@resources string:`#label default:`#def withArgs:`@args)'
                )
                do: [:node :answer :owner|
                    |receiverNode resourceProvider stringNode string missing missingSingleton 
                     class searchContext globalValue|

                    missing := nil.
                    receiverNode := node receiver.
                    stringNode := node arguments first.

                    stringNode isLiteralNode ifTrue:[
                        receiverNode isVariable ifTrue:[
                            ((searchContext := owner currentSearchContext) notNil
                              and:[(class := searchContext selectedClass) notNil
                              and:[(class := class isBehavior ifTrue:[class] ifFalse:[class realClass]) notNil]]
                            ) ifTrue:[
                                resourceProvider := class.
                            ].
                        ] ifFalse:[
                            (receiverNode isMessage and:[receiverNode selector == #resources]) ifTrue:[
                                ((receiverNode receiver isGlobal) 
                                  and:[ (globalValue := Smalltalk at:(receiverNode receiver name) asSymbol) isBehavior ]
                                ) ifTrue:[
                                    resourceProvider := globalValue.
                                ]
                            ]
                        ].
                        resourceProvider notNil ifTrue:[
                            string := stringNode value.
                            missing := self translationsMissingForString:string inClass:resourceProvider.
                            missing notEmptyOrNil ifTrue:[
                                missingLanguages isNil ifTrue:[ missingLanguages := Dictionary new ].
                                combinations isNil ifTrue:[ combinations := Set new ].
                                missing := combinations elementAt:missing ifAbsent:[combinations add:missing. missing].
                                missingLanguages at:string put:missing asArray.
                                result addSearchAction:(RBEnvironmentStringSelectAction 
                                                                selectFrom:stringNode start 
                                                                to:stringNode stop 
                                                                inMethod:owner currentSearchContext compiledMethod).
                            ].
                        ].
                    ].
                    missing notEmptyOrNil ifTrue:[
                        node
                    ] ifFalse:[
                        answer
                    ].
                ]

    "Modified: / 25-11-2016 / 16:26:19 / cg"
! !

!RBMissingTranslationInResourceFileRule class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


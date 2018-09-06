"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

ReportSourceInfo subclass:#ReportExtensionsSourceInfo
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports-Utils'
!


!ReportExtensionsSourceInfo methodsFor:'accessing'!

pathNameAbsolute: aBoolean
    "Return a path (as String) to file containing the source code. The file points to the
     real source file. If `aBoolean` is true, then absolute path is returned, otherwise
     realtive path to package root is returned."

    | packageDir |

    packageDir := aBoolean 
                    ifTrue:[ (Smalltalk getPackageDirectoryForPackage: package) pathName ]
                    ifFalse: [ package asString replaceAll: $: with: Filename separator; replaceAll: $/ with: Filename separator ].

    ^ packageDir , Filename separator , 'extensions.st'.

    "
    (Builder::ReportSourceInfo forExtensionsInPackage: 'stx:libtool') pathNameAbsolute: true
    (Builder::ReportSourceInfo forExtensionsInPackage: 'stx:libtool') pathNameAbsolute: false
    "

    "Created: / 16-12-2014 / 10:27:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportExtensionsSourceInfo methodsFor:'initialization'!

initializeWithPackage: pkg
    package := pkg.
    self setup.

    "Created: / 29-07-2013 / 18:38:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportExtensionsSourceInfo methodsFor:'utilities'!

fileOutOn: streamArg
    "This code is stupid as it is a copy-paste of several methods here and there that
     files out an extension.st. But the the original code is so rubbish so I had
     to do it this way. Sorry."

    | extensions wide stream s methodsSortedByName defClass scmManagerOrNil |

    extensions := ProjectDefinition searchForExtensionsWithProject: package.     
    extensions isEmptyOrNil ifTrue:[ ^ self ].
    wide := false.
    stream := streamArg.
    extensions do:[:method|
        wide := wide or:[method source isWideString].
    ].
    wide ifTrue:[
        stream := EncodedStream stream: stream encoder: (CharacterEncoder encoderForUTF8).      
        stream nextPutAll: '"{ Encoding: utf8 }"'; cr;cr.
    ].

    s := stream.

    s nextPutAll:'"{ Package: '''.
    s nextPutAll:package asString.
    s nextPutAll:''' }"'; nextPutChunkSeparator; cr; cr.

    "/ don't write a timestamp. Otherwise we would always generate a new version, even if nothing changed
    "/ s nextPutAll:(Smalltalk timeStamp).
    "/ s nextPutChunkSeparator. 
    "/ s cr; cr.

    "/ sort them by name (to avoid conflicts due to SCM merge)
    methodsSortedByName := extensions asOrderedCollection.
    methodsSortedByName sort:[:a :b |
                                |clsA clsB|

                                clsA := a mclass name.
                                clsB := b mclass name.
                                clsA < clsB ifTrue:[
                                    true
                                ] ifFalse:[
                                    clsA > clsB ifTrue:[
                                        false
                                    ] ifFalse:[
                                        a selector < b selector
                                    ]
                                ]
                              ].
    methodsSortedByName do:[:aMethod |
        |cat privacy aStream|

        aStream := s.

    aStream nextPutChunkSeparator.
    aMethod mclass name printOn:aStream.
"/        self printClassNameOn:aStream.

    (privacy := aMethod privacy) ~~ #public ifTrue:[
        aStream space; nextPutAll:privacy; nextPutAll:'MethodsFor:'.
    ] ifFalse:[
        aStream nextPutAll:' methodsFor:'.
    ].

    cat := aMethod category ? ''.
    aStream nextPutAll:cat asString storeString.
    aStream nextPutChunkSeparator; cr; cr.

    SmalltalkChunkFileSourceWriter new fileOutMethod:aMethod on:aStream.

    aStream space.
    aStream nextPutChunkSeparator.
            aStream cr.    
        s cr.
    ].

    scmManagerOrNil := AbstractSourceCodeManager managerForPackage: package.
    scmManagerOrNil notNil ifTrue:[
        defClass := ProjectDefinition definitionClassForPackage:package.
        defClass notNil ifTrue:[
            "/ make sure, an extensionVersion_XXX method is included...
            "/ (notice: no need to support a secondary backward compatible non-manager related version method here)
            (methodsSortedByName contains:[:aMethod | aMethod selector == scmManagerOrNil nameOfVersionMethodForExtensions]) ifFalse:[
                s nextPutLine:('!!%1 class methodsFor:''documentation''!!' bindWith:defClass name).
                s cr.
                s nextChunkPut:
                    (scmManagerOrNil versionMethodTemplateForSmalltalkFor:(scmManagerOrNil nameOfVersionMethodForExtensions)).
                s space; nextPutChunkSeparator; cr.
            ].
        ].
    ].

    "Modified: / 09-03-2015 / 15:55:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validate
    | extensions file |

    extensions := ProjectDefinition searchForExtensionsWithProject: package.     
    file := (Smalltalk getPackageDirectoryForPackage: package) / 'extensions.st'.                       

    extensions isEmptyOrNil ifTrue:[
        self assert: file exists not.
    ] ifFalse:[
        self validateAgainstReference: file.
    ]

    "Modified: / 09-03-2015 / 15:58:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportExtensionsSourceInfo class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


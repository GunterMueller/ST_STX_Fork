"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

ReportSourceInfo subclass:#ReportClassSourceInfo
	instanceVariableNames:'klass'
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports-Utils'
!


!ReportClassSourceInfo methodsFor:'accessing'!

pathNameAbsolute: aBoolean
    "Return a path (as String) to file containing the source code. The file points to the
     real source file. If `aBoolean` is true, then absolute path is returned, otherwise
     realtive path to package root is returned."

    | sourceFile packageDir |

    sourceFile := klass classFilename notNil 
                ifTrue:  [ klass classFilename ]
                ifFalse: [ (Smalltalk fileNameForClass:klass) , '.st' ].
    packageDir := aBoolean 
                    ifTrue:[ (Smalltalk getPackageDirectoryForPackage: package) pathName ]
                    ifFalse: [ package asString replaceAll: $: with: Filename separator; replaceAll: $/ with: Filename separator ].

    ^ packageDir , Filename separator , sourceFile.

    "
    (Builder::ReportSourceInfo forClass: Object inPackage: 'stx:libbasic') pathNameAbsolute: true
    (Builder::ReportSourceInfo forClass: Object inPackage: 'stx:libbasic') pathNameAbsolute: false
    "

    "Created: / 16-12-2014 / 10:25:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportClassSourceInfo methodsFor:'initialization'!

initializeWithPackage:aSymbolOrString class:aClass 
    package := aSymbolOrString asSymbol.
    klass := aClass theNonMetaclass.
    self setup.

    "Created: / 29-07-2013 / 18:37:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportClassSourceInfo methodsFor:'utilities'!

fileOutOn:aStream
    | filter |

    "JV@2012-02-02: Do not fileout extensionVersion methods, that one is filed out
     when extensions are filed out."
    (klass inheritsFrom: ProjectDefinition) ifTrue:[
        filter := [:m| m package = package 
                        and:[ (AbstractSourceCodeManager isExtensionsVersionMethodSelector:m selector) not 
                         "m selector ~~ self nameOfVersionMethodForExtensions"] 
                  ]
    ] ifFalse:[
        filter := [:mth | mth package = package ].
    ].
    klass isLoaded ifFalse:[ klass autoload ].
    klass fileOutOn:aStream 
           withTimeStamp:false 
           withInitialize:true 
           withDefinition:true
           methodFilter:filter.

    "Created: / 01-03-2013 / 17:51:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 15-12-2014 / 11:27:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validate
    | file |

    file := (Smalltalk getPackageDirectoryForPackage: klass package) / ((Smalltalk fileNameForClass: klass) , '.st').
    ^ self validateAgainstReference: file

    "Modified: / 29-07-2013 / 14:54:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportClassSourceInfo class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


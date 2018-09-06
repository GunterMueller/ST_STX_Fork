"
 Copyright (C) 2017 Claus Gittinger 

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

RBBlockLintRule subclass:#RBRefersToConcreteOSClasses
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Smalltalk/X'
!

!RBRefersToConcreteOSClasses class methodsFor:'documentation'!

copyright
"
 Copyright (C) 2017 Claus Gittinger 

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

!RBRefersToConcreteOSClasses class methodsFor:'accessing'!

tagsBasic
    "Return an array of tags (symbols) of given rule. Any rule may
     arbitrary number of tags. Tag values are not predefined/fixed.
     See class documentation for list of common tags"

    ^ #( 
        portability "/ code is not portable
        stx         "/ code is Smalltalk/X specific
    )
! !

!RBRefersToConcreteOSClasses methodsFor:'accessing'!

group
    ^ 'Possible Bugs - Smalltalk/X'
!

name
    ^ 'Refers to a concrete OS-ependent class'
!

rationale
        ^ 'Checks for references to a concrete OS-dependent class such as
UnixOperatingSystem or PCFilename.
These classes will not be present if ST/X is executed under another operating system.
<P>
Application programs should refer to the aliased globals "OperatingSystem" and "Filename" instead,
otherwise, your code may only run correctly on that particular operating system.
<P>
If you insist on refering those classes, make sure to have fallback code around,
which checks for the OS (eg. OperatingSystem isUNIXlike).'
! !

!RBRefersToConcreteOSClasses methodsFor:'constants'!

badClassNames
    ^ #( 
        "/ UnixFilename is always present, and also used with URLs 
        "/ - sigh should have an URLFilename for this check
        "UnixFilename" 
        "/ these are not present under Unix
        PCFilename OpenVMSFilename

        "/ these are not present in other OSs
        UnixOperatingSystem OSXOperatingSystem Win32OperatingSystem 
        "/ those are actually obsolete..
        OS2OperatingSystem MacOperatingSystem OpenVMSOperatingSystem

        "/ XWorkstation/GLXWorkstation are optional under Windows;
        XWorkstation GLXWorkstation
        "/ those are not present under Unix
        WinWorkstation WinPrinterContext WinPrinterStream
        "/ and those
        JavaWorkstation NeXTWorkstation GuiServerWorkstation

        "/ this is usually not present under Windows
        XftFontDesciption
    ).
! !

!RBRefersToConcreteOSClasses methodsFor:'running'!

checkClass:aContext 
    |cls check badConcreteClassNames|

    badConcreteClassNames := self badClassNames.
        
    cls := aContext selectedClass.
    check := [:cls |
        cls selectorsAndMethodsDo:[:sel :m |
            |usedGlobals|
            
            "/ first a quick check
            (m literalsDetect:[:lit | badConcreteClassNames includes:lit] ifNone:nil) notNil ifTrue:[
                usedGlobals := m usedGlobals.
                (usedGlobals includesAny:badConcreteClassNames) ifTrue:[
                    (usedGlobals select:[:globalName | badConcreteClassNames includes:globalName]) do:[:each |
                        result addSearchString:each.
                    ].    
                    self addClass:cls selector:sel to:result
                ]
            ].    
        ].
    ].
    check value:cls theNonMetaclass.
    check value:cls theMetaclass.
! !

!RBRefersToConcreteOSClasses class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


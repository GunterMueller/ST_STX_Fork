| pp wd i p |

"Search for package path, bit hacky but..."
wd := Filename currentDirectory.
pp := nil.
p := wd.
i := 10."How many super-directories try"
[i > 0 and:[pp == nil]] whileTrue:[
        p := p / '..'. i := i - 1.
        ((p / 'stx' / 'libbasic') exists and:[(p / 'stx' / 'libcomp') exists])
                ifTrue:[pp := p]].
pp
        ifNil:
                [Stderr nextPutAll: 'ERROR: Cannot find package path'.
                Smalltalk exit: 16]
        ifNotNil:
                [Smalltalk packagePath add: pp pathName].

(Smalltalk commandLineArguments includes:'--debug') ifTrue:[
    Stderr nextPutAll:'Package path:'; cr.
    Smalltalk packagePath do:[:each|
       Stderr nextPutAll:'  '; nextPutAll: each; cr.
    ].

    Smalltalk beHeadless: (OperatingSystem getEnvironment: 'DISPLAY') isNil.
] ifFalse: [
	Smalltalk beHeadless: true.
].

(Smalltalk at:#'Builder::ReportRunner') isNil ifTrue:[
    (Smalltalk loadPackage: 'stx:goodies/sunit') ifFalse:[
        Stderr nextPutAll:'ERROR: cannot load stx:goodies/sunit.'.
        Smalltalk exit: 17
    ].
    (Smalltalk loadPackage: 'stx:goodies/builder/reports') ifFalse:[
        Stderr nextPutAll:'ERROR: cannot load stx:goodies/builder/reports.'.
        Smalltalk exit: 17
    ].
].

"/ Due to some bug in ProcessorScheduler, we need to set 
"/ exitWhenNoMoreUserProcesses to prevent process dispatcher
"/ to exit prematurely. 
Processor exitWhenNoMoreUserProcesses: false.

(Smalltalk at:#'Builder::ReportRunner') start.
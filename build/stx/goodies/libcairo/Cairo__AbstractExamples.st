"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

TestCase subclass:#AbstractExamples
	instanceVariableNames:'view'
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Examples'
!

!AbstractExamples class methodsFor:'accessing'!

isTestSelector:aSelector
    | method |

    aSelector isNil ifTrue:[ ^ false ].
    method := self lookupMethodFor: aSelector.
    ^ method notNil 
        and:[(method hasAnnotation: #example:) or:[ method hasAnnotation: #example:category: ] ]

    "
    Cairo::Examples1 isTestSelector: #example01:
    "

    "Created: / 26-02-2016 / 21:57:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractExamples class methodsFor:'private'!

testSelectors
        "The API method is allTestSelectors which now includes #shouldInheritSelectors and so handles all cases.  Unlike that method, this does not guarantee to return a sorted ordered collection."

        ^self sunitSelectors select: [:each | self isTestSelector: each ]

    "Created: / 26-02-2016 / 22:40:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractExamples class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine again."

    ^ self == Cairo::AbstractExamples.
! !

!AbstractExamples class methodsFor:'utilities - markdown'!

markdownFilename
    ^ self nameWithoutNameSpacePrefix , '.md'

    "
    Cairo::Examples1 markdownFilename
    "

    "Created: / 01-03-2016 / 22:53:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMarkdownIn: aFilename
    aFilename asFilename writingFileDo:[:s|
        self writeMarkdownOn: s.  
    ]

    "Created: / 01-03-2016 / 22:53:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2016 / 21:37:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMarkdownInDirectory: directory
    self writeMarkdownIn: directory asFilename / self markdownFilename.  

    "
     Cairo::Examples1 writeMarkdownInDirectory: '/tmp'
     Cairo::Examples2 writeMarkdownInDirectory: '/tmp'

     Cairo::Examples1 writeMarkdownInDirectory: '/home/jv/Projects/Cairo/libcairo/wiki/examples'
     Cairo::Examples2 writeMarkdownInDirectory: '/home/jv/Projects/Cairo/libcairo/wiki/examples'

    "

    "Created: / 01-03-2016 / 22:53:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 02-03-2016 / 09:38:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMarkdownOn:aStream 
    ((self buildSuite tests) asSortedCollection:[:a :b | a name < b name]) do:[:example | 
        example writeMarkdownOn:aStream.
    ].

    "
     String streamContents:[ :s | Cairo::Examples1 writeMarkdownOn: s ].
     String streamContents:[ :s | Cairo::Examples2 writeMarkdownOn: s ]. 
    "

    "Created: / 01-03-2016 / 22:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractExamples class methodsFor:'utilities - screenshots'!

writeScreenshotsInDirectory:directory 
    self buildSuite tests do:[:example | 
        example writeScreenshotsInDirectory:directory
    ].

    "
     Cairo::Examples1 writeScreenshotsInDirectory: '/tmp'
     Cairo::Examples2 writeScreenshotsInDirectory: '/tmp'

     Cairo::Examples1 writeScreenshotsInDirectory: 'C:\Temp'
     Cairo::Examples2 writeScreenshotsInDirectory: 'C:\Temp'

     Cairo::Examples1 writeScreenshotsInDirectory: 'H:\Projects\Cairo\libcairo\wiki\examples'
     Cairo::Examples2 writeScreenshotsInDirectory: 'H:\Projects\Cairo\libcairo\wiki\examples'
     
    "

    "Created: / 01-03-2016 / 15:45:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-03-2016 / 23:03:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-03-2016 / 23:35:43 / jv"
! !

!AbstractExamples class methodsFor:'utilities - wiki'!

writeWikiInDirectory: aFilename
    self writeMarkdownInDirectory: aFilename.
    self writeScreenshotsInDirectory: aFilename.

    "
    Cairo::Examples1 writeWikiInDirectory: '/home/jv/Projects/Cairo/libcairo/wiki/examples'
    Cairo::Examples2 writeWikiInDirectory: '/home/jv/Projects/Cairo/libcairo/wiki/examples'
    "

    "Created: / 01-03-2016 / 22:58:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractExamples methodsFor:'accessing'!

category
    | annotations |
    annotations := self method annotationsAt: #example: orAt: #example:category:.
    annotations first arguments second

    "Created: / 01-03-2016 / 09:17:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

method
    ^ self class lookupMethodFor: testSelector

    "Created: / 01-03-2016 / 09:16:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

name
    | annotations |

    annotations := self method annotationsAt: #example: orAt: #example:category:.
    ^ annotations first arguments first

    "Created: / 01-03-2016 / 09:17:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

source
    | method source |
    method := self method.
    source := method source asStringCollection.
    source := source copyFrom: 2.
    source := source asString. 
    ^ source

    "Created: / 01-03-2016 / 09:18:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractExamples methodsFor:'private'!

performTestDrawingView:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!AbstractExamples methodsFor:'running'!

setUp
    | top |
    self assert: Display notNil.
    top := StandardSystemView new.
    top label: self name.
    top origin: 10@10 extent: (32 * 8) @ (32 * 8).       
    view := SimpleView origin: 0.0 @ 0.0 corner: 1.0 @ 1.0 in: top.
    top openAndWait.

    "Created: / 26-02-2016 / 22:15:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 10:09:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    view notNil ifTrue:[ 
        view topView close.
    ].

    "Created: / 26-02-2016 / 22:18:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractExamples methodsFor:'utilities - markdown'!

writeMarkdownLinkTo: target text: text inline: inline on: stream
    inline ifTrue:[ stream nextPut: $!! ].
    stream nextPut: $[.
    stream nextPutAll: text.
    stream nextPut: $].
    stream nextPut: $(.
    stream nextPutAll: target.
    stream nextPut: $).

    "Created: / 01-03-2016 / 22:21:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 02-03-2016 / 10:35:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMarkdownLinkTo: target text: text on: stream
    self writeMarkdownLinkTo: target text: text inline: false on: stream

    "Created: / 01-03-2016 / 22:22:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMarkdownOn: aStream
    | name |

    name := self name.
    aStream nextPutAll: '## '; nextPutAll: name; cr; cr.
    self writeMarkdownSourceOn: aStream.
    self writeMarkdownOutputOn: aStream.
    aStream cr; cr.

    "
    String streamContents:[ :s | (Cairo::Examples1 selector: #example24:) writeMarkdownOn: s ]
    "

    "Created: / 01-03-2016 / 22:08:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMarkdownOutputOn: aStream
    self subclassResponsibility

    "Created: / 01-03-2016 / 22:10:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMarkdownSourceOn: aStream
    aStream nextPutAll: 'Source'; cr.
    aStream nextPutAll: '````'; cr.
    aStream nextPutAll: '#!!smalltalk'; cr.
    aStream nextPutAll: self source; cr.
    aStream nextPutAll: '````'; cr; cr.

    "Created: / 01-03-2016 / 22:10:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!AbstractExamples methodsFor:'utilities - screenshots'!

screenshotFilename
    | basename |

    basename := String streamContents:[ :out | 
        | in char skipUndescore |

        in := self name readStream.
        [ in atEnd ] whileFalse:[
            char := in next.
            char isAlphaNumeric ifTrue:[ 
                skipUndescore := false.    
                out nextPut: char
            ] ifFalse:[ 
                skipUndescore ifFalse:[ 
                    skipUndescore := true.
                    out nextPut: $_
                ].
            ].
        ]
    ].
    ^ basename

    "
    (Cairo::Examples1 selector: #example22:) screenshotFilename
    "

    "Created: / 01-03-2016 / 21:30:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeScreenshotIn:basenameArg scale:scale 
    | basename  windowLabelFormat |

    basename := basenameArg.
    basename := basename , '_' , scale printString , '00'.
    windowLabelFormat := StandardSystemView windowLabelFormat.
    [
        StandardSystemView windowLabelFormat:(scale == 1 
                    ifTrue:[ '%1' ]
                    ifFalse:[ '%1 (' , scale printString , '00%)' ]).
        self setUp.
        scale < 3 ifTrue:[
            view topView extent:(32 * 8 * scale) @ (32 * 8 * scale).
        ] ifFalse:[
            view topView extent:(32 * 3 * scale) @ (32 * 3 * scale).
        ].
        scale ~~ 1 ifTrue:[
            view transformation:(WindowingTransformation scale:scale).
        ].
        Delay waitForMilliseconds:200.
        self performTestDrawingView:view.
        self writeScreenshotIn:basename windowID:view topView drawableId.
    ] ensure:[
        StandardSystemView windowLabelFormat:windowLabelFormat.
        self tearDown.
    ].

    "Created: / 01-03-2016 / 12:38:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 15:48:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 23:39:41 / jv"
!

writeScreenshotIn:basenameArg windowID:windowId 
    | basename |

    basename := basenameArg.
    (basename endsWith:'.png') ifFalse:[
        basename := basename , '.png'.
    ].
    OperatingSystem isUNIXlike ifTrue:[
        OperatingSystem 
            executeCommand:'import -frame -window 0x' 
                    , windowId address hexPrintString , ' ' 
                    , basename.
        ^ self.
    ].
    OperatingSystem isMSWINDOWSlike ifTrue:[
        OperatingSystem 
            executeCommand:'screenshot-cmd -wh ' , windowId address hexPrintString 
                    , ' -o ' , basename.
        ^ self
    ].
    self error:'Unsupported operating system'.

    "
     (Cairo::Examples1 selector: #example24:) writeScreenshotInDirectory: '/tmp' scale: 8
     (Cairo::Examples1 selector: #example24:) writeScreenshotInDirectory: 'C:\Temp' scale: 8
    "

    "Created: / 01-03-2016 / 10:48:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 12:39:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-03-2016 / 17:16:04 / jv"
    "Modified (comment): / 01-03-2016 / 21:49:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeScreenshotInDirectory:directory 
    ^ self writeScreenshotInDirectory:directory scale:1

    "
     (Cairo::Examples1 selector: #example24:) writeScreenshotInDirectory: '/tmp'
     (Cairo::Examples1 selector: #example24:) writeScreenshotInDirectory: '/tmp' scale: 8
    "

    "Created: / 01-03-2016 / 10:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-03-2016 / 17:18:28 / jv"
    "Modified (comment): / 01-03-2016 / 21:48:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeScreenshotInDirectory:directory scale:scale 
    | basename |

    basename := (directory asFilename / self screenshotFilename) pathName.
    OperatingSystem isUNIXlike ifTrue:[
        OperatingSystem isOSXlike ifTrue:[
            basename := basename , '_osx'.
        ] ifFalse:[
            basename := basename , '_linux'.
        ]
    ] ifFalse:[
        OperatingSystem isMSWINDOWSlike ifTrue:[
            basename := basename , '_windows'.
        ]
    ].   
    self writeScreenshotIn:basename scale:scale.

    "Created: / 01-03-2016 / 10:46:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 01-03-2016 / 17:23:44 / jv"
    "Modified: / 01-03-2016 / 22:12:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeScreenshotsInDirectory:directory 
    self writeScreenshotInDirectory:directory scale:1.
    self writeScreenshotInDirectory:directory scale:8.

    "
     (Cairo::Examples1 selector: #example24:) writeScreenshotInDirectory: '/tmp'
     (Cairo::Examples1 selector: #example24:) writeScreenshotInDirectory: '/tmp' scale: 8

     (Cairo::Examples1 selector: #example24:) writeScreenshotInDirectory: 'C:\Temp'
    "

    "Created: / 01-03-2016 / 12:33:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 01-03-2016 / 17:18:43 / jv"
    "Modified (comment): / 01-03-2016 / 21:48:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


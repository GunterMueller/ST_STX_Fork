"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

Object subclass:#ReportSourceInfo
	instanceVariableNames:'offsets lineEnds package'
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports-Utils'
!

Stream subclass:#LineCountingStream
	instanceVariableNames:'position lineEnds'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ReportSourceInfo
!

!ReportSourceInfo class methodsFor:'documentation'!

documentation
"
    Utility class to map line numbers in methods to global 
    line number in source file (in chunk-formatted .st file)

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ReportSourceInfo class methodsFor:'instance creation'!

forClass: class  inPackage: pkg
    ^ ReportClassSourceInfo new initializeWithPackage:pkg class:class.

    "Created: / 29-07-2013 / 18:36:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

forExtensionsInPackage: pkg
    ^ ReportExtensionsSourceInfo new initializeWithPackage: pkg

    "Created: / 29-07-2013 / 18:37:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportSourceInfo methodsFor:'accessing'!

pathNameAbsolute: aBoolean
    "Return a path (as String) to file containing the source code. The file points to the
     real source file. If `aBoolean` is true, then absolute path is returned, otherwise
     realtive path to package root is returned."  

    ^ self subclassResponsibility

    "Created: / 16-12-2014 / 10:25:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportSourceInfo methodsFor:'initialization'!

setup
    "To be called after class is set"

    | stream |

    stream := LineCountingStream new.
    offsets := Dictionary new.

    [
        self fileOutOn: stream.
    ] on: AbstractSourceFileWriter methodSourceRewriteQuery do:[:rewriteQuery |
        | m p |

        m := rewriteQuery method.
        offsets at: m put: stream position.
        rewriteQuery proceed.
    ].
    lineEnds := stream lineEnds.

    "/Now, check if all is correct...
"/    offsets keysAndValuesDo:[:method :offset |
"/        sourceF := method package == klass package 
"/                    ifTrue:[(Smalltalk getPackageDirectoryForPackage: klass package) / ((Smalltalk fileNameForClass: klass) , '.st')]
"/                    ifFalse:[(Smalltalk getPackageDirectoryForPackage: method package) / 'extensions.st'].                       
"/        sourceF readingFileDo:[:sourceS|
"/            | source |
"/
"/            sourceS position: offset.
"/            source := sourceS nextChunk.
"/"/            self assert: method source = source.
"/        ]
"/    ].
    self validate.




    "
        ReportSourceInfo for: Builder::ReportRunner
    "

    "Created: / 01-03-2013 / 17:30:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2013 / 18:20:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportSourceInfo methodsFor:'queries'!

lineAndColumnOfOffset: offset
    | low high middle element line col |

    low := 1.
    high := lineEnds size.
    [low > high] whileFalse:[
        middle := (low + high) // 2.
        element := lineEnds at:middle.
        element <= offset ifTrue:[
            "middleelement is smaller than object"
            low := middle + 1
        ] ifFalse:[
            high := middle - 1
        ]
    ].

    line := low.
    col := offset - (line > 1 ifTrue:[lineEnds at: line - 1] ifFalse:[0]).
    ^line @ col.

    "Created: / 03-03-2013 / 10:50:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2013 / 18:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

offsetOfMethod: aMethod
    ^offsets at: aMethod

    "Created: / 03-03-2013 / 10:49:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportSourceInfo methodsFor:'utilities'!

fileOutOn:arg
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

validate
    ^ self subclassResponsibility

    "Created: / 29-07-2013 / 14:52:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

validateAgainstReference: referenceFile

    referenceFile readingFileDo:[:sourceS|
        offsets keysAndValuesDo:[:method :offset |
            | source |

            sourceS position: offset.
            source := sourceS nextChunk.
"/            self assert: method source = source.
        ]
    ].

    "Created: / 29-07-2013 / 14:52:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2013 / 19:20:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportSourceInfo::LineCountingStream class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ReportSourceInfo::LineCountingStream methodsFor:'accessing'!

contents
    "return the entire contents of the stream.
     For a readStream, that is the rest (i.e. upToEnd),
     for a writeStream, that is the collected data. As we do not know here,
     what we are, this is the responsibility of a subclass..."

    ^ self shouldNotImplement

    "Modified: / 01-03-2013 / 17:36:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

lineEnds
    ^ lineEnds
!

position
    ^ position
! !

!ReportSourceInfo::LineCountingStream methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    position := 0.
    lineEnds := OrderedCollection new.

    "/ super initialize.   -- commented since inherited method does nothing

    "Modified: / 01-03-2013 / 17:39:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportSourceInfo::LineCountingStream methodsFor:'queries'!

isReadable
    "return true, if reading is supported by the recevier.
     This has to be redefined in concrete subclasses."

    ^ false

    "Modified: / 01-03-2013 / 17:36:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isWritable
    "return true, if writing is supported by the recevier.
     This has to be redefined in concrete subclasses."

    ^ true

    "Modified: / 01-03-2013 / 17:37:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

size
    "return the number of elements in the streamed collection."

    ^ self shouldImplement
! !

!ReportSourceInfo::LineCountingStream methodsFor:'reading'!

next
    "return the next element of the stream
     - we do not know here how to do it, it must be redefined in subclass"

    ^ self shouldNotImplement

    "Modified: / 01-03-2013 / 17:37:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportSourceInfo::LineCountingStream methodsFor:'testing'!

atEnd
    "return true if the end of the stream has been reached;
     - we do not know here how to do it, it must be redefined in subclass"

    ^ false

    "Modified: / 01-03-2013 / 17:37:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isEmpty
    "return true, if the contents of the stream is empty"

    ^ self shouldNotImplement

    "Modified: / 01-03-2013 / 17:37:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportSourceInfo::LineCountingStream methodsFor:'writing'!

nextPut:aCharacter
    "put the argument, anObject onto the receiver
     - we do not know here how to do it, it must be redefined in subclass"

     position := position + 1.
    aCharacter == Character cr ifTrue:[
        lineEnds add: position
    ].

    "Modified: / 01-03-2013 / 17:39:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportSourceInfo class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


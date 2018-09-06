"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

Object subclass:#ReportFormat
	instanceVariableNames:'report stream'
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports-Formats'
!


!ReportFormat class methodsFor:'instance creation'!

named:aString 
    "Return new format with given name. Name may be
     either class or symbolic name"
    
    self allSubclassesDo:
            [:cls |             
            (cls isAbstract not and:[cls name = aString or:[ cls symbolicNames includes:aString ]]) 
                ifTrue:[ ^ cls new ] ].

    self error:'No format named ' , aString.

    "
        ReportFormat named: 'tap'
        ReportFormat named: 'JUnitFormat'
        ReportFormat named: 'NONEX'
    "

    "Created: / 04-08-2011 / 11:47:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!ReportFormat class methodsFor:'accessing'!

symbolicNames
    "Returns a collection of symbolic names for this format"
    
    ^ self subclassResponsibility

    "Modified (comment): / 04-08-2011 / 11:46:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportFormat class methodsFor:'testing'!

isAbstract

    ^self == HDReportFormat

    "Created: / 04-08-2011 / 11:44:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportFormat methodsFor:'accessing - defaults'!

defaultFileSuffix

    ^self subclassResponsibility

    "Created: / 04-08-2011 / 12:47:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportFormat methodsFor:'initialization'!

initialize
    "Invoked when a new instance is created."

    "/ please change as required (and remove this comment)
    "/ stream := nil.
    "/ suite := nil.

    "/ super initialize.   -- commented since inherited method does nothing
!

report: aReport stream: aStream

    report := aReport.
    (aStream isKindOf: EncodedStream) ifTrue:[
        stream := aStream.
    ] ifFalse:[
        | encoder |
        "Kludge since ISO10646_to_XMLUTF8 encoder may not be present"

        CharacterEncoderImplementations::ISO10646_to_XMLUTF8 notNil ifTrue:[
            CharacterEncoderImplementations::ISO10646_to_XMLUTF8 autoload.
            encoder := CharacterEncoderImplementations::ISO10646_to_XMLUTF8 new.
        ] ifFalse:[
            encoder := CharacterEncoder encoderForUTF8.
        ].
        stream := EncodedStream stream: aStream encoder: encoder
    ]

    "Created: / 03-08-2011 / 18:54:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportFormat methodsFor:'stream - utilities'!

stream 

    ^ stream

!

streamClose

    "Temporarily closes the stream"

    "stream is EncodedStream..."             
    stream stream close.

    "Created: / 12-08-2011 / 09:30:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

streamFlush

    "Temporarily closes the stream"

    "stream is EncodedStream..."             
    stream stream flush.

    "Created: / 12-08-2011 / 09:35:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

streamOpenForAppend

    "Open previously closes stream"
    
    | s |
    "stream is EncodedStream..."             
    s := stream stream.
    s isExternalStream ifTrue:[
        s isOpen ifTrue:[s close].
        s openForWriting.
	s setToEnd.
    ].

    "Created: / 12-08-2011 / 09:31:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportFormat methodsFor:'writing'!

writeFooter
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
!

writeHeader
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility
! !

!ReportFormat methodsFor:'writing - utilities'!

encode: aString

    ^Report encode: aString

    "Created: / 03-08-2011 / 14:37:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeCDATA: string
    | start stop |

    start := 1. 
    stop := start.
    [ (stop := (string indexOf: $] startingAt: stop)) ~~ 0 ] whileTrue:[
        ((stop < (string size - 1)) 
            and:[(string at: stop + 1) == $]
                and:[(string at: stop + 2) == $>]]) ifTrue:[
                    " Okay, found CDATA end token "
                    stream nextPutAll: string startingAt: start to: stop + 1.
                    stream nextPutAll: ']]><!![CDATA[>'.
                    start := stop := stop + 3.
                ] ifFalse:[
                    stop := stop + 1.
                ].
    ].
    start < string size ifTrue:[
        stream nextPutAll: string startingAt: start to: string size.        
    ].

    "
    String streamContents:[:s | Builder::TestReportFormat::JUnit new report: nil stream: s; writeCDATA:'ABCD']
    String streamContents:[:s | Builder::TestReportFormat::JUnit new report: nil stream: s; writeCDATA:']]]]']         
    String streamContents:[:s | Builder::TestReportFormat::JUnit new report: nil stream: s; writeCDATA:'Some <[CDATA[ CDATA ]]> Some Text and stray terminator ]]> here']
    "

    "Created: / 05-07-2013 / 16:54:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ReportFormat class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


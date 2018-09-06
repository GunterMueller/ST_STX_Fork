"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

ReportFormat subclass:#CoverageReportFormat
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports-Formats'
!

CoverageReportFormat subclass:#Cobertura
	instanceVariableNames:'currentPackage currentClass currentClassLinesBuffer currentMethod
		infos'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CoverageReportFormat
!

Parser subclass:#MethodAnalyzer
	instanceVariableNames:'intervals branches'
	classVariableNames:''
	poolDictionaries:''
	privateIn:CoverageReportFormat::Cobertura
!


!CoverageReportFormat class methodsFor:'testing'!

isAbstract

    ^self == CoverageReportFormat

    "Created: / 04-08-2011 / 11:44:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-06-2013 / 01:26:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 30-07-2013 / 09:19:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReportFormat::Cobertura class methodsFor:'accessing'!

symbolicNames
    "Returns a collection of symbolic names for this format"

    ^ self shouldImplement
! !

!CoverageReportFormat::Cobertura class methodsFor:'documentation'!

documentation
" }

 Replace 'Object', 'NewClass1' and
 the empty string arguments by true values.

 Install (or change) the class by 'accepting',
 either via the menu or the keyboard (usually CMD-A).

 You can also change the category simply by editing
 the categoryString and accepting.

 To be nice to others (and yourself later), do not forget to
 add some documentation; preferably under the classes documentation
 protocol.
 (see the `create documentation stubs' item in the methodList menu;
  switch from instance to class to find this menu item.)

 Notice, that ST/X uses the convention to document the class using
 comment-only class methods (however, ST80 comments are supported and
 can be changed via the class-documentation menu).

"
! !

!CoverageReportFormat::Cobertura methodsFor:'accessing - defaults'!

defaultFileSuffix
    "superclass Builder::ReportFormat says that I am responsible to implement this method"

    ^ 'xml'

    "Modified: / 25-06-2013 / 02:02:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReportFormat::Cobertura methodsFor:'private'!

sourceInfoForClass: class inPackage: package
    | infosPerPackage cls |

    cls := class.
    cls isMetaclass ifTrue:[
        cls := cls theNonMetaclass
    ].
    cls isPrivate ifTrue:[
        cls := cls topOwningClass.
    ].
    infosPerPackage := infos at: package ifAbsentPut:[Dictionary new].
    ^ infosPerPackage at: class ifAbsentPut: [ReportSourceInfo forClass: cls inPackage: package].

    "Created: / 29-07-2013 / 18:43:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sourceInfoForExtensionsinPackage: package
    | infosPerPackage |

    infosPerPackage := infos at: package ifAbsentPut:[Dictionary new].
    ^ infosPerPackage at: 'extensions.st' ifAbsentPut: [ReportSourceInfo forExtensionsInPackage: package].

    "Created: / 29-07-2013 / 18:43:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReportFormat::Cobertura methodsFor:'writing'!

write: instrumentedMethods
    | packageMap |

    packageMap := Dictionary new.
    infos := Dictionary new.
    instrumentedMethods do:[:method|
        | classMap methodSet |
        classMap := packageMap at: method package ifAbsentPut: [ Dictionary new ].
        methodSet := classMap at: method mclass theNonMetaclass ifAbsentPut: [ Set new ].
        methodSet add: method.
    ].

    packageMap keys asSortedCollection do:[:package|
        | classMap |            

        self writePackage: package with:[            
            ((classMap := packageMap at: package) keys asSortedCollection:[:a :b| a name < b name ]) do:[:class|
                self writeClass: class with:[
                    | methodSetOrdered |

"/                    methodSetOrdered := (classMap at: class) asSortedCollection:[:a :b | (info offsetOfMethod: a) < (info offsetOfMethod: b)].
                    methodSetOrdered := (classMap at: class) asSortedCollection:[:a :b | a selector < b selector].
                    methodSetOrdered do:[:method|
                        self writeMethod: method.
                    ]                    
                ]
            ]
        ]
    ]

    "Created: / 25-06-2013 / 13:17:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2013 / 18:49:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (format): / 15-12-2014 / 10:21:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeClass: class with: content

    | className classFileName classPathName |

    className := class name.
    classFileName := class isPrivate 
                        ifTrue:[(Smalltalk fileNameForClass: class topOwningClass) , '.st']
                        ifFalse:[(Smalltalk fileNameForClass: class) , '.st'].
    class package ~~ currentPackage ifTrue:[
        classFileName := 'extensions.st'
    ].
    classPathName := ((currentPackage copyReplaceAll: $: with: Filename separator) replaceAll: $/ with: Filename separator) 
                        , Filename separator , classFileName.

    stream nextPutAll:'        <class name="'; nextPutAll: className; nextPutAll: '" filename="'; nextPutAll: classPathName; nextPutLine:'" line-rate="1.0" branch-rate="1.0" complexity="1.0">'.
    stream nextPutLine:'          <methods>'.
    currentClass := class.
    currentClassLinesBuffer := String new writeStream.
    content value.               
    currentClass := nil.
    stream nextPutLine:'          </methods>'.
    stream nextPutLine:'          <lines>'.
    stream nextPutAll: currentClassLinesBuffer contents.
    stream nextPutLine:'          </lines>'.
    currentClassLinesBuffer := nil.
    stream nextPutLine:'        </class>'

    "Created: / 25-06-2013 / 12:29:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-06-2013 / 00:05:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeFooter
    stream nextPutAll:'  </packages>
</coverage>'

    "Modified: / 25-06-2013 / 11:57:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeHeader
    stream nextPutAll:'<?xml version="1.0"?>
<!!--DOCTYPE coverage SYSTEM "http://cobertura.sourceforge.net/xml/coverage-03.dtd"-->

<coverage line-rate="1.0" branch-rate="1.0" version="1.9" timestamp="'; nextPutAll: Timestamp now utcSecondsSince1970 printString; nextPutLine:'">'.
    stream nextPutLine:'  <sources>'.
    Smalltalk packagePath do:[:each|
        stream 
            nextPutAll: '<source>';
            nextPutAll: each asFilename asAbsoluteFilename pathName;
            nextPutAll: '</source>';
            cr.                
    ].
    stream nextPutLine:'  </sources>'.
    stream nextPutLine:'  <packages>'.

    "Modified: / 26-06-2013 / 17:50:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeLine: lineNr hits: nhits on: s

    s nextPutAll:'            <line number="'; nextPutAll: lineNr printString; nextPutAll:'" hits="'; nextPutAll: nhits printString; nextPutLine:'" branch="false" />'.

    "Created: / 27-06-2013 / 00:03:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeMethod: method

    | info firstCharOffset firstLineNr lastLineNr analyzer lines name |

    name := method selector.
    method mclass isMetaclass ifTrue:[
        name := name , ' [class method]'.
    ].

    stream nextPutAll:'        <method name="'; nextPutAll: (self encode: name); nextPutLine: '" signature="" line-rate="1.0" branch-rate="1.0" complexity="1.0">'.
    stream nextPutLine:'          <lines>'.
    currentMethod := method.

    info := method package == method mclass package 
                ifTrue:[self sourceInfoForClass: method mclass inPackage: method package]
                ifFalse:[self sourceInfoForExtensionsinPackage: method package]. 

    firstCharOffset := info offsetOfMethod: method.
    firstLineNr := (info lineAndColumnOfOffset: firstCharOffset) x.
    lastLineNr := (info lineAndColumnOfOffset: firstCharOffset + method source size) x.

    lines := Array new: lastLineNr - firstLineNr + 1 withAll: nil.
    analyzer := MethodAnalyzer new.
    analyzer parseMethod: method source in: method mclass.
    analyzer intervals do:[:interval|
        | start stop |
        start := info lineAndColumnOfOffset: firstCharOffset + interval first - 1.
        stop := info lineAndColumnOfOffset: firstCharOffset + interval last - 1.
        start x to: stop x do:[:lineNr|
            lines at: lineNr - firstLineNr + 1 put: -1.
        ].
    ].

    (method statementInvocationInfo copy sort:[:a :b | a startPosition < b startPosition]) do:[:eachBlockInfo |
        | startLine endLine |

        startLine := (info lineAndColumnOfOffset: firstCharOffset + eachBlockInfo startPosition - 1) x.
        endLine := (info lineAndColumnOfOffset: firstCharOffset + eachBlockInfo endPosition - 1) x.
        startLine to: endLine do:[:lineNr|

            (lines at: (lineNr - firstLineNr + 1)) == -1 ifTrue:[
                lines at: (lineNr - firstLineNr + 1) put: (eachBlockInfo count)
            ] ifFalse:[
                lines at: (lineNr - firstLineNr + 1) put: (((lines at: (lineNr - firstLineNr + 1)) ? (SmallInteger maxVal)) min: eachBlockInfo count)
            ]
        ]            
    ].
    1 to: lines size do:[:i|
        (lines at: i) notNil ifTrue:[
            (lines at: i) == -1 ifTrue:[
                lines at: i put: 0.
            ].
            self writeLine: (i + firstLineNr - 1) hits: ((lines at: i)) on: stream.
            self writeLine: (i + firstLineNr - 1) hits: ((lines at: i)) on: currentClassLinesBuffer.
        ]
    ].

    currentMethod := nil.
    stream nextPutLine:'          </lines>'.
    stream nextPutLine:'        </method>'

    "Created: / 25-06-2013 / 13:17:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 30-07-2013 / 09:12:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writePackage: packageName with: aBlock

    stream nextPutAll:'    <package name="'; nextPutAll: packageName; nextPutLine: '" line-rate="1.0" branch-rate="1.0" complexity="1.0">'.
    stream nextPutLine:'      <classes>'.
    currentPackage := packageName.
    aBlock value.               
    currentPackage := nil.
    stream nextPutLine:'      </classes>'.
    stream nextPutLine:'    </package>'

    "Created: / 25-06-2013 / 11:55:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-06-2013 / 13:24:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReportFormat::Cobertura::MethodAnalyzer methodsFor:'accessing'!

branches
    ^ branches
!

intervals
    ^ intervals
! !

!CoverageReportFormat::Cobertura::MethodAnalyzer methodsFor:'code generation hooks'!

statementListRewriteHookFor:aStatementNode
    "invoked whenever a statement list node has been generated;
     gives subclasses a chance to rewrite (instrument) it"

    | stmt |

    intervals isNil ifTrue:[
        intervals := OrderedCollection new.
    ].
    stmt := aStatementNode.
    [ stmt notNil ] whileTrue:[
        intervals add: (stmt startPosition to: stmt endPosition).
        stmt := stmt nextStatement.
    ].
    ^ aStatementNode

    "Created: / 29-07-2013 / 10:16:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-07-2013 / 11:25:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CoverageReportFormat class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


"{ Package: 'stx:goodies/builder/reports' }"

"{ NameSpace: Builder }"

ReportFormat subclass:#LintReportFormat
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Builder-Reports-Formats'
!

LintReportFormat subclass:#CheckStyle
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:LintReportFormat
!

LintReportFormat subclass:#PMD
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:LintReportFormat
!


!LintReportFormat class methodsFor:'testing'!

isAbstract

    ^self == LintReportFormat

    "Created: / 04-08-2011 / 11:44:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReportFormat methodsFor:'writing'!

writeFile: filename with: block

    "Writes a section for given file"

    stream tab; nextPutAll:'<file name="'; nextPutAll:filename; nextPutAll: '">'; cr.
    block valueWithOptionalArgument: self.
    stream tab; nextPutAll:'</file>'; cr.

    "Created: / 07-10-2011 / 10:40:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReportFormat::CheckStyle class methodsFor:'accessing'!

symbolicNames
    "Returns a collection of symbolic names for this format"

    ^#(checkstyle)

    "Modified: / 04-08-2011 / 14:23:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReportFormat::CheckStyle methodsFor:'accessing - defaults'!

defaultFileSuffix

    ^ 'xml'

    "Modified: / 08-10-2011 / 10:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReportFormat::CheckStyle methodsFor:'writing'!

writeFile: filename with: block

    "Writes a section for given file"

    stream tab; nextPutAll:'<file name="'; nextPutAll:filename; nextPutAll: '">'; cr.
    block valueWithOptionalArgument: self.
    stream tab; nextPutAll:'</file>'; cr.

    "Created: / 07-10-2011 / 10:40:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeFooter

    stream nextPutAll: '</checkstyle>'

    "Modified: / 04-08-2011 / 14:42:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeHeader

    stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'; nextPut: Character lf.
    stream nextPutAll: '<checkstyle version="5.4">'; nextPut: Character lf.

    "Modified: / 06-10-2011 / 23:50:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeViolation:rule class: aClass selector: aSelector startLine:line column:column stopLine:lineStop column:columnStop

    | severity |

    rule severity = #information ifTrue:[
        severity := 'info'
    ] ifFalse:[
        rule severity = #warning ifTrue:[
            severity := 'warning'
        ] ifFalse:[
            severity := 'error'
        ]
    ].

    stream tab; tab; nextPutAll:'<error'.
    stream nextPutAll:' source="'; nextPutAll:(self encode:rule class name); nextPut:$".
    stream nextPutAll:' message="'; nextPutAll:(self encode:rule name ); nextPut:$".

    stream nextPutAll:' severity="'; nextPutAll: severity; nextPut:$".
    stream nextPutAll:' line="'; nextPutAll:line printString; nextPut:$".
    column <= 1 ifFalse:[
        stream nextPutAll:' column="'; nextPutAll:column printString; nextPut:$"
    ].
    stream nextPutAll:'/>'; cr.

    "Created: / 25-11-2011 / 22:23:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReportFormat::PMD methodsFor:'accessing - defaults'!

defaultFileSuffix

    ^ 'xml'

    "Modified: / 08-10-2011 / 10:47:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReportFormat::PMD methodsFor:'writing'!

writeFooter

    stream nextPutAll: '</pmd>'

    "Modified: / 25-11-2011 / 19:38:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeHeader

    stream nextPutAll: '<?xml version="1.0" encoding="UTF-8"?>'; nextPut: Character lf.
    stream 
        nextPutAll: '<pmd version="4.3" timestamp="'; 
        nextPutAll: Timestamp now printString;
        nextPutAll:'">';
        nextPut: Character lf.

    "Modified: / 25-11-2011 / 19:39:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeViolation:rule class: aClass selector: aSelector startLine:beginLine column:beginColumn stopLine:endLine column:endColumn

    | priority |

    rule severity = #information ifTrue:[
        priority := '1'
    ] ifFalse:[
        rule severity = #warning ifTrue:[
            priority := '2'
        ] ifFalse:[
            priority := '3'
        ]
    ].

    stream nextPutAll:'<violation '.

    stream nextPutAll:'beginline="';nextPutAll: beginLine printString; nextPut:$"; cr.
    stream nextPutAll:'begincolumn="';nextPutAll: beginColumn printString; nextPut:$"; cr.
    stream nextPutAll:'endline="';nextPutAll: endLine printString; nextPut:$"; cr.
    stream nextPutAll:'endcolumn="';nextPutAll: endColumn printString; nextPut:$"; cr.

    stream nextPutAll:'rule="';nextPutAll: (self encode:rule class name); nextPut:$"; cr.
    stream nextPutAll:'ruleset="';nextPutAll: (self encode:rule group); nextPut:$"; cr.

    stream nextPutAll:'package="';nextPutAll: aClass package; nextPut:$"; cr.
    stream nextPutAll:'class="';nextPutAll: aClass name; nextPut:$"; cr.

    aSelector notNil ifTrue:[
        stream nextPutAll:'method="';nextPutAll: aSelector; nextPut:$"; cr.
    ].

    stream nextPutAll:'><!![CDATA['; cr.
    stream nextPutAll: (self encode: rule rationale); cr.
    stream nextPutAll:']]></violation>'; cr; cr.
    stream flush.

    "Created: / 25-11-2011 / 22:28:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LintReportFormat class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '$Id$'
! !


"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
"{ Package: 'stx:goodies/loggia' }"

"{ NameSpace: Loggia }"

Object subclass:#LogFacility
	instanceVariableNames:'levels colors'
	classVariableNames:''
	poolDictionaries:'Loggia::LogLevels'
	category:'System-Support-Loggia'
!

!LogFacility class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2005-2011 by Jan Vrany & Martin Dvorak

 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the 'Software'), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:

 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
"
! !

!LogFacility class methodsFor:'instance creation'!

new

    ^self basicNew initialize
! !

!LogFacility methodsFor:'accessing'!

colorFor: severitySymbol

    ^colors
	at: severitySymbol
	ifAbsent: [nil]

    "Created: / 20-05-2005 / 09:37:35 / masca"
!

colors
    ^ colors

    "Created: / 30-05-2005 / 15:28:59 / masca"
!

levels

    ^levels
!

name

    ^Logger default facilityNameFor: self
!

registeredLevels

    ^levels
!

removeLevel: severitySymbol

    (self registeredLevels includes: severitySymbol)
	ifTrue: [self error: 'System severity level cannot be removed.'].

    levels
	removeKey: severitySymbol
	ifAbsent: [self error: 'Severity level not reistered.'].

    colors
	removeKey: severitySymbol
	ifAbsent: [nil]

    "Modified: / 20-05-2005 / 09:36:49 / masca"
! !

!LogFacility methodsFor:'accessing-presentation'!

string

    ^self name

    "Created: / 01-09-2011 / 10:35:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogFacility methodsFor:'configuration'!

for: aLogLevel use: aLogTransport
    "Tell the facility to log all messages with given log level using
     given transport."

    levels
        at: aLogLevel
        put: aLogTransport

    "Modified (comment): / 29-10-2014 / 10:10:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

for: aLogLevel useColor: aColor
    "Configure the facility to use given color for given log level.
     This color is used only by UI tools.

     This method will wanish - this should be moved to the UI itself."

    <resource: #obsolete>

    (levels includesKey: aLogLevel)
        ifTrue: [
            aColor isNil
                ifTrue: [levels removeKey: aLogLevel]
                ifFalse: [colors
                    at: aLogLevel
                    put: aColor]]

    "Created: / 20-05-2005 / 09:37:09 / masca"
    "Modified: / 20-05-2005 / 14:25:05 / masca"
    "Modified: / 29-10-2014 / 10:12:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogFacility methodsFor:'initialization'!

initialize

    super initialize.

    levels := Dictionary new.
    colors := Dictionary new.
    self setupSystemLevels

    "Modified: / 20-05-2005 / 09:36:22 / masca"
! !

!LogFacility methodsFor:'printing'!

displayString

    ^self name
! !

!LogFacility methodsFor:'private'!

setupSystemLevels
    self systemLevels do: [:e | self for: e use: TranscriptTransport default]

    "Modified: / 05-05-2005 / 14:01:00 / masca"
    "Modified: / 22-09-2014 / 15:38:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

systemLevels

    ^Levels

    "Modified: / 22-09-2014 / 15:25:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

transportForSeverity: severityObject
    | severity |

    severity := severityObject.
    severityObject isSymbol ifTrue:[ 
        severity := LogLevel symbolToLevel: severityObject.
    ].

    ^levels
        at: severity
        ifAbsent: [levels
            at: WARN
            ifAbsent: [self error: 'Warning log severity undefined, something goes wrong.']]

    "Modified: / 22-09-2014 / 15:38:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!LogFacility methodsFor:'processing'!

commitSeverity: aSymbol

    (self transportForSeverity: aSymbol) commit
!

log: aLogMessage

    (self transportForSeverity: aLogMessage severity) process: aLogMessage
!

resetSeverity: aSymbol

    (self transportForSeverity: aSymbol) reset
! !

!LogFacility class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogFacility.st,v 1.5 2014-10-29 10:18:14 vrany Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/loggia/Loggia__LogFacility.st,v 1.5 2014-10-29 10:18:14 vrany Exp $'
!

version_SVN
    ^ '$Id: Loggia__LogFacility.st,v 1.5 2014-10-29 10:18:14 vrany Exp $'
! !


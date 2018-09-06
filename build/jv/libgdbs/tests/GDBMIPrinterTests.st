"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs/tests' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#GDBMIPrinterTests
	instanceVariableNames:'stream printer'
	classVariableNames:''
	poolDictionaries:''
	category:'GDB-Private-Tests'
!

!GDBMIPrinterTests class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
! !

!GDBMIPrinterTests methodsFor:'running'!

setUp
    stream := String new writeStream.
    printer := GDBMIPrinter on: stream.

    "Created: / 11-07-2017 / 22:15:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIPrinterTests methodsFor:'tests'!

testCString

    printer printCString:'aaa'.
    self assert: stream contents equals: '"aaa"'.
    stream reset.

    printer printCString:'abc', Character tab, 'xyz'.
    self assert: stream contents equals: '"abc\txyz"'.
    stream reset.

    printer printCString:'abc\\xyz'.
    self assert: stream contents equals: '"abc\\\\xyz"'.
    stream reset.

    printer printCString:'a "bcxy" z'.
    self assert: stream contents equals: '"a \"bcxy\" z"'.
    stream reset.

    printer printCString:'a z'.
    self assert: stream contents equals: '"a z"'.
    stream reset.

    printer printCString:'a', (Character codePoint: 16r80).
    self assert: stream contents equals: '"a\x80"'.
    stream reset.

    "Created: / 11-07-2017 / 22:13:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-07-2017 / 23:55:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testOption

    printer printOption:'aaa'.
    self assert: stream contents equals: 'aaa'.
    stream reset.

    printer printOption:'-t'.
    self assert: stream contents equals: '-t'.
    stream reset.

    printer printOption:'--thread'.
    self assert: stream contents equals: '--thread'.
    stream reset.

    printer printOption:'a "bcxy" z'.
    self assert: stream contents equals: '"a \"bcxy\" z"'.
    stream reset.

    printer printOption:'100'.
    self assert: stream contents equals: '100'.
    stream reset.

    "Created: / 11-07-2017 / 23:21:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBMIPrinterTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


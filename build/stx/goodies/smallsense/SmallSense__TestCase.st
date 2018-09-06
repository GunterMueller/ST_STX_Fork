"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense' }"

"{ NameSpace: SmallSense }"

Smalltalk::TestCase subclass:#TestCase
	instanceVariableNames:'u v'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests-Obsolete'
!

!TestCase class methodsFor:'documentation'!

copyright
"
stx:goodies/smallsense - A productivity plugin for Smalltalk/X IDE
Copyright (C) 2013-2015 Jan Vrany

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

!TestCase class methodsFor:'testing'!

isAbstract

    ^self == SmallSense::TestCase

    "Created: / 03-04-2011 / 22:54:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 24-08-2013 / 21:47:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestCase methodsFor:'generate'!

doForSource:src 
    |parser|

    parser := SmalltalkParser new.
"/    parser sourceText:('gen',src) asText.
    parser 
        parseMethod:'gen' , src
        in:self class
        ignoreErrors:false
        ignoreWarnings:false.
    ^ parser.

    "Created: / 16-03-2011 / 12:27:38 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 18-03-2011 / 21:57:21 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 19-09-2013 / 11:34:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

processMethod: aCompiledMethod
        "Fail by default. Needs to be overridden by subclasses to trigger the base testing backbone."

        | collector |
        collector := SmallSenseTypeCollector onClass: self class.
        collector currentExtractedMethod: aCompiledMethod.
        SmallSenseTypeCollector new newExtractor
                extractInterfacesFrom: aCompiledMethod source class:aCompiledMethod mclass
                addTo: collector.
        ^collector

    "Created: / 17-03-2011 / 16:56:07 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 03-04-2011 / 22:53:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TestCase class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


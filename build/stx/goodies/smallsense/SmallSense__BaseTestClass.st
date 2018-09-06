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

Smalltalk::TestCase subclass:#BaseTestClass
	instanceVariableNames:'u v'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests-Obsolete'
!

!BaseTestClass class methodsFor:'documentation'!

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

!BaseTestClass methodsFor:'generate'!

doForSource:src 
    |parser|

    parser := SmallSenseParser new.
    parser 
        parseMethod:'gen' , src
        in:self class
        ignoreErrors:false
        ignoreWarnings:false.
    ^ parser.

    "Created: / 16-03-2011 / 12:27:38 / Jakub <zelenja7@fel.cvut.cz>"
    "Modified: / 17-03-2011 / 17:45:23 / Jakub <zelenja7@fel.cvut.cz>"
!

processMethod: aCompiledMethod
        "Fail by default. Needs to be overridden by subclasses to trigger the base testing backbone."

        | collector |
        collector := TypeCollector onClass: self class.
        collector currentExtractedMethod: aCompiledMethod.
        TypeCollector new newExtractor
                extractInterfacesFrom: aCompiledMethod source class:aCompiledMethod mclass
                addTo: collector.
        ^collector

    "Created: / 17-03-2011 / 16:56:07 / Jakub <zelenja7@fel.cvut.cz>"
! !

!BaseTestClass class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id$'
! !


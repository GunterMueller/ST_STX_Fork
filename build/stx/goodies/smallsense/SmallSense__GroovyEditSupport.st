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

JavaEditSupport subclass:#GroovyEditSupport
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Groovy'
!

!GroovyEditSupport class methodsFor:'documentation'!

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

!GroovyEditSupport methodsFor:'accessing'!

language
    "superclass SmallSenseEditSupport says that I am responsible to implement this method"

    | groovyLanguageClass |

    groovyLanguageClass := Smalltalk at:#GroovyLanguage.
    ^ groovyLanguageClass notNil ifTrue:[ groovyLanguageClass instance ] ifFalse: [ nil ].

    "Created: / 04-10-2013 / 07:49:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GroovyEditSupport methodsFor:'accessing-classes'!

completionEngineClass
    "Returns a code completion engine class or nil, of 
     no completion is supported"

    ^ SmallSense::GroovyCompletionEngineSimple

    "Created: / 04-10-2013 / 07:46:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

scannerClass
    "Returns a class to use for scanning lines. If nil, scanning is
     not supported and scanLine* methods will return an empty array."

    ^ (Smalltalk at: #GroovyScanner)

    "Created: / 22-10-2013 / 00:38:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
"{ Package: 'stx:goodies/smallsense/refactoring_custom' }"

"{ NameSpace: SmallSense }"

CustomSourceCodeFormatter subclass:#CustomRBLocalSourceCodeFormatter
	instanceVariableNames:'localFormatterSettings originalFormatterSettings formatterClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Refactoring-Custom'
!

!CustomRBLocalSourceCodeFormatter class methodsFor:'documentation'!

copyright
"
A custom code generation and refactoring support for Smalltalk/X
Copyright (C) 2013-2015 Jakub Nesveda
Copyright (C) 2015 Jan Vrany

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
!

documentation
"
    Source code formatter based on RBFormatter, but with settings stored in instance variable.
    Formatting itself temporarily changes global settings then performs formatting and
    ensures that original settings are restored.

    [author:]
        Jakub Nesveda <nesvejak@fit.cvut.cz> 
"
! !

!CustomRBLocalSourceCodeFormatter methodsFor:'accessing'!

doesNotUnderstand: aMessage
    "Store RBFormatter local settings"
    | selector arguments |

    selector := aMessage selector asSymbol.
    arguments := aMessage arguments.

    ((formatterClass class canUnderstand: selector) and: [arguments size <= 1]) ifTrue: [
        (arguments isEmpty) ifTrue: [
            ^ localFormatterSettings at: selector.
        ] ifFalse: [
            | accessor |

            accessor := (selector copyFrom:1 to:(selector size - 1)) asSymbol.

            ^ localFormatterSettings at: accessor put: (arguments first).
        ]
    ].

    ^ super doesNotUnderstand: aMessage.

    "Created: / 28-08-2014 / 22:39:16 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 25-01-2015 / 15:37:39 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

formatterClass
    ^ formatterClass
!

formatterClass:something
    formatterClass := something.
! !

!CustomRBLocalSourceCodeFormatter methodsFor:'formatting'!

formatParseTree:aParseTree
    "Return parse tree formatted as source code with custom RBFormatter settings"
    | source |

    [
        self setUpFormatterSettings.
        aParseTree source notNil ifTrue:[
            "normally aParseTree >> formattedCode should return formatted string,
            but there is some error with building syntax-valid source code"
            source := self formatSourceCode: aParseTree source
        ] ifFalse:[
            source := aParseTree formattedCode
        ].
    ] ensure: [
        self restoreFormatterSettings.
    ].

    ^ source

    "Modified: / 29-08-2014 / 00:12:31 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

formatSourceCode:aSourceCodeString

    ^ formatterClass format: aSourceCodeString

    "Created: / 28-08-2014 / 23:58:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 31-08-2014 / 10:59:36 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBLocalSourceCodeFormatter methodsFor:'initialization'!

initialize

    localFormatterSettings := IdentityDictionary new.
    formatterClass := RBFormatter.

    "Created: / 28-08-2014 / 23:05:44 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 31-08-2014 / 10:58:58 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

restoreFormatterSettings
    "see setUpFormatterSettings "

    originalFormatterSettings keysAndValuesDo: [ :key :value |
        formatterClass perform: key asMutator with: value.   
    ].

    "Modified: / 31-08-2014 / 14:59:41 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
!

setUpFormatterSettings
    "Settings for RBFormatter to keep formatting settings independent on system settings.
    Actually this is not perfect solution because of global scope modifications - imagine
    parallel execution. "

    originalFormatterSettings := IdentityDictionary new.
    localFormatterSettings keysAndValuesDo: [ :key :value |
        originalFormatterSettings at: key put: (formatterClass perform: key).
        formatterClass perform: key asMutator with: value.   
    ].

    "Created: / 20-08-2014 / 22:21:17 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
    "Modified: / 31-08-2014 / 15:00:09 / Jakub Nesveda <nesvejak@fit.cvut.cz>"
! !

!CustomRBLocalSourceCodeFormatter class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


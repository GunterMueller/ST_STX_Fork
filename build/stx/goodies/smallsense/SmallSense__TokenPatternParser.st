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

Regex::RxParser subclass:#TokenPatternParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Utils-Matcher'
!

Regex::RxCharSetParser subclass:#TokenSpecParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:TokenPatternParser
!

!TokenPatternParser class methodsFor:'documentation'!

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
!

documentation
"
    A parser to parse token patterns

    [author:]
        Jan Vrany <jan.vrany@fit.cvut.cz>

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!TokenPatternParser class methodsFor:'parsing'!

parse: anArrayOrStream
    ^ self new parse: anArrayOrStream

    "Created: / 02-05-2014 / 18:56:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenPatternParser methodsFor:'private'!

characterSetFrom: setSpec
        "<setSpec> is what goes between the brackets in a charset regex
        (a String). Make a string containing all characters the spec specifies.
        Spec is never empty."

        | negated spec |
        spec := ReadStream on: setSpec.
        spec peek = $^
                ifTrue:         [negated := true.
                                spec next]
                ifFalse:        [negated := false].
        ^ TokenPatternTokenSet new
                initializeElements: (TokenSpecParser on: spec) parse
                negated: negated

    "Created: / 09-05-2014 / 15:48:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

next
    "Advance the input storing the just read character
    as the lookahead."

    "/ Overriden here to allow for spaces (to increase readability)

    input atEnd ifTrue: [
        lookahead := #epsilon.
    ] ifFalse:[ 
        input skipSeparators.
        lookahead := input next
    ].

    "Created: / 09-05-2014 / 17:24:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenPatternParser methodsFor:'recursive descent'!

atom
    | atom |

    atom := super atom.
    (atom isKindOf:Regex::RxsCharacter) ifTrue:[
        atom := TokenPatternToken new type:atom character.
    ].
    ^ atom

    "Created: / 09-05-2014 / 15:56:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenPatternParser::TokenSpecParser methodsFor:'parsing'!

parseNamedSet
    | type value done out |

    self
        match:$[;
        match:$:.
    done := false.
    out := '' writeStream.
    [ done ] whileFalse:[ 
        lookahead == $\ ifTrue:[ 
            "/ Escape sequence
            lookahead := source next.
            out nextPut: lookahead.
        ] ifFalse:[ 
            lookahead == $: ifTrue:[ 
                done := true.
            ] ifFalse:[ 
                lookahead == $= ifTrue:[ 
                    type := out contents.
                    out reset.
                ] ifFalse:[ 
                    out nextPut: lookahead.
                ].
            ].
        ].
        lookahead := source next.
    ].
    type isNil ifTrue:[ 
        type := out contents.
    ] ifFalse:[
        value := out contents.
    ].
    self match:$].

    elements add:((TokenPatternToken new)
                type:type;
                value:value)

    "Modified: / 09-05-2014 / 16:35:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenPatternParser class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


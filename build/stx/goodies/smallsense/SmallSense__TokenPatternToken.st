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

Regex::RxsNode subclass:#TokenPatternToken
	instanceVariableNames:'type value'
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Utils-Matcher'
!

!TokenPatternToken class methodsFor:'documentation'!

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

!TokenPatternToken methodsFor:'accessing'!

type
    ^ type
!

type:something
    type := something.
!

value
    ^ value
!

value:something
    value := something.
! !

!TokenPatternToken methodsFor:'double dispatch'!

dispatchTo: matcher
     "Inform the matcher of the kind of the node, and it
      will do whatever it has to."

     ^matcher syntaxToken: self

    "Created: / 06-05-2014 / 14:32:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenPatternToken methodsFor:'initialization'!

initializeTyoe: t value: v
    type := t.
    value := v

    "Created: / 02-05-2014 / 21:21:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TokenPatternToken methodsFor:'testing'!

isEnumerable
    ^ false

    "Created: / 09-05-2014 / 16:10:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


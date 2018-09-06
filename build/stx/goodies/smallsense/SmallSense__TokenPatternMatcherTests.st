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

Smalltalk::TestCase subclass:#TokenPatternMatcherTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SmallSense-Tests'
!

!TokenPatternMatcherTests class methodsFor:'documentation'!

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

!TokenPatternMatcherTests methodsFor:'tests'!

test_01

    | pattern matcher |

    pattern := SmallSense::TokenPatternParser parse: '][[:Keyword=do\::]]'.
    matcher := SmallSense::TokenPatternMatcher for: pattern.

    self assert: (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: '] do:'))).
    self deny:   (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: 'self matches do:'))).

    "Created: / 06-05-2014 / 16:29:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-05-2014 / 16:36:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_02

    | pattern matcher |

    pattern := SmallSense::TokenPatternParser parse: '\[ ( (\:[[:Identifier:]])+ \| )? \.'.
    matcher := SmallSense::TokenPatternMatcher for: pattern.

    self assert: (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: '[ .'))).
    self assert: (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: '[ :arg1 | .'))).
    self assert: (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: '[ :arg1 :arg2 | .'))).

    self deny: (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: '[ :arg1 arg2 | .'))).

    "Created: / 06-05-2014 / 17:04:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 09-05-2014 / 17:27:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03a

    | pattern matcher |

    pattern := SmallSense::TokenPatternParser parse: '[[:import:]] ( [[:Identifier:]](.[[:Identifier:]])*\.?\*? )?'.
    matcher := SmallSense::TokenPatternMatcher for: pattern.

    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import '))).
    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList'))).
    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.concurent.ArrayList'))).
    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList.*'))).
    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList.'))).

    "Created: / 14-05-2014 / 16:13:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03b

    | pattern stream matcher matches match |

    pattern := SmallSense::TokenPatternParser parse: '[[:import:]] ( [[:Identifier:]](.[[:Identifier:]])*\.?\*? )?'.
    matcher := SmallSense::TokenPatternMatcher for: pattern.


    stream := SmallSense::TokenStream on: (JavaScanner for: 'import ').

    matches := matcher matchesOnStream: stream.
    self assert: matches size == 1.
    match := matches first.
    self assert: match size == 1.
    self assert: match first type == #import.

    stream reset.

    matches := matcher matchesOnStream: stream.
    self assert: matches size == 1.
    match := matches first.
    self assert: match size == 1.
    self assert: match first type == #import.

"/    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList'))).
"/    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.concurent.ArrayList'))).
"/    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList.*'))).
"/    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList.'))).

    "Created: / 14-05-2014 / 16:15:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_03c

    | pattern stream matcher matches match |

    pattern := SmallSense::TokenPatternParser parse: '[[:import:]] ( [[:Identifier:]](.[[:Identifier:]])*\.?\*? )?'.
    matcher := SmallSense::TokenPatternMatcher for: pattern.


    stream := SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList.*').

    matches := matcher matchesOnStream: stream.
    self assert: matches size == 1.
    match := matches first.
    self assert: match size == 8.
    self assert: match first type == #import.
    self assert: match second type == #Identifier.
    self assert: match third type == $..
    self assert: match last type == $*.



"/    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList'))).
"/    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.concurent.ArrayList'))).
"/    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList.*'))).
"/    self assert: (matcher searchStream: (SmallSense::TokenStream on: (JavaScanner for: 'import java.util.ArrayList.'))).

    "Created: / 14-05-2014 / 16:20:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04a 
    "Test of cursor special token (CARRET)"

    | pattern matcher |

    pattern := SmallSense::TokenPatternParser parse: '][[:Keyword=do\::]] [[:CARET:]]'.
    matcher := SmallSense::TokenPatternMatcher for: pattern.

    self assert: (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: '] do: [:each |  ] ') cursor:6 )).
    self deny: (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: '] do: [:each |  ] ') cursor:8 )).

    "Created: / 15-05-2014 / 16:24:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_04b 
    "Test of cursor special token (CARRET)"

    | pattern matcher |

    pattern := SmallSense::TokenPatternParser parse: '\[ [[:CARET:]] \]'.
    matcher := SmallSense::TokenPatternMatcher for: pattern.

    self assert: (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: '[  ]') cursor:2 )).
    self deny: (matcher searchStream: (SmallSense::TokenStream on: (Scanner for: '[ :hello') cursor:2 )).

    "Created: / 15-05-2014 / 16:25:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !


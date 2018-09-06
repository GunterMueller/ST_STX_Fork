"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#CmdLineParserTest
	instanceVariableNames:'optionA optionB optionBValue'
	classVariableNames:''
	poolDictionaries:''
	category:'System-Support-Command line'
!

!CmdLineParserTest class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2009 Jan Vrany
 COPYRIGHT (c) 2016 Jan Vrany
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!CmdLineParserTest class methodsFor:'queries'!

coveredClassNames
    ^ #( 
        'CmdLineOption' 
        'CmdLineOptionError'
        'CmdLineParser'
    )
! !

!CmdLineParserTest methodsFor:'accessing'!

cmdlineOptionA

    ^CmdLineOption new
        short: $a;
        long: 'option-a';
        description: 'option a with no arg';
        action:[optionA := true]

    "Created: / 28-01-2009 / 11:56:28 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-06-2009 / 14:34:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

cmdlineOptionB

    ^CmdLineOption new
        short: $b;
        long: 'option-b';
        description: 'option b with one arg';
        action:[:value | optionB := true. optionBValue := value]

    "Created: / 28-01-2009 / 12:01:43 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 08-06-2009 / 14:33:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CmdLineParserTest methodsFor:'initialization'!

setUp

    optionA := optionB := false.
    optionBValue := nil

    "Created: / 28-01-2009 / 12:01:01 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!CmdLineParserTest methodsFor:'tests'!

test_01

    CmdLineParser 
        parse: #('-a')
        for: self.

    self assert: optionA.
    self deny: optionB.

    "Created: / 28-01-2009 / 14:19:18 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-05-2009 / 15:47:19 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_02

    CmdLineParser
        parse: #('--option-a')
        for: self.

    self assert: optionA.
    self deny: optionB.

    "Created: / 28-01-2009 / 14:19:38 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-05-2009 / 15:47:30 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_04a

    CmdLineParser
        parse: #('--option-b= value')
        for: self.

    self deny: optionA.
    self assert: optionB.
    self assert: optionBValue = ' value'

    "Created: / 30-01-2009 / 10:43:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-05-2009 / 15:47:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_04b

    self 
        should:[CmdLineParser  parse: #('--option-b') for: self]
        raise: CmdLineOptionError

    "Created: / 30-01-2009 / 10:43:37 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-05-2009 / 15:47:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_04c

    CmdLineParser parse: #('--option-b=') for: self.

    self deny: optionA.
    self assert: optionB.
    self assert: optionBValue = ''

    "Created: / 30-01-2009 / 10:44:20 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-05-2009 / 15:47:44 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_05

    CmdLineParser
        parse: #('-b' 'value')
        for: self.

    self deny: optionA.
    self assert: optionB.
    self assert: optionBValue = 'value'.

    "Created: / 03-02-2009 / 17:38:51 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-05-2009 / 15:47:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_06

    CmdLineParser
        parse: #('-a' '-b' 'value')
        for: self.

    self assert: optionA.
    self assert: optionB.
    self assert: optionBValue = 'value'.

    "Created: / 03-02-2009 / 17:39:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-05-2009 / 15:47:56 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_07

    CmdLineParser
        parse: #('-ab' 'value')
        for: self.

    self assert: optionA.
    self assert: optionB.
    self assert: optionBValue = 'value'.

    "Created: / 03-02-2009 / 17:40:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 29-05-2009 / 15:48:02 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_08

    | rest |
    rest := CmdLineParser
                parse: #('-a' '/tmp/abc.txt')
                for: self.

    self assert: optionA.
    self assert: optionB not.
    self assert: rest asArray = #('/tmp/abc.txt')

    "Created: / 08-06-2009 / 14:51:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_09

    | rest |
    rest := CmdLineParser
                parse: #('/tmp/abc.txt')
                for: self.

    self assert: optionA not.
    self assert: optionB not.
    self assert: rest asArray = #('/tmp/abc.txt')

    "Created: / 08-06-2009 / 14:52:13 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_10
    | option |

    option := CmdLineOption new spec:$a.
    self assert: option short == $a.
    self assert: option long isNil.

    option := CmdLineOption new spec:'-a'.
    self assert: option short == $a.
    self assert: option long isNil.

    option := CmdLineOption new spec:'add'.
    self assert: option short isNil.
    self assert: option long = 'add'.

    option := CmdLineOption new spec:'--add'.
    self assert: option short isNil.
    self assert: option long = 'add'.

    option := CmdLineOption new spec:#('-a' '--add').
    self assert: option short == $a.
    self assert: option long = 'add'.

    "Created: / 14-06-2016 / 06:58:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_11

    | rest |
    rest := CmdLineParser new
                ignoreUnknownOptions: true;
                parse: #('--ignored-option' '/tmp/abc.txt')
                for: self.

    self assert: optionA not.
    self assert: optionB not.
    self assert: rest asArray = #('--ignored-option' '/tmp/abc.txt')

    "Created: / 29-06-2016 / 00:15:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_12a

    | parser longOptionValue |
    parser := CmdLineParser new
                on: #('-l' '--long-option=VALUE') do:[:value | longOptionValue := value ];
                yourself.
    
    parser parse:#('-l' 'v1').
    self assert: longOptionValue = 'v1'.

    parser parse:#('--long-option=v2').
    self assert: longOptionValue = 'v2'.

    "Created: / 29-06-2016 / 17:07:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_12b

    | parser longOptionValue |
    parser := CmdLineParser new
                on: #('-l' '--long-option VALUE') do:[:value | longOptionValue := value ];
                yourself.
    
    parser parse:#('-l' 'v1').
    self assert: longOptionValue = 'v1'.

    parser parse:#('--long-option' 'v2').
    self assert: longOptionValue = 'v2'.

    "Created: / 29-06-2016 / 18:43:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!CmdLineParserTest class methodsFor:'documentation'!

version
    ^'$Header: /cvs/stx/stx/libbasic/CmdLineParserTest.st,v 1.4 2015-01-29 19:22:05 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


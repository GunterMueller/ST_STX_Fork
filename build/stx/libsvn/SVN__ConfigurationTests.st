"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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
"{ Package: 'stx:libsvn' }"

"{ NameSpace: SVN }"

TestCase subclass:#ConfigurationTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'SVN-Tests'
!

!ConfigurationTests class methodsFor:'documentation'!

copyright
"
 Copyright (c) 2007-2010 Jan Vrany
 Copyright (c) 2009-2010 eXept Software AG

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
!

documentation
"
    documentation to be added.

    [author:]
        jv (jv@WIN7)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ConfigurationTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!ConfigurationTests methodsFor:'tests'!

test01

    | c |
    c := Configuration new name:'Test config'.
    c repositories 
        add: (Configuration::Repository package: 'test:f/*' url: 'file:///svn/f/%p');
        add: (Configuration::Repository package: 'test:p/*' url: 'file:///svn/p/%(PATH)');
        add: (Configuration::Repository package: 'test:dp/*' url: 'file:///svn/dp/%(DOTTED_PATH)');
        add: (Configuration::Repository package: 'test:md/*' url: 'file:///svn/md/%(MODULE)/%(DIRECTORY)').

    self 
        assert:(c repositoryFor: #'test:f/m1/t1') url = 'file:///svn/f/test/f/m1/t1';
        assert:(c repositoryFor: #'test:p/m1/t1') url = 'file:///svn/p/test/p/m1/t1';
        assert:(c repositoryFor: #'test:dp/m1/t1') url = 'file:///svn/dp/test.dp.m1.t1';
        assert:(c repositoryFor: #'test:md/m1/t1') url = 'file:///svn/md/test/md/m1/t1'

    "Created: / 09-01-2010 / 12:48:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 14-03-2011 / 10:29:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test02

    "Configuration::Repository literal array encoding/decoding"

    | repo1 enc repo2 |
    repo1 := Configuration::Repository 
                package:'stx:libsvn/test'
                url: 'file:///var/svn/stx/libsvn/test'.

    enc := repo1 literalArrayEncoding.

    repo2 := enc decodeAsLiteralArray.

    self 
        assert: (repo1 url = repo2 url);
        assert: (repo1 package = repo2 package);
        assert: (repo1 branch == nil);
        assert: (repo2 branch == nil).

    repo1 := Configuration::Repository 
                package:'stx:libsvn/test'
                url: 'file:///var/svn/stx/libsvn/test'
                branch: '/branches/jv'.

    enc := repo1 literalArrayEncoding.

    repo2 := enc decodeAsLiteralArray.

    self 
        assert: (repo1 url = repo2 url);
        assert: (repo1 package = repo2 package);
        assert: (repo1 branch = repo2 branch)

    "Created: / 09-01-2010 / 14:54:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test03

    "Configuration literal array encoding/decoding"

    | config1 repo1_1 repo1_2 enc config2 |
    repo1_1 := Configuration::Repository 
                package:'stx:libsvn/test'
                url: 'file:///var/svn/stx/libsvn/test'.
    repo1_2 := Configuration::Repository 
                package:'stx:libsvn/test2'
                url: 'file:///var/svn/stx/libsvn/test2'
                branch: 'branches/jv'.
    config1 := Configuration new name: 'Test config'.
    config1 repositories add: repo1_1; add: repo1_2.

    enc := config1 literalArrayEncoding.

    config2 := enc decodeAsLiteralArray.

    self
        assert: config1 name = config2 name;
        assert: config2 repositories size = 2;
        assert: config2 repositories first url = 'file:///var/svn/stx/libsvn/test';
        assert: config2 repositories second branch = 'branches/jv'.

    "Created: / 09-01-2010 / 15:17:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test04

    "
        Tests URL creation for subpackages
    "

    | c |
    c := Configuration new 
            name:'Test config';
            package: 'test:a/b/*' url: 'file:///svn/a/b/%(BRANCH)/%(1)';

            yourself.


    self 
        assert:(c repositoryFor: #'test:a/b/c') url = 'file:///svn/a/b/%(BRANCH)/c';
        assert:(c repositoryFor: #'test:a/b') url = 'file:///svn/a/b/%(BRANCH)/'.

    "Created: / 11-03-2011 / 18:25:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-03-2011 / 09:17:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ConfigurationTests class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_SVN
    ^ '§Id: SVN__ConfigurationTests.st 350 2011-07-07 18:42:56Z vranyj1 §'
! !


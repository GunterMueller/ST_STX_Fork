"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libtool' }"

"{ NameSpace: Tools }"

TestCase subclass:#NavigationHistoryTests
	instanceVariableNames:'history'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Browsers-New-History'
!

!NavigationHistoryTests class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
 COPYRIGHT (c) 2015 Jan Vrany
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
! !

!NavigationHistoryTests methodsFor:'initialization'!

setUp

    history := NavigationHistory new

    "Created: / 21-02-2008 / 16:52:19 / janfrog"
! !

!NavigationHistoryTests methodsFor:'tests'!

test_01

    self
        assert: history canGoBack not;
        assert: history canGoForward not

    "Created: / 21-02-2008 / 16:54:55 / janfrog"
!

test_02

    history goTo: 1.
        
    self
        assert: history canGoBack not;
        assert: history canGoForward not

    "Created: / 21-02-2008 / 16:55:34 / janfrog"
!

test_03
    history
        goTo:1;
        goTo:2;
        goTo:3;
        goBack.
    self
        assert:history currentItem = 2;
        assert:history canGoBack;
        assert:history goBackItems asArray = #( 1 );
        assert:history canGoForward;
        assert:history goForwardItems asArray = #( 3 ).

    "Created: / 21-02-2008 / 16:57:29 / janfrog"
    "Modified: / 27-02-2008 / 11:52:26 / janfrog"
    "Modified: / 06-06-2008 / 09:31:24 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_04
    history
        goTo:1;
        goTo:2;
        goTo:3;
        goTo:2.
    self
        assert:history currentItem = 2;
        assert:history canGoBack;
        assert:history goBackItems asArray = #( 3 2 1);
        assert:history canGoForward not;
        assert:history goForwardItems asArray = #( ).

    "Created: / 21-02-2008 / 16:57:58 / janfrog"
    "Modified: / 27-02-2008 / 11:52:26 / janfrog"
    "Modified: / 06-06-2008 / 09:31:32 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 04-09-2015 / 06:56:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_05
    history
        goTo:1;
        goTo:2;
        goTo:3;
        goBack;
        goBack;
        goTo:5.
    self
        assert:history currentItem = 5;
        assert:history canGoBack;
        assert:history goBackItems asArray = #( 1 );
        assert:history canGoForward not.

    "Created: / 21-02-2008 / 16:59:11 / janfrog"
    "Modified: / 27-02-2008 / 11:52:12 / janfrog"
    "Modified: / 06-06-2008 / 09:31:40 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_06
    history goTo:1.
    self assert: history currentItem = 1.
    self assert: history canGoBack not.
    self assert: history goBackItems asArray = #( ).
    self assert: history canGoForward not.
    self assert: history goForwardItems asArray = #( ).

    history goTo:2.
    self assert: history currentItem = 2.
    self assert: history canGoBack .
    self assert: history goBackItems asArray = #( 1 ).
    self assert: history canGoForward not.
    self assert: history goForwardItems asArray = #( ).

    history goTo:3.
    self assert: history currentItem = 3.
    self assert: history canGoBack .
    self assert: history goBackItems asArray = #( 2 1 ).
    self assert: history canGoForward not.
    self assert: history goForwardItems asArray = #( ).

    history goTo:2.
    self assert: history currentItem = 2.
    self assert: history canGoBack .
    self assert: history goBackItems asArray = #( 3 2 1 ).
    self assert: history canGoForward not.
    self assert: history goForwardItems asArray = #( ).

    history goBack.
    self assert: history currentItem = 3.
    self assert: history canGoBack .
    self assert: history goBackItems asArray = #( 2 1 ).
    self assert: history canGoForward.
    self assert: history goForwardItems asArray = #( 2 ).

    history goBack.
    self assert: history currentItem = 2.
    self assert: history canGoBack .
    self assert: history goBackItems asArray = #( 1 ).
    self assert: history canGoForward.
    self assert: history goForwardItems asArray = #( 3 2 ).   

    history goBack.
    self assert: history currentItem = 1.
    self assert: history canGoBack not.
    self assert: history goBackItems asArray = #( ).
    self assert: history canGoForward.
    self assert: history goForwardItems asArray = #( 2 3 2 ).   

    history goForward.
    self assert: history currentItem = 2.
    self assert: history canGoBack.
    self assert: history goBackItems asArray = #( 1 ).
    self assert: history canGoForward.
    self assert: history goForwardItems asArray = #( 3 2 ).   

    history goForward.
    self assert: history currentItem = 3.
    self assert: history canGoBack.
    self assert: history goBackItems asArray = #( 2 1 ).
    self assert: history canGoForward.
    self assert: history goForwardItems asArray = #( 2 ).

    "Created: / 04-09-2015 / 06:59:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NavigationHistoryTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libtool/Tools__NavigationHistoryTests.st,v 1.2 2012-09-02 11:21:14 cg Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '§Id: Tools__NavigationHistoryTests.st 7486 2009-10-26 22:06:24Z vranyj1 §'
! !


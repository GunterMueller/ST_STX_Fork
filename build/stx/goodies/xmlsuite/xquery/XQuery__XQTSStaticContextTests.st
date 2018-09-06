"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XQTSTestCase subclass:#XQTSStaticContextTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-XQTS'
!


!XQTSStaticContextTests methodsFor:'tests'!

test_static_context_1

    | query |

    query := '
(:*******************************************************:)
(:Test: static-context-1                                 :)
(:Written By: Carmelo Montanez                           :)
(:Date: July 12, 2006                                    :)
(:Purpose: Evaluate error condition XPST0001             :)
(:*******************************************************:)

declare namespace test = ''http://www.example.com'';

(: insert-start :)
declare variable $input-context1 external;
(: insert-end :)

(: <a/> instance of element(*, test:unknownType) :)
 <a/> instance of element(*) 
'.

"/    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc.xml'.
    self xqtsBind: 'input-context1' toContentsOf: 'emptydoc'.

"/    self
"/        should:[interpreter evaluate: query]
"/        raiseErrorCodes: #('XPST0001' 'XPTY0004')

    "Created: / 10-11-2008 / 17:21:03 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-09-2009 / 16:04:01 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XQTSStaticContextTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

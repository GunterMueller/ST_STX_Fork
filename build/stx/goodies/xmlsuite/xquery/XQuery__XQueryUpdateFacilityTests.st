"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

TestCase subclass:#XQueryUpdateFacilityTests
	instanceVariableNames:'bookstoreDOM namespaceDOM interpreter'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Tests-UpdateFacility'
!

!XQueryUpdateFacilityTests class methodsFor:'documentation'!

documentation
"
    Update facility does not work at all...

    [author:]

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!XQueryUpdateFacilityTests class methodsFor:'accessing'!

resources

    ^Array 
        with:XQueryDocumentProviderTestResource
! !

!XQueryUpdateFacilityTests methodsFor:'document provider mimicry'!

documentAdaptorsFor: aStringOrURI

    aStringOrURI = 'file:///bookstore.xml'
        ifTrue:
            [^Array with:(XQuery::XDMAdaptorFactory documentAdaptorFor: bookstoreDOM)].

    aStringOrURI = 'file:///namespaces.xml'
        ifTrue:
            [^Array with:(XQuery::XDMAdaptorFactory documentAdaptorFor: namespaceDOM)].

   self error:'Unknown document URI'.

    "Modified: / 28-01-2010 / 10:50:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XQueryUpdateFacilityTests methodsFor:'initialization & release'!

setUp
    interpreter := (XQueryInterpreter new)
                setDocumentProvider:self;
                yourself.
    bookstoreDOM := XQueryDocumentProviderTestResource current bookstoreDOM.
    namespaceDOM := XQueryDocumentProviderTestResource current namespacesDOM.

    "Created: / 25-10-2006 / 09:08:14 / ked"
    "Modified: / 06-04-2007 / 17:18:31 / janfrog"
    "Modified: / 18-09-2008 / 17:18:16 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

tearDown

    interpreter := bookstoreDOM := namespaceDOM := nil.

    "Created: / 25-10-2006 / 09:08:15 / ked"
    "Modified: / 18-09-2008 / 17:18:06 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryUpdateFacilityTests methodsFor:'tests - fn:put'!

test_function_fn_put_01
    |file document|

    file := Filename newTemporary.
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
            fn:put ( doc(''file:///bookstore.xml'')/bookstore/book[1] , ''file:///' 
                , file asString , ''' )
        '.
    self assert:file exists.
    document := XMLv2::Parser forDOM3 processDocumentInFilename:file.
    self assert:document documentElement localName = 'book'.
    self 
        assert:(document documentElement childNodes 
                select:[:node | node isElement ]) size 
                = 4.

    "Created: / 05-12-2007 / 10:45:18 / janfrog"
    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryUpdateFacilityTests methodsFor:'tests - misc'!

test_comma_01
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do delete doc(''file:///bookstore.xml'')/bookstore/book[1] , do delete doc(''file:///bookstore.xml'')/bookstore/book[2]
    '.
    self assert:(bookstoreDOM documentElement childNodes size = 1).

    "Modified: / 05-12-2007 / 10:32:31 / janfrog"
    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryUpdateFacilityTests methodsFor:'tests - transform'!

test_transform_01
    |result|

    self assert:(bookstoreDOM documentElement nodeName = 'bookstore').
    self 
        assert:((bookstoreDOM documentElement childNodes at:1) childNodes size = 4).
    result := interpreter 
                evaluate:'
        transform
        copy $jb := doc(''file:///bookstore.xml'')/bookstore/book[1]
        modify do delete $jb/parentalAdvisory
        return $jb
    '.
    self 
        assert:((bookstoreDOM documentElement childNodes at:1) childNodes size = 4).
    self assert:((result first childNodes at:1) childNodes size = 3).

    "Created: / 05-12-2007 / 09:39:48 / janfrog"
    "Modified: / 05-12-2007 / 12:09:33 / janfrog"
    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryUpdateFacilityTests methodsFor:'tests - upd:delete'!

test_upd_delete_01
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do delete doc(''file:///bookstore.xml'')/bookstore/book[2]
    '.
    self assert:(bookstoreDOM documentElement childNodes size = 2).

    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_upd_delete_02
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do delete doc(''file:///bookstore.xml'')/bookstore/book
    '.
    self assert:(bookstoreDOM documentElement childNodes size = 0).

    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_upd_delete_03
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do delete doc(''file:///bookstore.xml'')/bookstore
    '.
    self assert:(bookstoreDOM documentElement size = 0).

    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_upd_delete_04
    self 
        assert:((bookstoreDOM documentElement childNodes at:1) childNodes first 
                hasAttribute:'withPictures').
    interpreter 
        evaluate:'
        do delete doc(''file:///bookstore.xml'')/bookstore/book[1]/title/@withPictures
    '.
    self 
        assert:((bookstoreDOM documentElement childNodes at:1) childNodes first 
                hasAttribute:'withPictures') not.

    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryUpdateFacilityTests methodsFor:'tests - upd:insert'!

test_insertAfter_01
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do insert doc(''file:///bookstore.xml'')/bookstore/book[3]
       after doc(''file:///bookstore.xml'')/bookstore/book[1]
    '.
    self assert:(bookstoreDOM documentElement childNodes size = 4).

    "Modified: / 21-11-2007 / 09:02:33 / janfrog"
    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_insertBefore_01
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do insert doc(''file:///bookstore.xml'')/bookstore/book[3]
       before doc(''file:///bookstore.xml'')/bookstore/book[1]
    '.
    self assert:(bookstoreDOM documentElement childNodes size = 4).

    "Created: / 21-11-2007 / 11:36:10 / janfrog"
    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_insertIntoAsFirst_01
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do insert doc(''file:///bookstore.xml'')/bookstore/book[3]
        as first into doc(''file:///bookstore.xml'')/bookstore
    '.
    self assert:(bookstoreDOM documentElement childNodes size = 4).

    "Modified: / 14-11-2007 / 13:45:39 / janfrog"
    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_insertIntoAsFirst_02
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do insert attribute withPictures { ''yes'' }
        as first into doc(''file:///bookstore.xml'')/bookstore/book[2]
    '.
    self assert:((bookstoreDOM documentElement childNodes second) 
                hasAttribute:'withPictures')

    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_insertIntoAsLast_01
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do insert doc(''file:///bookstore.xml'')/bookstore/book[3]
        as last into doc(''file:///bookstore.xml'')/bookstore
    '.
    self assert:(bookstoreDOM documentElement childNodes size = 4).

    "Created: / 21-11-2007 / 11:36:31 / janfrog"
    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_insertIntoAsLast_02
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do insert attribute withPictures { ''yes'' }
        as last into doc(''file:///bookstore.xml'')/bookstore/book[2]
    '.
    self assert:((bookstoreDOM documentElement childNodes second) 
                hasAttribute:'withPictures')

    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_insertInto_01
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do insert doc(''file:///bookstore.xml'')/bookstore/book[3]
         into doc(''file:///bookstore.xml'')/bookstore
    '.
    self assert:(bookstoreDOM documentElement childNodes size = 4).

    "Created: / 21-11-2007 / 11:37:39 / janfrog"
    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_insertInto_02
    self assert:(bookstoreDOM documentElement childNodes size = 3).
    interpreter 
        evaluate:'
        do insert attribute withPictures { ''yes'' }
        into doc(''file:///bookstore.xml'')/bookstore/book[2]
    '.
    self assert:((bookstoreDOM documentElement childNodes second) 
                hasAttribute:'withPictures')

    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryUpdateFacilityTests methodsFor:'tests - upd:rename'!

test_upd_rename_01
    self assert:(bookstoreDOM documentElement nodeName = 'bookstore').
    interpreter 
        evaluate:'
        do rename doc(''file:///bookstore.xml'')/bookstore as ''knihovna''
    '.
    self assert:(bookstoreDOM documentElement nodeName = 'knihovna').

    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_upd_rename_02
    self 
        assert:((bookstoreDOM documentElement childNodes at:1) childNodes first 
                hasAttribute:'lang').
    interpreter 
        evaluate:'
        do rename doc(''file:///bookstore.xml'')/bookstore/book[1]/title/@lang as ''jazyk''
    '.
    self 
        assert:((bookstoreDOM documentElement childNodes at:1) childNodes first 
                hasAttribute:'lang') not.
    self 
        assert:((bookstoreDOM documentElement childNodes at:1) childNodes first 
                hasAttribute:'jazyk').
    self 
        assert:(bookstoreDOM documentElement childNodes first childNodes first 
                getAttribute:'jazyk') first 
                nodeValue = 'eng'.

    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryUpdateFacilityTests methodsFor:'tests - upd:replace'!

test_upd_replace_01
    self assert:(bookstoreDOM documentElement nodeName = 'bookstore').
    interpreter 
        evaluate:'
        do replace doc(''file:///bookstore.xml'')/bookstore/book[1] with element test {}
    '.
    self 
        assert:(bookstoreDOM documentElement childNodes at:1) nodeName = 'test'.
    self 
        assert:(bookstoreDOM documentElement childNodes at:1) childNodes size = 0.

    "Modified: / 14-11-2007 / 11:44:17 / janfrog"
    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_upd_replace_02
    self assert:(bookstoreDOM documentElement nodeName = 'bookstore').
    interpreter 
        evaluate:'
        do replace doc(''file:///bookstore.xml'')/bookstore/book[1]/title/@withPictures with attribute withPhotos { ''yes'' }
    '.
    self 
        assert:(((bookstoreDOM documentElement childNodes first childNodes first) 
                hasAttribute:'withPictures') not 
                and:[
                    (bookstoreDOM documentElement childNodes first childNodes first) 
                        hasAttribute:'withPhotos'
                ]).
    self 
        assert:(bookstoreDOM documentElement childNodes first childNodes first 
                getAttribute:'withPhotos') first 
                value = 'yes'.

    "Modified: / 05-12-2007 / 21:56:58 / janfrog"
    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryUpdateFacilityTests methodsFor:'tests - upd:replaceValueOf'!

test_upd_replace_value_of_01
    self assert:(bookstoreDOM documentElement nodeName = 'bookstore').
    interpreter 
        evaluate:'
        do replace value of doc(''file:///bookstore.xml'')/bookstore/book[1] with ''newcontent''
    '.
    self 
        assert:(bookstoreDOM documentElement childNodes at:1) childNodes size = 1.
    self 
        assert:(bookstoreDOM documentElement childNodes at:1) childNodes first 
                isText.
    self 
        assert:(bookstoreDOM documentElement childNodes at:1) childNodes first 
                data = 'newcontent'.

    "Created: / 21-11-2007 / 12:49:13 / janfrog"
    "Modified: / 18-09-2008 / 17:18:59 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

test_upd_replace_value_of_02
    self assert:(bookstoreDOM documentElement nodeName = 'bookstore').
    interpreter 
        evaluate:'
        do replace value of doc(''file:///bookstore.xml'')/bookstore/book[1]/title/@lang with ''cz''
    '.
    self 
        assert:(bookstoreDOM documentElement childNodes first childNodes first 
                getAttribute:'lang') first 
                nodeValue = 'cz'.

    "Created: / 21-11-2007 / 12:49:53 / janfrog"
    "Modified: / 05-12-2007 / 13:50:22 / janfrog"
    "Modified: / 18-09-2008 / 17:18:58 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!XQueryUpdateFacilityTests class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

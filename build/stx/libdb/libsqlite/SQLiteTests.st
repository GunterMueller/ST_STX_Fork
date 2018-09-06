"{ Package: 'stx:libdb/libsqlite' }"

TestCase subclass:#SQLiteTests
	instanceVariableNames:'conn'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-SQLite-Tests'
!

!SQLiteTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg (cg@CG-PC)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!SQLiteTests methodsFor:'setup'!

setUp

    conn := SQLiteConnection fileNamed: Filename newTemporary pathName.
    conn open.

    "Created: / 25-01-2012 / 16:38:03 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    "ensure a deined state"

    conn close.
    conn fileName asFilename remove.

    "Created: / 20-01-2012 / 11:42:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SQLiteTests methodsFor:'tests'!

test01_open_close

    Transcript showCR:conn handle.

    "
     self run:#test01_open_close
     self new test01_open_close
    "

    "Modified: / 20-10-2010 / 18:50:13 / cg"
    "Modified: / 25-01-2012 / 16:39:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test02_open_lastInsertId_close


    self assert:(conn lastInsertId = 0).

    "
     self run:#test02_open_lastInsertId_close
     self new test02_open_lastInsertId_close
    "

    "Modified: / 11-10-2010 / 12:46:13 / cg"
    "Modified: / 25-01-2012 / 16:39:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test03_createTable
    | rslt |

    rslt := conn executeQuery:'create table employee (id, name)'.
    "/ rslt inspect.
    
    Transcript showCR:rslt.

    "
     self run:#test03_createTable
     self new test03_createTable
    "

    "Created: / 04-10-2010 / 16:12:16 / cg"
    "Modified: / 11-10-2010 / 12:46:09 / cg"
    "Modified: / 25-01-2012 / 16:39:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test04_dropTable
    | rslt |


    #(
         'create table employee (id, name)'
    ) do:[:sql | 
        conn executeQuery:sql 
    ].

    rslt := conn executeQuery:'drop table employee'.
    "/ rslt inspect.
    Transcript showCR:rslt.

    "
     self run:#test04_dropTable
     self new test04_dropTable
    "

    "Created: / 04-10-2010 / 16:13:05 / cg"
    "Modified: / 11-10-2010 / 12:46:05 / cg"
    "Modified: / 25-01-2012 / 16:39:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test20_statements_01

    | stmt |

    stmt := conn newStatementFor: 'SELECT 1+1'.
    stmt prepare.
    stmt release.

    "Created: / 25-01-2012 / 16:33:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test20_statements_01b

    | stmt |

    stmt := conn newStatementFor: 'SELECT 1+1'.
    stmt prepare.
    stmt execute.
    stmt release.

    "Created: / 25-01-2012 / 20:12:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test20_statements_02

    | stmt cursor |

    #(
        'create table employee (id, name)'
        'insert into employee values (3, ''Kain'')'
        'insert into employee values (4, ''Abel'')'
    ) do:[:sql | 
        conn executeQuery:sql
    ].

    stmt := conn newStatementFor: 'SELECT * FROM employee'.
    stmt prepare.
    cursor := stmt execute.
    self assert: cursor next notNil.
    self assert: (cursor at: #id)   = 3.
    self assert: (cursor at: #name) = 'Kain'.
    self assert: cursor next notNil.
    self assert: (cursor at: #id)   = 4.
    self assert: (cursor at: #name) = 'Abel'.
    self assert: cursor next isNil.

    "Created: / 25-01-2012 / 17:52:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test20_statements_03a

    | stmt cursor |

    #(
        'create table employee (id, name)'
        'insert into employee values (3, ''Kain'')'
        'insert into employee values (4, ''Abel'')'
    ) do:[:sql | 
        conn executeQuery:sql
    ].

    stmt := conn newStatementFor: 'SELECT * FROM employee WHERE id = ?'.
    stmt prepare.
    stmt bindValues: #((3)).
    cursor := stmt execute.
    self assert: cursor next notNil.
    self assert: (cursor at: #id)   = 3.
    self assert: (cursor at: #name) = 'Kain'.
    self assert: cursor next isNil.

    "Created: / 26-01-2012 / 11:33:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test20_statements_03b

    | stmt cursor |

    #(
        'create table employee (id, name)'
        'insert into employee values (3, ''Kain'')'
        'insert into employee values (4, ''Abel'')'
    ) do:[:sql | 
        conn executeQuery:sql
    ].

    stmt := conn newStatementFor: 'SELECT * FROM employee WHERE name = ?'.
    stmt prepare.
    stmt bindValues: #(('Kain')).
    cursor := stmt execute.
    self assert: cursor next notNil.
    self assert: (cursor at: #id)   = 3.
    self assert: (cursor at: #name) = 'Kain'.
    self assert: cursor next isNil.

    "Created: / 26-01-2012 / 12:25:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test90_avi
    |arrayOfDicts|

    #(
         'create table employee (id, name)'
         'insert into employee values (1, ''Adam'')'
         'insert into employee values (2, ''Eve'')'
    ) do:[:sql | 
        conn executeQuery:sql 
    ].
    arrayOfDicts := conn executeQuery:'SELECT * FROM employee'.
    self assert:((arrayOfDicts next next at:'name') = 'Eve').
    self assert:(conn lastInsertId = 2).

    "
     self run:#test90_avi
     self new test90_avi
    "

    "Modified: / 11-10-2010 / 12:46:02 / cg"
    "Modified: / 25-01-2012 / 16:40:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test91_avi
    |arrayOfDicts|

    #(
         'create table employee (id, name)'
         'insert into employee values (3, ''Kain'')'
         'insert into employee values (4, ''Abel'')'
    ) do:[:sql | 
        conn executeQuery:sql 
    ].
    arrayOfDicts := conn executeQuery:'SELECT * FROM employee'.
    self assert:((arrayOfDicts next next at:'name') = 'Abel').
    self assert:(conn lastInsertId = 2).

    "
     self run:#test91_avi
     self new test91_avi
    "

    "Modified: / 11-10-2010 / 12:45:57 / cg"
    "Modified: / 25-01-2012 / 16:40:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test93_transact
    |arrayOfDicts|

    #(
        'create table employee (id, name)'
        'begin transaction'
        'insert into employee values (5, ''Stefan'')'
        'insert into employee values (6, ''Claus'')'
        'commit'
    ) do:[:sql | 
        conn executeQuery:sql
    ].
    arrayOfDicts := conn executeQuery:'SELECT * FROM employee'.
    self assert:((arrayOfDicts next next at:'name') = 'Claus').
    self assert:(conn lastInsertId = 2).

    "
     self run:#test93_transact
     self new test93_transact
    "

    "Modified: / 11-10-2010 / 12:45:57 / cg"
    "Modified: / 25-01-2012 / 16:40:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test94_rollback
    |arrayOfDicts|

    #(
        'create table employee (id, name)'
        'begin transaction'
        'insert into employee values (11, ''Mist'')'
        'insert into employee values (12, ''Murks'')'
        'rollback'
    ) do:[:sql | 
        conn executeQuery:sql
    ].
    arrayOfDicts := conn executeQuery:'SELECT * FROM employee where name = "Mist"'.
    self assert:(arrayOfDicts next isNil).

    "
     self run:#test94_rollback
     self new test94_rollback
    "

    "Modified: / 11-10-2010 / 12:45:57 / cg"
    "Modified: / 25-01-2012 / 16:40:22 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test95_select
    |arrayOfDicts|

    "JV@2011-01-20: What this test actually tests?"    

    #(
         'create table employee (id, name)'
         'insert into employee values (1, ''Adam'')'
         'insert into employee values (2, ''Eve'')'
    ) do:[:sql | 
        conn executeQuery:sql 
    ].
    
    arrayOfDicts := conn executeQuery:'SELECT * FROM employee'.

    "
     self run:#test95_select
     self new test95_select
    "

    "Modified: / 11-10-2010 / 12:45:53 / cg"
    "Modified: / 25-01-2012 / 16:40:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test98_delete
    |arrayOfDicts|

    #(
        'create table employee (id, name)'
        'insert into employee values (3, ''Kain'')'
        'insert into employee values (4, ''Abel'')'
        'delete from employee where name = "Abel"'
    ) do:[:sql | 
        conn executeQuery:sql
    ].
    arrayOfDicts := conn executeQuery:'SELECT * FROM employee where name = "Abel"'.
    self assert:(arrayOfDicts next isNil).

    "
     self run:#test98_delete
     self new test98_delete
    "

    "Modified: / 11-10-2010 / 12:45:57 / cg"
    "Modified: / 25-01-2012 / 16:40:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

xtest20_mozillaCookies
    |con rslt|

    con := SQLiteConnection fileNamed:'C:\Users\cg\AppData\Roaming\Mozilla\Firefox\Profiles\yk2uwu38.default\cookies.sqlite'.
    con open.
    "/ con inspect.

    "/ rslt := con executeQuery:'SELECT name FROM sqlite_master WHERE type IN (''table'',''view'')'. 
    rslt := con executeQuery:'SELECT * FROM sqlite_master WHERE type IN (''table'',''view'')'. 
    "/ rslt inspect.
    Transcript showCR:rslt.

    rslt := con executeQuery:'SELECT * FROM moz_cookies'. 
    rslt inspect.
    Transcript showCR:rslt.

    con close.

    "
     self run:#xtest20_mozillaCookies
     self new xtest20_mozillaCookies
    "

    "Created: / 19-10-2010 / 22:50:00 / cg"
!

xtest21_mozillaDownloads
    |con rslt|

    con := SQLiteConnection fileNamed:'C:\Users\cg\AppData\Roaming\Mozilla\Firefox\Profiles\yk2uwu38.default\downloads.sqlite'.
    con open.
    "/ con inspect.

    "/ rslt := con executeQuery:'SELECT name FROM sqlite_master WHERE type IN (''table'',''view'')'. 
    "/ rslt := con executeQuery:'SELECT * FROM sqlite_master WHERE type IN (''table'',''view'')'. 
    rslt := con executeQuery:'SELECT name,source FROM sqlite_master WHERE type IN (''table'',''view'')'. 
    rslt inspect.
    Transcript showCR:rslt.
    con close.

    "
     self run:#xtest21_mozillaDownloads
     self new xtest21_mozillaDownloads
    "

    "Created: / 19-10-2010 / 23:10:33 / cg"
!

xtest22_mozillaFormHistory
    |con rslt|

    con := SQLiteConnection fileNamed:'C:\Users\cg\AppData\Roaming\Mozilla\Firefox\Profiles\yk2uwu38.default\formhistory.sqlite'.
    con open.
    "/ con inspect.

    "/ rslt := con executeQuery:'SELECT name FROM sqlite_master WHERE type IN (''table'',''view'')'. 
    "/ rslt := con executeQuery:'SELECT * FROM sqlite_master WHERE type IN (''table'',''view'')'. 
    rslt := con executeQuery:'SELECT * FROM sqlite_master WHERE type IN (''table'',''view'')'. 
    rslt inspect.
    Transcript showCR:rslt.
    con close.

    "
     self run:#xtest22_mozillaFormHistory
     self new xtest22_mozillaFormHistory
    "

    "Created: / 19-10-2010 / 23:16:00 / cg"
! !

!SQLiteTests class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libsqlite/SQLiteTests.st,v 1.16 2012-01-26 12:29:28 vrany Exp $'
! !

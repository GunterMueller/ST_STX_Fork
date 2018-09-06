"{ Package: 'stx:libdb/nosql/goods' }"

Object subclass:#KKTestDocumentation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Test'
!

KKTestDocumentation comment:''
!

!KKTestDocumentation class methodsFor:'documentation'!

preparingToRunTests
"
The integration tests supplied by KKDBTest require a working GOODS database.  Before you can run those tests you must:

   1) Install GOODS
   2) Create a database configuration file
   3) Start the database server


--------------------------------------------------------------------------
1) Installing the GOODS software

See http://www.garret.ru/goods.html

--------------------------------------------------------------------------
2) Creating a GOODS database configuration file

Begin by creating a directory to house the database:

	FileDirectory default createDirectory: 'db'

Add a GOODS configuration file to it.  This configuration file should create a server with a single storage running on port 2006 of localhost:

    ((FileDirectory default directoryNamed: 'db')
		newFileNamed: 'test.cfg')
		 nextPutAll: '1' , String lf;
		 nextPutAll: '0: localhost:2006' , String lf;
		 close.

--------------------------------------------------------------------------
3) Starting the database server

I don't recommend starting this server from within your Smalltalk image.  Instead use a shell of some form to enter the command:

cd .......path to db directory.......
goodsrv test

This will leave you in the GOODS database monitor.  Type 'help' for a list of commands.  (Note to shutdown the server you use the 'exit' command.  That is, exiting the monitor, shuts down the server.)

If you insist on starting the server from within your Smalltalk image, squeak users can use OSProcess (install from PackageUniverse) as:

OSProcess command: 'cd db; goodsrv test'
"

	self error: 'Documentation only'



!

wipingTheTestDatabase
"
If you are getting repeated test failures, you may want to start with an empty test database to ensure that problem isn't a corrupted database root, for example.  To wipe a GOODS database:

1) Stop the server (using the 'exit' command inside goodsrv)
2) remove every file beginning with 'test' except 'test.cfg'

I use the following UNIX script:

#!!/bin/sh
rm -f test.his test.idx test.log test.map test.odb
"

	self error: 'Documentation only'



! !

!KKTestDocumentation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKTestDocumentation.st,v 1.3 2013-03-31 12:02:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKTestDocumentation.st,v 1.3 2013-03-31 12:02:29 cg Exp $'
! !


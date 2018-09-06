"{ Package: 'stx:libdb/nosql/goods' }"

KKFieldType subclass:#KKReferenceField
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-GOODS-Metadata'
!

KKReferenceField comment:'GOODS assumes that static type information is available, and so distinguishes between reference fields and immediate fields. In smalltalk, of course, the same field could hold a string one moment and an integer the next. To accomodate this, I''ve patched GOODS to support tagged pointers - the high bit of the reference field (actually of the storage id word of the reference field) is used to mark immediate values such as integers, floats, and booleans.
The patch is included in the class comment of KKReferenceField; after filing in the goods changeset, make sure you apply this patch to your GOODS installation.
If you already have GOODS installed, it isn''t strictly necessary to apply this patch before trying out the Squeak interface - the goodsrv will work just fine without it until the first GC. At which point it will segfault.
This patch does have the side effect of reducing the maximum possible number of GOODS servers for a single database to around 32000. 32k should be enough for anyone.
For goods-2.71:
--- memmgr.cxx.orig     2002-10-16 10:05:02.000000000 -0700
+++ memmgr.cxx  2003-10-27 14:10:44.000000000 -0800
@@ -1270,11 +1270,13 @@
		 while (--n_refs >= 0) {
		     opid_t ropid;
		     stid_t rsid;
-                    p = unpackref(rsid, ropid, p);
+                p = unpackref(rsid, ropid, p);
+                if(!!!!(rsid & 0x8000)) {
		     assert(rsid < n_servers
			    && (ropid <= max_opid
				|| (ropid < last_opid && hp[ropid].is_free())));
		 }
+                }
	     }
	 }
     }
@@ -1705,6 +1707,7 @@
	     GC_MARK(opid);
	     gc_state |= gcs_cont;
	 }
+    } else if (sid & 0x8000) { //tagged pointer
     } else {
	 export_buffer* bp = &gc_export_buf[sid];
	 opid_t* op = bp->refs;
--- objmgr.cxx.orig     2003-02-26 09:11:40.000000000 -0800
+++ objmgr.cxx  2003-10-27 14:10:44.000000000 -0800
@@ -626,7 +626,7 @@
			     continue;
			 }
		     }
-                    if (old_opid !!!!= 0) {
+                    if ((old_opid !!!!= 0) && !!!!(old_sid & 0x8000)) {
			 rp=rp->next=create_object_reference(old_sid, old_opid);
		     }
		 }
'
!


!KKReferenceField methodsFor:'accessing'!

size
	^ 6
!

type
	^ 1
! !

!KKReferenceField methodsFor:'as yet unclassified'!

decodeUnsignedInteger: anInteger
	(anInteger bitAnd: 16r80000000) = 0
		ifTrue: [^ anInteger]
		ifFalse: [^ -1 - (anInteger bitXor: 16rFFFFFFFF)]
!

fieldFromStream: aStream forDatabase: aDatabase
	|sid oid|

	sid := aStream uint16.
	oid := aStream uint32.

	^ (oid = 0 or: [(sid >> 15) = 1])
			ifTrue: [self fieldFromTag: sid value: oid  forDatabase: aDatabase]
			ifFalse: [self referenceAt: oid database: aDatabase]
!

fieldFromTag: sid value: oid forDatabase: aDatabase
	^ sid = 0
		ifTrue: [nil]
		ifFalse: [|tag|
			tag := (sid bitAnd: 16r00FF).
			tag = 1 ifTrue: [self decodeUnsignedInteger: oid]
			ifFalse: [tag = 2 ifTrue: [oid = 1]
			ifFalse: [tag = 3 ifTrue: [Float fromIEEE32Bit: oid]
			ifFalse: [tag = 4 ifTrue: [self referenceAt: oid * -1  database: aDatabase]
			ifFalse: [tag = 5 ifTrue: [Character value: oid]
			ifFalse: [self error: 'Invalid object tag']]]]]]
!

keyForReference: anObject database: aDatabase
	^ aDatabase keyForObject: anObject
!

referenceAt: aKey database: aDatabase
	^ aDatabase objectForKey: aKey
!

writeField: anObject onStream: aStream forDatabase: aDatabase
	| oid sid |
	anObject goodsIsImmediateValue
		ifTrue: [self writeTaggedField: anObject onStream: aStream]
		ifFalse:
			[oid := self keyForReference: anObject database: aDatabase.
			oid < 0
				ifTrue: [sid := 16rFF04. oid := oid * -1]
				ifFalse: [sid := 0].
			aStream
				uint16: sid;
				uint32: oid]
!

writeTaggedField: anObject onStream: aStream
	anObject
		ifNil: [aStream nextNumber: 6 put: 0]
		ifNotNil:
			[aStream nextPut: 255.
			 anObject goodsWriteTaggedOn: aStream].
! !

!KKReferenceField methodsFor:'testing'!

isReference
	^ true
! !

!KKReferenceField class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKReferenceField.st,v 1.6 2013-03-31 12:03:21 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/goods/KKReferenceField.st,v 1.6 2013-03-31 12:03:21 cg Exp $'
! !


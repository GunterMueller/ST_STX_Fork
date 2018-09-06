'From Smalltalk/X, Version:3.5.4 on 24-sep-1999 at 03:44:23 pm'                 !

Object subclass:#User
	instanceVariableNames:'userName password enabled attributes'
	classVariableNames:''
	poolDictionaries:''
	category:'beispiele'
!

Object subclass:#UserAttribute
	instanceVariableNames:'attrKey attrValue'
	classVariableNames:''
	poolDictionaries:''
	privateIn:User
!

!User class methodsFor:'instance creation'!

fromFile:aFilename
    |s o|

    s := aFilename asFilename readStream.
    o := Object readFrom:s.
    s close.
    ^ o

    "
     (User fromFile:'testFile') inspect
    "
!

fromLiteralFile:aFilename
    |s arr|

    s := aFilename asFilename readStream.
    arr := Array readFrom:s.
    s close.
    ^ arr decodeAsLiteralArray

    "
     (User fromLiteralFile:'testFile2') inspect
    "
! !

!User methodsFor:'accessing'!

attributes
    "return the value of the instance variable 'attributes' (automatically generated)"

    ^ attributes!

attributes:something
    "set the value of the instance variable 'attributes' (automatically generated)"

    attributes := something.!

enabled
    "return the value of the instance variable 'enabled' (automatically generated)"

    ^ enabled!

enabled:something
    "set the value of the instance variable 'enabled' (automatically generated)"

    enabled := something.!

password
    "return the value of the instance variable 'password' (automatically generated)"

    ^ password!

password:something
    "set the value of the instance variable 'password' (automatically generated)"

    password := something.!

userName
    "return the value of the instance variable 'userName' (automatically generated)"

    ^ userName!

userName:something
    "set the value of the instance variable 'userName' (automatically generated)"

    userName := something.! !

!User methodsFor:'storing (ascii)'!

storeLiteralOn:aStream
    self literalArrayEncoding storeOn:aStream

    "
     |u|

     u := User new
        userName:'Franz';
        password:'foobarbaz';
        attributes:(Array with:(UserAttribute new
                                        attrKey:'key1';
                                        attrValue:'value1')
                          with:(UserAttribute new
                                        attrKey:'key2';
                                        attrValue:'value2')).

     u storeLiteralOn:Transcript.
    "

!

storeLiteralOnFile:aFilename
    |s|

    s := aFilename asFilename writeStream.
    self storeLiteralOn:s.
    s close.

    "
     |u|

     u := User new
        userName:'Franz';
        password:#[ 123 64 98 78 89 62 127 04];
        attributes:(Array with:(UserAttribute new
                                        attrKey:'key1';
                                        attrValue:'value1')
                          with:(UserAttribute new
                                        attrKey:'key2';
                                        attrValue:'value2')).

     u storeLiteralOnFile:'testFile2'.
    "

!

storeLiteralPrettyOn:aStream
    UISpecification 
        prettyPrintSpecArray:self literalArrayEncoding
        on:aStream
        indent:0

    "
     |u|

     u := User new
        userName:'Franz';
        password:'foobarbaz';
        attributes:(Array with:(UserAttribute new
                                        attrKey:'key1';
                                        attrValue:'value1')
                          with:(UserAttribute new
                                        attrKey:'key2';
                                        attrValue:'value2')).

     u storeLiteralPrettyOn:Transcript.
    "

!

storeLiteralPrettyOnFile:aFilename
    |s|

    s := aFilename asFilename writeStream.
    self storeLiteralPrettyOn:s.
    s close.

    "
     |u|

     u := User new
        userName:'Franz';
        password:#[ 123 64 98 78 89 62 127 04];
        attributes:(Array with:(UserAttribute new
                                        attrKey:'key1';
                                        attrValue:'value1')
                          with:(UserAttribute new
                                        attrKey:'key2';
                                        attrValue:'value2')).

     u storeLiteralPrettyOnFile:'testFile2'.
    "

!

storeOn:aStream
    aStream nextPutLine:'(User new '.
    aStream nextPutAll:'  userName: '. userName storeOn:aStream. aStream nextPut:$;. aStream cr.
    aStream nextPutAll:'  password: '. password storeOn:aStream. aStream nextPut:$;. aStream cr.
    aStream nextPutAll:'  attributes: '. attributes storeOn:aStream. aStream nextPut:$;. aStream cr.
    aStream nextPutAll:'  yourself'. aStream cr.
    aStream nextPutLine:')'.

    "
     |u|

     u := User new
        userName:'Franz';
        password:#[ 123 64 98 78 89 62 127 04];
        attributes:(Array with:(UserAttribute new
                                        attrKey:'key1';
                                        attrValue:'value1')
                          with:(UserAttribute new
                                        attrKey:'key2';
                                        attrValue:'value2')).

     u storeOn:Transcript.
    "

!

storeOnFile:aFilename
    |s|

    s := aFilename asFilename writeStream.
    self storeOn:s.
    s close.

    "
     |u|

     u := User new
        userName:'Franz';
        password:#[ 123 64 98 78 89 62 127 04];
        attributes:(Array with:(UserAttribute new
                                        attrKey:'key1';
                                        attrValue:'value1')
                          with:(UserAttribute new
                                        attrKey:'key2';
                                        attrValue:'value2')).

     u storeOnFile:'testFile'.
    "

! !

!User::UserAttribute methodsFor:'accessing'!

attrKey
    "return the value of the instance variable 'attrKey' (automatically generated)"

    ^ attrKey!

attrKey:something
    "set the value of the instance variable 'attrKey' (automatically generated)"

    attrKey := something.!

attrValue
    "return the value of the instance variable 'attrValue' (automatically generated)"

    ^ attrValue!

attrValue:something
    "set the value of the instance variable 'attrValue' (automatically generated)"

    attrValue := something.! !

!User::UserAttribute methodsFor:'storing (ascii)'!

storeOn:aStream
    aStream nextPutLine:'(UserAttribute new '.
    aStream nextPutAll:'  attrKey: '. attrKey storeOn:aStream. aStream nextPut:$;. aStream cr.
    aStream nextPutAll:'  attrValue: '. attrValue storeOn:aStream. aStream nextPut:$;. aStream cr.
    aStream nextPutAll:'  yourself'. aStream cr.
    aStream nextPutLine:')'.


! !


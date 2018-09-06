"{ Package: 'stx:goodies/regression' }"

"{ NameSpace: RegressionTests }"

TestCase subclass:#HTMLParserTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'tests-Regression-XML'
!

!HTMLParserTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
	mb (mb@SUNGSAM)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 15-01-2009 / 12:44:33 / mb"
! !

!HTMLParserTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown
! !

!HTMLParserTests methodsFor:'tests'!

test01
    |el|

    el := HTML::HTMLParser parseText:'
<HEAD>
</HEAD>
'.
    el inspect.

    "
     self new test01
    "
!

test02
    |doc|

    doc := HTML::HTMLParser parseText:'
<!!--
Copyright 2004 ThoughtWorks, Inc

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Test Open</title>
</head>
<body>
<table cellpadding="1" cellspacing="1" border="1">
  <tbody>
    <tr>
      <td rowspan="1" colspan="3">Google Test Search<br>
      </td>
    </tr>
    <tr>
      <td>open</td>
      <td>http://www.google.com/webhp?hl=en</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>verifyTitle</td>
      <td>Google</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>type</td>
      <td>q</td>
      <td>Selenium OpenQA</td>
    </tr>
    <tr>
      <td>verifyValue</td>
      <td>q</td>
      <td>Selenium OpenQA</td>
    </tr>
    <tr>
      <td>clickAndWait</td>
      <td>btnG</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>verifyTextPresent</td>
      <td>openqa.org</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>verifyTitle</td>
      <td>Selenium OpenQA - Google Search</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>

</table>
</body>
</html>
'.
    self assert:(doc first tag = '!!DOCTYPE').

    "
     self new test02
    "
!

test03
    |doc|

    doc := HTML::HTMLParser parseText:'
<!!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<!!--
Copyright 2004 ThoughtWorks, Inc

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
<html>
<head>
  <meta content="text/html; charset=ISO-8859-1"
 http-equiv="content-type">
  <title>Test Open</title>
</head>
<body>
<table cellpadding="1" cellspacing="1" border="1">
  <tbody>
    <tr>
      <td rowspan="1" colspan="3">Google Test Search<br>
      </td>
    </tr>
    <tr>
      <td>open</td>
      <td>http://www.google.com/webhp?hl=en</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>verifyTitle</td>
      <td>Google</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>type</td>
      <td>q</td>
      <td>Selenium OpenQA</td>
    </tr>
    <tr>
      <td>verifyValue</td>
      <td>q</td>
      <td>Selenium OpenQA</td>
    </tr>
    <tr>
      <td>clickAndWait</td>
      <td>btnG</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>verifyTextPresent</td>
      <td>openqa.org</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>verifyTitle</td>
      <td>Selenium OpenQA - Google Search</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>

</table>
</body>
</html>
'.
    self assert:(doc children first tagName = 'head').
    self assert:(doc docType = '-//W3C//DTD HTML 4.01 Transitional//EN').

    "
     self new test03
    "
! !

!HTMLParserTests class methodsFor:'documentation'!

version
    ^ '$Header$'
! !


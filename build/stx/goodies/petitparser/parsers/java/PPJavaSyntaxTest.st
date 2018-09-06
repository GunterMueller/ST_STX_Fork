"{ Package: 'stx:goodies/petitparser/parsers/java' }"

"{ NameSpace: Smalltalk }"

PPJavaLexiconTest subclass:#PPJavaSyntaxTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'PetitJava-Tests'
!

!PPJavaSyntaxTest methodsFor:'accessing'!

parserClass
	^ PPJavaSyntax
! !

!PPJavaSyntaxTest methodsFor:'testing'!

testAdditiveExpression1

	self parse: 'true'
		rule: #additiveExpression
!

testAdditiveExpression2

	self parse: '3 + 5'
		rule: #additiveExpression
!

testAdditiveExpression3

	self parse: '4 + 8 - 2 + 9'
		rule: #additiveExpression
!

testAndExpression1

	self parse: 'true'
		rule: #andExpression
!

testBlock1

	self parse: '{	}'
		rule: #block
!

testBlock2

	self
		parse:
		'{
			System.out.println("Hello World!!");
 	       	System.out.println("Hello World!!");
		}'
		rule: #block
!

testCompilationUnit1

	self parse: 'package foo;
				public class CU1 {}'
	rule: #compilationUnit
!

testCompilationUnit2

	self parse: 'package foo;
				import foo.Bar;
				public class CU2 {
				}'
	rule: #compilationUnit
!

testCompilationUnit3

	self parse: 'class myfirstjavaprog
{  
        public static void main(String args[])
        {
           System.out.println("Hello World!!");
        }
}'
	rule: #compilationUnit
!

testCompilationUnit4

	self parse: '
					public class OddEven {
 						private int input;
 					  public static void main(String[] args) {
     					OddEven number = new OddEven();
					        number.showDialog(); }
					public void showDialog() {
       
        try {
          
            input = Integer.parseInt(JOptionPane.showInputDialog("Please Enter A Number"));
            calculate();
        } catch (NumberFormatException e) {
            
            System.err.println("ERROR: Invalid input. Please type in a numerical value.");
        }
    }

private void calculate() {
        if (input % 2 == 0) {
            System.out.println("Even");
        } else {
            System.out.println("Odd");
        }
    }
					}'
	rule: #compilationUnit
!

testCompilationUnit5

	self parse: 'class myfirstjavaprog
{  

		public myfirstjavaprog() {
			
		}
	
        public static void main(String args[])
        {
           System.out.println("Hello World!!");
        }
}'
	rule: #compilationUnit
!

testConditionalAndExpression1

	self parse: 'true'
		rule: #conditionalAndExpression
!

testConditionalOrExpression1

	self parse: 'true'
		rule: #conditionalOrExpression
!

testEqualityExpression1

	self 
		parse: 'true'
		rule: #equalityExpression
!

testExclusiveOrExpression1

	self parse: 'true'
		rule: #exclusiveOrExpression
!

testExpression1

	self parse: '1 + 2'
		rule: #expression
!

testExpression2

	self parse: 'true'
		rule: #expression
!

testExpression3

	self parse: 'a.method()'
		rule: #expression
!

testExpression4

	self parse: 'a'
		rule: #expression
!

testExpression5

	self parse: 'a += 5'
		rule: #expression
!

testFormalParameters1

	self 
		parse: '
    (String s, Object parameterType)
'
	rule: #formalParameters
!

testFormalParameters2

	self 
		parse: '
    (Object ... parameterType)
'
	rule: #formalParameters
!

testFormalParameters3

	self 
		parse: '(String name, Class<?>... parameterTypes)
'
	rule: #formalParameters
!

testFormalParameters4

	self 
		parse: '(int one, int two, int three, int four)'
		rule: #formalParameters
!

testFormalParameters5

	self 
		parse: '()'
		rule: #formalParameters
!

testIfStatement1

	self parse: 'if (true) {}'
		rule: #ifStatement
!

testIfStatement2

	self parse: 'if (true) {} else {}'
		rule: #ifStatement
!

testIfStatement3

	self parse: '
	if (true) 
		{int a = 0; a = 1;}
	else
		{return false;}'
		rule: #ifStatement
!

testIfStatement4

	self parse: 'if (true) a = 0;'
		rule: #ifStatement
!

testIfStatement5

	self parse: 'if (a < 4) {}'
		rule: #ifStatement
!

testImportDeclaration1

	self parse: 'import foo.Top;'
		rule: #importDeclaration
!

testImportDeclaration2

	self parse: 'import foo.Top2.*;'
		rule: #importDeclaration
!

testInclusiveOrExpression1

	self parse: 'true'
		rule: #inclusiveOrExpression
!

testInstanceofExpression1

	self 
		parse: 'true'
		rule: #instanceofExpression
!

testLocalVariableDeclaration1

	self parse: 'Type name'
		rule: #localVariableDeclaration
!

testLocalVariableDeclaration2

	self parse: 'Type name = value, name2'
		rule: #localVariableDeclaration
!

testLocalVariableDeclarationStatement1

	self parse: 'int i = 5;'
		rule: #localVariableDeclarationStatement
!

testLocalVariableDeclarationStatement2

	self parse: 'int i, j = 6;'
		rule: #localVariableDeclarationStatement
!

testLocalVariableDeclarationStatement3

	self parse: 'Srting str, in, g;'
		rule: #localVariableDeclarationStatement
!

testMethodDeclaration3

	self 
		parse: '
    public void getMethod(String s, Object ... parameterType)
    {
    }
'
	rule: #methodDeclaration
!

testMethodDeclaration4

	self 
		parse: '
    public void getMethod(String s, int o)
    {
    }
'
	rule: #methodDeclaration
!

testMultiplicativeExpression1

	self parse: 'true'
		rule: #multiplicativeExpression
!

testMultiplicativeExpression2

	self parse: '3 * 5'
		rule: #multiplicativeExpression
!

testMultiplicativeExpression3

	self parse: '4 * 8 / 2 * 9'
		rule: #multiplicativeExpression
!

testNormalParameterDecl1

	self parse: 'final int integers[]'
		rule: #normalParameterDecl
!

testNormalParameterDecl2

	self parse: 'String str'
		rule: #normalParameterDecl
!

testPackageDeclaration1

	self parse: 'package foo;'
		rule: #packageDeclaration
!

testPackageDeclaration2

	self parse: 'package foo.Bar;'
		rule: #packageDeclaration
!

testPackageDeclaration3

	self fail: 'package ;'
		rule: #packageDeclaration
!

testPrimary1

	self 
		parse: 'true'
		rule: #primary
!

testPrimary2

	self 
		parse: '"Java string"'
		rule: #primary
!

testPrimaryWithselectors1

	self 
		parse: 'true'
		rule: #primaryWithselectors
!

testPrimaryWithselectors2

	self 
		parse: 'foo().bar()'
		rule: #primaryWithselectors
!

testQualifiedName1

	self parse: 'a.a'
		rule: #qualifiedName
!

testRelationalExpression1

	self parse: 'true'
		rule: #relationalExpression
!

testRelationalExpression2

	self parse: '3 > 5'
		rule: #relationalExpression
!

testReturnStatement1

	self parse: 'return true;'
		rule: #returnStatement
!

testReturnStatement2

	self parse: 'return;'
		rule: #returnStatement
!

testShiftExpression1

	self parse: 'true'
		rule: #shiftExpression
!

testStatement1

	self parse: 'System.out.println("Hello World!!");'
		rule: #statement
!

testStatement2

	self parse: 'return true;'
		rule: #statement
!

testStatement3

	self parse: '{}'
		rule: #statement
!

testUnaryExpression1

	self parse: 'a'
		rule: #unaryExpression
!

testUnaryExpression2

	self parse: 'true'
		rule: #unaryExpression
!

testUnaryExpressionNotPlusMinus1

	self 
		parse: 'true'
		rule: #unaryExpressionNotPlusMinus
!

testVariableDeclarator1

	self parse: 'var'
		rule: #variableDeclarator
!

testVariableDeclarator2

	self parse: 'var[][]'
		rule: #variableDeclarator
!

testVariableDeclarator3

	self parse: 'var = a.methd()'
		rule: #variableDeclarator
!

testWhileStatement1

	self parse: 'while (true) object.executeMethod();'
		rule: #whileStatement
!

testWhileStatement2

	self parse: 'while (3>2) {block; of; statements;}'
		rule: #whileStatement
! !

!PPJavaSyntaxTest methodsFor:'testing-classes'!

testClassDeclaration1

	self parse: '//comment
	class myfirstjavaprog
{  
        public static void main(String args[])
        {
           System.out.println("Hello World!!");
        }
}'
	rule: #classDeclaration
!

testMethodDeclaration1

	self 
		parse: 'public void aMethod() {	}'
			rule: #methodDeclaration
!

testMethodDeclaration2

	self 
		parse: 'public aMethod() {	}'
			rule: #methodDeclaration
! !


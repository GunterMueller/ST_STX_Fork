/*
 * COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
 * COPYRIGHT (c) 2014-2015 by Tomas Heger
 *                            SWING Research Group, Czech Technical University in Prague
 *
 * This software is furnished under a license and may be used
 * only in accordance with the terms of that license and with the
 * inclusion of the above copyright notice. This software may not
 * be provided or otherwise made available to, or used by, any
 * other person. No title to or ownership of the software is
 * hereby transferred.
 */
package stx.libjava.tools.groovy.ast.tests;

import static org.junit.Assert.*;

import java.util.List;

import org.codehaus.groovy.ast.ASTNode;
import org.codehaus.groovy.ast.ClassNode;
import org.codehaus.groovy.ast.MethodNode;
import org.codehaus.groovy.ast.builder.AstBuilder;
import org.codehaus.groovy.ast.expr.ConstantExpression;
import org.codehaus.groovy.ast.expr.MethodCall;
import org.codehaus.groovy.ast.stmt.ReturnStatement;
import org.junit.Test;

import stx.libjava.tools.groovy.ast.ASTNodeFinder;

public class ASTNodeFinderTests {
	public static final String SOURCE_1 = 
			/*01*/  "class Foo {\n"
			/*02*/+ "    class Bar {\n"
			/*03*/+ "        def marker() {\n"
			/*04*/+ "            return new Object() {\n"
			/*05*/+ "                def String toString() {\n"
			/*06*/+ "\n"
			/*07*/+ "                    return \"MARKER\";\n"
			/*08*/+ "\n"
			/*09*/+ "                }\n"
			/*10*/+ "        }   }\n"
			/*11*/+ "\n"
			/*12*/+ "         def String toString() {\n"
			/*13*/+ "             return \"Foo.Bar\";\n"
			/*14*/+ "         }\n"
			/*15*/+ "    }\n"
			/*16*/+ "\n"
			/*17*/+ "    def execute() {\n"
			/*18*/+ "\n"
			/*19*/+ "        Transcript.showCR(\"Hello world\");\n"
			/*20*/+ "\n"				  
			/*21*/+ "        log(\n"
			/*22*/+ "            (new\n"
			/*23*/+ "                 Bar()).maker());\n"
			/*24*/+ "        fail();\n"
			/*25*/+ "    }\n"
			/*26*/+ "}\n";
	
	public static final List<? extends ASTNode> TREE_1 = (new AstBuilder()).buildFromString(SOURCE_1);

	@Test
	public void test_01() {
		ASTNodeFinder finder;
		ASTNode node;
		
		node = (finder = new ASTNodeFinder()).find(TREE_1, 24, 9);		
		assertTrue(node instanceof MethodCall);
		assertEquals("Foo", finder.getTypeNode().getName());
		
		node = (finder = new ASTNodeFinder()).find(TREE_1, 13, 14);		
		assertTrue(node instanceof ReturnStatement);
		assertEquals("Foo.Bar", ((ConstantExpression)((ReturnStatement)node).getExpression()).getValue());
		assertEquals("Foo$Bar", finder.getTypeNode().getName());
		
		node = (finder = new ASTNodeFinder()).find(TREE_1, 07, 21);		
		assertTrue(node instanceof ReturnStatement);
		assertEquals("MARKER", ((ConstantExpression)((ReturnStatement)node).getExpression()).getValue());
		assertEquals("Foo$Bar$1", finder.getTypeNode().getName());
				
		node = (finder = new ASTNodeFinder()).find(TREE_1, 20, 01);		
		assertTrue(node instanceof MethodNode);
		assertEquals("execute", ((MethodNode)node).getName());
		assertEquals("Foo", finder.getTypeNode().getName());
		
		node = (finder = new ASTNodeFinder()).find(TREE_1, 16, 01);		
		assertTrue(node instanceof ClassNode);
		assertEquals("Foo", ((ClassNode)node).getName());
		assertEquals("Foo", finder.getTypeNode().getName());

	}

}

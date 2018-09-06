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
package stx.libjava.tools.groovy.ast;

import java.util.List;

import org.codehaus.groovy.ast.ASTNode;
import org.codehaus.groovy.ast.ClassNode;
import org.codehaus.groovy.ast.CodeVisitorSupport;
import org.codehaus.groovy.ast.ConstructorNode;
import org.codehaus.groovy.ast.FieldNode;
import org.codehaus.groovy.ast.GroovyClassVisitor;
import org.codehaus.groovy.ast.MethodNode;
import org.codehaus.groovy.ast.PropertyNode;
import org.codehaus.groovy.ast.expr.ArgumentListExpression;
import org.codehaus.groovy.ast.expr.ArrayExpression;
import org.codehaus.groovy.ast.expr.AttributeExpression;
import org.codehaus.groovy.ast.expr.BinaryExpression;
import org.codehaus.groovy.ast.expr.BitwiseNegationExpression;
import org.codehaus.groovy.ast.expr.BooleanExpression;
import org.codehaus.groovy.ast.expr.CastExpression;
import org.codehaus.groovy.ast.expr.ClassExpression;
import org.codehaus.groovy.ast.expr.ClosureExpression;
import org.codehaus.groovy.ast.expr.ClosureListExpression;
import org.codehaus.groovy.ast.expr.ConstantExpression;
import org.codehaus.groovy.ast.expr.ConstructorCallExpression;
import org.codehaus.groovy.ast.expr.DeclarationExpression;
import org.codehaus.groovy.ast.expr.ElvisOperatorExpression;
import org.codehaus.groovy.ast.expr.Expression;
import org.codehaus.groovy.ast.expr.FieldExpression;
import org.codehaus.groovy.ast.expr.GStringExpression;
import org.codehaus.groovy.ast.expr.ListExpression;
import org.codehaus.groovy.ast.expr.MapEntryExpression;
import org.codehaus.groovy.ast.expr.MapExpression;
import org.codehaus.groovy.ast.expr.MethodCallExpression;
import org.codehaus.groovy.ast.expr.MethodPointerExpression;
import org.codehaus.groovy.ast.expr.NotExpression;
import org.codehaus.groovy.ast.expr.PostfixExpression;
import org.codehaus.groovy.ast.expr.PrefixExpression;
import org.codehaus.groovy.ast.expr.PropertyExpression;
import org.codehaus.groovy.ast.expr.RangeExpression;
import org.codehaus.groovy.ast.expr.SpreadExpression;
import org.codehaus.groovy.ast.expr.SpreadMapExpression;
import org.codehaus.groovy.ast.expr.StaticMethodCallExpression;
import org.codehaus.groovy.ast.expr.TernaryExpression;
import org.codehaus.groovy.ast.expr.TupleExpression;
import org.codehaus.groovy.ast.expr.UnaryMinusExpression;
import org.codehaus.groovy.ast.expr.UnaryPlusExpression;
import org.codehaus.groovy.ast.expr.VariableExpression;
import org.codehaus.groovy.ast.stmt.AssertStatement;
import org.codehaus.groovy.ast.stmt.BlockStatement;
import org.codehaus.groovy.ast.stmt.BreakStatement;
import org.codehaus.groovy.ast.stmt.CaseStatement;
import org.codehaus.groovy.ast.stmt.CatchStatement;
import org.codehaus.groovy.ast.stmt.ContinueStatement;
import org.codehaus.groovy.ast.stmt.DoWhileStatement;
import org.codehaus.groovy.ast.stmt.EmptyStatement;
import org.codehaus.groovy.ast.stmt.ExpressionStatement;
import org.codehaus.groovy.ast.stmt.ForStatement;
import org.codehaus.groovy.ast.stmt.IfStatement;
import org.codehaus.groovy.ast.stmt.ReturnStatement;
import org.codehaus.groovy.ast.stmt.Statement;
import org.codehaus.groovy.ast.stmt.SwitchStatement;
import org.codehaus.groovy.ast.stmt.SynchronizedStatement;
import org.codehaus.groovy.ast.stmt.ThrowStatement;
import org.codehaus.groovy.ast.stmt.TryCatchStatement;
import org.codehaus.groovy.ast.stmt.WhileStatement;
import org.codehaus.groovy.classgen.BytecodeExpression;

/**
 * Given a position in the source code (as line and column) and an Groovy AST
 * it searches for the closes AST node and returns it.
 *
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 *
 */
public class ASTNodeFinder extends CodeVisitorSupport implements GroovyClassVisitor {
	protected int line;
	protected int column;

	protected ASTNode   positionNode;
	protected ClassNode typeNode;
	
	public ASTNodeFinder() {
		
	}

	public ASTNodeFinder(int line, int column) {
		this();
		this.line = line;
		this.column = column;
	}

	public int getLine() {
		return line;
	}

	public void setLine(int line) {
		this.line = line;
	}

	public int getColumn() {
		return column;
	}

	public void setColumn(int column) {
		this.column = column;
	}

	public ASTNode getPositionNode() {
		return positionNode;
	}
	public ASTNode find(ASTNode root, int line, int column) {
		this.setLine(line);
		this.setColumn(column);
		return find(root);
	}
	
	public ASTNode find(ASTNode root) {
		/* A special hack to visit classes/methods/constructors and properties - they have no visit(), sigh! */
		if (root instanceof ClassNode) {			
			visitClass((ClassNode)root);
		} else {
			root.visit(this);
		}
		/* A special hack for ctor nodes - if ctor has the same boundary as its
		 * declaring type, return the type node instead. The ctor is synthetic, 
		 * event though it's not marked so...
		 */
		if (positionNode instanceof ConstructorNode) {
			ClassNode classNode = ((ConstructorNode)positionNode).getDeclaringClass();
			if (classNode.getLineNumber() == positionNode.getLineNumber()
					&& classNode.getColumnNumber() == positionNode.getColumnNumber()
					&& classNode.getLastLineNumber() == positionNode.getLastLineNumber()
					&& classNode.getLastColumnNumber() == positionNode.getLastColumnNumber() )
				positionNode = classNode;
		}
		return positionNode;
	}
	
	public ASTNode find(List<? extends ASTNode> roots, int line, int column) {
		this.setLine(line);
		this.setColumn(column);
		return find(roots);
	}
	
	public ASTNode find(List<? extends ASTNode> roots) {
		ASTNode bestNode = null;
		ClassNode bestType = null;
		for (ASTNode root : roots) {
			ASTNode bestInRoot = this.find(root);
			if (bestInRoot != null) {
				if (bestNode == null) {
					bestNode = bestInRoot;
					bestType = typeNode;
				} else {
					if (bestNode != bestInRoot) {
						if (isInside(bestNode, bestInRoot)) {
							bestNode = bestInRoot;
							bestType = typeNode;
						}						
					}
				}
			}
		}
		positionNode = bestNode;
		typeNode = bestType;
		return positionNode;		
	}
	
	/**
	 * Return true if given position (line and column) is inside given node's
	 * boundary, false otherwise
	 */
	private static boolean isInside(ASTNode node, int line, int column) {
		if (node.getLineNumber() == -1) {
			return true;
		}
		if (node.getLineNumber() <= line && line <= node.getLastLineNumber()) {
			if (node.getLineNumber() == line && node.getColumnNumber() > column) return false;
			if (node.getLastLineNumber() == line && node.getLastColumnNumber() < column) return false;			
			return true;
		}
		return false;
	}
	
	/**
	 * Return true if inner node is nested (position-wise) in the outer node,
	 * false otherwise.
	 */
	private static boolean isInside(ASTNode outer, ASTNode inner) {
		if (isInside(outer, inner.getLineNumber(), inner.getColumnNumber())) {
			assert isInside(outer, inner.getLastLineNumber(), inner.getLastColumnNumber());
			return true;
		} else {
			assert ! isInside(outer, inner.getLastLineNumber(), inner.getLastColumnNumber());
			return false;
		}		
	}

	protected boolean enter(ASTNode node) {
		if (node.getLineNumber() == -1) {
			return true;
		}
		if (isInside(node, line, column)) {
			positionNode = node;
			return true;
		}
		return false;
	}

	protected void leave(ASTNode node) {
	}


	@Override
	public void visitBlockStatement(BlockStatement block) {
		// Oops, BlockStatement seems to have funny lastLineNumber, ignore it here...
		super.visitBlockStatement(block);
	}


	@Override
	public void visitForLoop(ForStatement forLoop) {
		if (enter(forLoop)) {
			super.visitForLoop(forLoop);
		}
		leave(forLoop);
	}


	@Override
	public void visitWhileLoop(WhileStatement loop) {
		if (enter(loop)) {
			super.visitWhileLoop(loop);
		}
		leave(loop);
	}


	@Override
	public void visitDoWhileLoop(DoWhileStatement loop) {
		if (enter(loop)) {
			super.visitDoWhileLoop(loop);
		}
		leave(loop);
	}


	@Override
	public void visitIfElse(IfStatement ifElse) {
		if (enter(ifElse)) {
			super.visitIfElse(ifElse);
		}
		leave(ifElse);
	}


	@Override
	public void visitExpressionStatement(ExpressionStatement statement) {
		if (enter(statement)) {
			super.visitExpressionStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitReturnStatement(ReturnStatement statement) {
		if (enter(statement)) {
			super.visitReturnStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitAssertStatement(AssertStatement statement) {
		if (enter(statement)) {
			super.visitAssertStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitTryCatchFinally(TryCatchStatement statement) {
		if (enter(statement)) {
			super.visitTryCatchFinally(statement);
		}
		leave(statement);
	}


	@Override
	protected void visitEmptyStatement(EmptyStatement statement) {
		if (enter(statement)) {
			super.visitEmptyStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitSwitch(SwitchStatement statement) {
		if (enter(statement)) {
			super.visitSwitch(statement);
		}
		leave(statement);
	}


	@Override
	public void visitCaseStatement(CaseStatement statement) {
		if (enter(statement)) {
			super.visitCaseStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitBreakStatement(BreakStatement statement) {
		if (enter(statement)) {
			super.visitBreakStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitContinueStatement(ContinueStatement statement) {
		if (enter(statement)) {
			super.visitContinueStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitSynchronizedStatement(SynchronizedStatement statement) {
		if (enter(statement)) {
			super.visitSynchronizedStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitThrowStatement(ThrowStatement statement) {
		if (enter(statement)) {
			super.visitThrowStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitMethodCallExpression(MethodCallExpression call) {
		if (enter(call)) {
			call.getObjectExpression().visit(this);	       
	        call.getArguments().visit(this);
		}
		leave(call);
	}


	@Override
	public void visitStaticMethodCallExpression(StaticMethodCallExpression call) {
		if (enter(call)) {
			super.visitStaticMethodCallExpression(call);
		}
		leave(call);
	}


	@Override
	public void visitConstructorCallExpression(ConstructorCallExpression call) {
		if (enter(call)) {
			super.visitConstructorCallExpression(call);
		}
		leave(call);
	}


	@Override
	public void visitBinaryExpression(BinaryExpression expression) {
		if (enter(expression)) {
			super.visitBinaryExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitTernaryExpression(TernaryExpression expression) {
		if (enter(expression)) {
			super.visitTernaryExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitShortTernaryExpression(ElvisOperatorExpression expression) {
		if (enter(expression)) {
			super.visitShortTernaryExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitPostfixExpression(PostfixExpression expression) {
		if (enter(expression)) {
			super.visitPostfixExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitPrefixExpression(PrefixExpression expression) {
		if (enter(expression)) {
			super.visitPrefixExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitBooleanExpression(BooleanExpression expression) {
		if (enter(expression)) {
			super.visitBooleanExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitNotExpression(NotExpression expression) {
		if (enter(expression)) {
			super.visitNotExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitClosureExpression(ClosureExpression expression) {
		if (enter(expression)) {
			super.visitClosureExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitTupleExpression(TupleExpression expression) {
		if (enter(expression)) {
			super.visitTupleExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitListExpression(ListExpression expression) {
		if (enter(expression)) {
			super.visitListExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitArrayExpression(ArrayExpression expression) {
		if (enter(expression)) {
			super.visitArrayExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitMapExpression(MapExpression expression) {
		if (enter(expression)) {
			super.visitMapExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitMapEntryExpression(MapEntryExpression expression) {
		if (enter(expression)) {
			super.visitMapEntryExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitRangeExpression(RangeExpression expression) {
		if (enter(expression)) {
			super.visitRangeExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitSpreadExpression(SpreadExpression expression) {
		if (enter(expression)) {
			super.visitSpreadExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitSpreadMapExpression(SpreadMapExpression expression) {
		if (enter(expression)) {
			super.visitSpreadMapExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitMethodPointerExpression(MethodPointerExpression expression) {
		if (enter(expression)) {
			super.visitMethodPointerExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitUnaryMinusExpression(UnaryMinusExpression expression) {
		if (enter(expression)) {
			super.visitUnaryMinusExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitUnaryPlusExpression(UnaryPlusExpression expression) {
		if (enter(expression)) {
			super.visitUnaryPlusExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitBitwiseNegationExpression(
			BitwiseNegationExpression expression) {
		if (enter(expression)) {
			super.visitBitwiseNegationExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitCastExpression(CastExpression expression) {
		if (enter(expression)) {
			super.visitCastExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitConstantExpression(ConstantExpression expression) {
		if (enter(expression)) {
			super.visitConstantExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitClassExpression(ClassExpression expression) {
		if (enter(expression)) {
			super.visitClassExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitVariableExpression(VariableExpression expression) {
		if (enter(expression)) {
			super.visitVariableExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitDeclarationExpression(DeclarationExpression expression) {
		if (enter(expression)) {
			super.visitDeclarationExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitPropertyExpression(PropertyExpression expression) {
		if (enter(expression)) {
			super.visitPropertyExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitAttributeExpression(AttributeExpression expression) {
		if (enter(expression)) {
			super.visitAttributeExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitFieldExpression(FieldExpression expression) {
		if (enter(expression)) {
			super.visitFieldExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitGStringExpression(GStringExpression expression) {
		if (enter(expression)) {
			super.visitGStringExpression(expression);
		}
		leave(expression);
	}


	@Override
	public void visitCatchStatement(CatchStatement statement) {
		if (enter(statement)) {
			super.visitCatchStatement(statement);
		}
		leave(statement);
	}


	@Override
	public void visitArgumentlistExpression(ArgumentListExpression ale) {
		if (enter(ale)) {
			super.visitArgumentlistExpression(ale);
		}
		leave(ale);
	}


	@Override
	public void visitClosureListExpression(ClosureListExpression cle) {
		if (enter(cle)) {
			super.visitClosureListExpression(cle);
		}
		leave(cle);
	}


	@Override
	public void visitBytecodeExpression(BytecodeExpression cle) {
		if (enter(cle)) {
			super.visitBytecodeExpression(cle);
		}
		leave(cle);
	}

	@Override
	public void visitClass(ClassNode node) {
		if (enter(node)) {
			typeNode = node;
			node.visitContents(this);			
		}
		leave(node);
	}

	@Override
	public void visitConstructor(ConstructorNode node) {
		visitMethod(node);		
	}

	@Override
	public void visitMethod(MethodNode node) {
		if (enter(node)) {
			Statement code = node.getCode();
			if (code != null) {
				code.visit(this);
			}
		}
		leave(node);
	}

	@Override
	public void visitField(FieldNode node) {
		if (enter(node)) {
			Expression value = node.getInitialExpression();
			if (value != null) {
				value.visit(this);
			}
		}
		leave(node);		
	}

	@Override
	public void visitProperty(PropertyNode node) {
		if (enter(node)) {
			Expression value = node.getInitialExpression();
			if (value != null) {
				value.visit(this);
			}
		}
		leave(node);			
	}

	public ClassNode getTypeNode() {
		return typeNode;
	}	
}

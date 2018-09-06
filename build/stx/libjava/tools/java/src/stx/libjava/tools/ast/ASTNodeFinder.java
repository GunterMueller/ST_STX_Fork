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
package stx.libjava.tools.ast;

import org.eclipse.jdt.internal.compiler.ASTVisitor;
import org.eclipse.jdt.internal.compiler.ast.AND_AND_Expression;
import org.eclipse.jdt.internal.compiler.ast.ASTNode;
import org.eclipse.jdt.internal.compiler.ast.AbstractMethodDeclaration;
import org.eclipse.jdt.internal.compiler.ast.AllocationExpression;
import org.eclipse.jdt.internal.compiler.ast.AnnotationMethodDeclaration;
import org.eclipse.jdt.internal.compiler.ast.Argument;
import org.eclipse.jdt.internal.compiler.ast.ArrayAllocationExpression;
import org.eclipse.jdt.internal.compiler.ast.ArrayInitializer;
import org.eclipse.jdt.internal.compiler.ast.ArrayQualifiedTypeReference;
import org.eclipse.jdt.internal.compiler.ast.ArrayReference;
import org.eclipse.jdt.internal.compiler.ast.ArrayTypeReference;
import org.eclipse.jdt.internal.compiler.ast.AssertStatement;
import org.eclipse.jdt.internal.compiler.ast.Assignment;
import org.eclipse.jdt.internal.compiler.ast.BinaryExpression;
import org.eclipse.jdt.internal.compiler.ast.Block;
import org.eclipse.jdt.internal.compiler.ast.BreakStatement;
import org.eclipse.jdt.internal.compiler.ast.CaseStatement;
import org.eclipse.jdt.internal.compiler.ast.CastExpression;
import org.eclipse.jdt.internal.compiler.ast.CharLiteral;
import org.eclipse.jdt.internal.compiler.ast.ClassLiteralAccess;
import org.eclipse.jdt.internal.compiler.ast.Clinit;
import org.eclipse.jdt.internal.compiler.ast.CompoundAssignment;
import org.eclipse.jdt.internal.compiler.ast.ConditionalExpression;
import org.eclipse.jdt.internal.compiler.ast.ConstructorDeclaration;
import org.eclipse.jdt.internal.compiler.ast.ContinueStatement;
import org.eclipse.jdt.internal.compiler.ast.DoStatement;
import org.eclipse.jdt.internal.compiler.ast.DoubleLiteral;
import org.eclipse.jdt.internal.compiler.ast.EmptyStatement;
import org.eclipse.jdt.internal.compiler.ast.EqualExpression;
import org.eclipse.jdt.internal.compiler.ast.ExplicitConstructorCall;
import org.eclipse.jdt.internal.compiler.ast.ExtendedStringLiteral;
import org.eclipse.jdt.internal.compiler.ast.FalseLiteral;
import org.eclipse.jdt.internal.compiler.ast.FieldDeclaration;
import org.eclipse.jdt.internal.compiler.ast.FieldReference;
import org.eclipse.jdt.internal.compiler.ast.FloatLiteral;
import org.eclipse.jdt.internal.compiler.ast.ForStatement;
import org.eclipse.jdt.internal.compiler.ast.ForeachStatement;
import org.eclipse.jdt.internal.compiler.ast.IfStatement;
import org.eclipse.jdt.internal.compiler.ast.ImportReference;
import org.eclipse.jdt.internal.compiler.ast.Initializer;
import org.eclipse.jdt.internal.compiler.ast.InstanceOfExpression;
import org.eclipse.jdt.internal.compiler.ast.IntLiteral;
import org.eclipse.jdt.internal.compiler.ast.LabeledStatement;
import org.eclipse.jdt.internal.compiler.ast.LocalDeclaration;
import org.eclipse.jdt.internal.compiler.ast.LongLiteral;
import org.eclipse.jdt.internal.compiler.ast.MarkerAnnotation;
import org.eclipse.jdt.internal.compiler.ast.MemberValuePair;
import org.eclipse.jdt.internal.compiler.ast.MessageSend;
import org.eclipse.jdt.internal.compiler.ast.MethodDeclaration;
import org.eclipse.jdt.internal.compiler.ast.NormalAnnotation;
import org.eclipse.jdt.internal.compiler.ast.NullLiteral;
import org.eclipse.jdt.internal.compiler.ast.OR_OR_Expression;
import org.eclipse.jdt.internal.compiler.ast.ParameterizedQualifiedTypeReference;
import org.eclipse.jdt.internal.compiler.ast.ParameterizedSingleTypeReference;
import org.eclipse.jdt.internal.compiler.ast.PostfixExpression;
import org.eclipse.jdt.internal.compiler.ast.PrefixExpression;
import org.eclipse.jdt.internal.compiler.ast.QualifiedAllocationExpression;
import org.eclipse.jdt.internal.compiler.ast.QualifiedNameReference;
import org.eclipse.jdt.internal.compiler.ast.QualifiedSuperReference;
import org.eclipse.jdt.internal.compiler.ast.QualifiedThisReference;
import org.eclipse.jdt.internal.compiler.ast.QualifiedTypeReference;
import org.eclipse.jdt.internal.compiler.ast.ReturnStatement;
import org.eclipse.jdt.internal.compiler.ast.SingleMemberAnnotation;
import org.eclipse.jdt.internal.compiler.ast.SingleNameReference;
import org.eclipse.jdt.internal.compiler.ast.SingleTypeReference;
import org.eclipse.jdt.internal.compiler.ast.StringLiteral;
import org.eclipse.jdt.internal.compiler.ast.StringLiteralConcatenation;
import org.eclipse.jdt.internal.compiler.ast.SuperReference;
import org.eclipse.jdt.internal.compiler.ast.SwitchStatement;
import org.eclipse.jdt.internal.compiler.ast.SynchronizedStatement;
import org.eclipse.jdt.internal.compiler.ast.ThisReference;
import org.eclipse.jdt.internal.compiler.ast.ThrowStatement;
import org.eclipse.jdt.internal.compiler.ast.TrueLiteral;
import org.eclipse.jdt.internal.compiler.ast.TryStatement;
import org.eclipse.jdt.internal.compiler.ast.TypeDeclaration;
import org.eclipse.jdt.internal.compiler.ast.TypeParameter;
import org.eclipse.jdt.internal.compiler.ast.UnaryExpression;
import org.eclipse.jdt.internal.compiler.ast.UnionTypeReference;
import org.eclipse.jdt.internal.compiler.ast.WhileStatement;
import org.eclipse.jdt.internal.compiler.ast.Wildcard;
import org.eclipse.jdt.internal.compiler.lookup.BlockScope;
import org.eclipse.jdt.internal.compiler.lookup.ClassScope;
import org.eclipse.jdt.internal.compiler.lookup.CompilationUnitScope;
import org.eclipse.jdt.internal.compiler.lookup.MethodScope;
import org.eclipse.jdt.internal.compiler.lookup.Scope;

/**
 * AST node visitor to find a node under given position (offset in 
 * the source)
 * 
 * @author Jan Vrany <jan.vrany [at] fit.cvut.cz>
 *
 */
@stx.libjava.annotation.Package("stx:libjava")
public class ASTNodeFinder extends ASTVisitor {
        public ASTNode positionNode;
        public Scope positionScope;
        public TypeDeclaration typeNode;
        public TypeDeclaration[] typeNodeStack;
        public int typeNodeStackDepth = 0; 
        public AbstractMethodDeclaration methodNode;
        
        public int position;
             
        ASTNodeFinder(int position) {
            this.position = position;
        }
        
        public int getPosition() {
            return position;
        }

        public void setPosition(int position) {
            this.position = position;
        }
        
        public ASTNode getPositionNode() {
            return positionNode;
        }
        
        public Scope getPositionScope() {
            return positionScope;
        }

        public TypeDeclaration getTypeNode() {
            return typeNode;
        }
        
        public TypeDeclaration[] getTypeNodeStack() {
        	TypeDeclaration[] stack = new TypeDeclaration[typeNodeStackDepth];
        	System.arraycopy(typeNodeStack, 0, stack, 0, typeNodeStackDepth);
        	return stack;
        }

        public AbstractMethodDeclaration getMethodNode() {
            return methodNode;
        }
        
        protected void typeNodeStackPush(TypeDeclaration type) {
        	if (typeNodeStack == null) {
        		typeNodeStack = new TypeDeclaration[20];
        	}
        	this.typeNode = type;
        	this.typeNodeStack[typeNodeStackDepth++] = type;
        }
            
        public boolean visit(
            ConstructorDeclaration constructorDeclaration,
            ClassScope scope) {

            if (constructorDeclaration.declarationSourceStart <= this.position
                && this.position <= constructorDeclaration.declarationSourceEnd) {
                    this.positionNode = this.methodNode = constructorDeclaration;
                    this.positionScope = scope;
                    return true;
            }
            return false;
        }

        public boolean visit(
            FieldDeclaration fieldDeclaration,
            MethodScope scope) {
                if (fieldDeclaration.declarationSourceStart <= this.position
                    && this.position <= fieldDeclaration.declarationSourceEnd) {
                        this.positionNode = fieldDeclaration;
                        this.positionScope = scope;
                        return true;
                }
                return false;
        }

        public boolean visit(Initializer initializer, MethodScope scope) {
            return enter(initializer, scope);
        }

        public boolean visit(
            TypeDeclaration memberTypeDeclaration,
            ClassScope scope) {
                if (memberTypeDeclaration.declarationSourceStart <= this.position
                    && this.position <= memberTypeDeclaration.declarationSourceEnd) {
                        this.positionNode = memberTypeDeclaration;
                        typeNodeStackPush(memberTypeDeclaration);
                        this.positionScope = scope;
                        return true;

                }
                return false;
        }

        public boolean visit(
            MethodDeclaration methodDeclaration,
            ClassScope scope) {

            if (methodDeclaration.declarationSourceStart <= this.position
                && this.position <= methodDeclaration.declarationSourceEnd) {
                    this.positionNode = this.methodNode = methodDeclaration;
                    this.positionScope = scope;
                    return true;
            }
            return false;
        }

        public boolean visit(
            TypeDeclaration typeDeclaration,
            CompilationUnitScope scope) {
                if (typeDeclaration.declarationSourceStart <= this.position
                    && this.position <= typeDeclaration.declarationSourceEnd) {
                        this.positionNode = typeDeclaration;
                        typeNodeStackPush(typeDeclaration);
                        this.positionScope = scope;
                        return true;
                }
                return false;
        }
              
        public boolean visit(AllocationExpression allocationExpression, BlockScope scope) {
            return this.enter(allocationExpression, scope);
        }
        public boolean visit(AND_AND_Expression and_and_Expression, BlockScope scope) {
            return this.enter(and_and_Expression, scope);
        }
        public boolean visit(ArrayAllocationExpression arrayAllocationExpression, BlockScope scope) {
            return this.enter(arrayAllocationExpression, scope);
        }
        public boolean visit(ArrayInitializer arrayInitializer, BlockScope scope) {
            return this.enter(arrayInitializer, scope);
        }
        public boolean visit(ArrayQualifiedTypeReference arrayQualifiedTypeReference, BlockScope scope) {
            return this.enter(arrayQualifiedTypeReference, scope);
        }
        public boolean visit(ArrayQualifiedTypeReference arrayQualifiedTypeReference, ClassScope scope) {
            return this.enter(arrayQualifiedTypeReference, scope);
        }
        public boolean visit(ArrayReference arrayReference, BlockScope scope) {
            return this.enter(arrayReference, scope);
        }
        public boolean visit(ArrayTypeReference arrayTypeReference, BlockScope scope) {
            return this.enter(arrayTypeReference, scope);
        }
        public boolean visit(ArrayTypeReference arrayTypeReference, ClassScope scope) {
            return this.enter(arrayTypeReference, scope);
        }
        public boolean visit(Assignment assignment, BlockScope scope) {
            return this.enter(assignment, scope);
        }
        public boolean visit(BinaryExpression binaryExpression, BlockScope scope) {
            return this.enter(binaryExpression, scope);
        }
        public boolean visit(CastExpression castExpression, BlockScope scope) {
            return this.enter(castExpression, scope);
        }
        public boolean visit(CompoundAssignment compoundAssignment, BlockScope scope) {
            return this.enter(compoundAssignment, scope);
        }
        public boolean visit(ConditionalExpression conditionalExpression, BlockScope scope) {
            return this.enter(conditionalExpression, scope);
        }
        public boolean visit(EqualExpression equalExpression, BlockScope scope) {
            return this.enter(equalExpression, scope);
        }
        public boolean visit(ExplicitConstructorCall explicitConstructor, BlockScope scope) {
            return this.enter(explicitConstructor, scope);
        }
        public boolean visit(FieldReference fieldReference, BlockScope scope) {
            return this.enter(fieldReference, scope);
        }
        public boolean visit(InstanceOfExpression instanceOfExpression, BlockScope scope) {
            return this.enter(instanceOfExpression, scope);
        }
        public boolean visit(MessageSend messageSend, BlockScope scope) {
            return this.enter(messageSend, scope);
        }
        public boolean visit(OR_OR_Expression or_or_Expression, BlockScope scope) {
            return this.enter(or_or_Expression, scope);
        }
        public boolean visit(ParameterizedQualifiedTypeReference parameterizedQualifiedTypeReference, BlockScope scope) {
            return this.enter(parameterizedQualifiedTypeReference, scope);
        }
        public boolean visit(ParameterizedQualifiedTypeReference parameterizedQualifiedTypeReference, ClassScope scope) {
            return this.enter(parameterizedQualifiedTypeReference, scope);
        }
        public boolean visit(ParameterizedSingleTypeReference parameterizedSingleTypeReference, BlockScope scope) {
            return this.enter(parameterizedSingleTypeReference, scope);
        }
        public boolean visit(ParameterizedSingleTypeReference parameterizedSingleTypeReference, ClassScope scope) {
            return this.enter(parameterizedSingleTypeReference, scope);
        }
        public boolean visit(PostfixExpression postfixExpression, BlockScope scope) {
            return this.enter(postfixExpression, scope);
        }
        public boolean visit(PrefixExpression prefixExpression, BlockScope scope) {
            return this.enter(prefixExpression, scope);
        }
        public boolean visit(QualifiedAllocationExpression qualifiedAllocationExpression, BlockScope scope) {
            return this.enter(qualifiedAllocationExpression, scope);
        }
        public boolean visit(QualifiedNameReference qualifiedNameReference, BlockScope scope) {
            return this.enter(qualifiedNameReference, scope);
        }
        public boolean visit(QualifiedSuperReference qualifiedSuperReference, BlockScope scope) {
            return this.enter(qualifiedSuperReference, scope);
        }
        public boolean visit(QualifiedThisReference qualifiedThisReference, BlockScope scope) {
            return this.enter(qualifiedThisReference, scope);
        }
        public boolean visit(QualifiedTypeReference qualifiedTypeReference, BlockScope scope) {
            return this.enter(qualifiedTypeReference, scope);
        }
        public boolean visit(QualifiedTypeReference qualifiedTypeReference, ClassScope scope) {
            return this.enter(qualifiedTypeReference, scope);
        }
        public boolean visit(SingleNameReference singleNameReference, BlockScope scope) {
            return this.enter(singleNameReference, scope);
        }
        public boolean visit(SingleTypeReference singleTypeReference, BlockScope scope) {
            return this.enter(singleTypeReference, scope);
        }
        public boolean visit(SingleTypeReference singleTypeReference, ClassScope scope) {
            return this.enter(singleTypeReference, scope);
        }
        public boolean visit(StringLiteral stringLiteral, BlockScope scope) {
            return this.enter(stringLiteral, scope);
        }
        public boolean visit(SuperReference superReference, BlockScope scope) {
            return this.enter(superReference, scope);
        }
        public boolean visit(ThisReference thisReference, BlockScope scope) {
            return this.enter(thisReference, scope);
        }
        public boolean visit(UnaryExpression unaryExpression, BlockScope scope) {
            return this.enter(unaryExpression, scope);
        }
        public boolean visit(MemberValuePair pair, BlockScope scope) {
            return this.enter(pair, scope);
        }
        public boolean visit(MemberValuePair pair, CompilationUnitScope scope) {
            return this.enter(pair, scope);
        }
               
        @Override
        public boolean visit(
                AnnotationMethodDeclaration annotationTypeDeclaration,
                ClassScope scope) {
            return enter(annotationTypeDeclaration, scope);
        }

        @Override
        public boolean visit(Argument argument, BlockScope scope) {
            return enter(argument, scope);        
        }

        @Override
        public boolean visit(Argument argument, ClassScope scope) {
            return enter(argument, scope);        
        }

        @Override
        public boolean visit(AssertStatement assertStatement, BlockScope scope) {
            return enter(assertStatement, scope);       
        }   

        @Override
        public boolean visit(Block block, BlockScope scope) {
            return enter(block, scope);
        }

        @Override
        public boolean visit(BreakStatement breakStatement, BlockScope scope) {
            return enter(breakStatement, scope);
        }

        @Override
        public boolean visit(CaseStatement caseStatement, BlockScope scope) {
            return enter(caseStatement, scope);
        }

        @Override
        public boolean visit(CharLiteral charLiteral, BlockScope scope) {
            return enter(charLiteral, scope);
        }

        @Override
        public boolean visit(ClassLiteralAccess classLiteral, BlockScope scope) {
            return enter(classLiteral, scope);
        }

        @Override
        public boolean visit(Clinit clinit, ClassScope scope) {
            return enter(clinit, scope);
        }

        @Override
        public boolean visit(ContinueStatement continueStatement,
                BlockScope scope) {
            return enter(continueStatement, scope);        }

        @Override
        public boolean visit(DoStatement doStatement, BlockScope scope) {
            return enter(doStatement, scope);
        }

        @Override
        public boolean visit(DoubleLiteral doubleLiteral, BlockScope scope) {
            return enter(doubleLiteral, scope);
        }

        @Override
        public boolean visit(EmptyStatement emptyStatement, BlockScope scope) {
            return enter(emptyStatement, scope);
        }

        @Override
        public boolean visit(ExtendedStringLiteral extendedStringLiteral,
                BlockScope scope) {
            return enter(extendedStringLiteral, scope);
        }

        @Override
        public boolean visit(FalseLiteral falseLiteral, BlockScope scope) {
            return enter(falseLiteral, scope);        }

        @Override
        public boolean visit(FieldReference fieldReference, ClassScope scope) {
            return enter(fieldReference, scope);        }

        @Override
        public boolean visit(FloatLiteral floatLiteral, BlockScope scope) {
            return enter(floatLiteral, scope);
        }

        @Override
        public boolean visit(ForeachStatement forStatement, BlockScope scope) {
            return enter(forStatement, scope);
        }

        @Override
        public boolean visit(ForStatement forStatement, BlockScope scope) {
            return enter(forStatement, scope);
        }

        @Override
        public boolean visit(IfStatement ifStatement, BlockScope scope) {
            return enter(ifStatement, scope);
        }

        @Override
        public boolean visit(ImportReference importRef,
                CompilationUnitScope scope) {
            return enter(importRef, scope);
        }

        @Override
        public boolean visit(IntLiteral intLiteral, BlockScope scope) {
            return enter(intLiteral, scope);
        }

        @Override
        public boolean visit(LabeledStatement labeledStatement, BlockScope scope) {
            return enter(labeledStatement, scope);
        }

        @Override
        public boolean visit(LocalDeclaration localDeclaration, BlockScope scope) {
            return enter(localDeclaration, scope);
        }

        @Override
        public boolean visit(LongLiteral longLiteral, BlockScope scope) {
            return enter(longLiteral, scope);
        }

        @Override
        public boolean visit(MarkerAnnotation annotation, BlockScope scope) {
            return enter(annotation, scope);
        }

        @Override
        public boolean visit(StringLiteralConcatenation literal,
                BlockScope scope) {
            return enter(literal, scope);
        }

        @Override
        public boolean visit(NormalAnnotation annotation, BlockScope scope) {
            return enter(annotation, scope);
        }

        @Override
        public boolean visit(NullLiteral nullLiteral, BlockScope scope) {
            return enter(nullLiteral, scope);
        }

        @Override
        public boolean visit(QualifiedNameReference qualifiedNameReference,
                ClassScope scope) {
            return enter(qualifiedNameReference, scope);
        }

        @Override
        public boolean visit(QualifiedSuperReference qualifiedSuperReference,
                ClassScope scope) {
            return enter(qualifiedSuperReference, scope);
        }

        @Override
        public boolean visit(QualifiedThisReference qualifiedThisReference,
                ClassScope scope) {
            return enter(qualifiedThisReference, scope);
        }

        @Override
        public boolean visit(ReturnStatement returnStatement, BlockScope scope) {
            return enter(returnStatement, scope);
        }

        @Override
        public boolean visit(SingleMemberAnnotation annotation, BlockScope scope) {
            return enter(annotation, scope);
        }

        @Override
        public boolean visit(SingleNameReference singleNameReference,
                ClassScope scope) {
            return enter(singleNameReference, scope);
        }

        @Override
        public boolean visit(SwitchStatement switchStatement, BlockScope scope) {
            return enter(switchStatement, scope);            
        }

        @Override
        public boolean visit(SynchronizedStatement synchronizedStatement,
                BlockScope scope) {
            return enter(synchronizedStatement, scope);
        }

        @Override
        public boolean visit(ThisReference thisReference, ClassScope scope) {
            return enter(thisReference, scope);            
        }

        @Override
        public boolean visit(ThrowStatement throwStatement, BlockScope scope) {
            return enter(throwStatement, scope);
        }

        @Override
        public boolean visit(TrueLiteral trueLiteral, BlockScope scope) {
            return enter(trueLiteral, scope);
        }

        @Override
        public boolean visit(TryStatement tryStatement, BlockScope scope) {
            return enter(tryStatement, scope);
        }

        @Override
        public boolean visit(TypeDeclaration localTypeDeclaration,
                BlockScope scope) {
        	   if (localTypeDeclaration.declarationSourceStart <= this.position
                       && this.position <= localTypeDeclaration.declarationSourceEnd) {
                           this.positionNode = localTypeDeclaration;
                           this.typeNodeStackPush(localTypeDeclaration);
                           this.positionScope = scope;
                           return true;
                   }
                   return false;
        }

        @Override
        public boolean visit(TypeParameter typeParameter, BlockScope scope) {
            return enter(typeParameter, scope);
        }

        @Override
        public boolean visit(TypeParameter typeParameter, ClassScope scope) {
            return enter(typeParameter, scope);
        }

        @Override
        public boolean visit(UnionTypeReference unionTypeReference,
                BlockScope scope) {
            return enter(unionTypeReference, scope);        }

        @Override
        public boolean visit(UnionTypeReference unionTypeReference,
                ClassScope scope) {
            return enter(unionTypeReference, scope);        }

        @Override
        public boolean visit(WhileStatement whileStatement, BlockScope scope) {
            return enter(whileStatement, scope);        }

        @Override
        public boolean visit(Wildcard wildcard, BlockScope scope) {
            return enter(wildcard, scope);        }

        @Override
        public boolean visit(Wildcard wildcard, ClassScope scope) {
            return enter(wildcard, scope);
        }
        
        protected boolean enter(ASTNode node, Scope scope) {
            return enter(node, scope, node.sourceStart, node.sourceEnd);
        }
                            
        protected boolean enter(ASTNode node, Scope scope, int start, int end) {
            if (start <= position && position <= end + 1) {
                this.positionNode = node;
                this.positionScope = scope;
                return true;
            }
            return false;
        }
        
    }


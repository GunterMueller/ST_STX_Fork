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
package stx.libjava.tools.text;


import org.eclipse.jdt.core.compiler.InvalidInputException;
import org.eclipse.jdt.internal.compiler.ASTVisitor;
import org.eclipse.jdt.internal.compiler.DefaultErrorHandlingPolicies;
import org.eclipse.jdt.internal.compiler.ast.ASTNode;
import org.eclipse.jdt.internal.compiler.ast.Argument;
import org.eclipse.jdt.internal.compiler.ast.ArrayQualifiedTypeReference;
import org.eclipse.jdt.internal.compiler.ast.ArrayTypeReference;
import org.eclipse.jdt.internal.compiler.ast.Assignment;
import org.eclipse.jdt.internal.compiler.ast.CompilationUnitDeclaration;
import org.eclipse.jdt.internal.compiler.ast.ConstructorDeclaration;
import org.eclipse.jdt.internal.compiler.ast.FieldDeclaration;
import org.eclipse.jdt.internal.compiler.ast.FieldReference;
import org.eclipse.jdt.internal.compiler.ast.LocalDeclaration;
import org.eclipse.jdt.internal.compiler.ast.MessageSend;
import org.eclipse.jdt.internal.compiler.ast.MethodDeclaration;
import org.eclipse.jdt.internal.compiler.ast.ParameterizedQualifiedTypeReference;
import org.eclipse.jdt.internal.compiler.ast.ParameterizedSingleTypeReference;
import org.eclipse.jdt.internal.compiler.ast.QualifiedTypeReference;
import org.eclipse.jdt.internal.compiler.ast.SingleNameReference;
import org.eclipse.jdt.internal.compiler.ast.SingleTypeReference;
import org.eclipse.jdt.internal.compiler.env.ICompilationUnit;
import org.eclipse.jdt.internal.compiler.lookup.Binding;
import org.eclipse.jdt.internal.compiler.lookup.BlockScope;
import org.eclipse.jdt.internal.compiler.lookup.ClassScope;
import org.eclipse.jdt.internal.compiler.lookup.CompilationUnitScope;
import org.eclipse.jdt.internal.compiler.lookup.MethodScope;
import org.eclipse.jdt.internal.compiler.lookup.TypeBinding;
import org.eclipse.jdt.internal.compiler.problem.ProblemReporter;

import stx.libjava.tools.parser.Parser;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class Highlighter extends Parser {
    
    protected Marker marker;
    protected Indexer indexer;
    
    public Highlighter() {
        this(new Marker() {            
           
        },
        new Indexer() {
                       
        });
    }
    
    public Highlighter(Marker marker, Indexer indexer) {
        this(
                new ProblemReporter(
                        DefaultErrorHandlingPolicies.proceedWithAllProblems(), 
                        defaultCompilerOptions(), 
                        defaultProblemFactory()),
                true, 
                marker,
                indexer);
    }

    public Highlighter(ProblemReporter problemReporter,
            boolean optimizeStringLiterals, Marker marker, Indexer indexer) {
        super(problemReporter, optimizeStringLiterals);
        setMarker(marker);
        setIndexer(indexer);
    }
    
    public Marker getMarker() {
        return marker;
    }
    
    public void setMarker(Marker marker) {
        this.marker = marker;        
        ((HighlightingScanner)this.scanner).marker = marker;
    }

    public Indexer getIndexer() {
        return indexer;
    }

    public void setIndexer(Indexer indexer) {
        this.indexer = indexer;
    }


    public void initializeScanner(){
        this.scanner = new Highlighter.HighlightingScanner(
            false /*comment*/,
            false /*whitespace*/,
            false, /* will be set in initialize(boolean) */
            this.options.sourceLevel /*sourceLevel*/,
            this.options.complianceLevel /*complianceLevel*/,
            this.options.taskTags/*taskTags*/,
            this.options.taskPriorities/*taskPriorities*/,
            this.options.isTaskCaseSensitive/*taskCaseSensitive*/);
    }
    
    
    public CompilationUnitDeclaration parse(ICompilationUnit cu, boolean diet, boolean resolve) {
        CompilationUnitDeclaration cud = super.parse(cu, diet, resolve);
        HighlightingAndIndexingVisitor v = new HighlightingAndIndexingVisitor();
        cud.ignoreFurtherInvestigation = false;
        v.setMarker(marker);
        v.setIndexer(indexer);
        cud.traverse(v, (CompilationUnitScope)null);                            
        return cud;
    }
    
    /* 
    public ASTNode[] parseClassBodyDeclarations(char[] source, int offset, int length, CompilationUnitDeclaration unit) {
        ASTNode[] nodes = super.parseClassBodyDeclarations(source, offset, length, unit);
        HighlightingAndIndexingVisitor v = new HighlightingAndIndexingVisitor();
        v.setMarker(marker);
        v.setIndexer(indexer);
        for (int i = 0; i < nodes.length; i++) {
            ASTNode n = nodes[i];            
            if (n instanceof MethodDeclaration) {
                ((MethodDeclaration)n).traverse(v, (ClassScope)null);
            } else {
                nodes[i].traverse(v, null);
            }
        }
        return nodes;
    }
    */

    
    public static class HighlightingAndIndexingVisitor extends ASTVisitor {
        protected Marker marker;        
        protected Indexer indexer;

        public Marker getMarker() {
            return marker;
        }

        public void setMarker(Marker marker) {
            this.marker = marker;
        }

        public Indexer getIndexer() {
            return indexer;
        }

        public void setIndexer(Indexer indexer) {
            this.indexer = indexer;
        }
                     
        public void endVisit(FieldDeclaration fieldDeclaration, MethodScope scope) {
            marker.mark(Marker.MARK_FIELD, fieldDeclaration.sourceStart, fieldDeclaration.sourceEnd);
            indexer.addFieldDeclaration(fieldDeclaration, fieldDeclaration.sourceStart, fieldDeclaration.sourceEnd);
        }
        
        public void endVisit(LocalDeclaration localDeclaration, BlockScope scope) {
            marker.mark(Marker.MARK_LOCAL, localDeclaration.sourceStart, localDeclaration.sourceEnd);
            indexer.addLocalDeclaration(localDeclaration, localDeclaration.sourceStart, localDeclaration.sourceEnd);
        }
        
        public void endVisit(Argument localDeclaration, BlockScope scope) {
            marker.mark(Marker.MARK_LOCAL, localDeclaration.sourceStart, localDeclaration.sourceEnd);
            indexer.addLocalDeclaration(localDeclaration, localDeclaration.sourceStart, localDeclaration.sourceEnd);
        }

        
        public void endVisit(FieldReference fieldReference, BlockScope scope) {
            int start = (int)(fieldReference.nameSourcePosition >>> 32);
            int stop  = (int)(fieldReference.nameSourcePosition & 0x0000FFFFFFFF);
            marker.mark(Marker.MARK_FIELD, start, stop);
            indexer.addVariableReference(fieldReference, start, stop);
        }
        public void endVisit(FieldReference fieldReference, ClassScope scope) {
            int start = (int)(fieldReference.nameSourcePosition >>> 32);
            int stop  = (int)(fieldReference.nameSourcePosition & 0x0000FFFFFFFF);
            marker.mark(Marker.MARK_FIELD, start, stop);
            indexer.addVariableReference(fieldReference, start, stop);
        }
        
                
        public void endVisit(MessageSend messageSend, BlockScope scope) {
            int start = (int)(messageSend.nameSourcePosition >>> 32);
            int stop  = (int)(messageSend.nameSourcePosition & 0x0000FFFFFFFF);
            marker.mark(Marker.MARK_SELECTOR, start, stop);
            indexer.addMessageSend(messageSend, start, stop);                                                                        
        }
        
        public boolean visit(MethodDeclaration methodDeclaration, ClassScope scope) {
            int start = methodDeclaration.sourceStart;
            int stop  = start + methodDeclaration.selector.length - 1;
            marker.mark(Marker.MARK_SELECTOR, start, stop);
            indexer.methodEnter(methodDeclaration);
            return true;
        }
        
        public void endVisit(MethodDeclaration methodDeclaration, ClassScope scope) {
            indexer.methodLeave(methodDeclaration);
        }
        
        public void endVisit(
                SingleTypeReference type,
                BlockScope scope) {
            if (type.token == TypeBinding.VOID.simpleName) return;
            if (type.token == TypeBinding.BOOLEAN.simpleName) return;
            if (type.token == TypeBinding.CHAR.simpleName) return;
            if (type.token == TypeBinding.FLOAT.simpleName) return;
            if (type.token == TypeBinding.DOUBLE.simpleName) return;
            if (type.token == TypeBinding.BYTE.simpleName) return;
            if (type.token == TypeBinding.SHORT.simpleName) return;
            if (type.token == TypeBinding.INT.simpleName) return;
            if (type.token == TypeBinding.LONG.simpleName) return;
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceEnd);
            indexer.addTypeReference(type, type.sourceStart, type.sourceEnd);
        }
        
        
        public void endVisit(
                SingleTypeReference type,
                ClassScope scope) {
            if (type.token == TypeBinding.VOID.simpleName) return;
            if (type.token == TypeBinding.BOOLEAN.simpleName) return;
            if (type.token == TypeBinding.CHAR.simpleName) return;
            if (type.token == TypeBinding.FLOAT.simpleName) return;
            if (type.token == TypeBinding.DOUBLE.simpleName) return;
            if (type.token == TypeBinding.BYTE.simpleName) return;
            if (type.token == TypeBinding.SHORT.simpleName) return;
            if (type.token == TypeBinding.INT.simpleName) return;
            if (type.token == TypeBinding.LONG.simpleName) return;
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceEnd);
            indexer.addTypeReference(type, type.sourceStart, type.sourceEnd);
        }
        
        public void endVisit(
                ParameterizedSingleTypeReference type,
                BlockScope scope) {
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceStart + type.token.length - 1);
            indexer.addTypeReference(type, type.sourceStart, type.sourceStart + type.token.length - 1);            
        }

        public void endVisit(
                ParameterizedSingleTypeReference type,
                ClassScope scope) {
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceStart + type.token.length - 1);
            indexer.addTypeReference(type, type.sourceStart, type.sourceStart + type.token.length - 1);
            
        }
        
        public void endVisit(ArrayTypeReference type, BlockScope scope) {
            if (type.token == TypeBinding.VOID.simpleName) return;
            if (type.token == TypeBinding.BOOLEAN.simpleName) return;
            if (type.token == TypeBinding.CHAR.simpleName) return;
            if (type.token == TypeBinding.FLOAT.simpleName) return;
            if (type.token == TypeBinding.DOUBLE.simpleName) return;
            if (type.token == TypeBinding.BYTE.simpleName) return;
            if (type.token == TypeBinding.SHORT.simpleName) return;
            if (type.token == TypeBinding.INT.simpleName) return;
            if (type.token == TypeBinding.LONG.simpleName) return;
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceEnd);
            indexer.addTypeReference(type, type.sourceStart, type.sourceEnd);
        }
        public void endVisit(ArrayTypeReference type, ClassScope scope) {
            if (type.token == TypeBinding.VOID.simpleName) return;
            if (type.token == TypeBinding.BOOLEAN.simpleName) return;
            if (type.token == TypeBinding.CHAR.simpleName) return;
            if (type.token == TypeBinding.FLOAT.simpleName) return;
            if (type.token == TypeBinding.DOUBLE.simpleName) return;
            if (type.token == TypeBinding.BYTE.simpleName) return;
            if (type.token == TypeBinding.SHORT.simpleName) return;
            if (type.token == TypeBinding.INT.simpleName) return;
            if (type.token == TypeBinding.LONG.simpleName) return;
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceEnd);
            indexer.addTypeReference(type, type.sourceStart, type.sourceEnd);
        }
        
        protected void breakpoint() {}
        
        public void endVisit(
                SingleNameReference ref,
                BlockScope scope) {
            /*
            if (ref.binding == null) {
                breakpoint();
                ref.resolve(scope);
            }
            */
            
            boolean isField = (ref.bits & ASTNode.RestrictiveFlagMASK) == Binding.FIELD;
            if (isField) {
                marker.mark(Marker.MARK_FIELD, ref.sourceStart,  ref.sourceEnd);
            }
            indexer.addVariableReference(ref, ref.sourceStart,  ref.sourceEnd);                      
        }
        
        
        public void endVisit(Assignment assignment, BlockScope scope) {
            if ((assignment.lhs.bits & ASTNode.RestrictiveFlagMASK) == Binding.FIELD) {
                marker.mark(Marker.MARK_FIELD_ASSIGNED, assignment.lhs.sourceStart,  assignment.lhs.sourceEnd);
            }
        }
                
        public void endVisit(
                ArrayQualifiedTypeReference type,
                BlockScope scope) {
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceEnd);
            indexer.addTypeReference(type, type.sourceStart, type.sourceEnd);
        }
        public void endVisit(
                ArrayQualifiedTypeReference type,
                ClassScope scope) {
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceEnd);
            indexer.addTypeReference(type, type.sourceStart, type.sourceEnd);                
        }
        
        public void endVisit(
                QualifiedTypeReference type,
                BlockScope scope) {            
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceEnd);
            indexer.addTypeReference(type, type.sourceStart, type.sourceEnd);                

        }
        public void endVisit(
                QualifiedTypeReference type,
                ClassScope scope) {
            marker.mark(Marker.MARK_CLASS, type.sourceStart, type.sourceEnd);
            indexer.addTypeReference(type, type.sourceStart, type.sourceEnd);                
        }
        
        public void endVisit(
                ParameterizedQualifiedTypeReference type,
                BlockScope scope) {
            int start = type.sourceEnd;
            int stop = (int)(type.sourcePositions[type.sourcePositions.length - 1] & 0x0000FFFFFFFF);
            marker.mark(Marker.MARK_CLASS, start, stop);
            indexer.addTypeReference(type, start, stop);            
        }

        public void endVisit(
                ParameterizedQualifiedTypeReference type,
                ClassScope scope) {
            int start = type.sourceEnd;
            int stop = (int)(type.sourcePositions[type.sourcePositions.length - 1] & 0x0000FFFFFFFF);
            marker.mark(Marker.MARK_CLASS, start, stop);
            indexer.addTypeReference(type, start, stop);            
        }
        
        public boolean visit(
                ConstructorDeclaration constructorDeclaration,
                ClassScope scope) {
            indexer.methodEnter(constructorDeclaration);
            return true;
        }

        
        public void endVisit(
                ConstructorDeclaration constructorDeclaration,
                ClassScope scope) {
            indexer.methodLeave(constructorDeclaration);
            int start = constructorDeclaration.sourceStart;
            int stop  = start + constructorDeclaration.selector.length - 1;
            marker.mark(Marker.MARK_SELECTOR, start, stop);
            
        }

        
    }
        
    public static class HighlightingScanner extends org.eclipse.jdt.internal.compiler.parser.Scanner {
        
        public Marker marker;
        protected int lastCommentPtr = -1;

        public HighlightingScanner(boolean b, boolean c, boolean d, long sourceLevel,
                long complianceLevel, char[][] taskTags,
                char[][] taskPriorities, boolean isTaskCaseSensitive) {
            super(b,c,d,sourceLevel, complianceLevel, taskTags, taskPriorities, isTaskCaseSensitive);
        }
        
        public void recordComment(int token) {            
            // compute position
            int start = this.startPosition;
            int stop = this.currentPosition;
            super.recordComment(token);
            
            switch (token) {
            case TokenNameCOMMENT_LINE:
            case TokenNameCOMMENT_BLOCK:
                marker.mark(Marker.MARK_COMMENT, start, stop);
                break;                 
            case TokenNameCOMMENT_JAVADOC:
                marker.mark(Marker.MARK_JAVADOC, start, stop);
                break;             
            }
            
        }
        
        
        public int getNextToken() throws InvalidInputException {
            int t = super.getNextToken();
                               
            switch (t) {
            
            case TokenNamebreak:
            case TokenNamecatch:
            case TokenNameelse:    
            case TokenNamefinally:
            case TokenNamecontinue:
            case TokenNamedefault:
            case TokenNamedo:
            case TokenNamefor:
            case TokenNameif:
            case TokenNamecase:
            case TokenNamereturn:
                marker.mark(Marker.MARK_KEYWORD_FLOW, getCurrentTokenStartPosition(), getCurrentTokenEndPosition());
                break;           
            case TokenNameabstract:
            case TokenNameassert:
            case TokenNameboolean:            
            case TokenNamebyte:            
            case TokenNamechar:
            case TokenNameclass:
            case TokenNamedouble:            
            case TokenNameextends:
            case TokenNamefalse:
            case TokenNamefinal:
            case TokenNamethrow:
            case TokenNametry:
            case TokenNamewhile:
            case TokenNameswitch:
            case TokenNamefloat:
            case TokenNameimplements:
            case TokenNameimport:
            case TokenNameinstanceof:
            case TokenNameinterface:
            case TokenNamelong:
            case TokenNameint:
            case TokenNamenative:
            case TokenNamenew:
            case TokenNamenull:
            case TokenNamepackage:
            case TokenNameprivate:
            case TokenNameprotected:
            case TokenNamepublic:            
            case TokenNameshort:
            case TokenNamestatic:
            case TokenNamestrictfp:
            case TokenNamesuper:            
            case TokenNamesynchronized:
            case TokenNamethis:            
            case TokenNamethrows:
            case TokenNametransient:
            case TokenNametrue:            
            case TokenNamevoid:
            case TokenNamevolatile:            
                marker.mark(Marker.MARK_KEYWORD, getCurrentTokenStartPosition(), getCurrentTokenEndPosition());
                break;
            case TokenNameIntegerLiteral:
            case TokenNameLongLiteral:
            case TokenNameFloatingPointLiteral:
            case TokenNameDoubleLiteral:
                marker.mark(Marker.MARK_NUMBER, getCurrentTokenStartPosition(), getCurrentTokenEndPosition());
                break;
            case TokenNameStringLiteral:
                marker.mark(Marker.MARK_STRING, getCurrentTokenStartPosition(), getCurrentTokenEndPosition());
                break;
            case TokenNameCharacterLiteral:                
                marker.mark(Marker.MARK_CHARACTER, getCurrentTokenStartPosition(), getCurrentTokenEndPosition());
                break; 
            }
            
            return t;
        }
        
    }
    
}

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
package stx.libjava.tools.parser;

import org.eclipse.jdt.internal.compiler.CompilationResult;
import org.eclipse.jdt.internal.compiler.DefaultErrorHandlingPolicies;
import org.eclipse.jdt.internal.compiler.ast.ASTNode;
import org.eclipse.jdt.internal.compiler.ast.AbstractMethodDeclaration;
import org.eclipse.jdt.internal.compiler.ast.CompilationUnitDeclaration;
import org.eclipse.jdt.internal.compiler.ast.FieldDeclaration;
import org.eclipse.jdt.internal.compiler.ast.TypeDeclaration;
import org.eclipse.jdt.internal.compiler.classfmt.ClassFileConstants;
import org.eclipse.jdt.internal.compiler.env.ICompilationUnit;
import org.eclipse.jdt.internal.compiler.impl.CompilerOptions;
import org.eclipse.jdt.internal.compiler.problem.DefaultProblemFactory;
import org.eclipse.jdt.internal.compiler.problem.ProblemReporter;

import stx.libjava.tools.ast.Utils;
import stx.libjava.tools.environment.Resolver;


@stx.libjava.annotation.Package("stx:libjava/tools")
public class Parser extends org.eclipse.jdt.internal.compiler.parser.Parser {
    
    /**
     * Returns default compiler options to use
     * 
     * @return default compiler options. 
     */
    public static CompilerOptions defaultCompilerOptions() {
        CompilerOptions options = new CompilerOptions();
        String spec = System.getProperty("java.specification.version");
        long level = ClassFileConstants.JDK1_6;
        if (spec.equals("1.7")) {
            level = ClassFileConstants.JDK1_7;
        }            
        options.complianceLevel = level;
        options.originalComplianceLevel = level;
        options.sourceLevel = level;
        options.originalComplianceLevel = level;        
        return options;
    }
    
    public static DefaultProblemFactory defaultProblemFactory() {
        return new DefaultProblemFactory();
    }
    
    
    
    
    public Parser() {
        this(
                new ProblemReporter(
                        DefaultErrorHandlingPolicies.proceedWithAllProblems(), 
                        defaultCompilerOptions(), 
                        defaultProblemFactory()),
                true);                
    }
    

    public Parser(ProblemReporter problemReporter,
            boolean optimizeStringLiterals) {
        super(problemReporter, optimizeStringLiterals);
        options.docCommentSupport = true;
        javadocParser.checkDocComment = true;
    }
    
    public CompilationUnitDeclaration parse(ICompilationUnit cu, boolean diet, boolean resolve) {
        CompilationUnitDeclaration cud;
        if (diet) {
            cud = dietParse(cu, new CompilationResult(cu, 1, 1, 1000));
        } else {
            cud = parse(cu, new CompilationResult(cu, 1, 1, 1000 ));            
        }
        if (resolve) {            
            Resolver resolver = new Resolver(problemReporter);
            resolver.resolve(cud);
        }
        return cud;
    }

    public CompilationUnitDeclaration parse(ICompilationUnit cu, boolean diet) {
        return parse(cu, diet, false);
    }
    
    public ASTNode[] parseClassBodyDeclarations(char[] source, CompilationUnitDeclaration unit, TypeDeclaration type, boolean resolve) {        
        ASTNode[] nodes = this.parseClassBodyDeclarations(source, 0, source.length, unit);
        if (resolve) {
            for (int i = 0; i < nodes.length; i++) {
                ASTNode n = nodes[i];
                if (n instanceof TypeDeclaration) {
                    Utils.addOrReplaceType(type, (TypeDeclaration)n);
                } else if (n instanceof AbstractMethodDeclaration) {
                    Utils.addOrReplaceMethod(type, (AbstractMethodDeclaration)n);
                } else if (n instanceof FieldDeclaration) {
                    Utils.addOrReplaceField(type, (FieldDeclaration)n);
                }
            }
            unit.types[0] = type;                                          
            Resolver resolver = new Resolver(problemReporter);
            resolver.resolve(unit);
        }
        return nodes;
    }
    
        

}

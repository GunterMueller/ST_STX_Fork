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
package stx.libjava.tools.environment;

import org.eclipse.jdt.internal.compiler.DefaultErrorHandlingPolicies;
import org.eclipse.jdt.internal.compiler.ast.CompilationUnitDeclaration;
import org.eclipse.jdt.internal.compiler.ast.TypeDeclaration;
import org.eclipse.jdt.internal.compiler.env.AccessRestriction;
import org.eclipse.jdt.internal.compiler.env.IBinaryType;
import org.eclipse.jdt.internal.compiler.env.ICompilationUnit;
import org.eclipse.jdt.internal.compiler.env.ISourceType;
import org.eclipse.jdt.internal.compiler.impl.CompilerOptions;
import org.eclipse.jdt.internal.compiler.impl.ITypeRequestor;
import org.eclipse.jdt.internal.compiler.lookup.LookupEnvironment;
import org.eclipse.jdt.internal.compiler.lookup.PackageBinding;
import org.eclipse.jdt.internal.compiler.problem.DefaultProblemFactory;
import org.eclipse.jdt.internal.compiler.problem.ProblemReporter;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class Resolver implements ITypeRequestor {
    ProblemReporter reporter;
    LookupEnvironment environment;

    public Resolver() {
        this(new ProblemReporter(
                DefaultErrorHandlingPolicies.proceedWithAllProblems(), 
                new CompilerOptions(), 
                new DefaultProblemFactory()));
    }
    
    public Resolver(ProblemReporter reporter) {
        this.reporter = reporter;
        environment = new LookupEnvironment(this, reporter.options, reporter, new ReflectiveEnvironment());
    }
       
    public void resolve(CompilationUnitDeclaration cud) {        
        environment.buildTypeBindings(cud, null);
        environment.completeTypeBindings(cud, true);        
        this.completeTypeBindings2(cud);
        cud.resolve();
        cud.analyseCode();
    }
    
    protected void completeTypeBindings2(CompilationUnitDeclaration cud) {
        if (cud.types != null) {
            for (int i = 0; i < cud.types.length; i++) {
                this.completeTypeBindings2(cud.types[i]);
            }
        }
    }
    
    protected void completeTypeBindings2(TypeDeclaration td) {
        if (td.memberTypes != null) {
            for (int i = 0; i < td.memberTypes.length; i++) {
                this.completeTypeBindings2(td.memberTypes[i]);
            }
        }
        td.binding.methods();
        td.binding.fields();
        /*
        if (td.methods != null) {
            for (int i = 0; i < td.methods.length; i++) {
                td.methods[i].resolveStatements();
            }         
        }
        */
    }

    @Override
    public void accept(IBinaryType binaryType,
            PackageBinding packageBinding,
            AccessRestriction accessRestriction) {
        environment.createBinaryTypeFrom(binaryType, packageBinding, accessRestriction);        
    }

    @Override
    public void accept(ICompilationUnit unit,
            AccessRestriction accessRestriction) {
    }

    @Override
    public void accept(ISourceType[] sourceType,
            PackageBinding packageBinding,
            AccessRestriction accessRestriction) {
        // TODO Auto-generated method stub
        
    }

}

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
package stx.libjava.groovy;

import java.security.AccessController;
import java.security.PrivilegedAction;

import org.codehaus.groovy.control.CompilationUnit;
import org.codehaus.groovy.control.SourceUnit;

@stx.libjava.annotation.Package("stx:libjava")
public class GroovyClassLoader extends groovy.lang.GroovyClassLoader {

    protected ClassCollector createCollector(CompilationUnit unit, SourceUnit su) {
        InnerLoader loader = AccessController.doPrivileged(new PrivilegedAction<InnerLoader>() {
            public InnerLoader run() {
                return new InnerLoader(GroovyClassLoader.this);
            }
        });
        return new SystemClassCollector(loader, unit, su);
    }
	
	public static class SystemClassCollector extends groovy.lang.GroovyClassLoader.ClassCollector  {
		
		protected SystemClassCollector(InnerLoader cl, CompilationUnit unit, SourceUnit su) {
			super(cl, unit, su);
		}
		
		public native GroovyClassLoader getDefiningClassLoader();
				
	}	
}

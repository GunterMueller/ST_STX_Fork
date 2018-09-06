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
package stx.libjava.tools.text.tests;

import static org.junit.Assert.*;

import java.util.ArrayList;

import org.eclipse.jdt.internal.compiler.ast.ASTNode;
import org.junit.Test;
import org.junit.Before;

import stx.libjava.tools.Source;
import stx.libjava.tools.text.Highlighter;
import stx.libjava.tools.text.Indexer;
import stx.libjava.tools.text.Marker;

@stx.libjava.annotation.Package("stx:libjava/tools")
public class HighlighterTests {
        
    protected static class MarkerEntry {        
        public int kind;
        public int from;
        public int to;
        
        public MarkerEntry(int kind, int from, int to) {
            this.kind = kind;
            this.from = from;
            this.to = to;
        }
    }
    
    protected static class IndexEntry {
        public ASTNode node;
        public int from;
        public int to;
        
        public IndexEntry(ASTNode node, int from, int to) {
            this.node = node;
            this.from = from;
            this.to = to;
        }

    }
    
    protected ArrayList<MarkerEntry> markerLog;
    protected ArrayList<IndexEntry> indexLog;
    
        
    protected void parse(String code) {
        Highlighter h = new Highlighter();
        h.setMarker(new Marker() {
           public void mark(int kind, int from, int to) {
               markerLog.add(new MarkerEntry(kind, from,to));
           }
        });
        h.setIndexer(new Indexer() {
            public void index(ASTNode node, int from, int to) {
                indexLog.add(new IndexEntry(node, from,to));
            }
        });
        h.parse(new Source(code), false);
    }
    
    
    @Before
    public void setup() {
        markerLog = new ArrayList<MarkerEntry>();
        indexLog = new ArrayList<IndexEntry>();
    }

    @Test
    public void test_01() {
        parse("public class X { public void foo() { bar().baz(); } }");
        
        assertEquals(2, indexLog.size());
    }

}

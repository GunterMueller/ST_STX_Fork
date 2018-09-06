package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

import sun.misc.DoubleConsts;


/*
 * Test for (B/I/L)AND and (B/I/L)LOR 
 */

@stx.libjava.annotation.Package("stx:libjava/tests")
public class XAND_and_XOR {

    @Test
    public void test_LAND_01() {
        long l;
        
        l =-9223372036854775808L & 0L;
        assertTrue(l == 0L);

               
        l =-9223372036854775808L & DoubleConsts.SIGN_BIT_MASK;
        assertTrue(l != 0L);             
    }
    
    @Test
    public void test_LOR_01() {
        long l;
                       
        l =-9223372036854775808L | 1L;
        assertTrue(l == -9223372036854775807L);
    }
    
    @Test
    public void test_rawCopySign_01() {
        long magnitude = Double.doubleToRawLongBits(-0.0d);
        long sign =      Double.doubleToRawLongBits(-1.0d);        
        long l1, l2, l3, l4;
        
        l1 = sign & DoubleConsts.SIGN_BIT_MASK; 
        
        l2 = DoubleConsts.EXP_BIT_MASK | DoubleConsts.SIGNIF_BIT_MASK;
        
        l3 = magnitude & l2;
        
        l4 = l1 | l3;
        
        assertTrue(l1 == -9223372036854775808L);
        assertTrue(l2 == 9223372036854775807L);
        assertTrue(l3 == 0L);
        assertTrue(l4 == -9223372036854775808L);               
    }

    @Test
    public void test_rawCopySign_02() {
        long magnitude = Double.doubleToRawLongBits(-1.0d);
        long sign =      Double.doubleToRawLongBits(-0.0d);        
        long l1, l2, l3, l4;
        
        l1 = sign & DoubleConsts.SIGN_BIT_MASK; 
        
        l2 = DoubleConsts.EXP_BIT_MASK | DoubleConsts.SIGNIF_BIT_MASK;
        
        l3 = magnitude & l2;
        
        l4 = l1 | l3;
        
        assertTrue(l1 == -9223372036854775808L);
        assertTrue(l2 == 9223372036854775807L);
        assertTrue(l3 == 4607182418800017408L);
        assertTrue(l4 == -4616189618054758400L);               
    }
    
    @Test
    public void test_rawCopySign_03() {
        long magnitude = Double.doubleToRawLongBits( 1.0d);
        long sign =      Double.doubleToRawLongBits(-0.0d);        
        long l1, l2, l3, l4;
        
        l1 = sign & DoubleConsts.SIGN_BIT_MASK; 
        
        l2 = DoubleConsts.EXP_BIT_MASK | DoubleConsts.SIGNIF_BIT_MASK;
        
        l3 = magnitude & l2;
        
        l4 = l1 | l3;
        
        assertTrue(l1 == -9223372036854775808L);
        assertTrue(l2 == 9223372036854775807L);
        assertTrue(l3 == 4607182418800017408L);
        assertTrue(l4 == -4616189618054758400L);               
    }
    

}

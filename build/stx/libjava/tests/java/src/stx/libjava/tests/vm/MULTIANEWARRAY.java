package stx.libjava.tests.vm;

import static org.junit.Assert.*;

import org.junit.Test;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class MULTIANEWARRAY {
    
    // ===================== byte =================================

    @Test
    public void test_byte_01a() {
        byte[][] array2 = new byte[9][8];
        assertTrue(array2.length == 9);
        assertTrue(array2[0].length == 8);

        byte[][][] array3 = new byte[9][8][7];
        assertTrue(array3.length == 9);
        assertTrue(array3[8].length == 8);
        assertTrue(array3[8][0].length == 7);

        byte[][][][] array4 = new byte[9][8][7][6];
        assertTrue(array4.length == 9);
        assertTrue(array4[7].length == 8);
        assertTrue(array4[7][6].length == 7);
        assertTrue(array4[7][6][5].length == 6);

        byte[][][][][] array5 = new byte[9][8][7][6][5];
        assertTrue(array5.length == 9);
        assertTrue(array5[7].length == 8);
        assertTrue(array5[7][6].length == 7);
        assertTrue(array5[7][6][5].length == 6);
        assertTrue(array5[7][6][5][4].length == 5);

        byte[][][][][][] array6 = new byte[9][8][7][6][5][4];
        assertTrue(array6.length == 9);
        assertTrue(array6[7].length == 8);
        assertTrue(array6[7][6].length == 7);
        assertTrue(array6[7][6][0].length == 6);
        assertTrue(array6[7][6][5][4].length == 5);
        assertTrue(array6[7][6][5][4][0].length == 4);

        byte[][][][][][][] array7 = new byte[9][8][7][6][5][4][3];
        assertTrue(array7.length == 9);
        assertTrue(array7[7].length == 8);
        assertTrue(array7[7][6].length == 7);
        assertTrue(array7[7][6][5].length == 6);
        assertTrue(array7[7][6][5][4].length == 5);
        assertTrue(array7[7][6][5][4][3].length == 4);
        assertTrue(array7[7][6][5][4][3][2].length == 3);
        
        byte[][][][][][][][] array8 = new byte[9][8][7][6][5][4][3][2];
        assertTrue(array8.length == 9);
        assertTrue(array8[0].length == 8);
        assertTrue(array8[0][0].length == 7);
        assertTrue(array8[0][0][0].length == 6);
        assertTrue(array8[0][0][0][0].length == 5);
        assertTrue(array8[0][0][0][0][0].length == 4);
        assertTrue(array8[0][0][0][0][0][0].length == 3);
        assertTrue(array8[0][0][0][0][0][0][0].length == 2);
               
        byte[][][][][][][][][] array9 = new byte[9][8][7][6][5][4][3][2][1];
        assertTrue(array9.length == 9);
        assertTrue(array9[0].length == 8);
        assertTrue(array9[0][0].length == 7);
        assertTrue(array9[0][0][0].length == 6);
        assertTrue(array9[0][0][0][0].length == 5);
        assertTrue(array9[0][0][0][0][0].length == 4);
        assertTrue(array9[0][0][0][0][0][0].length == 3);
        assertTrue(array9[0][0][0][0][0][0][0].length == 2);
        assertTrue(array9[0][0][0][0][0][0][0][0].length == 1);        
    }
    
    @Test
    public void test_byte_01b() {
        test_byte_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_byte_02a() {
        try {
            byte[][][][][] array5 = new byte[9][8][-1][6][5];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }
        
        try {
            byte[][][][][][][][][][] array10 = new byte[9][8][7][6][5][9][8][7][6][-1];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }             
        
    }
    
    @Test
    public void test_byte_02b() {
        test_byte_02a();
    }
    
    // ============= short ===========================
    @Test
    public void test_short_01a() {
        short[][] array2 = new short[9][8];
        assertTrue(array2.length == 9);
        assertTrue(array2[0].length == 8);

        short[][][] array3 = new short[9][8][7];
        assertTrue(array3.length == 9);
        assertTrue(array3[0].length == 8);
        assertTrue(array3[0][0].length == 7);

        short[][][][] array4 = new short[9][8][7][6];
        assertTrue(array4.length == 9);
        assertTrue(array4[0].length == 8);
        assertTrue(array4[0][0].length == 7);
        assertTrue(array4[0][0][0].length == 6);

        short[][][][][] array5 = new short[9][8][7][6][5];
        assertTrue(array5.length == 9);
        assertTrue(array5[0].length == 8);
        assertTrue(array5[0][0].length == 7);
        assertTrue(array5[0][0][0].length == 6);
        assertTrue(array5[0][0][0][0].length == 5);

        short[][][][][][] array6 = new short[9][8][7][6][5][4];
        assertTrue(array6.length == 9);
        assertTrue(array6[0].length == 8);
        assertTrue(array6[0][0].length == 7);
        assertTrue(array6[0][0][0].length == 6);
        assertTrue(array6[0][0][0][0].length == 5);
        assertTrue(array6[0][0][0][0][0].length == 4);

        short[][][][][][][] array7 = new short[9][8][7][6][5][4][3];
        assertTrue(array7.length == 9);
        assertTrue(array7[0].length == 8);
        assertTrue(array7[0][0].length == 7);
        assertTrue(array7[0][0][0].length == 6);
        assertTrue(array7[0][0][0][0].length == 5);
        assertTrue(array7[0][0][0][0][0].length == 4);
        assertTrue(array7[0][0][0][0][0][0].length == 3);
        
        short[][][][][][][][] array8 = new short[9][8][7][6][5][4][3][2];
        assertTrue(array8.length == 9);
        assertTrue(array8[0].length == 8);
        assertTrue(array8[0][0].length == 7);
        assertTrue(array8[0][0][0].length == 6);
        assertTrue(array8[0][0][0][0].length == 5);
        assertTrue(array8[0][0][0][0][0].length == 4);
        assertTrue(array8[0][0][0][0][0][0].length == 3);
        assertTrue(array8[0][0][0][0][0][0][0].length == 2);
               
        short[][][][][][][][][] array9 = new short[9][8][7][6][5][4][3][2][1];
        assertTrue(array9.length == 9);
        assertTrue(array9[0].length == 8);
        assertTrue(array9[0][0].length == 7);
        assertTrue(array9[0][0][0].length == 6);
        assertTrue(array9[0][0][0][0].length == 5);
        assertTrue(array9[0][0][0][0][0].length == 4);
        assertTrue(array9[0][0][0][0][0][0].length == 3);
        assertTrue(array9[0][0][0][0][0][0][0].length == 2);
        assertTrue(array9[0][0][0][0][0][0][0][0].length == 1);        
    }
    
    @Test
    public void test_short_01b() {
        test_short_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_short_02a() {
        try {
            short[][][][][] array5 = new short[9][8][-1][6][5];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }
        
        try {
            short[][][][][][][][][][] array10 = new short[9][8][7][6][5][9][8][7][6][-1];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }             
        
    }
    
    @Test
    public void test_short_02b() {
        test_short_02a();
    }
    
    // ===================== int ==========================================

    @Test
    public void test_int_01a() {
        int[][] array2 = new int[9][8];
        assertTrue(array2.length == 9);
        assertTrue(array2[0].length == 8);

        int[][][] array3 = new int[9][8][7];
        assertTrue(array3.length == 9);
        assertTrue(array3[0].length == 8);
        assertTrue(array3[0][0].length == 7);

        int[][][][] array4 = new int[9][8][7][6];
        assertTrue(array4.length == 9);
        assertTrue(array4[0].length == 8);
        assertTrue(array4[0][0].length == 7);
        assertTrue(array4[0][0][0].length == 6);

        int[][][][][] array5 = new int[9][8][7][6][5];
        assertTrue(array5.length == 9);
        assertTrue(array5[0].length == 8);
        assertTrue(array5[0][0].length == 7);
        assertTrue(array5[0][0][0].length == 6);
        assertTrue(array5[0][0][0][0].length == 5);

        int[][][][][][] array6 = new int[9][8][7][6][5][4];
        assertTrue(array6.length == 9);
        assertTrue(array6[0].length == 8);
        assertTrue(array6[0][0].length == 7);
        assertTrue(array6[0][0][0].length == 6);
        assertTrue(array6[0][0][0][0].length == 5);
        assertTrue(array6[0][0][0][0][0].length == 4);

        int[][][][][][][] array7 = new int[9][8][7][6][5][4][3];
        assertTrue(array7.length == 9);
        assertTrue(array7[0].length == 8);
        assertTrue(array7[0][0].length == 7);
        assertTrue(array7[0][0][0].length == 6);
        assertTrue(array7[0][0][0][0].length == 5);
        assertTrue(array7[0][0][0][0][0].length == 4);
        assertTrue(array7[0][0][0][0][0][0].length == 3);
        
        int[][][][][][][][] array8 = new int[9][8][7][6][5][4][3][2];
        assertTrue(array8.length == 9);
        assertTrue(array8[0].length == 8);
        assertTrue(array8[0][0].length == 7);
        assertTrue(array8[0][0][0].length == 6);
        assertTrue(array8[0][0][0][0].length == 5);
        assertTrue(array8[0][0][0][0][0].length == 4);
        assertTrue(array8[0][0][0][0][0][0].length == 3);
        assertTrue(array8[0][0][0][0][0][0][0].length == 2);
               
        int[][][][][][][][][] array9 = new int[9][8][7][6][5][4][3][2][1];
        assertTrue(array9.length == 9);
        assertTrue(array9[0].length == 8);
        assertTrue(array9[0][0].length == 7);
        assertTrue(array9[0][0][0].length == 6);
        assertTrue(array9[0][0][0][0].length == 5);
        assertTrue(array9[0][0][0][0][0].length == 4);
        assertTrue(array9[0][0][0][0][0][0].length == 3);
        assertTrue(array9[0][0][0][0][0][0][0].length == 2);
        assertTrue(array9[0][0][0][0][0][0][0][0].length == 1);        
    }
    
    @Test
    public void test_int_01b() {
        test_int_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_int_02a() {
        try {
            int[][][][][] array5 = new int[9][8][-1][6][5];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }
        
        try {
            int[][][][][][][][][][] array10 = new int[9][8][7][6][5][9][8][7][6][-1];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }             
        
    }
    
    @Test
    public void test_int_02b() {
        test_int_02a();
    }

    // ===================== long =================================

    @Test
    public void test_long_01a() {
        long[][] array2 = new long[9][8];
        assertTrue(array2.length == 9);
        assertTrue(array2[0].length == 8);

        long[][][] array3 = new long[9][8][7];
        assertTrue(array3.length == 9);
        assertTrue(array3[0].length == 8);
        assertTrue(array3[0][0].length == 7);

        long[][][][] array4 = new long[9][8][7][6];
        assertTrue(array4.length == 9);
        assertTrue(array4[0].length == 8);
        assertTrue(array4[0][0].length == 7);
        assertTrue(array4[0][0][0].length == 6);

        long[][][][][] array5 = new long[9][8][7][6][5];
        assertTrue(array5.length == 9);
        assertTrue(array5[0].length == 8);
        assertTrue(array5[0][0].length == 7);
        assertTrue(array5[0][0][0].length == 6);
        assertTrue(array5[0][0][0][0].length == 5);

        long[][][][][][] array6 = new long[9][8][7][6][5][4];
        assertTrue(array6.length == 9);
        assertTrue(array6[0].length == 8);
        assertTrue(array6[0][0].length == 7);
        assertTrue(array6[0][0][0].length == 6);
        assertTrue(array6[0][0][0][0].length == 5);
        assertTrue(array6[0][0][0][0][0].length == 4);

        long[][][][][][][] array7 = new long[9][8][7][6][5][4][3];
        assertTrue(array7.length == 9);
        assertTrue(array7[0].length == 8);
        assertTrue(array7[0][0].length == 7);
        assertTrue(array7[0][0][0].length == 6);
        assertTrue(array7[0][0][0][0].length == 5);
        assertTrue(array7[0][0][0][0][0].length == 4);
        assertTrue(array7[0][0][0][0][0][0].length == 3);
        
        long[][][][][][][][] array8 = new long[9][8][7][6][5][4][3][2];
        assertTrue(array8.length == 9);
        assertTrue(array8[0].length == 8);
        assertTrue(array8[0][0].length == 7);
        assertTrue(array8[0][0][0].length == 6);
        assertTrue(array8[0][0][0][0].length == 5);
        assertTrue(array8[0][0][0][0][0].length == 4);
        assertTrue(array8[0][0][0][0][0][0].length == 3);
        assertTrue(array8[0][0][0][0][0][0][0].length == 2);
               
        long[][][][][][][][][] array9 = new long[9][8][7][6][5][4][3][2][1];
        assertTrue(array9.length == 9);
        assertTrue(array9[0].length == 8);
        assertTrue(array9[0][0].length == 7);
        assertTrue(array9[0][0][0].length == 6);
        assertTrue(array9[0][0][0][0].length == 5);
        assertTrue(array9[0][0][0][0][0].length == 4);
        assertTrue(array9[0][0][0][0][0][0].length == 3);
        assertTrue(array9[0][0][0][0][0][0][0].length == 2);
        assertTrue(array9[0][0][0][0][0][0][0][0].length == 1);        
    }
    
    @Test
    public void test_long_01b() {
        test_long_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_long_02a() {
        try {
            long[][][][][] array5 = new long[9][8][-1][6][5];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }
        
        try {
            long[][][][][][][][][][] array10 = new long[9][8][7][6][5][9][8][7][6][-1];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }             
        
    }
    
    @Test
    public void test_long_02b() {
        test_long_02a();
    }

    // ===================== float =================================

    @Test
    public void test_float_01a() {
        float[][] array2 = new float[9][8];
        assertTrue(array2.length == 9);
        assertTrue(array2[0].length == 8);

        float[][][] array3 = new float[9][8][7];
        assertTrue(array3.length == 9);
        assertTrue(array3[0].length == 8);
        assertTrue(array3[0][0].length == 7);

        float[][][][] array4 = new float[9][8][7][6];
        assertTrue(array4.length == 9);
        assertTrue(array4[0].length == 8);
        assertTrue(array4[0][0].length == 7);
        assertTrue(array4[0][0][0].length == 6);

        float[][][][][] array5 = new float[9][8][7][6][5];
        assertTrue(array5.length == 9);
        assertTrue(array5[0].length == 8);
        assertTrue(array5[0][0].length == 7);
        assertTrue(array5[0][0][0].length == 6);
        assertTrue(array5[0][0][0][0].length == 5);

        float[][][][][][] array6 = new float[9][8][7][6][5][4];
        assertTrue(array6.length == 9);
        assertTrue(array6[0].length == 8);
        assertTrue(array6[0][0].length == 7);
        assertTrue(array6[0][0][0].length == 6);
        assertTrue(array6[0][0][0][0].length == 5);
        assertTrue(array6[0][0][0][0][0].length == 4);

        float[][][][][][][] array7 = new float[9][8][7][6][5][4][3];
        assertTrue(array7.length == 9);
        assertTrue(array7[0].length == 8);
        assertTrue(array7[0][0].length == 7);
        assertTrue(array7[0][0][0].length == 6);
        assertTrue(array7[0][0][0][0].length == 5);
        assertTrue(array7[0][0][0][0][0].length == 4);
        assertTrue(array7[0][0][0][0][0][0].length == 3);
        
        float[][][][][][][][] array8 = new float[9][8][7][6][5][4][3][2];
        assertTrue(array8.length == 9);
        assertTrue(array8[0].length == 8);
        assertTrue(array8[0][0].length == 7);
        assertTrue(array8[0][0][0].length == 6);
        assertTrue(array8[0][0][0][0].length == 5);
        assertTrue(array8[0][0][0][0][0].length == 4);
        assertTrue(array8[0][0][0][0][0][0].length == 3);
        assertTrue(array8[0][0][0][0][0][0][0].length == 2);
               
        float[][][][][][][][][] array9 = new float[9][8][7][6][5][4][3][2][1];
        assertTrue(array9.length == 9);
        assertTrue(array9[0].length == 8);
        assertTrue(array9[0][0].length == 7);
        assertTrue(array9[0][0][0].length == 6);
        assertTrue(array9[0][0][0][0].length == 5);
        assertTrue(array9[0][0][0][0][0].length == 4);
        assertTrue(array9[0][0][0][0][0][0].length == 3);
        assertTrue(array9[0][0][0][0][0][0][0].length == 2);
        assertTrue(array9[0][0][0][0][0][0][0][0].length == 1);        
    }
    
    @Test
    public void test_float_01b() {
        test_float_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_float_02a() {
        try {
            float[][][][][] array5 = new float[9][8][-1][6][5];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }
        
        try {
            float[][][][][][][][][][] array10 = new float[9][8][7][6][5][9][8][7][6][-1];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }             
        
    }
    
    @Test
    public void test_float_02b() {
        test_float_02a();
    }

    // ===================== double =================================

    @Test
    public void test_double_01a() {
        double[][] array2 = new double[9][8];
        assertTrue(array2.length == 9);
        assertTrue(array2[0].length == 8);

        double[][][] array3 = new double[9][8][7];
        assertTrue(array3.length == 9);
        assertTrue(array3[0].length == 8);
        assertTrue(array3[0][0].length == 7);

        double[][][][] array4 = new double[9][8][7][6];
        assertTrue(array4.length == 9);
        assertTrue(array4[0].length == 8);
        assertTrue(array4[0][0].length == 7);
        assertTrue(array4[0][0][0].length == 6);

        double[][][][][] array5 = new double[9][8][7][6][5];
        assertTrue(array5.length == 9);
        assertTrue(array5[0].length == 8);
        assertTrue(array5[0][0].length == 7);
        assertTrue(array5[0][0][0].length == 6);
        assertTrue(array5[0][0][0][0].length == 5);

        double[][][][][][] array6 = new double[9][8][7][6][5][4];
        assertTrue(array6.length == 9);
        assertTrue(array6[0].length == 8);
        assertTrue(array6[0][0].length == 7);
        assertTrue(array6[0][0][0].length == 6);
        assertTrue(array6[0][0][0][0].length == 5);
        assertTrue(array6[0][0][0][0][0].length == 4);

        double[][][][][][][] array7 = new double[9][8][7][6][5][4][3];
        assertTrue(array7.length == 9);
        assertTrue(array7[0].length == 8);
        assertTrue(array7[0][0].length == 7);
        assertTrue(array7[0][0][0].length == 6);
        assertTrue(array7[0][0][0][0].length == 5);
        assertTrue(array7[0][0][0][0][0].length == 4);
        assertTrue(array7[0][0][0][0][0][0].length == 3);
        
        double[][][][][][][][] array8 = new double[9][8][7][6][5][4][3][2];
        assertTrue(array8.length == 9);
        assertTrue(array8[0].length == 8);
        assertTrue(array8[0][0].length == 7);
        assertTrue(array8[0][0][0].length == 6);
        assertTrue(array8[0][0][0][0].length == 5);
        assertTrue(array8[0][0][0][0][0].length == 4);
        assertTrue(array8[0][0][0][0][0][0].length == 3);
        assertTrue(array8[0][0][0][0][0][0][0].length == 2);
               
        double[][][][][][][][][] array9 = new double[9][8][7][6][5][4][3][2][1];
        assertTrue(array9.length == 9);
        assertTrue(array9[0].length == 8);
        assertTrue(array9[0][0].length == 7);
        assertTrue(array9[0][0][0].length == 6);
        assertTrue(array9[0][0][0][0].length == 5);
        assertTrue(array9[0][0][0][0][0].length == 4);
        assertTrue(array9[0][0][0][0][0][0].length == 3);
        assertTrue(array9[0][0][0][0][0][0][0].length == 2);
        assertTrue(array9[0][0][0][0][0][0][0][0].length == 1);        
    }
    
    @Test
    public void test_double_01b() {
        test_double_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_double_02a() {
        try {
            double[][][][][] array5 = new double[9][8][-1][6][5];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }
        
        try {
            double[][][][][][][][][][] array10 = new double[9][8][7][6][5][9][8][7][6][-1];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }             
        
    }
    
    @Test
    public void test_double_02b() {
        test_double_02a();
    }

    // ===================== boolean =================================

    @Test
    public void test_boolean_01a() {
        boolean[][] array2 = new boolean[9][8];
        assertTrue(array2.length == 9);
        assertTrue(array2[0].length == 8);

        boolean[][][] array3 = new boolean[9][8][7];
        assertTrue(array3.length == 9);
        assertTrue(array3[0].length == 8);
        assertTrue(array3[0][0].length == 7);

        boolean[][][][] array4 = new boolean[9][8][7][6];
        assertTrue(array4.length == 9);
        assertTrue(array4[0].length == 8);
        assertTrue(array4[0][0].length == 7);
        assertTrue(array4[0][0][0].length == 6);

        boolean[][][][][] array5 = new boolean[9][8][7][6][5];
        assertTrue(array5.length == 9);
        assertTrue(array5[0].length == 8);
        assertTrue(array5[0][0].length == 7);
        assertTrue(array5[0][0][0].length == 6);
        assertTrue(array5[0][0][0][0].length == 5);

        boolean[][][][][][] array6 = new boolean[9][8][7][6][5][4];
        assertTrue(array6.length == 9);
        assertTrue(array6[0].length == 8);
        assertTrue(array6[0][0].length == 7);
        assertTrue(array6[0][0][0].length == 6);
        assertTrue(array6[0][0][0][0].length == 5);
        assertTrue(array6[0][0][0][0][0].length == 4);

        boolean[][][][][][][] array7 = new boolean[9][8][7][6][5][4][3];
        assertTrue(array7.length == 9);
        assertTrue(array7[0].length == 8);
        assertTrue(array7[0][0].length == 7);
        assertTrue(array7[0][0][0].length == 6);
        assertTrue(array7[0][0][0][0].length == 5);
        assertTrue(array7[0][0][0][0][0].length == 4);
        assertTrue(array7[0][0][0][0][0][0].length == 3);
        
        boolean[][][][][][][][] array8 = new boolean[9][8][7][6][5][4][3][2];
        assertTrue(array8.length == 9);
        assertTrue(array8[0].length == 8);
        assertTrue(array8[0][0].length == 7);
        assertTrue(array8[0][0][0].length == 6);
        assertTrue(array8[0][0][0][0].length == 5);
        assertTrue(array8[0][0][0][0][0].length == 4);
        assertTrue(array8[0][0][0][0][0][0].length == 3);
        assertTrue(array8[0][0][0][0][0][0][0].length == 2);
               
        boolean[][][][][][][][][] array9 = new boolean[9][8][7][6][5][4][3][2][1];
        assertTrue(array9.length == 9);
        assertTrue(array9[0].length == 8);
        assertTrue(array9[0][0].length == 7);
        assertTrue(array9[0][0][0].length == 6);
        assertTrue(array9[0][0][0][0].length == 5);
        assertTrue(array9[0][0][0][0][0].length == 4);
        assertTrue(array9[0][0][0][0][0][0].length == 3);
        assertTrue(array9[0][0][0][0][0][0][0].length == 2);
        assertTrue(array9[0][0][0][0][0][0][0][0].length == 1);        
    }
    
    @Test
    public void test_boolean_01b() {
        test_boolean_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_boolean_02a() {
        try {
            boolean[][][][][] array5 = new boolean[9][8][-1][6][5];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }
        
        try {
            boolean[][][][][][][][][][] array10 = new boolean[9][8][7][6][5][9][8][7][6][-1];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }             
        
    }
    
    @Test
    public void test_boolean_02b() {
        test_boolean_02a();
    }

    // ===================== char =================================

    @Test
    public void test_char_01a() {
        char[][] array2 = new char[9][8];
        assertTrue(array2.length == 9);
        assertTrue(array2[0].length == 8);

        char[][][] array3 = new char[9][8][7];
        assertTrue(array3.length == 9);
        assertTrue(array3[0].length == 8);
        assertTrue(array3[0][0].length == 7);

        char[][][][] array4 = new char[9][8][7][6];
        assertTrue(array4.length == 9);
        assertTrue(array4[0].length == 8);
        assertTrue(array4[0][0].length == 7);
        assertTrue(array4[0][0][0].length == 6);

        char[][][][][] array5 = new char[9][8][7][6][5];
        assertTrue(array5.length == 9);
        assertTrue(array5[0].length == 8);
        assertTrue(array5[0][0].length == 7);
        assertTrue(array5[0][0][0].length == 6);
        assertTrue(array5[0][0][0][0].length == 5);

        char[][][][][][] array6 = new char[9][8][7][6][5][4];
        assertTrue(array6.length == 9);
        assertTrue(array6[0].length == 8);
        assertTrue(array6[0][0].length == 7);
        assertTrue(array6[0][0][0].length == 6);
        assertTrue(array6[0][0][0][0].length == 5);
        assertTrue(array6[0][0][0][0][0].length == 4);

        char[][][][][][][] array7 = new char[9][8][7][6][5][4][3];
        assertTrue(array7.length == 9);
        assertTrue(array7[0].length == 8);
        assertTrue(array7[0][0].length == 7);
        assertTrue(array7[0][0][0].length == 6);
        assertTrue(array7[0][0][0][0].length == 5);
        assertTrue(array7[0][0][0][0][0].length == 4);
        assertTrue(array7[0][0][0][0][0][0].length == 3);
        
        char[][][][][][][][] array8 = new char[9][8][7][6][5][4][3][2];
        assertTrue(array8.length == 9);
        assertTrue(array8[0].length == 8);
        assertTrue(array8[0][0].length == 7);
        assertTrue(array8[0][0][0].length == 6);
        assertTrue(array8[0][0][0][0].length == 5);
        assertTrue(array8[0][0][0][0][0].length == 4);
        assertTrue(array8[0][0][0][0][0][0].length == 3);
        assertTrue(array8[0][0][0][0][0][0][0].length == 2);
               
        char[][][][][][][][][] array9 = new char[9][8][7][6][5][4][3][2][1];
        assertTrue(array9.length == 9);
        assertTrue(array9[0].length == 8);
        assertTrue(array9[0][0].length == 7);
        assertTrue(array9[0][0][0].length == 6);
        assertTrue(array9[0][0][0][0].length == 5);
        assertTrue(array9[0][0][0][0][0].length == 4);
        assertTrue(array9[0][0][0][0][0][0].length == 3);
        assertTrue(array9[0][0][0][0][0][0][0].length == 2);
        assertTrue(array9[0][0][0][0][0][0][0][0].length == 1);        
    }
    
    @Test
    public void test_char_01b() {
        test_char_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_char_02a() {
        try {
            char[][][][][] array5 = new char[9][8][-1][6][5];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }
        
        try {
            char[][][][][][][][][][] array10 = new char[9][8][7][6][5][9][8][7][6][-1];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }             
        
    }
    
    @Test
    public void test_char_02b() {
        test_char_02a();
    }
    
    
    // ====================== Object =================================

    @Test
    public void test_01a() {
        ArrayElement[][] array2 = new ArrayElement[9][8];
        assertTrue(array2.length == 9);
        assertTrue(array2[0].length == 8);

        ArrayElement[][][] array3 = new ArrayElement[9][8][7];
        assertTrue(array3.length == 9);
        assertTrue(array3[0].length == 8);
        assertTrue(array3[0][0].length == 7);

        ArrayElement[][][][] array4 = new ArrayElement[9][8][7][6];
        assertTrue(array4.length == 9);
        assertTrue(array4[0].length == 8);
        assertTrue(array4[0][0].length == 7);
        assertTrue(array4[0][0][0].length == 6);

        ArrayElement[][][][][] array5 = new ArrayElement[9][8][7][6][5];
        assertTrue(array5.length == 9);
        assertTrue(array5[0].length == 8);
        assertTrue(array5[0][0].length == 7);
        assertTrue(array5[0][0][0].length == 6);
        assertTrue(array5[0][0][0][0].length == 5);

        ArrayElement[][][][][][] array6 = new ArrayElement[9][8][7][6][5][4];
        assertTrue(array6.length == 9);
        assertTrue(array6[0].length == 8);
        assertTrue(array6[0][0].length == 7);
        assertTrue(array6[0][0][0].length == 6);
        assertTrue(array6[0][0][0][0].length == 5);
        assertTrue(array6[0][0][0][0][0].length == 4);

        ArrayElement[][][][][][][] array7 = new ArrayElement[9][8][7][6][5][4][3];
        assertTrue(array7.length == 9);
        assertTrue(array7[0].length == 8);
        assertTrue(array7[0][0].length == 7);
        assertTrue(array7[0][0][0].length == 6);
        assertTrue(array7[0][0][0][0].length == 5);
        assertTrue(array7[0][0][0][0][0].length == 4);
        assertTrue(array7[0][0][0][0][0][0].length == 3);
        
        ArrayElement[][][][][][][][] array8 = new ArrayElement[9][8][7][6][5][4][3][2];
        assertTrue(array8.length == 9);
        assertTrue(array8[0].length == 8);
        assertTrue(array8[0][0].length == 7);
        assertTrue(array8[0][0][0].length == 6);
        assertTrue(array8[0][0][0][0].length == 5);
        assertTrue(array8[0][0][0][0][0].length == 4);
        assertTrue(array8[0][0][0][0][0][0].length == 3);
        assertTrue(array8[0][0][0][0][0][0][0].length == 2);
               
        ArrayElement[][][][][][][][][] array9 = new ArrayElement[9][8][7][6][5][4][3][2][1];
        assertTrue(array9.length == 9);
        assertTrue(array9[8].length == 8);
        assertTrue(array9[0][7].length == 7);
        assertTrue(array9[0][0][6].length == 6);
        assertTrue(array9[0][0][0][5].length == 5);
        assertTrue(array9[0][0][0][0][4].length == 4);
        assertTrue(array9[0][0][0][0][0][3].length == 3);
        assertTrue(array9[0][0][0][0][0][0][2].length == 2);
        assertTrue(array9[0][0][0][0][0][0][0][1].length == 1);        
    }
    
    @Test
    public void test_01b() {
        test_01a();
    }
    
    @Test
    @SuppressWarnings({"unused" })
    public void test_02a() {
        try {
            ArrayElement[][][][][] array5 = new ArrayElement[9][8][-1][6][5];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }
        
        try {
            ArrayElement[][][][][][][][][][] array10 = new ArrayElement[9][8][7][6][5][9][8][7][6][-1];
            assertTrue(false);
        } catch (NegativeArraySizeException nase) {
            assertTrue(true);
        }             
        
    }
    
    @Test
    public void test_02b() {
        test_02a();
    }

    
    public static class ArrayElement {
        public Object value;
    }

    // ========================== MISC ===========================
    
    @Test
    public void test_incomplete_01() {
        int grid[][][];
        grid = new int[10][5][];    
        
        assertTrue(grid.length == 10);
        assertTrue(grid[9].length == 5);
        assertTrue(grid[5][3] == null);
    }
    
    @Test
    public void test_incomplete_02() {
        int grid[][][][][][][][][];
        grid = new int[3][3][3][3][3][3][3][3][];    
        
        assertTrue(grid.length == 3);
        assertTrue(grid[0].length == 3);
        assertTrue(grid[0][1][2][2][1][0][1][2] == null);
    }
}

package stx.libjava.tests.mocks.interop;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class Object implements TooGeneralInterface
{
    public static final int ICONST1 = 1;
    public static final int ICONST_2 = 2;

    public static char CHR = 'C';
    public char        chr = '\0';

    public char[][] events = new char[100][];
    public int      eventsTally = 0;

    public Object()
    {
        events[eventsTally++] = "Default Constructor".toCharArray();
    }

    public Object(String s)
    {
        s.compareTo("XX"); // Just to invoke some String method...
        events[eventsTally++] = "String Constructor".toCharArray();
    }

    public Object(Integer i)
    {
        i.doubleValue(); // Just to invoke some Integer method
        events[eventsTally++] = "Integer Constructor".toCharArray();
    }
    
    public Object(stx.libjava.tests.mocks.interop.Object o)
    {
        events[eventsTally++] = "cz.cvut.fit.swing.methodLookup.Object".toCharArray();
    }

    public String sayHello()
    {
        return "hello";
    }

    public static String staticSayHello()
    {
        return "static hello";
    }

    public String sayHello(String name)
    {
        return "hello " + name;
    }

    public String sayHello(Integer age)
    {
        return "hello in age [Integer] " + age;
    }

    public String sayHello(int age)
    {
        return "hello in age [int] " + age;
    }

    public String sayHello(String name, Integer age)
    {
        return "hello " + name + " in age [Integer]" + age;
    }

    public String sayHello(String name, int age)
    {
        return "hello " + name + " in age [int] " + age;
    }

    public String sayHello(int i, int age)
    {
        return "hello " + i + " in age [int] " + age;
    }

    public int returnAge(int i)
    {
        return i;
    }

    public int returnPrimTypeInt()
    {
        return 2048;
    }

    // no param foo
    public int foo()
    {
        return 0;
    }

    public int foo(int i)
    {
        return 1;
    }

    public int foo(Object o, int i)
    {
        return 2;
    }
    
    public Boolean getTrue()
    {
        return Boolean.TRUE;
    }
    public Boolean getFalse()
    {
        return Boolean.FALSE;
    }
    
    public boolean getTruePrim()
    {
        return true;
    }
    
    public boolean getFalsePrim()
    {
        return false;
    }
    
    public Boolean getFalseWithConversion()
    {
        return false;
    }

    public Boolean getTrueWithConversion()
    {
        return true;
    }
    
    public Boolean getFalseFromBooleanValueOf()
    {
        boolean b = getFalsePrim();
        return Boolean.valueOf(b);
    }
    
    
    public int getInt()
    {
        return 1;
    }
    
    public Integer getInteger()
    {
        return 12345;
    }
    
    public int overloadedMethodInt(int i) 
    {
        return 1;
    }
    
    public int overloadedMethodInt(Integer i)
    {
        return 2;
    }
    
    public int overloadedMethod(String s) 
    {
        return 3;
    }
    
    public int overloadedMethod(Integer i)
    {
        return 4;
    }

    @Override
    public java.lang.String getMethodReturningObject() {
        return "working";
    }
}

package stx.libjava.tests.mocks.interop;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class Person implements IPerson1, IPerson2
{
    private String name;
    private Integer age;
    
    public java.lang.Object tag1;
    protected java.lang.Object tag2;
    protected java.lang.Object tag3;
    
    public void setAge(Integer age)
    {
        this.age = age;
    }
    
    public void setName(String name)
    {
        this.name = name;
    }
    
    public String getName()
    {
        return name;
    }
    
    public Integer getAge()
    {
        return age;
    }
    
    public void setTag1(java.lang.Object o) {
        tag1 = o;
    }
    
    public java.lang.Object getTag1() {
        return tag1;
    }
}

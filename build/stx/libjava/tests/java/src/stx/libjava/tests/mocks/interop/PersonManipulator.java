package stx.libjava.tests.mocks.interop;

@stx.libjava.annotation.Package("stx:libjava/tests")
public class PersonManipulator
{
    public Integer getPersonAge(Person p)
    {
        return p.getAge();
    }
    
    public String getPersonName(Person p)
    {
        return p.getName();
    }
    
}

import java.util.List;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElements;


@stx.libjava.annotation.Package("stx:libjava/tests")
public class ClassWithNestedAnnotations {
	@XmlElements(@XmlElement(name = "Text", namespace = "http://www.w3.org/2003/05/soap-envelope"))
    private final List<Integer> field = null;
}

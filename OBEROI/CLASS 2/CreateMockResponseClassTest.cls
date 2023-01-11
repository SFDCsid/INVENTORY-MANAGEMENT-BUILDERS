@isTest
public class CreateMockResponseClassTest {
     @isTest static void testEchoString() {              
        // This causes a fake response to be generated
        Test.setMock(WebServiceMock.class, new CreateMockResponseClass());
        
        
    }

}
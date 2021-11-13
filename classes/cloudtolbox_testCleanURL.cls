@istest
public class Test_cleanURL {

    @testsetup
    public static void createDate() {
        CreateTestData.createData();
    }
    
    @istest
    public static void testURLs() {
        // test an email address
		cloudtoolbox_cleanURL emailAddress = new cloudtoolbox_cleanURL('skot@cloudtoolbox.io');
        
		// test a www and a trailing slash
		cloudtoolbox_cleanURL wwwAndSlash = new cloudtoolbox_cleanURL('http://www.cloudtoolbox.io/');
        
        // test a short url
		cloudtoolbox_cleanURL shortURL = new cloudtoolbox_cleanURL('a.b');

        // test a bad domain
		cloudtoolbox_cleanURL badDomain = new cloudtoolbox_cleanURL('cloudtoolbox.b');
        
        // test a URL without a period
		cloudtoolbox_cleanURL noPeriod = new cloudtoolbox_cleanURL('cloudtoolboxcom');
        
        // test consecutive periods
		cloudtoolbox_cleanURL twoPeriods = new cloudtoolbox_cleanURL('amazon..com');
        
    }
    
}
global class cloudtoolbox_cleanURL {

// Pass this an email address and you get a domain
// Pass it any other form of valid url and we strip the prefix
// foo@fighters.com --> fighters.como
// ftp://www.foofighters.com/ --> foofighters.com
// https://macintouch.com --> macintouch.com
// This is a controller so call it as a method
// Axiom_cleanURL foo = new Axiom_cleanURL('bilbo@penguin.com')
// foo.newURL will equal penguin.com

// Too call
// cloudtoolbox_cleanURL foo = new cloudtoolbox_cleanURL('http://fooo.com');
// website = foo.newURL;

// To use in a Before Insert or Before Update lead trigger
// this will clean the website if it has one, and if not it will populate the website
// based on email
//                if(l.Website != null) {
//                    cloudtoolbox_cleanURL foo = new cloudtoolbox_cleanURL(l.Website);
//                    l.Website = foo.newURL;        
//                } else if (l.Website == null && l.Email != null) {
//                    cloudtoolbox_cleanURL foo = new cloudtoolbox_cleanURL(l.Website);
//                    l.Website = foo.newURL;        
//                }
// In an Account trigger
//            if(a.Website != null) { 
//                cloudtoolbox_cleanURL cleanAddress = new cloudtoolbox_cleanURL(a.Website);
//                a.Website = cleanAddress.newURL; 
//            }


    public String newURL{get; set;}
    
    public cloudtoolbox_cleanURL(String url){
            
        // Email or Web Address?
        if(url.contains('@') == true) {
            newURL = cleanWebAddress(getDomainFromEmail(url));
        } else {
            newURL = cleanWebAddress(url);
        }
    }
    
    public static string cleanWebAddress(String address) {
		System.Debug('It is an URL');

        // Strip any properly formed URL  prefix which will have to // in it
        if(address.indexOf('//') != -1) {
            System.Debug(address.length());
            System.Debug(address.indexOf('//'));
            address = address.right(address.length() - address.indexOf('//') - 2);
/*
            if(address.startsWith('http://') == true) {
            address = address.right(address.length() - 7 );
        } else if (address.startsWith('https://') == true) {
            address = address.right(address.length() - 8 );
        }
            */
        }   
        System.Debug(address);
        
        // Strip a www. prefix if it has one
        if(address.startsWith('www.') == true) {
            address = address.right(address.length() - 4);
        }
        System.Debug(address);
        
        // Strip a trailing slash becuase we hate trailing slashes
        if(address.right(1) == '/') { 
           address = address.left(address.length() - 1); 
           }
        System.Debug(address);
        
        if(invalidDomains(address.toLowerCase()) == true) {
            return address.toLowerCase();
        } else { 
            return null; 
        }
        
    }
    
    public static string getDomainFromEmail(String address) {
		System.Debug('It is an Email');
        address = address.right(address.length() - address.indexOf('@') - 1);
		System.Debug(address);  
        
        return address.toLowerCase();
            
    }
    
	// use this to check for invalid domains
	// It would be better to make this a custom setting so it can be easily edited
	// but I don't feel like doing that at 10pm on a Thursday
    public static boolean invalidDomains(String address) {

        Boolean valid = true;
        
        // Get all the Invalid Web Doamins from the Custom Metadata
        List<Invalid_Web_Domain__mdt> allInvalidWebDomains = new List<Invalid_Web_Domain__mdt>();
        	allInvalidWebDomains = [SELECT Id, Label FROM Invalid_Web_Domain__mdt];
        // Map those domains to a false value so we  can set our boolen
        Map<String, boolean> invalidWebDomains = new Map<String, boolean>();
        for(Invalid_Web_Domain__mdt www : allInvalidWebDomains) {
            invalidWebDomains.put(www.Label, false);
        }

        	// these things below aren't even domains. We don't allow them
        	invalidWebDomains.put('ebay', false);
        	invalidWebDomains.put('-', false);
        	invalidWebDomains.put('none', false);
        	invalidWebDomains.put('na', false);
        	invalidWebDomains.put('n/a', false);
        
        if (address.length() < 4) {
            // a domain name is 1 character minimum, a period and a top level domain of at least two characters
            // which is four a.uk is valid. a.u is not.
            // check for length first because . fools this thing
            valid = false;
            System.Debug('too short');
        } else if (address.contains('..') == true) {
			// if there are consecutive periods, it's not cool brosef
            valid = false;
            System.Debug('consecutive periods');
        } else if (address.contains('.') == false) {
			// if there is no period at all, it can't be a domain bro
            valid = false;
            System.Debug('no period');
        } else if(invalidWebDomains.containsKey(address.toLowerCase()) == true) {
            valid = invalidWebDomains.get(address.toLowerCase());
            System.Debug('on the list');
        }
        return valid;
    }
}
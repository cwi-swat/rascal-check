module tests::VerifyURIPatterns

import lang::java::m3::Core;
import lang::java::m3::AST;

import tests::RascalInformation;

public test bool verifyNoURICreateCalls() 
  = requireEmpty({ f | <f,t> <- getRascalM3()@methodInvocation, 
                   |java+method:///java/net/URI/create(java.lang.String)| == t,
			       /org.rascalmpl.uri.URIUtil/ !:= f.path }
			    , "illegal call to URI.create, should use URIUtil");

public test bool verifyNoURIConstructorCalls() 
  = requireEmpty({ f | <f,t> <- getRascalM3()@methodInvocation
               , t.scheme == "java+constructor", /^java.net.URI/ := t.path
		       , /org.rascalmpl.uri.URIUtil/ !:= f.path }
		       , "illegal call to URI constructor, should use URIUtil");

public test bool verifyNOURLEncoderUsed() 
  = requireEmpty({ f | <f,t> <- getRascalM3()@methodInvocation, /^java.net.URLEncoder/ := t.path}
                , "The URLEncoder should not be used, except for encoding values of the query part of an URL");

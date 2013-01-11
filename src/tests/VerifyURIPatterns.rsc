module tests::VerifyURIPatterns

import IO;
import Set;
import util::Resources;
import lang::java::jdt::Java;
import lang::java::jdt::JavaADT;
import lang::java::jdt::JDT;

import tests::RascalInformation;
import tests::UnitTestAdditions;

public test bool verifyNoURICreateCalls() {
	Resource dt = getRascalResources();
	uriCalls = { f | <f,t> <- dt@calls
		, entity([package("java"), package("net"), class("URI"), method("create", _, _)]) := t
		, entity([package("org"),package("rascalmpl"),package("uri"),class("URIUtil"), _*]) !:= f};
	return assertIsEmpty(uriCalls, "The following methods use URI.create but should use the correct org.rascalmpl.uri.URIUtil method");
}


public test bool verifyNoURIConstructorCalls() {
	Resource dt = getRascalResources();
	uriCalls = { f | <f,t> <- dt@calls
		, entity([package("java"), package("net"), class("URI"), constr(_)]) := t
		, entity([package("org"),package("rascalmpl"),package("uri"),class("URIUtil"),_*]) !:= f};
	return assertIsEmpty(uriCalls, "The following methods use new URI() but should use the correct org.rascalmpl.uri.URIUtil method");
}

public test bool verifyNOURLEncoderUsed() {
	Resource dt = getRascalResources();
	invalidUsage = { f | <f,t> <- dt@calls, entity([package("java"), package("net"), class("URLEncoder"),_*]) := t
		, entity([_*,class("NonRascalMenuContributionItem"),method("encodeLabel",_,_), _*]) !:= f
		, entity([_*,class("Resource"),method("uriEncode",_,_), _*]) !:= f
	};
	return assertIsEmpty(invalidUsage, "The URLEncoder should not be used, except for encoding values of the query part of an URL");
}

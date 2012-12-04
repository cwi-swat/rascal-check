module VerifyURIPatterns

import IO;
import Set;
import util::Resources;
import lang::java::jdt::Java;
import lang::java::jdt::JavaADT;
import lang::java::jdt::JDT;

import RascalInformation;

public void main() {
	println("Checking for incorrect URI usage");
	verifyNoURICreateCalls();
	verifyNoURIConstructorCalls();
}


public test bool verifyNoURICreateCalls() {
	Resource dt = getRascalResources();
	uriCalls = { f | <f,t> <- dt@calls
		, entity([package("java"), package("net"), class("URI"), method("create", _, _)]) := t
		, entity([package("org"),package("rascalmpl"),package("uri"),class("URIUtil"), _*]) !:= f};
	if (size(uriCalls) > 0 ) {
		println("The following methods use URI.create but should use the correct org.rascalmpl.uri.URIUtil method");
		for (c <- uriCalls) {
			println("\t" + readable(c));
		}
		return false;
	}
	return true;
}


public test bool verifyNoURIConstructorCalls() {
	Resource dt = getRascalResources();
	uriCalls = { f | <f,t> <- dt@calls
		, entity([package("java"), package("net"), class("URI"), constr(_)]) := t
		, entity([package("org"),package("rascalmpl"),package("uri"),class("URIUtil"),_*]) !:= f};
	if (size(uriCalls) > 0 ) {
		println("The following methods use new URI() but should use the correct org.rascalmpl.uri.URIUtil method");
		for (c <- uriCalls) {
			println("\t" + readable(c));
		}
		return false;
	}
	return true;
}
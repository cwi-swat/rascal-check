module tests::RascalInformation

import IO;
import ValueIO;
import util::Maybe;
import util::Resources;
import lang::java::jdt::Java;
import lang::java::jdt::JavaADT;
import lang::java::jdt::JDT;

private Maybe[Resource] resources = nothing();
private Maybe[set[AstNode]] adts = nothing();

public Resource getRascalResources() {
	if (resources == nothing()) {
		println("Getting rascal JDT information, this can take a while (plus quite some memory)");
		resources = just(unionFacts(extractProject(|project://rascal/|), extractProject(|project://rascal-eclipse|)));
	}
	return resources.val; 
}

public set[AstNode] getRascalAdts() {
	if (adts == nothing()) {
		println("Getting rascal AST information, this can take a while (plus quite some memory)");
		adts = just({createAstsFromProject(|project://rascal/|), createAstsFromProject(|project://rascal-eclipse|)});
	}
	return adts.val;
}
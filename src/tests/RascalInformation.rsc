module tests::RascalInformation

import IO;
import Set;
import ValueIO;
import String;
import util::Maybe;
import util::Resources;
import lang::java::jdt::Java;
import lang::java::jdt::JavaADT;
import lang::java::jdt::JDT;

private Maybe[Resource] resources = nothing();
private Maybe[set[AstNode]] adts = nothing();

public void resetRascalInformation() {
	resources = nothing();
	adts = nothing();
}

private bool isGeneratedFile(loc f)
	= startsWith(f.path, "/src/org/rascalmpl/library/lang/rascal/syntax")
	;

private set[Resource] getRascalFiles() {
	Resource rascal = getProject(|project://rascal/|);
	Resource eclipse = getProject(|project://rascal-eclipse/|);
	return { f | /f:file(fid) <- {rascal, eclipse}, fid.extension == "java", isOnBuildPath(fid), !isGeneratedFile(fid)};
}

public Resource getRascalResources() {
	if (resources == nothing()) {
		println("Getting rascal JDT information, this can take a while (plus quite some memory)");
		resources = just((getProject(|project://rascal/|) | unionFacts(it, extractClass(r.id, gatherASTs = false, fillASTBindings = false, fillOldStyleUsage = false)) | r <- getRascalFiles()));
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
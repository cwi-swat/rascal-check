module tests::RascalInformation

import IO;
import Set;
import ValueIO;
import String;
import util::Maybe;
import util::FileSystem;
import util::Monitor;
import List;

import analysis::m3::Core;
import analysis::m3::Registry;
import lang::java::m3::Core;
import lang::java::m3::AST;
import lang::java::m3::ClassPaths;
       
bool requireEmpty({}, str _) = true;

default bool requireEmpty(set[value] s, str message) {
  println("<for (e <- s) {><message>: <e>
          '<}>");
  return false;
}

bool init(loc workspace = |file:///ufs/daybuild/jenkins/workspace| /* on lille.sen.cwi.nl */) {
  cp          = getClassPath(workspace);
  sourcePaths = { p + "src" | p <- workspace.ls, isDirectory(p)};
  
  println("classpath: <cp>");
  println("sources  : <sourcePaths>");
  
  setEnvironmentOptions(cp, sourcePaths);
  return true; 
}

bool isGenerated(loc l)
  = /lang.rascal.syntax.*\.java/ := l.path;
  
bool isInteresting(loc l) 
  = (l.extension == "java" || l.extension == "rsc")
  && !isGenerated(l);

@memo
set[loc] getRascalFiles() = {*find(d, isInteresting) | d <- projects};

private bool done(loc f) {
  event("<f>");
  return true;
}

@memo
M3 getRascalM3() {
  init();
  fs =  [ f | sp <- { p + "src" | p <- projects}, loc f <- find(sp, "java") ];
  startJob("Analyzing Java files", size(fs));
  m3s = { createM3FromFile(f) | f <- fs, done(f) };
  result = composeJavaM3(|rascal:///|, m3s);
  registerProject(|rascal:///|, result);
  return result;
}
  
@memo
set[Declaration] getRascalAdts() 
  = { createAstFromFile(f, true) | init(), d <- projects, loc f <- find(d, "java"), bprintln(f) };


// Minigrace exports methods for compiling Grace files.

import "genc" as genc
import "genjs" as genjs
import "lexer" as lexer
import "parser" as parser

def Target = "c" | "js"

def BuildMode = "source" | "make" | "run"

method compile(path : String) withTarget(target : String) withModule(mod) mode(rm) build(bt){
    def tokens = lexer.new.lexfile(path)
    def ast = parser.new.parse(tokens)

    def size = path.size
    def strip = if(path.substringFrom(size - 5) to(size) == ".grace") then {
        path.substringFrom(1) to(size - 6)
    } else {
        path
    }

    def out = strip ++ ".{target}"

    match(target)
      case { "c" ->
        genc.new
    } case { "js" ->
        genjs.new
    }.compile(ast) asModule(strip) to(out) modName(mod) runMode(rm) buildType(bt) 
}

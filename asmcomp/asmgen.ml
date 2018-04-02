type error = Assembler_error of string

exception Error of error

let compile_unit _output_prefix asm_filename keep_asm
    obj_filename gen =
    ignore(_output_prefix);
    ignore(asm_filename);
    ignore(keep_asm);
    ignore(obj_filename);
    ignore(gen);
    ()

let report_error ppf err =
    ignore(ppf);
    ignore(err);
    ()

let compile_implementation_flambda ?toplevel prefixname
    ~required_globals ~backend ppf (program:Flambda.program) =
    ignore(toplevel);
    ignore(prefixname);
    ignore(required_globals);
    ignore(backend);
    ignore(ppf);
    ignore(program);
    ()

let compile_implementation_clambda ?toplevel prefixname
    ppf (program:Lambda.program) =
    ignore(toplevel);
    ignore(prefixname);
    ignore(ppf);
    ignore(program);
    ()

let compile_phrase ppf p = 
    ignore(ppf);
    ignore(p);
    ()
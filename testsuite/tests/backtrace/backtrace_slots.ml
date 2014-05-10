(***********************************************************************)
(*                                                                     *)
(*                                OCaml                                *)
(*                                                                     *)
(*            Xavier Leroy, projet Gallium, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 2008 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* A test for stack backtraces *)

let get_backtrace () =
  let raw_backtrace = Printexc.get_raw_backtrace () in
  let convert = Printexc.convert_raw_backtrace_slot in
  let backtrace = Array.map convert raw_backtrace in
  (* we'll play with slots a bit to check that hashing and comparison work:
     - create a hashtable that maps slots to their index in the raw backtrace
     - create a balanced set of all slots
  *)
  let table = Hashtbl.create 100 in
  Array.iteri (fun i slot -> Hashtbl.add table slot i) raw_backtrace;
  let module S = Set.Make(struct
    type t = Printexc.raw_backtrace_slot
    let compare = Pervasives.compare
  end) in
  let slots = Array.fold_right S.add raw_backtrace S.empty in
  Array.iteri (fun i slot ->
    assert (S.mem slot slots);
    assert (Hashtbl.mem table slot);
    let j =
      (* position in the table of the last slot equal to [slot] *)
      Hashtbl.find table slot in
    assert (slot = raw_backtrace.(j));
    assert (backtrace.(i) = backtrace.(j));
  ) raw_backtrace;
  backtrace

exception Error of string

let rec f msg n =
  if n = 0 then raise(Error msg) else 1 + f msg (n-1)

let g msg =
  try
    f msg 5
  with Error "a" -> print_string "a"; print_newline(); 0
     | Error "b" as exn -> print_string "b"; print_newline(); raise exn
     | Error "c" -> raise (Error "c")

let run args =
  try
    ignore (g args.(0)); print_string "No exception\n"
  with exn ->
    Printf.printf "Uncaught exception %s\n" (Printexc.to_string exn);
    get_backtrace () |> Array.iteri
        (fun i slot ->
          if slot <> Printexc.Unknown_location true then
            print_endline (Printexc.format_backtrace_slot i slot))

let _ =
  Printexc.record_backtrace true;
  run [| "a" |];
  run [| "b" |];
  run [| "c" |];
  run [| "d" |];
  run [| |]
let x = float_of_string "Inf";

        (*
let filelines = File.lines_of filename in
Enum.iter ( fun line -> (*Do something with line here*) ) filelines
         *)

;;

let fname =   "/home/mcarter/.fortran/STATSLIST/calcs/rs3gap" ;;
(* let x = File.lines fname; *)

(* chan might be stdin *)
let read_chan_lines chan =
  let res = ref [] in 
  try
    res := [];
    while true do
      let line : string = input_line chan in
      res.contents <- line :: !res 
      (* Printf.printf "%s\n" line *)
    done;
    List.rev (!res)
  with
    End_of_file -> (List.rev (!res))
;;

  
(*
let read_file_lines fname =
  open_in fname in
    try
      Stream.iter
        (fun line ->
          (* do something with line *)
          print_endline line)
        (line_stream_of_channel in_channel);
      close_in in_channel
    with e ->
      close_in in_channel;
      raise e
;
 *)
let read_file_lines fname =
  let chan = open_in fname in
  let res = read_chan_lines chan in
  let _ = close_in chan in
  res ;;


let use_stdin = false ;;
let inp_lines = if use_stdin then (read_chan_lines stdin) else (read_file_lines fname) ;;

let enfloat str =
  try
    let str1 = String.trim str in
    float_of_string str1
  with
    Failure e -> raise (Failure (String.concat "" ["Failed to convert to string: "; str]))
;;
let nums = List.map enfloat inp_lines ;;

let good_nums  nums =
  let f x = not ( (x == nan) || (x == infinity) ) in
  List.filter f nums
;;

let rec sort_mc lst =
  match lst with
    [] -> []
  | head :: tail -> insert head (sort_mc tail)
and insert elt lst =
  match lst with
    [] -> [elt]
  | head :: tail -> if elt <= head then elt :: lst else head :: insert elt tail
;;
  
(* sorted good numbers *)
let sgn  = sort_mc (good_nums nums)
;;
  
(*                            
List.iter print_string (read_chan_lines stdin) ;;
 *)

let prfl x =
  print_float x;
  print_string "\n"
;;

let prfls = List.iter prfl ;;  

let x = prfls  sgn ;; 
  (* let y = prfls (good_nums nums);; *)



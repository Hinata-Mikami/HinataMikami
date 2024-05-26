(*メイン関数*)
let eval_input () =
  (*コマンドライン引数がある場合はファイルを評価 *)  
  if Array.length Sys.argv > 1 then
    let file = Sys.argv.(1) in
    let op_file = open_in file 
    in Functions.read_file op_file;
    close_in op_file;

  (*そうでないときは標準入力を評価read_eval_point loop*)
  else Functions.repl()

(*随時実行*)
let () = eval_input ()


let display_file file =
  let open_file = open_in file in
  let rec display_line i =
     begin print_int i;
           print_string " ";
           print_endline file;
           try display_line (i + 1) 
           with End_of_file -> close_in open_file
     end
  in display_line 1;;


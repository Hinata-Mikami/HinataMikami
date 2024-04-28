let cp fl1 fl2 =
  let open_fl1 = open_in fl1 in
  let open_fl2 = open_out fl2 in
  let rec copy_line ()=
      try 
        output_string open_fl2 ((input_line open_fl1) ^ "\n"); 
        copy_line()
      with End_of_file -> 
        close_in open_fl1; 
        close_out open_fl2
  in copy_line ();;
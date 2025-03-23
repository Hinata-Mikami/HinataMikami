let x = 1 in let x = 3 in let x = x + 2 in x * x;;
(*予想： (3 + 2)*(3 + 2)の結果である 25が出力される*)
(*結果：出力：25*)

let x = 2 and y = 3 in (let y = x and x = y + 2 in x * y) + y;;
(*予想：(2 + 3) * 2 + 3 つまり　13が出力される*)
(*結果：出力：13*)

let x = 2 in let y = 3 in let y = x in let z = y + 2 in x * y * z;;
(*予想：2 * 2 * 4 つまり　16 となる*)
(*結果：出力：16*)
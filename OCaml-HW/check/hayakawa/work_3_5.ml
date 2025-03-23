let x = 0 and y = x;; (*let x = 0 と let y = x は独立しているため、後者のxが Unbound value となってしまう*)
let x = 0 let y = x;; (*let x = 0 の後に let y = x が実行されるため、可能である*)
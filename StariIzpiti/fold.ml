let rec fold f acc = function
| [] -> acc
| x :: xs -> fold f (f acc x) xs


let g = fold (fun x ys -> x * (fold ( + ) 0 ys)) 0

print_int (g [[1;2;3]; [4;5;6]]);;

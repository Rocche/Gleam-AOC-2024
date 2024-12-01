import gleam/int
import gleam/io
import gleam/list
import part_1

fn get_similarities(lists: #(List(Int), List(Int))) -> List(Int) {
  lists.0
  |> list.map(fn(n) { n * list.count(lists.1, fn(a) { a == n }) })
}

pub fn run() {
  let filepath = "real_input.txt"
  let result =
    part_1.get_lines(filepath)
    |> part_1.get_lists
    |> get_similarities
    |> int.sum
  io.debug(result)
}

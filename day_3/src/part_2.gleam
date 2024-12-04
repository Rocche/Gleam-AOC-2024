import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import part_1

fn filter_multiplications_loop(
  operations: List(String),
  do: Bool,
  result: List(String),
) -> List(String) {
  case operations, do {
    [], _ -> result
    ["do()", ..xs], _ -> filter_multiplications_loop(xs, True, result)
    ["don't()", ..xs], _ -> filter_multiplications_loop(xs, False, result)
    [x, ..xs], True -> filter_multiplications_loop(xs, do, [x, ..result])
    [_, ..xs], False -> filter_multiplications_loop(xs, do, result)
  }
}

fn filter_multiplications(operations: List(String)) -> List(String) {
  filter_multiplications_loop(operations, True, [])
}

fn find_multiplications(content: String) -> List(Int) {
  let assert Ok(re) =
    regexp.from_string("(mul\\(\\d+,\\d+\\)|do\\(\\)|don't\\(\\))")
  re
  |> regexp.scan(content)
  |> list.map(fn(match) { match.content })
  |> filter_multiplications
  |> list.map(part_1.find_multiplications)
  |> list.flatten
}

pub fn run() {
  let filepath = "real_input.txt"
  let result =
    part_1.get_content(filepath)
    |> find_multiplications
    |> list.fold(0, int.add)
  io.debug(result)
}

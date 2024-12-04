import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import simplifile

pub fn multiply(values: List(String)) -> Int {
  values
  |> list.map(int.base_parse(_, 10))
  |> result.values
  |> list.fold(1, int.multiply)
}

pub fn find_multiplications(content: String) -> List(Int) {
  let assert Ok(re) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")
  re
  |> regexp.scan(content)
  |> list.map(fn(match) { match.submatches })
  |> list.map(fn(submatches) { option.values(submatches) })
  |> list.map(multiply)
}

pub fn get_content(filepath: String) -> String {
  let assert Ok(content) = simplifile.read(from: filepath)
  content
}

pub fn run() {
  let filepath = "real_input.txt"
  let result =
    get_content(filepath)
    |> find_multiplications
    |> list.fold(0, int.add)
  io.debug(result)
}

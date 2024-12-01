import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

fn get_numbers_from_line(line: String) -> #(Int, Int) {
  let nums =
    line
    |> string.split(" ")
    |> list.map(string.trim)
    |> list.map(int.base_parse(_, 10))
  let first = nums |> list.first |> result.flatten |> result.unwrap(0)
  let second = nums |> list.last |> result.flatten |> result.unwrap(0)
  #(first, second)
}

pub fn get_lists(lines: List(String)) -> #(List(Int), List(Int)) {
  let number_pairs =
    lines
    |> list.map(get_numbers_from_line)
  #(
    number_pairs |> list.map(fn(t) { t.0 }),
    number_pairs |> list.map(fn(t) { t.1 }),
  )
}

fn get_distances(lists: #(List(Int), List(Int))) -> List(Int) {
  let sorted1 = list.sort(lists.0, int.compare)
  let sorted2 = list.sort(lists.1, int.compare)
  sorted1
  |> list.zip(sorted2)
  |> list.map(fn(tuple) { int.absolute_value(tuple.0 - tuple.1) })
}

pub fn get_lines(filepath: String) -> List(String) {
  let assert Ok(content) = simplifile.read(from: filepath)
  content
  |> string.split("\n")
  |> list.map(string.trim)
  |> list.filter(fn(s) { !string.is_empty(s) })
}

pub fn run() {
  let filepath = "real_input.txt"
  let result =
    get_lines(filepath)
    |> get_lists
    |> get_distances
    |> int.sum
  io.debug(result)
}

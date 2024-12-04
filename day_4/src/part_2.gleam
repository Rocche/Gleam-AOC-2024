import gleam/bool
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import part_1

fn get_x_from_coord(lines: List(String), row: Int, col: Int) -> List(String) {
  let target_grid =
    lines
    |> list.drop(row)
    |> list.take(3)
    |> list.map(fn(row) {
      list.range(col, col + 2)
      |> list.map(part_1.get_char_at_index(row, _))
      |> result.values
      |> string.join("")
    })
  let diagonal =
    target_grid
    |> list.index_map(fn(row, idx) { part_1.get_char_at_index(row, idx) })
    |> result.values
    |> string.join("")
  let antidiagonal =
    target_grid
    |> list.reverse
    |> list.index_map(fn(row, idx) { part_1.get_char_at_index(row, idx) })
    |> result.values
    |> string.join("")
  [diagonal, antidiagonal]
}

fn count_xmas_loop(lines: List(String), row: Int, col: Int, count: Int) -> Int {
  let assert Ok(first_line) = lines |> list.first
  case row > list.length(lines) - 3, col > string.length(first_line) - 3 {
    True, _ -> count
    False, True -> count_xmas_loop(lines, row + 1, 0, count)
    False, False -> {
      let xmas_found =
        get_x_from_coord(lines, row, col)
        |> list.all(fn(diag) { diag == "MAS" || diag == "SAM" })
        |> bool.to_int
      count_xmas_loop(lines, row, col + 1, count + xmas_found)
    }
  }
}

fn count_xmas(lines: List(String)) -> Int {
  count_xmas_loop(lines, 0, 0, 0)
}

pub fn run() {
  let filepath = "real_input.txt"
  let lines = part_1.get_lines(filepath)
  let result = lines |> count_xmas
  io.debug(result)
}

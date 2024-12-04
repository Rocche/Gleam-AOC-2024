import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import simplifile

fn count_word_in_string(s: String, word: String) -> Int {
  s
  |> string.to_graphemes
  |> list.window(4)
  |> list.map(string.join(_, with: ""))
  |> list.filter(fn(s) { s == word })
  |> list.length
}

fn count_bidirectional(s: String, word: String) -> Int {
  { s |> count_word_in_string(word) }
  + { s |> string.reverse |> count_word_in_string(word) }
}

fn lines_to_columns(lines: List(String)) -> List(String) {
  lines
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.map(string.join(_, with: ""))
}

pub fn get_char_at_index(s: String, i: Int) -> Result(String, Nil) {
  s
  |> string.to_graphemes
  |> list.drop(i)
  |> list.first
}

fn lines_to_diagonals_loop(
  lines: List(String),
  index: Int,
  diagonals: List(String),
) -> List(String) {
  case get_char_at_index(lines |> list.first |> result.unwrap(""), index) {
    Error(Nil) -> diagonals
    Ok(_) -> {
      let diagonal =
        lines
        |> list.index_map(fn(line, idx) { get_char_at_index(line, index + idx) })
        |> result.values
        |> string.join("")
      lines_to_diagonals_loop(lines, index + 1, [diagonal, ..diagonals])
    }
  }
}

fn lines_to_diagonals(lines: List(String)) -> List(String) {
  // A B C
  // D E F
  // G H I
  // [AEI, BF, C] is the upper half
  // [DH, G] is the lower half
  // AEI is the main diagonal

  // upper half
  lines_to_diagonals_loop(lines, 0, [])
  // lower half
  // starts with 1 instead of 0 because the main diagonal is already
  // counted in the upper half
  |> list.append(lines_to_diagonals_loop(lines |> lines_to_columns, 1, []))
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
  let lines = get_lines(filepath)
  let horizontal =
    lines
    |> list.map(count_bidirectional(_, "XMAS"))
    |> int.sum
  let vertical =
    lines
    |> lines_to_columns
    |> list.map(count_bidirectional(_, "XMAS"))
    |> int.sum
  let diagonal =
    lines
    |> lines_to_diagonals
    |> list.map(count_bidirectional(_, "XMAS"))
    |> int.sum
  let antidiagonal =
    lines
    |> list.map(string.reverse)
    |> lines_to_diagonals
    |> list.map(count_bidirectional(_, "XMAS"))
    |> int.sum
  let result = horizontal + vertical + diagonal + antidiagonal
  io.debug(result)
}

import gleam/int
import gleam/io
import gleam/list
import gleam/order.{type Order, Eq, Gt, Lt}
import gleam/result
import gleam/string
import simplifile

fn get_pair_order_and_difference(pair: #(Int, Int)) -> #(Order, Int) {
  #(int.compare(pair.0, pair.1), int.absolute_value(pair.0 - pair.1))
}

fn check_orders_and_differences(ords_diffs: List(#(Order, Int))) -> Bool {
  let first_el = ords_diffs |> list.first |> result.unwrap(#(Eq, 0))
  let ords_ok =
    ords_diffs
    |> list.map(fn(t) { t.0 })
    |> list.all(fn(ord) { ord == first_el.0 && ord != Eq })
  let diffs_ok =
    ords_diffs
    |> list.map(fn(t) { t.1 })
    |> list.all(fn(diff) { diff >= 1 && diff <= 3 })
  ords_ok && diffs_ok
}

pub fn check_level(level: List(Int)) -> Bool {
  level
  |> list.window_by_2
  |> list.map(get_pair_order_and_difference)
  |> check_orders_and_differences
}

pub fn parse_line(line: String) -> List(Int) {
  line
  |> string.split(" ")
  |> list.map(string.trim)
  |> list.map(int.base_parse(_, 10))
  |> result.values
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
    |> list.map(parse_line)
    |> list.map(check_level)
    |> list.filter(fn(ok) { ok })
    |> list.length
  io.debug(result)
}

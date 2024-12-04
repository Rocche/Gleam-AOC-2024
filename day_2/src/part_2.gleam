import gleam/io
import gleam/list
import part_1

fn check_level_loop(
  current_level: List(Int),
  current_index: Int,
  original_level: List(Int),
) -> Bool {
  case
    part_1.check_level(current_level),
    current_index
    == list.length(original_level)
  {
    True, _ -> True
    False, True -> False
    False, False -> {
      let prefix = original_level |> list.take(current_index)
      let suffix = original_level |> list.drop(current_index + 1)
      let new_current_level =
        prefix
        |> list.append(suffix)
      check_level_loop(new_current_level, current_index + 1, original_level)
    }
  }
}

fn check_level(level: List(Int)) -> Bool {
  check_level_loop(level, 0, level)
}

pub fn run() {
  let filepath = "real_input.txt"
  let result =
    part_1.get_lines(filepath)
    |> list.map(part_1.parse_line)
    |> list.map(check_level)
    |> list.filter(fn(ok) { ok })
    |> list.length
  io.debug(result)
}

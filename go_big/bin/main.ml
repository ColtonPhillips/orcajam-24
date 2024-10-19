open Graphics;;

(* Define map and character positions *)
let room_width = 20
let room_height = 10
let walls = "#"
let player_symbol = "O"
let enemy_symbol = "X"

(* Player and enemy initial positions *)
let player_pos = ref (1, 1)
let enemy_pos = ref (room_width - 2, room_height - 2)

(* Helper functions *)
let draw_char x y ch =
  moveto (x * 10) (y * 10);
  draw_string ch

let draw_room () =
  clear_graph ();
  for y = 0 to room_height do
    for x = 0 to room_width do
      if x = 0 || x = room_width || y = 0 || y = room_height then
        draw_char x y walls
    done
  done

let draw_player () =
  let (x, y) = !player_pos in
  draw_char x y player_symbol

let draw_enemy () =
  let (x, y) = !enemy_pos in
  draw_char x y enemy_symbol

(* Enemy movement logic *)
let move_enemy () =
  let (px, py) = !player_pos in
  let (ex, ey) = !enemy_pos in
  if Random.int 2 = 0 then () (* sometimes enemy pauses *)
  else if ex < px then enemy_pos := (ex + 1, ey)
  else if ex > px then enemy_pos := (ex - 1, ey)
  else if ey < py then enemy_pos := (ex, ey + 1)
  else if ey > py then enemy_pos := (ex, ey - 1)

(* Handle player input *)
let handle_input () =
  if key_pressed () then
    let key = read_key () in
    let (x, y) = !player_pos in
    player_pos := (
      match key with
      | 'w' when y < room_height - 1 -> (x, y + 1)
      | 's' when y > 1 -> (x, y - 1)
      | 'a' when x > 1 -> (x - 1, y)
      | 'd' when x < room_width - 1 -> (x + 1, y)
      | _ -> (x, y)
    )

(* Check if game over (player caught by enemy) *)
let check_game_over () =
  if !player_pos = !enemy_pos then
    true  (* Game over condition met *)
  else
    false  (* Game continues *)

(* Main game loop - no recursion *)
let game_loop () =
  let game_over = ref false in
  while not !game_over do
    draw_room ();
    draw_player ();
    draw_enemy ();
    handle_input ();
    move_enemy ();
    game_over := check_game_over ();
    synchronize ();
    Unix.sleepf 0.2  (* Control framerate *)
  done

(* Main entry point *)
let () =
  open_graph " 400x400";
  auto_synchronize false;

  (* Show the main menu *)
  clear_graph ();
  moveto 1 1;

  draw_string "Welcome to the game!";
  moveto 50 200;
  draw_string "Press any key to start...";
  ignore (read_key ());

  (* Start the game loop *)
  game_loop ();

  (* Close the graphics window after the game ends *)
  close_graph ()

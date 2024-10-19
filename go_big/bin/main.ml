open Graphics;;

(* let font_size = ref (8 13);;
let (char_width, char_height) = !_font_size *)
let char_width = 8
let char_height = 13
let room_width = 130 / 2
let room_height = 80 / 2
(* I can't explain why it needs me to do these extra char buffers. Jank *)
let window_width = char_width +char_width + char_width + (room_width * char_width)
let window_height = char_height +char_height +char_height + char_height + (room_height * char_height)

let wall_tile = "#"
let player_tile = "O"
let enemy_tile = "X"

let player_pos = ref (2, 2)
let enemy_pos = ref (room_width - 2, room_height - 2)

let draw_char x y ch =
    moveto (x * char_width) (y * char_height);
    draw_string ch

let draw_room () =
    clear_graph ();
    for y = 0 to room_height do
        for x = 0 to room_width do
        if x = 0 || x = room_width || y = 0 || y = room_height then
            draw_char x y wall_tile
        done
    done

let draw_player () = 
    let (x, y) = !player_pos in
    draw_char x y player_tile

let draw_enemy () =
    let (x, y) = !enemy_pos in
    draw_char x y enemy_tile

(* Enemy movement logic *)
let move_enemy () =
    if Random.int 100 < 98 then () (* sometimes enemy pauses *)
    else begin
        let (px, py) = !player_pos in
        let (ex, ey) = !enemy_pos in

        (* Move towards the player's position in both x and y directions *)
        let new_x = 
            if ex < px then ex + 1
            else if ex > px then ex - 1
            else ex  (* No movement if aligned in x direction *)
        in
        let new_y = 
            if ey < py then ey + 1
            else if ey > py then ey - 1
            else ey  (* No movement if aligned in y direction *)
        in
        enemy_pos := (new_x, new_y)  (* Update position with new coordinates *)
    end

let check_game_over () =
    if !player_pos = !enemy_pos then
        true  (* Game over condition met *)
    else
        false  (* Game continues *)

let last_key = ref None;;  (* Track the last key pressed *)

let handle_input () =
  if key_pressed () then
    let key = read_key () in

    (* Only process input if it's a new key press *)
    if !last_key <> Some key then begin
      last_key := Some key;  (* Update the last key pressed *)
      let (x, y) = !player_pos in
      player_pos := (
        match key with
        | 'w' when y < room_height - 1 -> (x, y + 1)
        | 's' when y > 1 -> (x, y - 1)
        | 'a' when x > 1 -> (x - 1, y)
        | 'd' when x < room_width - 1 -> (x + 1, y)
        | _ -> (x, y)
      )
    end
  else
    (* Clear last key if no key is pressed *)
    last_key := None;;
let game_loop () = 
    let game_over = ref false in 
    while not !game_over do
        draw_room ();
        handle_input ();
        move_enemy ();
        draw_player ();
        draw_enemy ();
        game_over := check_game_over ();
        synchronize ();
    done

let () =
    (* The origin is in the bottom left corner :( *)
    open_graph (Printf.sprintf " %dx%d" window_width window_height);
    (* All subsequent drawing commands are performed on the backing store only. *)
    auto_synchronize false;
    clear_graph ();

    draw_room ();
    draw_char (room_width / 3) (room_height / 2) "Welcome to Colton's 1st Game!";

    synchronize ();
    Unix.sleepf 0.2;

    ignore(read_key());

    game_loop ();

    close_graph ()  
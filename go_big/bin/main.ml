(* Import the graphics library `opam install graphics *)
open Graphics;;

(* Default font is about this size *)
let char_width = 8
let char_height = 13

(* The room is roughly square sized, because of the ratios of sizes *)
let room_width = char_height * 10 / 2
let room_height = char_width * 10 / 2

(* For some reason the window needs some padding to see my board *)
let window_width = 3 * char_width + (room_width * char_width)
let window_height = 4 * char_height + (room_height * char_height)

(* Each game "entity" has it's own tile *)
let wall_tile = "#"
let player_tile = "O"
let enemy_tile = "X"
let _empty_tile = " "

(* Player/Enemy positions *)
let player_pos = ref (2, 2)
let enemy_pos = ref (room_width - 2, room_height - 2)

(* Draw a char/string anywhere on the board *)
let draw_char x y ch =
    moveto (x * char_width) (y * char_height);
    draw_string ch

(* Draw all the walls around the square room *)
let draw_room () =
    clear_graph ();
    for y = 0 to room_height do
        for x = 0 to room_width do
        if x = 0 || x = room_width || y = 0 || y = room_height then
            draw_char x y wall_tile
        done
    done

(* Draw the player character *)
let draw_player () = 
    let (x, y) = !player_pos in
    draw_char x y player_tile

(* Draw the enemy character *)
let draw_enemy () =
    let (x, y) = !enemy_pos in
    draw_char x y enemy_tile

(* Move the enemy toward the player, even diagonally, but it typically doesn't want to move *)
(* This is slower/faster depending on your CPU speed, which matches my original implementation *)
let move_enemy () =
    if Random.float 100.0 < 99.5 then () (* sometimes enemy pauses *)
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

(* If the enemy and player tiles touch, you lose the game; Halt And Catch Fire *)
let check_game_over () =
    if !player_pos = !enemy_pos then
        true  (* Game over condition met *)
    else
        false  (* Game continues *)


let last_key = ref None;;  (* Track the last key pressed *)

(* Handle player input and update player position ASDW keys *)
let handle_input () =
  if key_pressed () then
    let key = read_key () in

    (* Only process input if it's a new key press *)
    if !last_key <> Some key then begin
      last_key := Some key;  (* Update the last key pressed *)

      (* Set players new position based on the key found *)
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

(* Main game loop; Quit if user dies *)
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

(* Main method *)
let () =
    (* The origin is in the bottom left corner :( *)
    (* Create a graphics window *)
    open_graph (Printf.sprintf " %dx%d" window_width window_height);

    (* All subsequent drawing commands are performed on the backing store only. *)
    auto_synchronize false;

    (* Erase the window *)
    clear_graph ();

    (* Draw the Starting Window *)
    draw_room ();
    draw_char (room_width / 3) (room_height / 2) "Welcome to Colton's 1st Game!";

    (* Synchronize the terminal graphics that are being buffered into it like, it literally just happened *)
    Unix.sleepf 0.5;
    synchronize ();

     (* Wait for User Input *)
    ignore(read_key());

    (* Run the main game loop until you die *)
    game_loop ();

    (* Shut it down; You don't have to go home, but you can't stay here. *)
    close_graph ()  
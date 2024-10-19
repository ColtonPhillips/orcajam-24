open Graphics;;

(* let font_size = ref (8 13);;
let (char_width, char_height) = !_font_size *)
let char_width = 8
let char_height = 13
let room_width = 130 / 2
let room_height = 80 / 2
let window_width = char_width +char_width + char_width + (room_width * char_width)
let window_height = char_height +char_height +char_height + char_height + (room_height * char_height)

let wall_tile = "#"
let _player_tile = "O"
let _enemy_tile = "X"

let _player_pos = ref (2, 2)
let _enemy_pos = ref (room_width - 2, room_height - 2)
(* 
let draw_char x y ch = 
    moveto *)

(* Helper functions *)
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

let check_game_over () =
    if Random.int 20 = 0 then
        true  (* Game over condition met *)
    else
        false  (* Game continues *)

let game_loop () = 
    let game_over = ref false in 
    while not !game_over do
        draw_room ();
        game_over := check_game_over ();
        synchronize ();
        Unix.sleepf 0.2
    done

let () =
    (* The origin is in the bottom left corner :( *)
    (* open_graph "500x500"; *)
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
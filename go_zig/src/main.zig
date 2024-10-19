const std = @import("std");

const width = 11;
const height = 11;

fn render_room(player_x: usize, player_y: usize) void {
    const stdout = std.io.getStdOut().writer();
    for (0..height) |y| {
        for (0..width) |x| {
            if (x == 0 or x == width - 1 or y == 0 or y == height - 1) {
                // Render walls
                stdout.writeAll("#") catch {};
            } else if (x == player_x and y == player_y) {
                // Render player
                stdout.writeAll("O") catch {};
            } else {
                // Render empty space
                stdout.writeAll(" ") catch {};
            }
        }
        stdout.writeAll("\n") catch {};
    }
}

pub fn main() !void {
    var player_x: usize = 1; // Start position of the player
    var player_y: usize = 1;

    const stdin = std.io.getStdIn().reader();
    const stdout = std.io.getStdOut().writer();

    while (true) {
        try stdout.print("\x1b[2J\x1b[H", .{});

        render_room(player_x, player_y); // Render the room

        // Read input
        const input = stdin.readByte() catch |err| {
            std.debug.print("Error reading input: {}\n", .{err});
            return err;
        };

        // Move player based on input
        switch (input) {
            'W' => {
                if (player_y > 1) player_y -= 1;
            }, // Move up
            'S' => {
                if (player_y < height - 2) player_y += 1;
            }, // Move down
            'A' => {
                if (player_x > 1) player_x -= 1;
            }, // Move left
            'D' => {
                if (player_x < width - 2) player_x += 1;
            }, // Move right
            else => {},
        }
    }
}

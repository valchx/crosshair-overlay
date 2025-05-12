pub fn main() !void {
    const w = 200;
    const h = 200;

    rl.setConfigFlags(.{
        .msaa_4x_hint = true,
        .window_resizable = false,
        .window_transparent = true,
        .window_undecorated = true,
        .window_topmost = true,
        .window_mouse_passthrough = true,
    });
    rl.initWindow(w, h, "CrossHair Test");

    // TODO : THis is weird
    // const current_monitor = rl.getCurrentMonitor();
    // rl.setWindowPosition(
    //     @divTrunc(rl.getMonitorWidth(current_monitor), 2),
    //     @divTrunc(rl.getMonitorHeight(current_monitor), 2),
    // );

    rl.setTargetFPS(60);

    const target = try setup_crosshair_texture(w, h);
    defer rl.unloadRenderTexture(target);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        {
            rl.clearBackground(rl.Color.blank);
            draw_crosshair(w, h, target.texture);
        }
        rl.endDrawing();
    }
}

fn setup_crosshair_texture(w: i32, h: i32) !rl.RenderTexture2D {
    const target = try rl.loadRenderTexture(w, h);
    rl.beginTextureMode(target);

    rl.clearBackground(rl.Color.blank);
    const center = .{
        .x = @divTrunc(rl.getScreenWidth(), 2),
        .y = @divTrunc(rl.getScreenHeight(), 2),
    };

    const dot = .{ .size = 10, .color = rl.Color{ .r = 255, .g = 0, .b = 0, .a = 192 } };

    rl.drawRectangle(
        center.x - @divTrunc(dot.size, 2),
        center.y - @divTrunc(dot.size, 2),
        dot.size,
        dot.size,
        dot.color,
    );

    rl.endTextureMode();

    return target;
}

fn draw_crosshair(w: f32, h: f32, texture: rl.Texture) void {
    const rect = rl.Rectangle{
        .x = 0,
        .y = 0,
        .width = w,
        .height = h,
    };
    rl.drawTexturePro(texture, rect, rect, .{ .x = 0, .y = 0 }, 0, rl.Color.white);
}

const std = @import("std");
const lib = @import("crosshair_overlay_lib");
const rl = @import("raylib");

pub fn main() !void {
    const w = 200;
    const h = 200;

    rl.setConfigFlags(.{
        .msaa_4x_hint = true,
        .window_resizable = false,
        .window_transparent = true,
        .window_undecorated = true,
        .window_mouse_passthrough = true,
        .window_topmost = true,
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

    regular_crosshair(4, .{ .r = 255, .g = 255, .b = 255, .a = 195 }, true, 8);

    rl.endTextureMode();

    return target;
}

fn regular_crosshair(
    size: i32,
    color: rl.Color,
    dot: bool,
    gap: i32,
) void {
    const center = .{
        .x = @divTrunc(rl.getScreenWidth(), 2),
        .y = @divTrunc(rl.getScreenHeight(), 2),
    };

    if (dot) {
        rl.drawRectangle(
            center.x - @divTrunc(size, 2),
            center.y - @divTrunc(size, 2),
            size,
            size,
            color,
        );
    }

    rl.drawRectangle(
        center.x - @divTrunc(size, 2) - gap - size,
        center.y - @divTrunc(size, 2),
        size * 2,
        size,
        color,
    );

    rl.drawRectangle(
        center.x - @divTrunc(size, 2) + gap,
        center.y - @divTrunc(size, 2),
        size * 2,
        size,
        color,
    );

    rl.drawRectangle(
        center.x - @divTrunc(size, 2),
        center.y - @divTrunc(size, 2) - gap - size,
        size,
        size * 2,
        color,
    );

    rl.drawRectangle(
        center.x - @divTrunc(size, 2),
        center.y - @divTrunc(size, 2) + gap,
        size,
        size * 2,
        color,
    );
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

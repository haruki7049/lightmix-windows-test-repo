const std = @import("std");
const lightmix = @import("lightmix");

pub fn gen(allocator: std.mem.Allocator) !lightmix.Wave(f64) {
    const wave = try Sine.gen(allocator);
    return wave;
}

const Sine = struct {
    fn gen(allocator: std.mem.Allocator) !lightmix.Wave(f64) {
        const sample_rate: u32 = 44100;
        const sample_rate_f: f64 = @floatFromInt(sample_rate);
        const frequency: f64 = 440.0;
        const amplitude: f64 = 1.0;
        const length: usize = 88200;
        const channels: u16 = 1;
        const samples: []f32 = try gen_samples(allocator, frequency, amplitude, length, sample_rate_f);

        return lightmix.Wave(f64){
            .allocator = allocator,
            .samples = samples,
            .sample_rate = sample_rate,
            .channels = channels,
        };
    }

    fn gen_samples(
        allocator: std.mem.Allocator,
        frequency: comptime_float,
        amplitude: comptime_float,
        length: usize,
        sample_rate: comptime_float,
    ) []f64 {
        const radians_per_sec: f32 = frequency * 2.0 * std.math.pi;
        var result: []f64 = try allocator.alloc(f64, length);

        for (0..length) |i| {
            const v: f64 = std.math.sin(@as(f32, @floatFromInt(i)) * radians_per_sec / sample_rate) * amplitude;
            result[i] = v;
        }

        return result;
    }
};

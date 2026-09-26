class_name ToneGenerator
extends RefCounted
## Generates short PCM tones/noise at runtime so functional audio feedback
## (warning beeps, simple ambience/static) exists even before real sound
## design assets are dropped into audio/. Replace with authored audio later
## -- callers only need an AudioStream, so swapping is a one-line change.

static func generate_beep(frequency: float = 880.0, duration: float = 0.12, sample_rate: int = 44100, volume: float = 0.5) -> AudioStreamWAV:
	var frame_count := int(sample_rate * duration)
	var data := PackedByteArray()
	data.resize(frame_count * 2)
	var fade_frames := maxi(1, int(sample_rate * 0.01))
	for i in frame_count:
		var t := float(i) / sample_rate
		var envelope := 1.0
		if i < fade_frames:
			envelope = float(i) / fade_frames
		elif i > frame_count - fade_frames:
			envelope = float(frame_count - i) / fade_frames
		var sample := sin(TAU * frequency * t) * volume * envelope
		data.encode_s16(i * 2, int(clampf(sample, -1.0, 1.0) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.data = data
	return stream

## Low, slowly-beating drone -- a functional stand-in for "low ominous
## restrained music" (PRD 10.2/54.1) until a composed score exists. Two
## closely-detuned low sine tones create a slow, uneasy beat frequency;
## deliberately avoids stingers, choir, or percussive hits per the PRD's
## explicit "avoid" list.
static func generate_drone(base_frequency: float = 55.0, duration: float = 4.0, sample_rate: int = 44100, volume: float = 0.35) -> AudioStreamWAV:
	var frame_count := int(sample_rate * duration)
	var data := PackedByteArray()
	data.resize(frame_count * 2)
	var detune := base_frequency * 1.01
	var fade_frames := maxi(1, int(sample_rate * 0.3))
	for i in frame_count:
		var t := float(i) / sample_rate
		var envelope := 1.0
		if i < fade_frames:
			envelope = float(i) / fade_frames
		elif i > frame_count - fade_frames:
			envelope = float(frame_count - i) / fade_frames
		var wave := sin(TAU * base_frequency * t) * 0.6 + sin(TAU * detune * t) * 0.4
		var sample := wave * volume * envelope
		data.encode_s16(i * 2, int(clampf(sample, -1.0, 1.0) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = frame_count - 1
	stream.data = data
	return stream

## Soft-band noise, useful as a stand-in for wind/static/ambience.
static func generate_noise(duration: float = 1.0, sample_rate: int = 44100, volume: float = 0.3) -> AudioStreamWAV:
	var frame_count := int(sample_rate * duration)
	var data := PackedByteArray()
	data.resize(frame_count * 2)
	var rng := RandomNumberGenerator.new()
	rng.seed = 1337
	var prev := 0.0
	for i in frame_count:
		var white := rng.randf_range(-1.0, 1.0)
		prev = lerp(prev, white, 0.15) # cheap low-pass so it isn't harsh
		data.encode_s16(i * 2, int(clampf(prev * volume, -1.0, 1.0) * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_end = frame_count - 1
	stream.data = data
	return stream

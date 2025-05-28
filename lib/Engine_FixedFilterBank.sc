Engine_FixedFilterBank : CroneEngine {
	var <synth;
	
	*new { arg context, doneCallBack;
		^super.new(context, doneCallBack);
	}

	alloc {
		SynthDef(\fbb, { |inL, inR, out, rq=1.0, a0=0.1, a1=0.3, a2=0, a3=0.5, a4=0, a5=0, a6=0.2, a7=0|
			var f0, f1, f2, f3, f4, f5, f6, f7;

			var inputL = SoundIn.ar(0);
			var inputR = SoundIn.ar(1);

			var filtersL = Mix.ar([
				BPF.ar(inputL,    55, rq, a0),
				BPF.ar(inputL,   111, rq, a1),
				BPF.ar(inputL,   222, rq, a2),
				BPF.ar(inputL,   555, rq, a3),
				BPF.ar(inputL,  1111, rq, a4),
				BPF.ar(inputL,  2222, rq, a5),
				BPF.ar(inputL,  5555, rq, a6),
				BPF.ar(inputL, 11111, rq, a7)
            ]);

			var filtersR = Mix.ar([
				BPF.ar(inputR,    55*1.1, rq, a0),
				BPF.ar(inputR,   111*1.1, rq, a1),
				BPF.ar(inputR,   222*1.1, rq, a2),
				BPF.ar(inputR,   555*1.1, rq, a3),
				BPF.ar(inputR,  1111*1.1, rq, a4),
				BPF.ar(inputR,  2222*1.1, rq, a5),
				BPF.ar(inputR,  5555*1.1, rq, a6),
				BPF.ar(inputR, 11111*1.1, rq, a7)
            ]);

			Out.ar(out, [filtersL, filtersR])
		}).add;

		context.server.sync;

		synth = Synth.new(\fbb,
			[
				\inL, context.in_b[0].index,
				\inR, context.in_b[1].index,
				\out, context.out_b.index,
			],
			context.xg
		);

		this.addCommand("rq", "f", {|msg|
			synth.set(\rq, msg[1].clip(0.01, 2));
		});

		this.addCommand("amp0", "f", {|msg|
			synth.set(\a0, msg[1]);
		});
		
		this.addCommand("amp1", "f", {|msg|
			synth.set(\a1, msg[1]);
		});

		this.addCommand("amp2", "f", {|msg|
			synth.set(\a2, msg[1]);
		});

		this.addCommand("amp3", "f", {|msg|
			synth.set(\a3, msg[1]);
		});

		this.addCommand("amp4", "f", {|msg|
			synth.set(\a4, msg[1]);
		});

		this.addCommand("amp5", "f", {|msg|
			synth.set(\a5, msg[1]);
		});

		this.addCommand("amp6", "f", {|msg|
			synth.set(\a6, msg[1]);
		});

		this.addCommand("amp7", "f", {|msg|
			synth.set(\a7, msg[1]);
		});
	}

	free {
		synth.free;
	}
}

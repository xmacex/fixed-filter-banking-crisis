Engine_FixedFilterBank : CroneEngine {
	var <synth;
	
	*new { arg context, doneCallBack;
		^super.new(context, doneCallBack);
	}

	alloc {
		SynthDef(\fbb, { |inL, inR, out, rq=1.0, a0=0.3, a1, a2, a3, a4, a5, a6, a7|
			var sig, f0, f1, f2, f3, f4, f5, f6, f7;
			sig = [In.ar(inL), In.ar(inR)];
			
			f0 = BPF.ar(sig,    55, rq, a0);
			f1 = BPF.ar(sig,   111, rq, a1);
			f2 = BPF.ar(sig,   222, rq, a2);
			f3 = BPF.ar(sig,   555, rq, a3);
			f4 = BPF.ar(sig,  1111, rq, a4);
			f5 = BPF.ar(sig,  2222, rq, a5);
			f6 = BPF.ar(sig,  5555, rq, a6);
			f7 = BPF.ar(sig, 11111, rq, a7);

			Out.ar(out, Mix.ar([f0, f1, f2, f3, f4, f5, f6, f7])!2);
		}).add;

		content.server.sync;

		synth = Synth.new(\fbb,
			[
				\inL, context.in_b[0].index,
				\inR, context.in_b[1].index,
				\out, context.out_b.index,
			],
			context.xg
		);

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

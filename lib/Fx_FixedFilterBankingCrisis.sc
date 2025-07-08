FxFixedFilterBankingCrisis : FxBase {
	*new {
		var ret = super.newCopyArgs(nil, \none, (
			amp0: 0.1,
			amp1: 0.3,
			amp2: 0.0,
			amp3: 0.5,
			amp4: 0.0,
			amp5: 0.0,
			amp6: 0.2,
			amp7: 0.0,
			rq:   1,
		), nil, 1);
		^ret;
	}

	*initClass {
		FxSetup.register(this.new);
	}

	subPath {
		^"/fx_ffbc";
	}

	symbol {
		^\fxFfbc;
	}

	addSynthdefs {
		SynthDef(\fxFfbc, { |inBus, outBus| //, rq=1.0, amp0=0.1, amp1=0.3, amp2=0, amp3=0.5, amp4=0, amp5=0, amp6=0.2, amp7=0|
			var f0, f1, f2, f3, f4, f5, f6, f7;

			var inputL = In.ar(inBus, 2)[0];
			var inputR = In.ar(inBus, 2)[1];

			var filtersL = Mix.ar([
				BPF.ar(inputL,    55, \rq.kr(1), \amp0.kr(1)),
				BPF.ar(inputL,   111, \rq.kr(1), \amp1.kr(1)),
				BPF.ar(inputL,   222, \rq.kr(1), \amp2.kr(1)),
				BPF.ar(inputL,   555, \rq.kr(1), \amp3.kr(1)),
				BPF.ar(inputL,  1111, \rq.kr(1), \amp4.kr(1)),
				BPF.ar(inputL,  2222, \rq.kr(1), \amp5.kr(1)),
				BPF.ar(inputL,  5555, \rq.kr(1), \amp6.kr(1)),
				BPF.ar(inputL, 11111, \rq.kr(1), \amp7.kr(1))
            ]);

			var filtersR = Mix.ar([
				BPF.ar(inputR,    55*1.1, \rq.kr(1), \amp0.kr(1)),
				BPF.ar(inputR,   111*1.1, \rq.kr(1), \amp1.kr(1)),
				BPF.ar(inputR,   222*1.1, \rq.kr(1), \amp2.kr(1)),
				BPF.ar(inputR,   555*1.1, \rq.kr(1), \amp3.kr(1)),
				BPF.ar(inputR,  1111*1.1, \rq.kr(1), \amp4.kr(1)),
				BPF.ar(inputR,  2222*1.1, \rq.kr(1), \amp5.kr(1)),
				BPF.ar(inputR,  5555*1.1, \rq.kr(1), \amp6.kr(1)),
				BPF.ar(inputR, 11111*1.1, \rq.kr(1), \amp7.kr(1))
            ]);

			Out.ar(outBus, [filtersL, filtersR])
		}).add;
	}
}

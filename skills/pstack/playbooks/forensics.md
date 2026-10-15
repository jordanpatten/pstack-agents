### Forensics

**You own the diagnosis. The deliverable is a cited diagnosis, not a fix.** Two variants. Runtime forensics instruments a live process. Trace forensics reads a capture that already exists. Throughput checkpoint stays one line: `throughput checkpoint: n/a, read-only forensics`.

#### Runtime forensics (live symptom)

Instrument the live process. Do not theorize from source.

1. Capture the live signal on the matching surface: a CPU profile for a spinning process, a heap snapshot for a leak, a browser performance trace for a visual glitch. A real artifact, not a guess.
2. Reduce the artifact to the smoking gun: the function on the hot path, the retainer chain from the leaked object to a GC root, the loop firing without input. Parse large artifacts in a subagent and keep the reduced finding in the main thread.
3. Prove the mechanism before you believe it. Inject instrumentation into the running process (for example a DevTools console eval), or hotfix the live code without a reload, to confirm the hypothesis cheaply.
4. Map the finding back to source: file, symbol, and the line that allocates or schedules.

**Reply:** the signal captured, the reduced finding, how you proved the mechanism, the source location, and artifact paths. No fix unless asked. Hand back to Bug fix or Perf issue once the cause is known.

#### Trace forensics (captured artifact)

The artifact is a fixed dataset. Read it. Do not re-run it. Keep tooling generic: a DevTools or trace parser for cpuprofile and `.json.gz`, a text editor for a spindump, your heap tooling for a heap snapshot.

1. Identify the format and load it with the right tool. Parse large artifacts in a subagent and keep the reduced finding in the main thread.
2. Transform the raw artifact into a form you can query. Dump the trace or heap snapshot into sqlite, one row per sample, frame, or node. Reach the queryable shape before you read.
3. Narrow to the cause. Query for the frames that hold the most time and walk the call tree to the hot path. For a leak, follow the retainer chain from the leaked object to a GC root. For a spindump, find the thread stuck on-CPU or blocked, and its wait reason.
4. Attribute to source. Map the hot frame to file, symbol, and line through the artifact's own symbols. A frame with no source mapping is not yet a diagnosis. Resolve the symbols, or say plainly that the artifact does not carry them.
5. If you have a paired capture, diff the before and after artifacts to confirm. Otherwise, mark the finding as the strongest hypothesis the artifact supports, not a confirmed cause.

**Reply:** the artifact and format, the reduced finding, the source location, the artifact paths, and whether a paired capture confirmed it.

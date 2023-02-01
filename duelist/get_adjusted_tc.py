from contextlib import ExitStack
import os
import subprocess
import sys

if len(sys.argv) != 2:
    print("Usage: ./get_adjusted_tc.py <10+0.1 or 60+0.6>")
    sys.exit(0)

# Modified from: https://github.com/glinscott/fishtest/blob/master/worker/games.py
def get_bench_nps(engine):
    cpu_features = "?"
    with subprocess.Popen(
        [engine, "compiler"],
        stdout=subprocess.PIPE,
        stderr=subprocess.DEVNULL,
        universal_newlines=True,
        bufsize=1,
        close_fds=True,
    ) as p:
        for line in iter(p.stdout.readline, ""):
            if "settings" in line:
                cpu_features = line.split(": ")[1].strip()
    if p.returncode:
        raise WorkerException(
            "Compiler info exited with non-zero code {}".format(
                format_return_code(p.returncode)
            )
        )
    with ExitStack() as stack:
        bench_sig = None
        bench_nps = None
        p = stack.enter_context(
            subprocess.Popen(
                [engine, "bench"],
                stderr=subprocess.PIPE,
                stdout=subprocess.DEVNULL,
                universal_newlines=True,
                bufsize=1,
                close_fds=True,
            )
        )
        for line in iter(p.stderr.readline, ""):
            if "Nodes searched" in line:
                bench_sig = line.split(": ")[1].strip()
            if "Nodes/second" in line:
                bench_nps = float(line.split(": ")[1].strip())
    if p.returncode != 0:
        if p.returncode == 1:  # EXIT_FAILURE
            raise RunException(
                "Bench of {} exited with EXIT_FAILURE".format(os.path.basename(engine))
            )
        else:  # Signal? It could be user generated so be careful.
            raise WorkerException(
                "Bench of {} exited with error code {}".format(
                    os.path.basename(engine), format_return_code(p.returncode)
                )
            )
    return bench_nps


def adjust_tc(tc, factor):
    # Parse the time control in cutechess format.
    chunks = tc.split("+")
    increment = 0.0
    if len(chunks) == 2:
        increment = float(chunks[1])

    chunks = chunks[0].split("/")
    num_moves = 0
    if len(chunks) == 2:
        num_moves = int(chunks[0])

    time_tc = chunks[-1]
    chunks = time_tc.split(":")
    if len(chunks) == 2:
        time_tc = float(chunks[0]) * 60 + float(chunks[1])
    else:
        time_tc = float(chunks[0])

    # Rebuild scaled_tc now: cutechess-cli and stockfish parse 3 decimal places.
    scaled_tc = "{:.3f}".format(time_tc * factor)
    tc_limit = time_tc * factor * 3
    if increment > 0.0:
        scaled_tc += "+{:.3f}".format(increment * factor)
        tc_limit += increment * factor * 200
    if num_moves > 0:
        scaled_tc = "{}/{}".format(num_moves, scaled_tc)
        tc_limit *= 100.0 / num_moves

    # print("CPU factor : {} - tc adjusted to {}".format(factor, scaled_tc))
    return scaled_tc


tc = sys.argv[1]
bench_nps = get_bench_nps('./Stockfish/src/stockfish')
print(adjust_tc(tc, 1328000 / bench_nps))

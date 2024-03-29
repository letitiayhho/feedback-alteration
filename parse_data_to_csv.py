from pathlib import Path
import csv
import numpy as np
import pandas as pd


def parse_pitch_tier(path):
    print("parsing:", path.name) #remove
    values = []
    start_offset = None
    index = 0

    with open(path) as f:
        for line in f:
            if "size" in line:
                _, size = line.split("=")
                size = float(size.strip())
                continue

            if "points " in line:
                _, point = line.split("[")
                point = float(point[:-3])
                continue

            if "number" in line:

                _, number = line.split("=")
                number = float(number.strip())

                if start_offset is None:
                    start_offset = number

                while True:
                    expected_number = start_offset + (index * 0.001)
                    if abs(number - expected_number) < 1e-5:
                        break
                    values.append(float("NaN"))
                    index += 1
                    size += 1

                continue

            # Record pitch value
            if "value" in line:
                _, value = line.split("=")
                value = float(value.strip())
                values.append(value)
                index += 1
                continue

    # Checks
    if len(values) != size:
        raise ValueError(f"Values array size {len(values)} doesn't match expected size {size}")
    return values

def parse_file_name(path):
    file_name = path.stem
    (
        subject,
        exp,
        phasename,
        num_rep,
        num_trial,
        num_formed,
        num_uttered,
        prompt,
        in_or_out,
        _,
        date_run,
        time_run,
        *rest,
    ) = file_name.split("_")

    # Handle the user accidentally suffixing with "__x__" instead
    # of "_[x]_" :(
    if len(rest) == 1:
        block = rest[0][1]
    elif len(rest) == 3:
        block = rest[1]
    else:
        raise ValueError(f"Too many _s ({file_name!r})")

    subject = int(subject[1:])
    phasename = int(phasename[1:])
    num_rep = int(num_rep[1:])
    num_trial = int(num_trial[1:])
    num_formed = int(num_formed[1:])
    num_uttered = int(num_uttered[1:])
    block = int(block)
    return (
        subject,
        exp,
        phasename,
        num_rep,
        num_trial,
        num_formed,
        num_uttered,
        prompt,
        in_or_out,
        date_run,
        time_run,
        block,
    )

DATA_ROOT = Path("./share/hcnlab/IND_all/Exp1_data/")

with open("data.csv", "w") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(
        [
            "subject",
            "exp",
            "phasename",
            "num_rep",
            "num_trial",
            "num_formed",
            "num_uttered",
            "prompt",
            "in_or_out",
            "date_run",
            "time_run",
            "block",
            "values",
        ]
    )
    for subject_root in DATA_ROOT.iterdir():
        if not subject_root.name.startswith("SUBJECT"):
            continue
        for pitch_tier in (subject_root / "wave_files/pitchtiers").iterdir():
            if not pitch_tier.name.endswith(".PitchTier"):
                continue
            values = parse_pitch_tier(pitch_tier)
            (
                subject,
                exp,
                phasename,
                num_rep,
                num_trial,
                num_formed,
                num_uttered,
                prompt,
                in_or_out,
                date_run,
                time_run,
                block,
            ) = parse_file_name(pitch_tier)
            writer.writerow(
                [
                    subject,
                    exp,
                    phasename,
                    num_rep,
                    num_trial,
                    num_formed,
                    num_uttered,
                    prompt,
                    in_or_out,
                    date_run,
                    time_run,
                    block,
                    values,
                ]
            )

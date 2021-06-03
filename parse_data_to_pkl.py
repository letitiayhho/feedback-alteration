from pathlib import Path
import numpy as np
import pandas as pd

from dataclasses import dataclass

@dataclass
class TrialMetadata:
    subject: int
    exp: str
    phasename: int
    num_rep: int
    num_trial: int
    num_formed: int
    num_uttered: int
    prompt: str
    in_or_out: str
    date_run: str
    time_run: str
    block: int

    @classmethod
    def from_filename(cls, filename: str) -> "TrialMetadata":
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
        ) = filename.split("_")

        # Handle the user accidentally suffixing with "__x__" instead
        # of "_[x]_" :(
        if len(rest) == 1:
            block = rest[0][1]
        elif len(rest) == 3:
            block = rest[1]
        else:
            raise ValueError(f"Too many _s ({filename!r})")

        return cls(
            subject=int(subject[1:]),
            exp=exp,
            phasename= int(phasename[1:]),
            num_rep=int(num_rep[1:]),
            num_trial=int(num_trial[1:]),
            num_formed=int(num_formed[1:]),
            num_uttered=int(num_uttered[1:]),
            prompt=prompt,
            in_or_out=in_or_out,
            date_run=date_run,
            time_run=time_run,
            block=int(block),
        )

def parse_pitch_tier(path):
    print("parsing:", path.name, "\r")
    pitches = []
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
                    pitches.append(float("NaN"))
                    index += 1
                    size += 1

                continue

            # Record pitch value
            if "value" in line:
                _, pitch = line.split("=")
                pitch = float(pitch.strip())
                pitches.append(pitch)
                index += 1
                continue

    # Checks
    if len(pitches) != size:
        raise ValueError(f"Pitches array size {len(pitches)} doesn't match expected size {size}")
    return pitches

DATA_ROOT = Path("./share/hcnlab/IND_all/Exp1_data/")

agg = {
    "subject": [],
    "exp": [],
    "phasename": [],
    "num_rep": [],
    "num_trial": [],
    "num_formed": [],
    "num_uttered": [],
    "prompt": [],
    "in_or_out": [],
    "date_run": [],
    "time_run": [],
    "block": [],
    "pitches": [],
}

for subject_root in DATA_ROOT.iterdir():
    if not subject_root.name.startswith("SUBJECT"):
        continue
    for pitch_tier in (subject_root / "wave_files/pitchtiers").iterdir():
        if not pitch_tier.name.endswith(".PitchTier"):
            continue

        # Metadata from filename
        trial = TrialMetadata.from_filename(pitch_tier.stem)
        agg["subject"].append(trial.subject)
        agg["exp"].append(trial.exp)
        agg["phasename"].append(trial.phasename)
        agg["num_rep"].append(trial.num_rep)
        agg["num_trial"].append(trial.num_trial)
        agg["num_formed"].append(trial.num_formed)
        agg["num_uttered"].append(trial.num_uttered)
        agg["prompt"].append(trial.prompt)
        agg["in_or_out"].append(trial.in_or_out)
        agg["date_run"].append(trial.date_run)
        agg["time_run"].append(trial.time_run)
        agg["block"].append(trial.block)

        # Data from Praat file
        pitches = parse_pitch_tier(pitch_tier)
        agg["pitches"].append(pitches)

    break


data_frame = pd.DataFrame(agg)
data_frame.to_pickle("data.pkl")

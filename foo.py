from pathlib import Path
import csv

#if False:
DATA_ROOT = Path("/share/hcnlab/IND_all/Exp1_data/")

for subject_root in DATA_ROOT.iterdir():
    if not subject_root.name.startswith("SUBJECT"):
        continue
    for pitch_tier in (subject_root / "wave_files/pitchtiers").iterdir():
        if not pitch_tier.name.endswith(".PitchTier"):
            continue
        print(pitch_tier)

def parse_pitch_tier(path):
    numbers = []
    values = []
    with open(path) as f:
        for line in f:
            if "number" in line:
                _, number = line.split("=")
                number = float(number.strip())
                numbers.append(number)
            if "value" in line:
                _, value = line.split("=")
                value = float(value.strip())
                values.append(value)
    return numbers, values

def parse_pitch_tier_file_name(path):
    file_name = path.stem
    subject, exp, phasename, num_rep, num_trial, num_formed, num_uttered, prompt, in_or_out, _, date_run, unk, block = file_name.split("_")
    subject = int(subject[1:])
    phasename = int(phasename[1:])
    num_rep = int(num_rep[1:])
    num_trial = int(num_trial[1:])
    num_formed = int(num_formed[1:])
    num_uttered = int(num_uttered[1:])
    block = int(block[1])
    return subject, exp, phasename, num_rep, num_trial, num_formed, num_uttered, prompt, in_or_out, date_run, unk, block

#numbers, values = parse_pitch_tier("test.PitchTier")
#path = Path('share/hcnlab/S6_FAE_P6_R32_T1_F712_U108_HECK_O_BSUBJECT6_20160518_HR_[4].PitchTier')
#print(parse_pitch_tier_file_name(path))
#S6_FAE_P6_R32_T1_F712_U108_HECK_O_BSUBJECT6_20160518_HR_[4]
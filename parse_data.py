from pathlib import Path
import csv


def parse_pitch_tier(path):
    values = []
    start_offset = None
    index = 0

    with open(path) as f:
        for line in f:
            if "number" in line:

                # Get the recorded time stamp
                _, number = line.split("=")
                number = round(float(number.strip())*1000)

                # Correct for start offset
                if start_offset is None:
                    start_offset = number
                number = number - start_offset

                # If there is a missing value append nan
                while number != index:
                    values.append(float("nan"))
                    print("value: nan") #remove
                    index += 1
                    print("index:", index) #remove

            # Record pitch value
            if "value" in line:
                _, value = line.split("=")
                value = float(value.strip())
                values.append(value)
                print("value:", value) #remove
                index += 1
                print("index:", index) #remove
    return values

def parse_file_name(path):
    file_name = path.stem
    print(file_name)
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

numbers = parse_pitch_tier("./share/hcnlab/IND_all/Exp1_data/SUBJECT30_20170302_11_[3]/wave_files/pitchtiers/S30_FIH_P1_R1_T1_F3776_U1_HECK_O_BSUBJECT30_20170302_11_[3].PitchTier")

#with open("data.csv", "w") as csvfile:
#    writer = csv.writer(csvfile)
#    writer.writerow(
#        [
#            "subject",
#            "exp",
#            "phasename",
#            "num_rep",
#            "num_trial",
#            "num_formed",
#            "num_uttered",
#            "prompt",
#            "in_or_out",
#            "date_run",
#            "time_run",
#            "block",
#            "numbers",
#            "values",
#        ]
#    )
#    for subject_root in DATA_ROOT.iterdir():
#        if not subject_root.name.startswith("SUBJECT"):
#            continue
#        for pitch_tier in (subject_root / "wave_files/pitchtiers").iterdir():
#            if not pitch_tier.name.endswith(".PitchTier"):
#                continue
#            numbers, values = parse_pitch_tier(pitch_tier)
#            (
#                subject,
#                exp,
#                phasename,
#                num_rep,
#                num_trial,
#                num_formed,
#                num_uttered,
#                prompt,
#                in_or_out,
#                date_run,
#                time_run,
#                block,
#            ) = parse_file_name(pitch_tier)
#            writer.writerow(
#                [
#                    subject,
#                    exp,
#                    phasename,
#                    num_rep,
#                    num_trial,
#                    num_formed,
#                    num_uttered,
#                    prompt,
#                    in_or_out,
#                    date_run,
#                    time_run,
#                    block,
#                    numbers,
#                    values,
#                ]
#            )

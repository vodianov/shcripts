#!/usr/bin/env python3

import json
import csv
import sys


def escape_semicolon(value: str) -> str:
    if not value:
        return ""
    return value.replace(";", r"\;")


def export_word_from_jsonl(jsonl_file, word, pos, csv_file) -> dict:
    with open(jsonl_file, "r", encoding="utf-8") as f:
        for line in f:
            entry = json.loads(line.strip())
            if entry.get("word") == word and entry.get("pos") == pos:
                return entry


def get_senses(data: str) -> list[str]:
    return [
        "\n".join(d.get("raw_glosses", d.get("glosses", [])))
        for d in data.get("senses", [])
    ]


def get_examples(data: str) -> list[str]:
    examples = []
    for sense in data.get("senses", []):
        for example in sense.get("examples", []):
            sent = example["text"]
            if example.get("english"):
                sent += f" / {example['english']}"
            examples.append(sent)
    return examples


def get_gender(data: str) -> str:
    genders = {"feminine", "masculine", "neuter", "common-gender"}
    # forms = data.get("senses", []) + data.get("forms", [])
    senses = data.get("senses", [])
    # FIXME: do we need to return the form too along with the gender? and can different forms have different genders?
    for form in senses:
        for gender in genders:
            if gender in form.get("tags", []):
                return gender

    # Latin words have their genders in "forms"
    forms = data.get("forms", [])
    for form in forms:
        for gender in genders:
            tags = form.get("tags", [])
            if gender in tags and "canonical" in tags:
                return gender

    return ""


def get_part_of_speech(data: str) -> str:
    return data.get("pos", "")


def get_ipa(data: str) -> str:
    sounds = data.get("sounds", [])
    for sound in sounds:
        if sound.get("ipa"):
            return sound["ipa"]
    return ""


def get_audio_url(data: str) -> str:
    sounds = data.get("sounds", [])
    for sound in sounds:
        if sound.get("ogg_url"):
            return sound["ogg_url"]
    return ""


def get_etymology(data: str) -> str:
    return data.get("etymology_text", "")


# "declension": forms in the declension table
def get_declension(data: str) -> dict[str, list[str]]:
    declensions: dict[str, list[str]] = {}
    forms = data.get("forms", [])
    for form in forms:
        if (
            isinstance(form.get("source"), str)
            and form.get("source").lower() == "declension"
        ):
            tags = form.get("tags", [])
            # "table-tags" and "inflection-template" seems like useless stuffs
            useless_tags = ["table-tags", "inflection-template"]
            for useless_tag in useless_tags:
                if useless_tag in tags:
                    break

            else:
                # append {"tags": "form"} to `declensions`
                key = ", ".join(tags)
                value = form.get("form")
                declensions.update({key: declensions.get(key, []) + [value]})

    return declensions


def main():
    if len(sys.argv) < 5:
        print(
            "Использование: python export_from_jsonl.py <jsonl_file> <word> <pos> <output_csv>"
        )
        sys.exit(1)
    jsonl_file = sys.argv[1]
    word = sys.argv[2]
    pos = sys.argv[3]
    csv_file = sys.argv[4]

    # print(export_word_from_jsonl(jsonl_file, word, pos, csv_file))
    data = export_word_from_jsonl(jsonl_file, word, pos, csv_file)
    #  print(data)

    print(get_senses(data))


#    print(get_examples(data))
#    print(get_part_of_speech(data))
#    print(get_gender(data))
#    print(get_ipa(data))
#    print(get_audio_url(data))
#    print(get_etymology(data))
#    print(get_declension(data))
#

if __name__ == "__main__":
    main()

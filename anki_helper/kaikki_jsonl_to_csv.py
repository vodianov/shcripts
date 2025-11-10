#!/usr/bin/env python3

import argparse
import csv

from kaikki_fetcher import KaikkiFetcher


def list_to_html_ordered(lst) -> str:
    html = "<ol>\n"
    for item in lst:
        html += f"  <li>{item}</li>\n"
    html += "</ol>"
    return html


def dict_to_html_table(d):
    html = "<table border='1' cellpadding='5' cellspacing='0'>\n"
    html += "  <tr><th>Ключ</th><th>Значение</th></tr>\n"
    for key, value in d.items():
        html += f"  <tr><td>{key}</td><td>{value}</td></tr>\n"
    html += "</table>"
    return html


examples = []
defs = []


def main():
    translation = []

    parser = argparse.ArgumentParser(
        description="Convert word's fields from Kaikki dump to csv"
    )

    parser.add_argument(
        "-j", "--json-file", required=True, help="Required. Dump of kaikki dictionary"
    )
    parser.add_argument(
        "-j2", "--json-file2", help="Dump of secondary kaikki dictionary"
    )
    parser.add_argument(
        "-c", "--csv-file", required=True, help="csv file for write data"
    )
    parser.add_argument("-w", "--word", required=True, help="Required. Undefined word")
    parser.add_argument("-p", "--pos", help="Word's part of speech")
    parser.add_argument("-t", "--translation", help="Translation of word")

    args = parser.parse_args()

    dict = KaikkiFetcher(args.json_file, args.word, args.pos, args.translation)
    if dict.entry:
        defs = dict.get_senses()
    if args.json_file2:
        sec_dict = KaikkiFetcher(args.json_file2, args.word, args.pos)
        if sec_dict.entry:
            translation = sec_dict.get_senses()
        elif args.translation:
            translation.append(args.translation)

    with open(args.csv_file, "a", newline="") as csvfile:
        writer = csv.writer(csvfile, delimiter="\t")
        writer.writerow(
            [
                args.word,
                list_to_html_ordered(translation),
                list_to_html_ordered(defs),
                list_to_html_ordered(dict.get_examples()),
                dict.get_gender(),
                dict.get_part_of_speech(),
                dict.get_ipa(),
                dict.get_audio_url(),
                dict.get_etymology(),
                dict_to_html_table(dict.get_declension()),
                str(len(defs)),
                str(len(translation)),
            ]
        )


if __name__ == "__main__":
    main()

#!/usr/bin/env python3

import argparse
import csv

from kaikki_fetcher import KaikkiFetcher
from html_converter import list_to_html_ordered, dict_to_html_ordered, dict_to_html_table

def main():
    defs = dict()
    translation = list()

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
    parser.add_argument("-l", "--language", help="language code of word")

    args = parser.parse_args()

    dictionary = KaikkiFetcher(args.json_file, args.word, args.pos)
    if dictionary.entry:
        defs = dictionary.get_definitions()
    if args.json_file2:
        sec_dictionary = KaikkiFetcher(args.json_file2, args.word, args.pos)
        if sec_dictionary.entry:
            translation = sec_dictionary.get_senses()
        elif args.translation:
            translation.append("custom translate:")
            translation.append(args.translation)
    if args.language:
            translation.append(dictionary.get_translations(args.language))

    with open(args.csv_file, "a", newline="") as csvfile:
        writer = csv.writer(csvfile, delimiter="\t")
        writer.writerow(
            [
                args.word,
                dict_to_html_ordered(defs),
                dict_to_html_table(dictionary.get_declension()),
                list_to_html_ordered(dictionary.get_examples()),
                list_to_html_ordered(translation),
                dictionary.get_gender(),
                dictionary.get_part_of_speech(),
                dictionary.get_ipa(),
                dictionary.get_audio_url(),
                dictionary.get_etymology(),
                str(len(defs)),
                str(len(translation)),
            ]
        )


if __name__ == "__main__":
    main()

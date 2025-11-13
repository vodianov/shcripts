import json

from typing import final


@final
class KaikkiFetcher:
    def __init__(self, jsonl_file, word: str, pos="") -> dict:
        self.entry = {}
        with open(jsonl_file, "r", encoding="utf-8") as f:
            for line in f:
                entry = json.loads(line.strip())
                if entry.get("word") == word and (not pos or entry.get("pos") == pos):
                    self.entry = entry

    def get_senses(self) -> list[str]:
        if self.entry:
            return [
                "\n".join(d.get("raw_glosses", d.get("glosses", [])))
                for d in self.entry.get("senses", [])
            ]
        return []

    def get_examples(self) -> list[str]:
        if self.entry:
            examples = []
            for sense in self.entry.get("senses", []):
                for example in sense.get("examples", []):
                    if example.get("text"):
                        sent = example["text"]
                    if example.get("english"):
                        sent += f" / {example['english']}"
                    examples.append(sent)
            return examples
        return []

    def get_gender(self) -> str:
        if self.entry:
            genders = {"feminine", "masculine", "neuter", "common-gender"}
            senses = self.entry.get("senses", [])
            # FIXME: do we need to return the form too along with the gender? and can different forms have different genders?
            for form in senses:
                for gender in genders:
                    if gender in form.get("tags", []):
                        return gender

            # Latin words have their genders in "forms"
            forms = self.entry.get("forms", [])
            for form in forms:
                for gender in genders:
                    tags = form.get("tags", [])
                    if gender in tags and "canonical" in tags:
                        return gender
        return ""

    def get_part_of_speech(self) -> str:
        if self.entry:
            return self.entry.get("pos", "")
        return ""

    def get_ipa(self) -> str:
        if self.entry:
            sounds = self.entry.get("sounds", [])
            for sound in sounds:
                if sound.get("ipa"):
                    return sound["ipa"]
        return ""

    def get_audio_url(self) -> str:
        if self.entry:
            sounds = self.entry.get("sounds", [])
            for sound in sounds:
                if sound.get("ogg_url"):
                    return sound["ogg_url"]
        return ""

    def get_etymology(self) -> str:
        if self.entry:
            return self.entry.get("etymology_text", "")
        return ""

    # "declension": forms in the declension table
    def get_declension(self) -> dict[str, list[str]]:
        if self.entry:
            declensions: dict[str, list[str]] = {}
            forms = self.entry.get("forms", [])
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
        return {}

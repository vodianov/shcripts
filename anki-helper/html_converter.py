def dict_to_html_table(d) -> str:
    html = "<table border='1' cellpadding='5' cellspacing='0'>\n"
    html += "  <tr><th>Ключ</th><th>Значение</th></tr>\n"
    for key, value in d.items():
        html += f"  <tr><td>{key}</td><td>{value}</td></tr>\n"
    html += "</table>"
    return html

def dict_to_html_ordered(d: dict[str, list[str]]) -> str:
    html = '<ol>\n'
    for key, values in d.items():
        html += f'  <li>{key}\n'
        if values:
            html += '    <ol>\n'
            for value in values:
                html += f'      <li>{value}</li>\n'
            html += '    </ol>\n'
        html += '  </li>\n'
    html += '</ol>'
    return html

def list_to_html_ordered(lst) -> str:
    html = "<ol>\n"
    for item in lst:
        html += f"  <li>{item}</li>\n"
    html += "</ol>"
    return html


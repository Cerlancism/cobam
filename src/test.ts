import { parseCobol, getCobolSources, getCopybooks, stripPathExtNames } from './parser'

import fs = require('fs');


const copybooks = getCopybooks()
const cobols = getCobolSources("./ml/sample/*.cbl")


void (async () =>
{
    const mapping = []
    for (const cobol of cobols) {
        mapping.push(await parseCobol(cobol))
    }
    fs.writeFileSync("./ml/sample/sample.json", JSON.stringify(mapping, undefined, 2), {encoding: 'utf-8'})
})()

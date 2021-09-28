export function splitLines(text: string) {
    return text.split("\n").map(x => x.trim()).filter(x => !!x)
}


export function splitByWord(text: string) {
    return text.split(/(\s+)/).map(x => x.trim()).filter(x => !!x)
}

export function wordCount(text: string) {
    var splits = splitLines(text).map(x => splitByWord(x))
    console.log(splits)
    return splits.reduce((a, b) => a + b.length, 0)
}
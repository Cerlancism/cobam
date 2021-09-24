export function split(text: string)
{
    return text.split(/(\s+)/).map(x => x.trim()).filter(x => !!x)
}

export function wordCount(text: string)
{
    var splits = split(text)
    console.log(splits)
    return splits.length
}
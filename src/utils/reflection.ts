export function reflect(input: Object)
{
    const target = input as { [key in string]: any }
    const output: { [key in string]: any } = {}

    for (const key in target)
    {
        if (target.hasOwnProperty(key))
        {
            const element = target[key];
            if (typeof element === "object")
            {
                output[key] = reflect(element)
                continue;
            }
            if (typeof element === "function")
            {
                output[key] = element.toString()
                continue;
            }
            output[key] = element
        }
    }
    return output
}
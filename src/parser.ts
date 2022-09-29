import * as glob from 'glob'
import fs = require('fs');
import readline = require('readline');
import { CopyBookDirectory, CobolDirectory, CobolIndent, CobolLastCol } from './config'
import { CobolFile, CobolSection, CobolSectionCall } from './types';

export function stripPathExtNames(file: string, ext: string)
{
    const splits = file.split("/")
    const last = splits[splits.length - 1].replace("." + ext, "")
    return last
}

export function getCopybooks()
{
    const files = glob.sync(`${CopyBookDirectory}/**/*.cpy`)
    return files
}

export function getCobolSources(source?: string)
{
    if (!source) {
        source = `${CobolDirectory}/**/*.cbl`
    }
    const files = glob.sync(source)
    return files
}

export async function parseCobol(file: string)
{
    const fileStream = fs.createReadStream(file)
    const rl = readline.createInterface({
        input: fileStream,
        crlfDelay: Infinity
    });

    let progress = 0
    let sections: CobolSection[] = []
    let currentSection: string[] = []
    for await (const line of rl)
    {
        const trimmed = line.trim()
        if (trimmed[0] === "*")
        {
            continue
        }

        switch (progress)
        {
            case 0:
                {
                    if (line.includes("WORKING-STORAGE SECTION."))
                    {
                        progress++
                    }
                    continue
                }
            case 1:
                {
                    if (line.includes("PROCEDURE DIVISION."))
                    {
                        progress++
                    }
                    continue
                }
            case 2:
                {
                    const subline = line.substring(CobolIndent.length, CobolLastCol)

                    if (subline[0] != ' ')
                    {
                        if (currentSection.length > 0)
                        {
                            sections.push(parseCobolSection(file, currentSection))
                        }
                        currentSection = [subline.trim()]
                    }
                    else
                    {
                        currentSection.push(subline.trim())
                    }
                }
                break
        }
    }
    return { file: file, presence: "source", name: stripPathExtNames(file, "cbl"), sections } as CobolFile
}

export function parseCobolSection(file: string, section: string[]): CobolSection
{
    let calls: CobolSectionCall[] = []

    for (const line of section)
    {
        if (line.includes("XCTL PROGRAM"))
        {
            const splits = line.split("'")
            const target = splits[1]

            if (target)
            {
                // console.log(file, section[0], target)
                calls.push({
                    type: "XCTL PROGRAM",
                    target
                })
            }
        }
    }

    return {
        file,
        importance: section[0].includes("*>IMPORTANT"),
        calls,
        raw: section.join("\n"),
        confidence: 0
    }
}
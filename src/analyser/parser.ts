import readline from 'readline'
import fs, { stat } from 'fs'

import assert from 'assert';

import { splitByWord, wordCount } from './tokeniser.js'

export type SourceLine = {
    index: number
    indent: number
    trimmed: string
    splits: string[]
    raw: string
    period: boolean
}

export type StorageStatement = {
    level: number
    identifier: string
    picture: boolean
    type: string
}

export type StorageVariable = {
    children: StorageVariable
    size: number
    type: "character" | "string" | "decimal"
    statement: StorageStatement
}

/**
 * Only supports files indented by spaces for now
 * @param line 
 */
export function getIndent(line: string) {
    for (let index = 0; index < line.length; index++) {
        const element = line[index];

        if (element === '\t') {
            throw "Tab character detected, tab indented file is not supported!"
        }

        if (element !== ' ') {
            return index
        }
    }
    return 0
}

export async function* parseSourceFile(file: string): AsyncGenerator<SourceLine> {
    const reader = readline.createInterface({
        input: fs.createReadStream(file)
    })
    let index = 0
    for await (const line of reader) {
        index++

        if (line === '\u001a') {
            continue
        }

        const indent = getIndent(line)
        const period = line.endsWith(".")
        let trimmed = line.substring(5).trim().replace(/  +/g, ' ')

        if (!trimmed) {
            continue
        }

        if (line[6] === "*") {
            continue
        }

        if (period) {
            trimmed = trimmed.slice(0, -1)
        }

        yield { index, indent, trimmed, splits: splitByWord(trimmed), raw: line, period }
    }
}

export function parseStatementStorage(lineSplits: string[]) {
    const output = {} as StorageStatement
    const slice = lineSplits.slice()

    if (slice.length <= 0) {
        throw "Expected level declaration"
    }

    let shifted = undefined

    shifted = slice.shift()
    output.level = Number.parseInt(shifted as string)

    shifted = slice.shift()
    output.identifier = shifted as string

    shifted = slice.shift()
    output.picture = shifted?.startsWith("PIC") ?? false

    shifted = slice.shift()

    if (shifted) {
        output.type = shifted
    }

    return output
}

function gaugeType(token: string) {
    let output

    if (!token) {
        output = "Custom"
    }
    else {
        if (token.startsWith("X")) {
            output = "String"
        }
        else if (token.startsWith("S9")) {
            output = "Decimal"
        }
        else if (token.startsWith("9")) {
            output = "Integer"
        }
        else if (token.startsWith("OCCURS")) {
            output = "List"
        }
        else {
            output = "Unknown"
        }
        output = `${output}<${token}>`
    }

    return output
}

export async function parseCopybookFile(file: string) {
    const parser = parseSourceFile(file)
    const lines = []

    let depth = 0
    let level = 0
    let splits = []
    for await (const line of parser) {
        lines.push(line)
        splits.push(...line.splits)
        
        if (!line.period) {
            continue
        }
        
        const statement = parseStatementStorage(splits.splice(0, splits.length))

        if (statement.level > level) {
            depth++
        }
        else if (statement.level < level) {
            depth--
        }
        level = statement.level

        console.log(" ".repeat(depth - 1) + gaugeType(statement.type), statement.identifier)
    }
}
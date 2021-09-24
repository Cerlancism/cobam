#! /usr/bin/env node
import path from 'path'
import fs from 'fs'

import { Command } from "commander";
import { wordCount } from "./analyser/tokeniser.js";

//@ts-ignore
import cobolscript from 'cobolscript';

import { reflect } from './utils/reflection.js';

const program = new Command("Cobol Analyser")

program.version("0.0.1", '-v, --version')

program.command("words <file>")
    .action(file => {
        console.log(wordCount(fs.readFileSync(file).toString()))
    })


program.command("js <file>")
    .action(file => {
        file = path.resolve(file)
        console.log("compiling", file)
        const program = cobolscript.compileProgramFile(file);
        console.log("cobolscript:\n", reflect(program))
        program.run(cobolscript.getRuntime())
    })

program.parse()


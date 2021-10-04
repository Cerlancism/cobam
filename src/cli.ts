#! /usr/bin/env node
import path from 'path'
import fs from 'fs'

import { Argument, Option, Command } from "commander";
//@ts-ignore
import cobolscript from 'cobolscript';

import { wordCount } from "./analyser/tokeniser.js";
import { reflect } from './utils/reflection.js';
import { hello } from './index.js';
import { parseCopybookFile } from './analyser/parser.js';
import { benchmarkFiles, FileReadBenchmark } from './utils/benchmark.js';

const program = new Command("Cobol Analyser")

program.version("0.0.1", '-v, --version')

const argsHello = new Argument("extras")
argsHello.required = false
argsHello.variadic = true

const argFileRequired = new Argument("file").argRequired()

program.command("hello")
    .addArgument(argsHello)
    .action((args) => hello(...args))

const benchMarkCmd = program.command("benchmark")
    .addArgument(argFileRequired)
    .addOption(new Option('-r, --recursive'))
    .action(target => {
        if (fs.lstatSync(target).isDirectory()) {
            const recursive = benchMarkCmd.opts().recursive as boolean
            function traverse(dir: string) {
                const full = path.resolve(dir)
                const items = fs.readdirSync(full, { withFileTypes: true })
                benchmarkFiles(items.filter(x => x.isFile()).map(x => path.join(full, x.name)))

                if (recursive) {
                    const recurses = items.filter(x => x.isDirectory())
                    for (const dir of recurses) {
                        traverse(path.join(full, dir.name))
                    }
                }
            }
            traverse(target)
        }
        else {
            benchmarkFiles([target])
        }
    })

program.command("words")
    .addArgument(argFileRequired)
    .action(file => console.log(wordCount(fs.readFileSync(path.resolve(file)).toString())))

program.command("run")
    .addArgument(argFileRequired)
    .addHelpText("before", "Compile and run a COBOL file using JavaScript Runtime")
    .action(file => {
        file = path.resolve(file)
        console.log("compiling", file)
        const program = cobolscript.compileProgramFile(file);
        console.log("cobolscript:\n", reflect(program))
        program.run(cobolscript.getRuntime())
    })

program.command("copybook")
    .addArgument(argFileRequired)
    .action(file => parseCopybookFile(file))

program.parse()

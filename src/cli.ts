#! /usr/bin/env node
import fs from 'fs' 

import { Command } from "commander";
import { wordCount } from "./analyser/tokeniser.js";

const program = new Command("Cobol Analyser")

program.version("0.0.1", '-v, --version')

program.command("words <file>")
    .action(file => console.log(wordCount(fs.readFileSync(file).toString())))


program.parse()


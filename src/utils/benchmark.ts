import assert from 'assert'
import fs from 'fs'
import path from 'path'
import { performance } from 'perf_hooks'
import readline from 'readline'

const ReportingFrequency = 1000

export function testRead(file: string, buff = Buffer.alloc(Math.pow(2, 20))) {
    fs.open(file, 'r', (err, fd) => {

        if (err) {
            console.error(err)
            process.exit(1)
        }

        const stats = fs.statSync(file)
        const size = stats.size
        const shortName = path.basename(file)
        const buffLength = buff.length

        let previousTime = performance.now()
        let totalTime = 0
        let reportingTime = 0
        let reportingSpeed = 0
        let totalRead = 0
        let currentRead = 0
        while ((currentRead = fs.readSync(fd, buff, 0, buffLength, totalRead)) > 0) {
            totalRead += currentRead
            reportingSpeed += currentRead

            const currentTime = performance.now()
            const deltaTime = currentTime - previousTime
            totalTime += deltaTime
            reportingTime += deltaTime
            previousTime = currentTime

            if (reportingTime > ReportingFrequency) {
                const displaySpeed = (reportingSpeed / reportingTime * 1000) / 1048576
                reportingTime -= ReportingFrequency
                reportingSpeed = 0
                readline.clearLine(process.stderr, 0)
                readline.cursorTo(process.stderr, 0)
                process.stderr.write([
                    `${(totalTime / 1000).toFixed(1)}`.padEnd(5),
                    displaySpeed.toFixed(3).padStart(10), "MB/s",
                    (totalRead / size).toLocaleString("en", { style: "percent", minimumFractionDigits: 2 }),
                    size.toLocaleString("en"),
                    shortName
                ].join(" "))
            }
        }
        readline.clearLine(process.stderr, 0)
        readline.cursorTo(process.stderr, 0)

        console.log("Completed", ((totalRead / totalTime * 1000) / 1048576).toFixed(3).padStart(8), "MB/s", shortName)

        assert.equal(totalRead, size, "Total read not equals file size")
    })
}
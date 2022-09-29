<template>
    <div>
        <div v-if="d3Ready">
            <!-- <h1>Codebase</h1> -->
            <v-card width="360"
                :style="`z-index: 10; position: absolute; left: ${0}px; top: ${0}px`">

                <div v-if="showOverview">
                    <!-- <v-card-title> </v-card-title> -->
                    <v-list-item three-line>
                        <v-list-item-content>
                            <v-list-item-subtitle>
                                <b>System Overview</b>
                            </v-list-item-subtitle>
                            <v-list-item-subtitle>
                                COBOL (Present):
                                {{
                                codeBase.cobolFiles.filter(
                                (x) => x.type === "source"
                                ).length
                                }}
                            </v-list-item-subtitle>
                            <v-list-item-subtitle>
                                COBOL (Only Specs):
                                {{
                                codeBase.cobolFiles.filter(
                                (x) => x.type === "specs"
                                ).length
                                }}
                            </v-list-item-subtitle>
                            <v-list-item-subtitle>
                                COBOL (Missing):
                                {{
                                codeBase.cobolFiles.filter(
                                (x) => x.type === "missing"
                                ).length
                                }}
                            </v-list-item-subtitle>
                            <!-- <v-list-item-subtitle>
                                CICS:
                                {{
                                        codeBase.cobolFiles.filter(
                                            (x) => x.type === "source"
                                        ).length
                                }}
                            </v-list-item-subtitle>
                            <v-list-item-subtitle>
                                COPYBOOKS: 10
                            </v-list-item-subtitle> -->
                        </v-list-item-content>
                    </v-list-item>
                </div>
                <!-- <v-card-actions>
                    <v-btn outlined rounded text @click="showOverview = !showOverview">
                        {{ showOverview ? "Minimise" : "Maximise" }}
                    </v-btn>
                    <v-btn outlined rounded text @click="expandAll = !expandAll">
                        {{ (expandAll ? "Collapse" : "Expand") + " All" }}
                    </v-btn>
                    <v-switch v-model="codeBase.focusMode" :label="`Focus Mode`"></v-switch>
                </v-card-actions> -->
            </v-card>

            <div v-if="!debugHide" :style="`position: absolute; transform: translate(${offsetX}px, ${offsetY}px);'`">
                <v-card v-for="(cobol, i) in codeBase.cobolFiles" :key="i"
                    @mouseover="onHoverCard(i, true)" @mouseleave="onHoverCard(i, false)"
                    :min-width="320"
                    :max-width="320"
                    :color="cobol.type === 'source' ? 'blue' : cobol.type === 'specs' ? 'orange' : 'red'"
                    :disabled="codeBase.focusMode && !cobol.focus"
                    :style="`z-index: ${cobol.expanded ? 999 : -1};opacity: ${codeBase.focusMode && !cobol.focus ? 0.5 : 1}; position: absolute; transform: translate(${coords[i].x}px, ${coords[i].y}px);`">

                    <v-card-actions>
                        <v-btn class="mx-2" fab dark small
                            :color="(cobol.type === 'source' ? 'blue' : cobol.type === 'specs' ? 'orange' : 'red') + ' lighten-1'">
                            <v-icon dark> mdi-pencil </v-icon>
                        </v-btn>
                        <v-btn outlined rounded text @click="cobol.expanded = !cobol.expanded">
                            {{ cobol.expanded ? "Collapse" : "Expand" }}
                        </v-btn>
                        <v-checkbox v-model="cobol.focus" :label="`Focus`"></v-checkbox>
                    </v-card-actions>

                    <v-list-item three-line>
                        <v-list-item-content>
                            <div class="text-overline mb-4">
                                {{ `COBOL ${cobol.type} File` }}
                            </div>

                            <v-list-item-title class="text-h5 mb-1">
                                {{ cobol.name }}
                            </v-list-item-title>
                            <v-list-item-subtitle>
                                Sections: {{ cobol.sections.length === 0 ? "unknown" : cobol.sections.length }}
                            </v-list-item-subtitle>
                            <div v-if="cobol.expanded" sm="12" style="max-height: 250px; overflow-y: scroll; overflow-x: hidden;">
                                <v-row>
                                    <v-col>
                                        <v-card
                                            v-for="section in cobol.sections" :key="section.name"
                                            max-width="344"
                                            outlined
                                            @click="onSectionClick(cobol.name, section.name)"
                                            :color="(cobol.type === 'source' ? 'blue' : cobol.type === 'specs' ? 'orange' : 'red') + ' lighten-1'">
                                            <v-list-item three-line>
                                                <v-list-item-content>
                                                    <v-list-item-subtitle>
                                                        {{ section.name }}
                                                    </v-list-item-subtitle>
                                                    <div v-if="section.important">
                                                        <v-list-item-icon>
                                                            <v-icon>mdi-star</v-icon>
                                                        </v-list-item-icon>
                                                        {{ section.confidence.toFixed(2) }}
                                                    </div>

                                                </v-list-item-content>
                                            </v-list-item>
                                        </v-card>
                                    </v-col>
                                </v-row>
                            </div>
                        </v-list-item-content>
                    </v-list-item>
                </v-card>
            </div>
        </div>

        <svg id="force-graph" :width="width + 'px'" :height="height + 'px'" @mousemove="drag($event)" @mouseup="drop()" @mousedown="offsetting()">
            <g v-if="d3Ready">
                <!-- <circle
                v-for="(node, i) in graph.nodes"
                :cx="coords[i].x + offsetX"
                :cy="coords[i].y + offsetY"
                :r="10"
                :fill="`blue`"
                stroke="white"
                stroke-width="1"
                :key="'nodec' + i" /> -->

                <g :transform="`translate(${offsetX} ${offsetY})`">
                    <g v-for="(link, i) in graph.links" :key="'linkc' + link.source.index + ',' + link.target.index">
                        <line v-if="!!coords[link.source.index] && !!coords[link.target.index]"
                            @mouseover="onHoverLink(i, true)" @mouseleave="onHoverLink(i, false)"
                            :x1="coords[link.source.index].x"
                            :y1="coords[link.source.index].y"
                            :x2="coords[link.target.index].x"
                            :y2="coords[link.target.index].y"
                            stroke="black" stroke-width="4" marker-end="url(#arrowhead)" :style="`opacity: ${linkHover[i].opacity};`" />
                    </g>
                </g>
            </g>
        </svg>
    </div>
</template>

<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';
import { sleepAsync } from '@/utils/common'
import * as d3 from 'd3'
import { CodeBase } from '@/data/sampleCode'

import { CobolFile } from '@/../../src/types'


@Component({
    components: {

    },
})
export default class Home extends Vue
{
    debugHide = false
    d3Ready = false
    padding = 1

    codeBase = CodeBase
    cobolAnalysisData!: CobolFile[];

    showOverview = true

    currentMove: any = null

    width = window.innerWidth
    height = window.innerHeight

    simulation!: d3.Simulation<{ index: number; x: number; y: number; }, undefined>

    offsetX = 0
    offsetY = 0

    offset = false

    showSection = false

    graph = {
        nodes: [] as any[],
        links: [] as any[]
    }

    set expandAll(value: boolean)
    {
        this.codeBase.expandedAll = value
        this.codeBase.cobolFiles.forEach(x => x.expanded = value)
    }

    get expandAll()
    {
        return this.codeBase.expandedAll
    }

    get bounds()
    {
        return {
            minX: Math.min(...this.graph.nodes.map(n => n.x / 5)),
            maxX: Math.max(...this.graph.nodes.map(n => n.x / 5)),
            minY: Math.min(...this.graph.nodes.map(n => n.y / 5)),
            maxY: Math.max(...this.graph.nodes.map(n => n.y / 5))
        }
    }

    async onSectionClick(file: string, section: string)
    {
        console.log("section click", file, section)
        await fetch(`http://localhost:30001/api/open?file=${encodeURIComponent(file + ".cbl")}&section=${encodeURIComponent(section)}`)

    }

    onHoverLink(i: number, state: boolean)
    {
        if (state)
        {
            this.linkHover.forEach((x, ii) => x.opacity = i === ii ? 1 : 0.1)
        }
        else
        {
            this.linkHover.forEach(x => x.opacity = 0.5)
        }
    }

    onHoverCard(i: number, state: boolean)
    {
        if (state)
        {
            this.linkHover.forEach((x) => x.opacity = x.source === i ? 1 : 0.1)
        }
        else
        {
            this.linkHover.forEach(x => x.opacity = 0.5)
        }
    }

    coords = [] as { x: number, y: number }[]
    linkHover: { source: number, target: number, opacity: number }[] = []

    offsetting()
    {
        this.offset = true;
    }

    drag(e: MouseEvent)
    {
        if (this.offset)
        {
            this.offsetX += e.movementX
            this.offsetY += e.movementY
        }
    }

    drop()
    {
        // delete this.currentMove.node.fx
        // delete this.currentMove.node.fy
        // this.currentMove = null
        // this.simulation.alpha(1)
        // this.simulation.restart()

        this.offset = false

        // console.log("ticks", this.ticks)
    }

    created()
    {
        console.log("created")
    }

    ticks = 0

    async mounted()
    {
        this.d3Ready = false
        console.log("mounted")

        void ((window as any)['codeBase'] = this.codeBase)
        window.addEventListener('mouseup', (event) =>
        {
            this.offset = false
        })

        this.cobolAnalysisData = await (await fetch("./data/cobols_predicts.json")).json() as CobolFile[]


        this.codeBase.cobolFiles = this.cobolAnalysisData.map(x => ({
            expanded: false,
            focus: false,
            name: x.name,
            type: x.presence,
            sections: x.sections.map(y => ({
                name: y.raw.split("\n")[0],
                important: y.importance,
                confidence: y.confidence
            }))
        }))

        const links = []
        const dupLinks = new Set<string>()

        for (let i = 0; i < this.cobolAnalysisData.length; i++)
        {
            const element = this.cobolAnalysisData[i];
            for (const section of element.sections)
            {
                for (const call of section.calls)
                {
                    const target = this.cobolAnalysisData.find(x => x.name === call.target)
                    if (!target)
                    {
                        console.log("missing", element.name, call.target)
                        continue
                    }
                    const targetIndex = this.cobolAnalysisData.indexOf(target)
                    const linkKey = `${i},${targetIndex}`
                    if (!dupLinks.has(linkKey))
                    {
                        dupLinks.add(linkKey)
                        links.push({ source: i, target: targetIndex })
                    }
                    else
                    {
                        console.log("Duplicate link", element.name, target.name)
                    }
                }
            }
        }

        this.graph = {
            nodes: d3.range(this.codeBase.cobolFiles.length).map(i => ({ index: i, x: 0, y: 0 })),
            links: links
        }

        this.linkHover = this.graph.links.map(x => ({source: x.source, target: x.target, opacity: 0.5}))

        let svg = d3.select("#force-graph")

        svg.append("defs")
            .append("marker")
            .attr("id", "arrowhead")
            .attr("viewBox", "0 -5 10 10")
            .attr("refX", 5)
            .attr("refY", 0)
            .attr("markerWidth", 5)
            .attr("markerHeight", 5)
            .attr("orient", "auto")
            .append("path")
            .attr("d", "M0,-5L10,0L0,5");


        this.simulation = d3.forceSimulation(this.graph.nodes as any[])
            .force('charge', d3.forceManyBody())
            .force('link', d3.forceLink(this.graph.links))
            .force('x', d3.forceX())
            .force('y', d3.forceY())
            // .force("collide", d3.forceCollide().radius(50))
            .on("tick", () =>
            {
                this.coords = this.graph.nodes.map(node =>
                {
                    return {
                        x: this.padding + (node.x - this.bounds.minX) * (this.width - 2 * this.padding) / (this.bounds.maxX - this.bounds.minX),
                        y: this.padding + (node.y - this.bounds.minY) * (this.height - 2 * this.padding) / (this.bounds.maxY - this.bounds.minY)
                    }
                })
                this.ticks++

                if (this.ticks === 100)
                {
                    this.simulation.stop()
                }
            })

        this.d3Ready = true
    }

    unmounted()
    {
        console.log(`unmounted ${this.constructor.name}`)
    }
}
</script>

<style>
</style>

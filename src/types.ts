
export type CobolFile = {
    file: string
    presence: "source" | "specs" | "missing"
    name: string
    sections: CobolSection[]
}

export type CobolSection = {
    file: string,
    importance: boolean
    confidence: number
    calls: CobolSectionCall[]
    raw: string
}

export type CobolSectionCall = {
    type: string
    target: string
    copybook?: string
}

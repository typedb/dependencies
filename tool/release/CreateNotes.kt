package com.vaticle.dependencies.tool.release

fun main() {
    // input:
    //  - arg1: which commit to release

    //  - to = arg1
    //  - from = release with a tag that precedes it and is closest to it semantically.
    //  for (c: from..to):
    //    pr = get_pr(c)
    //    if (pr != null):
    //      note = title: pr.title, desc: pr.desc, type: pr.label('type')
    //    else:
    //      note = title: c.message.first_line(), desc: c.message.second_line_onwards(), type: 'others'
    //    notes += note
    println("hello")
}
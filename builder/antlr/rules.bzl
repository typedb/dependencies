# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

def python_grammar_adapter(
        name,
        input,
        output):
    native.genrule(
        name = name,
        srcs = [input],
        outs = [output],
        cmd_bash = "$(location @vaticle_dependencies//builder/antlr:grammar-adapter) --in $< --out $@ --adapt-keyword type --adapt-keyword filter",
        tools = ["@vaticle_dependencies//builder/antlr:grammar-adapter"],
    )

def python_grammar_modifier(
        name,
        input,
        output):
    native.genrule(
        name = name,
        srcs = [input],
        outs = [output],
        cmd_bash = "$(location @vaticle_dependencies//builder/antlr:grammar-modifier) --in $< --out $@ --keyword type --keyword filter",
        tools = ["@vaticle_dependencies//builder/antlr:grammar-modifier"],
    )

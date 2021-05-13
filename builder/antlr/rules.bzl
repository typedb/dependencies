def python_grammar_converter(
        name,
        input,
        output):
    native.genrule(
        name = name,
        srcs = [input],
        outs = [output],
        cmd_bash = "$(location @vaticle_dependencies//builder/antlr:grammar-converter) --in $< --out $@ --keyword type --keyword filter",
        tools = ["@vaticle_dependencies//builder/antlr:grammar-converter"],
    )

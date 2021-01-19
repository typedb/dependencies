def expand_label(name):
    """
    Expands incomplete labels without target names into full ones, e.g.:
    "//pattern" -> "//pattern:pattern"
    """
    if ":" not in name:
        name = name + ":" + name[name.rfind("/")+1:]
    return name


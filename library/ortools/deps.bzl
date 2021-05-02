google_or_tools = select({
         "@vaticle_dependencies//util/platform:is_mac": [
             "@maven//:com_google_ortools_ortools_darwin",
             "@maven//:com_google_ortools_ortools_darwin_java",
         ],
         "@vaticle_dependencies//util/platform:is_linux": [
             "@maven//:com_google_ortools_ortools_linux_x86_64",
             "@maven//:com_google_ortools_ortools_linux_x86_64_java"
         ],
         "@vaticle_dependencies//util/platform:is_windows": [
             "@maven//:com_google_ortools_ortools_win32_x86_64",
             "@maven//:com_google_ortools_ortools_win32_x86_64_java"
         ],
         "//conditions:default": [
             "@maven//:com_google_ortools_ortools_darwin",
             "@maven//:com_google_ortools_ortools_darwin_java",
         ],
     })

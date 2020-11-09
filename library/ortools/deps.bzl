google_or_tools = select({
         "@graknlabs_dependencies//library/ortools:is_mac": [
             "@maven//:com_google_ortools_ortools_darwin",
             "@maven//:com_google_ortools_ortools_darwin_java",
         ],
         "@graknlabs_dependencies//library/ortools:is_linux": [
             "@maven//:com_google_ortools_ortools_linux_x86_64",
             "@maven//:com_google_ortools_ortools_linux_x86_64_java"
         ],
         "@graknlabs_dependencies//library/ortools:is_windows": [
             "@maven//:com_google_ortools_ortools_win32_x86_64",
             "@maven//:com_google_ortools_ortools_win32_x86_64_java"
         ],
         "//conditions:default": [
             "@maven//:com_google_ortools_ortools_darwin",
             "@maven//:com_google_ortools_ortools_darwin_java",
         ],
     })

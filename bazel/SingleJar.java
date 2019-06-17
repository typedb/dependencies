package grakn.buildtools;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class SingleJar {
    private final static Pattern JAVA_PACKAGE_PATTERN = Pattern.compile("package\\s+([\\w.]+);");
    private final static String[] SINGLEJAR_LOCATIONS = {
            // bazel v0.25.2 and before [Linux/macOS]
            "/tools/jdk/singlejar/singlejar",
            // bazel v0.26.0 and onwards [Linux/macOS]
            "/tools/singlejar/singlejar_local",
            // bazel v0.25.2 and before [Windows]
            "/tools/jdk/singlejar/singlejar.exe",
            // bazel v0.26.0 and onwards [Windows]
            "/tools/singlejar/singlejar_local.exe"
    };

    private static String javaPackage(String sourcePath) throws IOException {
        for (String line : Files.readAllLines(Paths.get(sourcePath))) {
            Matcher lineMatcher = JAVA_PACKAGE_PATTERN.matcher(line);
            if (lineMatcher.find()) {
                return lineMatcher.group(1);
            }
        }
        return null;
    }

    private static String unpackSingleJar() throws IOException {
        File singlejar = File.createTempFile("singlejar", "");
        singlejar.deleteOnExit();

        if (!singlejar.setExecutable(true)) {
            throw new RuntimeException("Could not make singlejar executable");
        }

        int i;
        byte[] buf = new byte[8192];

        InputStream is = null;
        for (String singleJarLocation : SINGLEJAR_LOCATIONS) {
            // iterate over all possible locations of singlejar
            is = SingleJar.class.getResourceAsStream(singleJarLocation);
            if (is != null) {
                break;
            }
        }

        if (is == null) {
            throw new RuntimeException("Could not find singlejar executable in JAR");
        }

        try (InputStream fileStream = is;
             OutputStream out = new FileOutputStream(singlejar)) {

            while ((i = fileStream.read(buf)) != -1) {
                out.write(buf, 0, i);
            }
        }

        return singlejar.getAbsolutePath();
    }

    private static void patchSourceJarLinks(String[] args) throws IOException {
        boolean inResources = false;
        for (int i = 0; i < args.length; i++) {
            String line = args[i];
            if (line.equals("--resources")) {
                inResources = true;
                continue;
            } else if (inResources && line.startsWith("--")) {
                break;
            }

            if (inResources) {
                String[] fl = line.split(":");
                if (fl.length == 2) {
                    String originalFn = fl[0];
                    String archiveFn = fl[1];

                    if (originalFn.endsWith(".java") && archiveFn.endsWith(".java")) {
                        // we are sure to map source file to source file
                        String resultingPath = javaPackage(originalFn).replaceAll("\\.", "/") + "/" + Paths.get(originalFn).getFileName().toString();
                        args[i] = String.format("%s:%s", originalFn, resultingPath);
                    }
                }
            }
        }
    }


    public static void main(String[] args) throws IOException, InterruptedException {
        List<String> singleJarWithArgs = new ArrayList<>(args.length);

        for (String arg : args) {
            String newArg = arg;
            if (arg.startsWith("@") && arg.endsWith(".params")) {
                // @fn signifies that command-line arguments
                // will be expanded from file with name 'fn'
                Path fn = Paths.get(arg.replace("@", ""));
                String[] lines = Files.readAllLines(fn).toArray(new String[0]);
                patchSourceJarLinks(lines);

                File paramsFile = File.createTempFile("patched.params", "");
                Files.write(paramsFile.toPath(), Arrays.asList(lines));
                newArg = "@" + paramsFile.toPath().toString();
            }
            singleJarWithArgs.add(newArg);
        }

        singleJarWithArgs.add(0, unpackSingleJar());
        Process process = new ProcessBuilder(singleJarWithArgs).inheritIO().start();
        System.exit(process.waitFor());
    }
}

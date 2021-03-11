package tool.util

import java.net.InetAddress
import java.net.UnknownHostException
import kotlin.system.exitProcess

fun ensureHostIsAvailable(host: String, indent: Int) {
    var indentText = " ".repeat(indent)
    println("${indentText}Waiting for hostname '$host' to be available...")
    var attempt = 0;
    var hostIsAvailable = false
    while (!hostIsAvailable && attempt++ < 100) {
        try {
            InetAddress.getAllByName(host)
            println("$indentText  '$host' is available!")
            hostIsAvailable = true
        } catch (e: UnknownHostException) {
            println("$indentText  '$host' not available (attempt $attempt).")
            Thread.sleep(2000L);
        }
    }
    if (!hostIsAvailable) {
        println("ERROR: $attempt attempts reached, but host is still unreachable")
        exitProcess(1)
    }
}

fun main(hosts: Array<String>) {
    val totalAttempts = 15
    for (host in hosts) {
        println("--- Performing checks for hostname $host ---")
        for (attempt in 0..totalAttempts) {
            if (attempt == 1) {
                println("Ensuring that the hostname is consistently available by querying it 15 times (some DNS implementations are unstable)...")
            }
            var indent = 0;
            if (attempt > 0) {
                indent = 2;
            }
            ensureHostIsAvailable(host, indent)
            Thread.sleep(2000L)
        }
        println("Hostname '$host' has been verified to be consistently available!")
        println()
    }
}

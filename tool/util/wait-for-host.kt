package tool.util

import java.net.InetAddress
import java.net.UnknownHostException
import kotlin.system.exitProcess

fun ensureHostIsAvailable(host: String) {
    var attempt = 0;
    var hostIsAvailable = false
    while (!hostIsAvailable && attempt++ < 100) {
        println("Waiting for host $host: (attempt $attempt).")
        try {
            InetAddress.getAllByName(host)
            println("Host $host available after $attempt attempts).")
            hostIsAvailable = true
        } catch (e: UnknownHostException) {
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
        for (attempt in 1..totalAttempts) {
            println("Verifying whether host $host is available: attempt $attempt of $totalAttempts")
            ensureHostIsAvailable(host)
            Thread.sleep(2000L)
        }
    }
}

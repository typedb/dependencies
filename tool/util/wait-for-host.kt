package tool.util

import java.net.InetAddress
import java.net.UnknownHostException
import kotlin.system.exitProcess

fun main(args: Array<String>) {
    for (i in 1..6) {
        var attempt = 0;
        val host = args[0]
        var hostIsUnavailable = true
        while (hostIsUnavailable && attempt++ < 100) {
            println("Waiting for host $host: (attempt $i/$attempt).")
            try {
                InetAddress.getAllByName(host)
                println("Host $host available after $i/$attempt attempts).")
                hostIsUnavailable = false
            } catch (e: UnknownHostException) {
                Thread.sleep(2000L);
            }
        }
        if (hostIsUnavailable) {
            println("ERROR: $attempt attempts reached, but host is still unreachable")
            exitProcess(1)
        }
    }
}
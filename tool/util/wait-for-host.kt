package tool.util

import java.net.InetAddress
import java.net.UnknownHostException
import kotlin.system.exitProcess

fun main(args: Array<String>) {
    var attempt = 0;
    val host = args[0]
    while (attempt++ < 100) {
        println("Waiting for host ${host}: (attempt $attempt).")
        try {
            InetAddress.getAllByName(host)
            println("Host ${host} available after $attempt attempts).")
            return;
        } catch (e: UnknownHostException) {
            Thread.sleep(2000L);
        }
    }
    println("ERROR: $attempt attempts reached, but host is still unreachable")
    exitProcess(1)
}
docker run -d -p 443:8443 -p 80:8081 --restart=on-failure --name nexus -v nexus-data:/nexus-data -e NEXUS_CONTEXT=/ sonatype/nexus3:3.33.0

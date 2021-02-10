docker run -d -p 443:8443 -p 80:8081 --name nexus-repo -v nexus-data:/nexus-data -e NEXUS_CONTEXT=/ nexus-repository-apt:3.15.2

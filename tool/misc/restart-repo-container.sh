#!/usr/bin/env bash
exec gcloud compute ssh repo-grakn-ai --project grakn-dev --zone europe-west1-b -- docker container restart nexus

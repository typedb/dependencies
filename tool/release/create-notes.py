#!/usr/bin/env python

import github
import os
import re
import sys
from io import open

GITHUB_TOKEN = os.getenv('RELEASE_NOTES_TOKEN')
if GITHUB_TOKEN is None:
    raise Exception("$RELEASE_NOTES_TOKEN is not set!")

if len(sys.argv) < 3:
    raise Exception("Arguments: <repo-name> <milestone-name>")

graknlabs = 'graknlabs'
github_connection = github.Github(GITHUB_TOKEN)
github_org = github_connection.get_organization(graknlabs)

release_notes_template_regex = r'{.*release notes.*}'

def pull_request_notes(pull_request):
    pull_notes = "- **{0}.**\n".format(pull_request.title)
    header = 0
    for line in pull_request.body.splitlines():
        if line[:2] == "##":
            header += 1
        elif header == 1 and len(line) > 0:
            pull_notes += "  " + line + "\n"
        elif header > 1:
            break
    return pull_notes

if __name__ == '__main__':
    release_repo_name = sys.argv[1]
    release_milestone_title = sys.argv[2]
    release_template_file = sys.argv[3]

    print("release repo: " + release_repo_name)
    print("release milestone: " + release_milestone_title)

    github_repo = github_org.get_repo(release_repo_name)
    github_milestones = github_repo.get_milestones(state="all")

    release_milestone = None
    for milestone in github_milestones:
        if milestone.title == release_milestone_title:
            release_milestone = milestone

    if release_milestone is None:
        raise Exception("Repo {0} does not contain milestone {1}"
                        .format(release_repo_name, release_milestone_title))

    release_milestone_issues = github_repo.get_issues(milestone=release_milestone, state="all")

    pull_features = []
    pull_bugs = []
    pull_refactors = []
    pull_others = []
    for issue in release_milestone_issues:
        if issue.state != "closed":
            raise Exception("At least issue/PR #{0} is not closed. There may be others too. "
                            "Please close all issues & PRs in milestone {1} before proceeding."
                            .format(issue.number, release_milestone.title))
        elif issue.pull_request is not None:
            pull = github_repo.get_pull(issue.number)
            if pull.merged:
                print("PR {0} will be compiled into the release notes.".format(pull.number))
                labels = [label.name for label in pull.labels]
                if "feature" in labels:
                    pull_features.append(pull)
                elif "bug" in labels:
                    pull_bugs.append(pull)
                elif "refactor" in labels:
                    pull_refactors.append(pull)
                else:
                    pull_others.append(pull)
            else:
                print("PR {0} was not merged and will be ignored.".format(pull.number))

    release_notes = ""

    release_notes += "\n## New Features\n\n"
    for pull in pull_features:
        release_notes += pull_request_notes(pull)
        release_notes += "\n"

    release_notes += "\n## Bugs Fixed\n\n"
    for pull in pull_bugs:
        release_notes += pull_request_notes(pull)
        release_notes += "\n"

    release_notes += "\n## Code Refactors\n\n"
    for pull in pull_refactors:
        release_notes += pull_request_notes(pull)
        release_notes += "\n"

    release_notes += "\n## Other Improvements\n\n"
    for pull in pull_others:
        release_notes += pull_request_notes(pull)
        release_notes += "\n"

    release_template_filepath = os.path.join(os.getenv("BUILD_WORKSPACE_DIRECTORY"), release_template_file)

    with open(release_template_filepath) as filepath:
        release_notes_content = filepath.read()

    release_notes_content = re.sub(release_notes_template_regex, release_notes, release_notes_content, 1, flags=re.IGNORECASE)

    with open(release_template_filepath, 'w', encoding='utf-8') as filepath:
        filepath.write(release_notes_content)

    release_milestone.edit(release_milestone.title, state="closed")

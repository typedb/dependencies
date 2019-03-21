#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2018 Grakn Labs Ltd
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

def _workspace_refs_impl(repository_ctx):
    repository_ctx.file('BUILD', content='exports_files(["refs.json"])', executable=False)
    workspace_refs_dict = {
        "commits": repository_ctx.attr.workspace_commit_dict,
        "tags": repository_ctx.attr.workspace_tag_dict,
    }
    repository_ctx.file('refs.json', content=struct(**workspace_refs_dict).to_json(), executable=False)

_workspace_refs = repository_rule(
    implementation = _workspace_refs_impl,
    attrs = {
        'workspace_commit_dict': attr.string_dict(),
        'workspace_tag_dict': attr.string_dict(),
    },
)

def workspace_refs(name):
    _workspace_refs(
        name = name,
        workspace_commit_dict = {k: v['commit'] for k, v in native.existing_rules().items() if 'commit' in v and len(v['commit'])>0},
        workspace_tag_dict = {k: v['tag'] for k, v in native.existing_rules().items() if 'tag' in v and len(v['tag'])>0}
    )
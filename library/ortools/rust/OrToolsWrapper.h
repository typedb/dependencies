// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/./

using namespace std;

namespace operations_research {
    using MPSolverResultStatus = MPSolver::ResultStatus;

    std::unique_ptr<MPSolver> new_mpsolver() {
      return std::unique_ptr<MPSolver>(MPSolver::CreateSolver("SCIP"));
    }
}

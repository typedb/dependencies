//
// Copyright (C) 2021 Vaticle
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

#[cxx::bridge(namespace = "operations_research")]
pub mod ffi {
    #[repr(i32)]
    #[derive(Debug)]
    enum MPSolverResultStatus {
        /// optimal.
        OPTIMAL,
        /// feasible, or stopped by limit.
        FEASIBLE,
        /// proven infeasible.
        INFEASIBLE,
        /// proven unbounded.
        UNBOUNDED,
        /// abnormal, i.e., error of some kind.
        ABNORMAL,
        /// the model is trivially invalid (NaN coefficients, etc).
        MODEL_INVALID,
        /// not been solved yet.
        NOT_SOLVED = 6
    }

    extern "C++" {
        include!("ortools/linear_solver/linear_solver.h");
        include!("library/ortools/rust/OrToolsWrapper.h");
        type MPSolverResultStatus;
    }

    unsafe extern "C++" {
        // no need to repeat includes - they are done in the previous block
        type MPSolver;
        type MPVariable;
        type MPConstraint;
        type MPObjective;

        fn new_mpsolver() -> UniquePtr<MPSolver>;
        fn MakeIntVar(self: Pin<&mut MPSolver>, lb: f64, ub: f64, name: &CxxString) -> *mut MPVariable;

        fn solution_value(self: &MPVariable) -> f64;

        fn NumVariables(self: &MPSolver) -> i32;
        fn MakeRowConstraint(self: Pin<&mut MPSolver>, lb: f64, ub: f64, name: &CxxString) -> *mut MPConstraint;
        unsafe fn SetCoefficient(self: Pin<&mut MPConstraint>, var: *const MPVariable, coeff: f64);

        fn MutableObjective(self: Pin<&mut MPSolver>) -> *mut MPObjective;
        unsafe fn SetCoefficient(self: Pin<&mut MPObjective>, var: *const MPVariable, coeff: f64);
        // fn SetMinimization(self: Pin<&mut MPObjective>);
        fn SetMaximization(self: Pin<&mut MPObjective>);

        fn Value(self: &MPObjective) -> f64;

        fn Solve(self: Pin<&mut MPSolver>) -> MPSolverResultStatus;
    }
}

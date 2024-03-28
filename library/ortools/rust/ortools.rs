// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

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

# streaklines

Compute particle streaklines on large unsteady flow datasets. Geometry tools are included to linear arrays of oscillating villi (to be published in an upcoming paper).

## Setup
call `setupPaths.m` to add the code to the matlab path

## Generating Unsteady Flow Datasets
This solver integrates unsteady vector fields saved on disk. Each timestep should be stored in a separate matlab binary `.mat` files named `frame<i>.mat` under some directory `matDir/`

### Metadata
A `metadata.mat` file included in `matDir/` indicates villi dimensions, pattern, time between frames etc.  Examples are included in `metadata/`. `experiment1Hz.mat` matches my experiment whereas `simulation1Hz.mat` is matches Justin's example CFD sim. A `metadata.mat` file should include
* `Pattern`   - villi pattern params
* `Villi`     - villi dimensions. These are automatically scaled to sim units in `Villi.m`
* `Tank`      - number of villi and spacing
* `timeDelta` - Constant time delta between frames

### Converting Tecplot Ascii to Matlab Binary (.dat -> .mat)
Individual files are converted with `parseTecplot.m`. To batch a dataset, use `dat2mat.m`, which saves `metadata.mat` as well.

## Frame Interpolator
The `FrameInterpolator` handle class interpolates a dataset with FIFO frame caching.

## Solution
A `Solution` struct contains computed trajectories and data needed for integration (model of villi / interpolator / `Settings` / ...). 

`solution = trackParticles(solution, tSpan, outDir)` performs integration by calling `ode45` until the end of `tSpan` is reached. Individual calls to `ode45` halt on particle crash events or to save data. Integrator settings are read from the `solution` struct, default settings are in `Settings.m` 

##### Particle Tracking Setup
* Create a new solution with `solution = Solution(matDir)`
* Add particles using `solution = addParticles(solution, xp, yp)`.
* Solve for particle trajectories `solution = trackParticles(solution, tSpan, outDir)`

## Plotting and Rendering
* `plotInitialCondition.m` initial condition
* `plotSolution.m` trajectories/streaklines
* `animate.m` animates to solution to screen / renders video to files

`src/plots/` contains plotting tools

## Tests
Call `tests.m` to run tests. Currently checks a few streaklines in some very simple steady flows (horizontal / vertical / rigid body vortex)

## Example Scripts
Checkout `examples/` for some example scripts including batching tecplot conversion, and particle tracking with TSection and uniform grid particle formations.


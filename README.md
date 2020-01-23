# Evaluating transmission scenarios for the Wuhan outbreak

**Aim:** Can we rule out transmission scenarios and give thresholds for other potential scenarios?

## Scenarios
​
1. Massive point source with very low human to human transmission (low R0).
2. Smaller point source with ongoing human -> human transmission (higher R0).
​
## Explore
​
* Look at transmission and point source scenarios to see what the probability is that R0 is greater than 1.
* Need multiple scenarios to check with generation time (could look at short and long (SARS ~ 8.7 days))
* Scenarios around how long the point source lasted (gene sequences indicate the 16th of December as the point estimate).

## Analysis

### Data

* Total cases

### Model

Parameters:

- Serial interval ($$T_{serial}$$)
- $$R_{0}$$ 
- Initial cluster size ($$N_{init}$$)


* Deterministic option:

  No. Generations $$G = (t/T_{serial})  - 1$$

  $$N = N_init * R_{0} ^ G$$

* Need to add seeding event size and duration (possibly by running a new outbreak from each daily seeding event)?
* Need an observation model (negative binomial?)
* Use branching process model from Joel's work

### Scenario analysis

* Stratify the analysis by seeding event size and duration:
  * Event size: 20, 40, 60, 80, 100
  * Event duration: 7 days, 14 days, 28 days
  * Case detection (and definition): 0.2, 0.4, 0.6, 0.8
* Sampled parameters:
  * Incubation period: 5 days (*CI needed*)
  * Generation time: 8-9 days (*CI needed*)
* Fitted parameters
  * R0: Uniform(0, 5) prior

  #### Analysis implementation

  ##### Option 1

  1. Base the branching process model on Joel's (initially Adam's) approach.
  2. Run the model for each fixed parameter scenario.
    * For each day of the seeding event, seeding the number of initial cases expected on that day
    * Run the observation model on the overall number of expected cases for each seeded outbreak
    * Summarise the overall outbreak
    * Fit R0 for the sampled outbreaks - *How should this be done?*
  3. Compare fitted R0s across scenarios.

##### Option 2

1. Implement the branching process model into STAN with an embedded observation model
2. Fit the model as above but using MCMC and holding all parameters except for R0 at their prior distribution.
3. Compare fitted R0s across scenarios.

### Output

* Grid of event size vs event duration with R0 estimates for each comparison for each case detection.
* Grid acreas can be rejected based on?

## Usage

### Set up

* Set your working directory to the home directory of this project (or use the provided Rstudio project).

* Run the following to check the installation of all required packages.

### Folders

### Run an analysis


### Additional functions (see `functions`)

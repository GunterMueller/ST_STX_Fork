/*
 * Run default pipeline. See `steps.groovy` for details.
 */

def steps;

/*
 * A helper function to return a branch to build.
 *
 * For normal jobs this is the value of 'Branch' field from SCM configuration.
 * For multibranch jobs, this is the value of BRANCH_NAME environment variable.
 *
 * This is the same as build() function in `steps.groovy` and should be kept
 * in sync. We cannot use the one there as we yet have to load it.
 */
def branch() {
    if (env.BRANCH_NAME == null) {
        return scm.getBranch();
    } else {
        return env.BRANCH_NAME;
    }
}

stage ( "Load Pipeline") {
    node {
        /*
         * Do not use default workspace here as checkout
         * would erase all contents. Use a dedicated
         * workspace instead
         */
        ws ("workspace/${env.JOB_NAME}@loadpipeline") {
            sshagent([ scm.getCredentialsId() ]) {
                sh  """
                    if [ -f ci/steps.groovy ]; then
                        hg pull --ssh ssh ${scm.getSource()}
                    else
                        hg clone --ssh ssh ${scm.getSource()} .
                    fi
                    hg up ${branch()}
                    """
            }
            steps = load "ci/steps.groovy"
        }
    }
}

/*
 * Set the branch to build to make sure it's in sync
 */
steps.branch = branch()

/*
 * If we're building a 'default' branch, run "integration" pipeline. Otherwise,
 * run normal "build" pipeline, assuming this build is just a test build for
 * some feature-in-progress. If different logic is needed, then make a branch
 * and modify this file
 */
if ( branch().equals("default") ) {
    steps.integration()
} else {
    steps.build()
}

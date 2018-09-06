/*
 * Jenkins Pipeline definitions for Smalltalk/X jv-branch
 *
 * Following stepss are defined here:
 *
 *  * `build()` - compiles and tests all supported configurations
 *    No artifacts are archived
 *
 *  * `integration()` - like `build()` steps, then all test pass on all
 *    configurations, archive artifacts and push staged changes to opstream
 *    (if approvec by the user)
 */

import com.cloudbees.plugins.credentials.CredentialsProvider;
import com.cloudbees.plugins.credentials.common.StandardUsernameCredentials;
import com.cloudbees.jenkins.plugins.sshcredentials.SSHUserPrivateKey;

/**
 * Supported configurations. To overwrite, do:
 *
 *     ...
 *     steps = load "steps.groovy"
 *     ...
 *     steps.configurations = [ 'BUILD_TARGET': 'mips-sgi-irix' ]
 *     ...
 *
 * Default value: see below.
 */
configurations = [
    'BUILD_TARGET': ['i686-pc-mingw32' , 'x86_64-w64-mingw32', 'i686-pc-linux-gnu', 'x86_64-pc-linux-gnu' ]
]

/** Branch to build. To overwrite do:
 *
 *     ...
 *     steps = load "steps.groovy"
 *     ...
 *     steps.branch = "issue-123"
 *     ...
 *
 * Default value:
 * For multibranch jobs, this is the value of BRANCH_NAME environment variable.
 * For normal jobs this is the value of 'Branch' field from SCM configuration.
 *
 * Due to Jenkins internals, the fallback to use SCM configuration must be done
 * by 'user' of this variable (i.e., use `branch != null ? branch : scm.getBranch())
 */
branch = env.BRANCH_NAME

/**
 * Workspace to use. To overwrite do:
 *
 *     ...
 *     steps = load "steps.groovy"
 *     ...
 *     steps.workspace = "some-other-job"
 *     ...
 *
 * Default value:
 * Name of current job.
 */
workspace = env.JOB_NAME

/*
 * "Default" steps:
 */
def build() {
    stage ( "Build" ) {
        matrix ( configurations ) {
            stage ( "Checkout - {${env.BUILD_TARGET}} " ) {
                sshagent([ scm.getCredentialsId() ]) {
                    branch_to_use = branch != null ? branch : scm.getBranch()
                    sh  """
                        if [ -f build.rb ]; then
                            hg pull --ssh ssh ${scm.getSource()}
                        else
                            hg clone --ssh ssh ${scm.getSource()} .
                        fi
                        hg up ${branch_to_use}
                        """
                    sh  "ruby build.rb --project \"stx:jv-branch\" --build-target ${env.BUILD_TARGET} update"
                }
            }

            stage ( "Compile - {${env.BUILD_TARGET}}") {
                sh "ruby build.rb --project \"stx:jv-branch\" --build-target ${env.BUILD_TARGET} compile"
            }
        }
    }

    stage ( "Test" ) {
        matrix ( configurations ) {
            stage ( "Test - {${env.BUILD_TARGET}}") {
                /*
                 * Some tests requires display, so:
                 *
                 *  * on *NIX hosts, launch Xvfb
                 *  * on Windows, do nothing. Windows slave must be configured
                 *    so it has an access to interactive window station (which
                 *    means it has to run under user session, not as a service)
                 */
                if ( isUnix() ) {
                    wrap([$class: 'Xvfb', autoDisplayName: true, additionalOptions: '-screen 0 1024x768x24 -pixdepths 24 4 8 15 16 32', parallelBuild: true]) {
                        sh "ruby build.rb --project \"stx:jv-branch\" --build-target ${env.BUILD_TARGET} test"
                    }
                } else {
                    sh "ruby build.rb --project \"stx:jv-branch\" --build-target ${env.BUILD_TARGET} test"
                }
                junit allowEmptyResults: true, testResults: "reports/*build${env.BUILD_NUMBER}*.xml"
            }
        }
    }
}

/*
 * "Integration" steps
 */
def integration() {
    build()
    /*
     * If a single test fails, abort the steps. There's no point
     * archiving a broken build.
     */
    println "Smalltalk/X built, job status is: ${currentBuild.result}"
    if ( currentBuild.result == 'UNSTABLE' ) {
        return;
    }
    artifacts()

    /*
     * Check if there are changes to be pushed to upstream. If so,
     * ask user to approve that push
     */
    if ( changes() ) {
        def integrate = false;

        if (env.JENKINS_URL == "https://swing.fit.cvut.cz/jenkins/") {
            integrate = true;
        } else {
            integrate = input(message: 'Integrate all staged changes to upstream?',
                              parameters: [
                                    booleanParam(name: "Integrate changes",
                                         description: 'If checked, all staged changes will be pushed to an upstream repository',
                                         defaultValue: true)]);
        }
        if ( integrate ) {
            push()
        }
    }
}

/*
 * Publish built artifacts to download server
 */
def publish(dir) {
    Calendar current = Calendar.getInstance()
    Calendar scheduled = current.clone()

    /*
     * Schedule the upload to the next day, 3am in the morning
     */
    scheduled.add(Calendar.DATE, 1)
    scheduled.set(Calendar.HOUR_OF_DAY, 3)

    build(job:        'stx_jv_publish',
          parameters: [
                        string(name: 'job', value: env.JOB_NAME),
                        string(name: 'srv', value: env.STX_PUBLISH_SERVER),
                        string(name: 'dir', value: "${env.STX_PUBLISH_DIRECTORY}/${dir}")
                      ],
          quietPeriod: (scheduled.getTimeInMillis() - current.getTimeInMillis()) / 1000,
          wait: false)
}



/*
 * Utility. Return true, if there are any changes to be pushed to an upstream,
 * false othervise.
 */
def changes() {
    changes = false;
    any ( configurations ) {
        withCredentialsForUpstream() { user, pass ->
            status = sh ( script: "rake \"workflow:out-upstream[${user}, ${pass}]\"", returnStatus: true)
        }
        changes = status == 0;
    }
    return changes;
}

def combine(configurations, axes = null, axis = 0, partial = new HashMap(), combinations = []) {
    def axes0 = axes
    if (axes0 == null) {
        axes0 = configurations.keySet().toArray();
    }
    if ( axis < axes0.length ) {
        for ( value in configurations[axes0[axis]] ) {
            def combined = partial.clone()
            combined[axes0[axis]] = value
            combine(configurations, axes0, axis + 1, combined, combinations)
        }
    } else {
        combinations.add(partial)
    }
    return combinations;
}


def matrix(configurations, block) {
    def combinations = combine(configurations).toArray()
    def branches = [failFast: true]
    for (i = 0; i < combinations.length; i++) {
        def index = i
        def conf = combinations[i];
        branches["${conf.BUILD_TARGET}"] = {
            node ( conf.BUILD_TARGET ) {
                def newEnv = []
                for (k in conf.keySet()) {
                    newEnv.add("${k}=${conf[k]}")
                }
                withEnv ( newEnv ) {
                    ws ("workspace/${workspace}/${env.BUILD_TARGET}") {
                        block()
                    }
                }
            }
        }
    }
    parallel branches
}



def any(configurations, block) {
    def axes = configurations.keySet().toArray()
    def conf = [:]
    for (axis in axes) {
        conf[axis] = configurations[axis][0]
    }
    node ( conf.BUILD_TARGET ) {
        def newEnv = []
        for (k in conf.keySet()) {
            newEnv.add("${k}=${conf[k]}")
        }
        withEnv ( newEnv ) {
            ws ("workspace/${workspace}/${env.BUILD_TARGET}") {
                block()
            }
        }
    }
}


def artifacts() {
    matrix ( configurations ) {
        stage ( "Artifacts - {${env.BUILD_TARGET}}") {
            sh "ruby build.rb --project \"stx:jv-branch\" --build-target ${env.BUILD_TARGET} artifacts"
            archiveArtifacts artifacts: "artifacts/*build${env.BUILD_NUMBER}*.zip, artifacts/*build${env.BUILD_NUMBER}*.bz2, artifacts/*build${env.BUILD_NUMBER}*.sha256", fingerprint: true//, onlyIfSuccessful: true
        }
    }
}

/**
 * Push changes to upstream reporitory. To be called after a successful
 * build. See #build()
 */
def push() {
    any ( configurations ) {
        stage ( "Push to upstream" ) {
            withCredentialsForUpstream { user, pass ->
                sh "rake \"workflow:push-upstream[${user}, ${pass}]\""
            }
        }
    }
}

/*
 * Utility. Executes given block with credentials for upstream repository.
 */
def withCredentialsForUpstream(block) {
    /*
     * Kludge: Upstream repositories may be on a public BitBucket
     * server. To access repos on BitBucket, I (JV) don't
     * want to use the same key / password as for checkouts from
     * staging repositories,
     *
     * Therefore, also look for another credentials with ID
     * `workflow:push-upstream`. If it exists, then use these to
     * push to upstrem repository. If no such credentials exist,
     * use standard credentials.
     *
     * So, here we go:
     */
    def id1 = "workflow-push-upstream";
    def id2 = scm.getCredentialsId();
    def credentials = null;

    for (StandardUsernameCredentials c : CredentialsProvider.lookupCredentials(StandardUsernameCredentials.class)) {
      if (c.getId().equals(id1)) {
        credentials = c;
        break;
      }
    }
    if (credentials == null) {
      for (StandardUsernameCredentials c : CredentialsProvider.lookupCredentials(StandardUsernameCredentials.class)) {
        if (c.getId().equals(id2)) {
          credentials = c;
          break;
        }
      }
    }

    println "Using upstream credentials ${credentials.getId()}: ${credentials.getDescription()}"

    if (credentials instanceof SSHUserPrivateKey) {
        sshagent([ credentials.getId() ]) {
            // sh "rake \"workflow:push-upstream\""
            block(null, null)
        }
    } else {
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: credentials.getId(), passwordVariable: 'pass', usernameVariable: 'user']]) {
            // sh "rake \"workflow:push-upstream[${user}, ${pass}]\""
            block(user, pass)
        }
    }
}

return this;

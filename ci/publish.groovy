/*
 * This is a publish pipeline
 */


pipeline {
    agent { label 'linux' }

    parameters {
        string(name: 'job', description: 'Job whose artifacts to upload',  defaultValue: 'stx_jv')
        string(name: 'srv', description: 'Server (and username) where to upload artifacts',  defaultValue: "${env.STX_PUBLISH_SERVER}")
        string(name: 'dir', description: 'Directory where to upload artifacts  ',  defaultValue: "${env.STX_PUBLISH_DIRECTORY}/6.2.6")
    }

    stages {
        stage('Copy artifacts') {
            steps {
                copyArtifacts projectName: "${params.job}", selector: lastSuccessful(), excludes: '**/*prebuilt*'
                sh "ls -al artifacts"
            }
        }

        stage ( "Upload artifacts" ) {
            steps {
                sshagent([ "8be01219-a51e-410a-9850-bf9c134283fb" ]) {
                    sh script:
                        """
                        sftp -b - ${params.srv} <<END
                        cd ${params.dir}
                        ls
                        rm *
                        put artifacts/*
                        ls
                        END
                        """.stripIndent()
                }
            }
        }
        stage ( "Cleanup" ) {
            steps {
                cleanWs()
            }
        }
    }
}



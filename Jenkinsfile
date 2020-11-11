pipeline {
    
    agent any
    
    // parameters {
    //     booleanParam(name: "RELEASE", defaultValue: false)
    // }
    
    stages {
        stage('Configure build') {
            steps {
                script {
                    timeout(time: 60, unit: 'SECONDS') {
                            userInput = input(
                                message:    'Input required!',
                                parameters: [
                                    password(defaultValue: 'value', description: 'Vault token to access secrets required for AppStore build. Needs to be in group mobile20-appstore.', name: 'vault_token'),
                                    string(defaultValue: 'CN',
                                            description: 'Path of config file',
                                            name: 'region')
                                ]
                            )

                            region = userInput.region

                    }
                }
            }
        }

        stage("Build") {
            steps {
                echo "hello build"
                echo "$userInput"
                echo "$region"
                script {
                    sh "ls"
                }

            }
        }
        
        stage("Publish") {
            when { expression { params.RELEASE } }

            steps {
                script {
                    if (params.RELEASE) {
                        sh "ls"
                    }
                }
            }
        }
    }
}

pipeline {
    agent any

    stages {
         stage('Configure build') {
            steps {
                script {
                    timeout(time: 60, unit: 'SECONDS') {
                            vaultToken = input(
                                message:    'Input required!',
                                parameters: [
                                    password(defaultValue: 'value', description: 'Vault token to access secrets required for AppStore build. Needs to be in group mobile20-appstore.', name: 'vault_token'),
                                    choice(name: 'PLATFORM_FILTER', choices: ['all', 'cn', 'row', 'kr'], description: 'Run on specific platform')

                                ]
                            )
                    }
                }
            }
        }
        stage('BuildAndTest') {
            environment {
                VAULT_TOKEN = "$vaultToken"
            }
            matrix {
                when { anyOf {
                    expression { params.PLATFORM_FILTER == 'all' && env.PLATFORM != 'cn' }
                    expression { params.PLATFORM_FILTER == env.PLATFORM }
                } }
                axes {
                    axis {
                        name 'PLATFORM'
                        values 'cn', 'row', 'kr'
                    }
                    axis {
                        name 'BROWSER'
                        values 'firefox', 'chrome', 'safari'
                    }
                }
            
                stages {
                    stage('Build') {
                        steps {
                            echo "Do Build for ${PLATFORM} - ${BROWSER}"
                        }
                    }
                    stage('Test') {
                        steps {
                            echo "Do Test for ${PLATFORM} - ${BROWSER}"
                        }
                    }

                }

                
            }
        }
    }
}
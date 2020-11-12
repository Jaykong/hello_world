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
                                    choice(name: 'REGION_PICKER', choices: ['global', 'ROW', 'CN', 'KR'], description: 'Run on specific region')

                                ]
                            )
                               
                            
                    }
                }
            }
        }
        stage('BuildAndTest') {
            
            environment {
                VAULT_TOKEN = "${vaultToken['vault_token']}"
                PLATFORM_FILTER = "${vaultToken['REGION_PICKER']}"

            }
            
            matrix {
                
                when { anyOf {
                    expression { PLATFORM_FILTER == 'global' && env.PLATFORM != 'cn' }
                    expression { PLATFORM_FILTER == env.PLATFORM }
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
                            echo "$PLATFORM_FILTER"


                            echo "Do Build for ${PLATFORM} - ${BROWSER}"
                        }
                    }
                    stage('Test') {
                        steps {
                            echo "Do Test for ${PLATFORM} - ${BROWSER}"
                            stage{
                                echo "stage in steps"
                            }
                        }
                    }

                }

                
            }
        }
    }
}
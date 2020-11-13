def globalTimeoutMinutes = 90
def vaultToken
def getTeamId(String region) {
    switch(region) {
        case "NA":
            return "${TEAM_ID_BMW_NA}"
        case ["ROW", "KR"]:
            return "${TEAM_ID_BMW_AG}"
        case "CN":
            return "${TEAM_ID_BMW_CHINA}"
    }
}

def getFlavor(String brand, String region) {
    def flavor = brand.toLowerCase()
    switch(region) {
        case "NA":
            flavor += "northamerica"
            break;
        case "ROW":
            flavor += "restofworld"
            break;
        case "KR":
            flavor += "korea"
            break;
        case "CN":
            flavor += "china"
            break;
    }
    return flavor + "appstore"
}

def getTarget(String brand, String region) {
    switch(region) {
        case "NA":
            return "./lib/main/here/main_${brand.toLowerCase()}_north_america_appstore.dart"
        case "ROW":
            return "./lib/main/here/main_${brand.toLowerCase()}_rest_of_world_appstore.dart"
        case "KR":
            return "./lib/main/main_${brand.toLowerCase()}_korea_appstore.dart"
        case "CN":
            return "./lib/main/main_${brand.toLowerCase()}_china_appstore.dart"
    }
}

def getAppId(String brand, String region) {
    return "de.${brand.toLowerCase()}.connected.mobile20.${region.toLowerCase()}"
}

pipeline {
    agent any;

    options {
        timeout(time: globalTimeoutMinutes, unit: 'MINUTES')
    }

    environment {
        // App Configuration
        APP_VERSION="1.1.0"
        // Docker images
        FLUTTER_ANDROID_DOCKER_CONTAINER="btcdocker.azurecr.io/bmw-flutter-android:2.39"
        FLUTTER_IOS_VAGRANT_LABEL="eadrax_xcode11_6_flutter_1_20_4"

        VAULT_ADDR = "https://secrets.connected.bmw"
        LC_ALL="en_US.UTF-8"
        LANG="en_US.UTF-8"
    }

    stages {
        stage('Verify build was triggered manually') {
            when {
                not {
                    triggeredBy cause: "UserIdCause"
                }
            }
            steps {
                error("This build can only be run by manually triggering it from the Jenkins UI.")
            }
        }
        stage('Configure build') {
            steps {
                script {
                    timeout(time: 60, unit: 'SECONDS') {
                            inputValue = input(
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
        stage('Verify vault token') {
            environment {
                VAULT_TOKEN = "${inputValue['vault_token']}"
                regionPicker = "${inputValue['REGION_PICKER']}"

            }
            steps {
                echo "Verify vault token"
                echo "$regionPicker"

            }
            // steps {
            //     sh("vault token lookup | grep display_name") // Makes sure to fail early if token is invalid, prints token owner when successful
            // }
        }
        stage("Build & Distribute") {
            environment {
                BUILD_NUMBER = sh(script: 'git rev-list --count HEAD', , returnStdout: true).trim()
                PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/vagrant/.gem/bin:/Users/vagrant/.fastlane/bin:/Users/vagrant/.pub-cache/bin:/Users/vagrant/flutter/bin/cache/dart-sdk/bin:/Users/vagrant/flutter/bin"
                FLUTTER_HOME="/Users/vagrant/flutter"
                DART_HOME="/Users/vagrant/flutter/bin/cache/dart-sdk"
                TEAM_ID_BMW_AG = "5GRN39QKB9"
                TEAM_ID_BMW_NA = "XC36KHSA2U"
                TEAM_ID_BMW_CHINA = "RYA5A9UM3L"
                regionPicker = "${inputValue['REGION_PICKER']}"
            }
           
            matrix {
                when { anyOf {
                    expression { regionPicker == 'global' && env.REGION != 'CN' }
                    expression { regionPicker == env.REGION }
                } }
                axes {
                    axis {
                        name 'PLATFORM'
                        values 'ios', 'android'
                    }
                    axis {
                        name 'BRAND'
                        values 'BMW', 'MINI'
                    }
                    axis {
                        name 'REGION'
                        values 'ROW', 'KR' , 'CN'//, 'NA'
                    }
                }
                options {
                    skipDefaultCheckout()
                }
                stages {
                    // stage('Android') {
                    //     when {
                    //         beforeAgent true
                    //         environment name: 'PLATFORM', value: 'android'
                    //     }
                    //     // agent {
                            
                    //     //     // docker {
                    //     //     //     image("${FLUTTER_ANDROID_DOCKER_CONTAINER}")
                    //     //     //     args('--user root')
                    //     //     //     label('high-memory-v1')
                    //     //     // }
                    //     // }
                    //     stages {
                    //         stage('Prepare node') {
                    //             steps {
                    //                 echo "Prepare node"

                    //             }
                    //             // steps {
                    //             //     sh("git clean -dfx")
                    //             //     sh("bmwsys vault az-msi-login jenkins")
                    //             //     sh("az-bmw-git-login")
                    //             //     sh("./scripts/pipeline/load_artifactory_credentials_from_vault.sh")
                    //             // }
                    //         }
                    //         stage('Build global') {
                               
                    //             environment {
                    //                 VAULT_TOKEN = "${inputValue['vault_token']}"
                    //                 FLAVOR = getFlavor(env.BRAND, env.REGION)
                    //             }
                    //             when {
                    //                 expression {env.REGION != 'CN'}
                    //             }
                    //             steps {
                    //                 echo "Building Android for $BRAND $REGION"
                    //                 // script {
                    //                 //     def target = getTarget(env.BRAND, env.REGION)
                    //                 //     def packageName = getAppId(env.BRAND, env.REGION)

                    //                 //     sh("./scripts/pipeline/preprocess_pubspec.sh ${FLAVOR}")
                    //                 //     sh("./scripts/pipeline/load_keys_from_vault.sh ${FLAVOR} --appstore")
                    //                 //     sh("./scripts/pipeline/load_android_signing_configuration.sh --appstore")
                    //                 //     sh("flutter packages get")
                    //                 //     sh("flutter build appbundle --release -t ${target} --flavor ${FLAVOR} --build-number=${BUILD_NUMBER}")

                    //                 //     sh("vault kv get -field=jsonkey secret/mobile20-appstore/android/play_account > ./android/gpuk.json")
                    //                 //     sh("cd android; ./gradlew publish${FLAVOR.capitalize()}ReleaseBundle")
                    //                 // }
                    //             }
                    //         }
                    //         stage('Build cn') {
                               
                    //             environment {
                    //                 VAULT_TOKEN = "${inputValue['vault_token']}"
                    //                 FLAVOR = getFlavor(env.BRAND, env.REGION)
                    //             }
                    //             when {
                    //                 expression {env.REGION == 'CN'}
                    //             }
                    //             steps {
                    //                 echo "Building Android for $BRAND $REGION"
                    //                 // script {
                    //                 //     def target = getTarget(env.BRAND, env.REGION)
                    //                 //     def packageName = getAppId(env.BRAND, env.REGION)

                    //                 //     sh("./scripts/pipeline/preprocess_pubspec.sh ${FLAVOR}")
                    //                 //     sh("./scripts/pipeline/load_keys_from_vault.sh ${FLAVOR} --appstore")
                    //                 //     sh("./scripts/pipeline/load_android_signing_configuration.sh --appstore")
                    //                 //     sh("flutter packages get")
                    //                 //     sh("export FLAVOR=${flavor} && flutter build apk --release -t ${target} --flavor ${flavor} --build-number=${BUILD_NUMBER}")
                    //                 // }
                    //                 // archiveArtifacts '**/*.apk'
                    //             }
                    //         }
                            
                    //     }
                    //     post {
                    //         always {
                    //             // archiveArtifacts artifacts: 'build/app/outputs/bundle/**/*.aab'
                    //             sh("git clean -dfx")
                    //             cleanWs(disableDeferredWipeout: true)
                    //         }
                    //     }
                    // }
                    stage('iOS') {
                        when {
                            // beforeAgent true
                            environment name: 'PLATFORM', value: 'ios'
                            regionPicker = "${inputValue['REGION_PICKER']}"

                        }
                        // agent {
                        //     any
                        //     // node {
                        //     //     label "${FLUTTER_IOS_VAGRANT_LABEL}"
                        //     // }
                        // }
                        environment {
                            VAULT_TOKEN = "${inputValue['vault_token']}"

                        }
                        steps {
                            echo "Building iOS for $BRAND $REGION"
                            // script {
                            //     def flavor = getFlavor(env.BRAND, env.REGION)
                            //     def target = getTarget(env.BRAND, env.REGION)
                            //     def appId = getAppId(env.BRAND, env.REGION)
                            //     def teamId = getTeamId(env.REGION)

                            //     sh("git clean -dfx")
                            //     sh("sudo killall -9 dart || true") // release orphaned locks
                            //     sh("./scripts/pipeline/preprocess_pubspec.sh ${flavor}")
                            //     sh("./scripts/pipeline/load_keys_from_vault.sh ${flavor} --appstore")
                            //     sh("./scripts/pipeline/build_ios_appstore.sh '${appId}' '${teamId}' '${flavor}' '${BUILD_NUMBER}' '${target}' '${REGION}' '${BRAND}'")
                            // }
                        }
                        // post {
                        //     always {
                        //         sh("./scripts/pipeline/upload_dsym.sh '$flavor'")
                        //         archiveArtifacts artifacts: '**/*.dSYM.zip'
                        //         sh "rm -rf /Users/vagrant/Library/Developer/Xcode/DerivedData/*"
                        //         sh("git clean -dfx")
                        //         // Remove keychain from slave
                        //         sh("security list-keychains -s /Users/vagrant/Library/Keychains/login.keychain-db /Library/Keychains/System.keychain")
                        //         sh("rm -f /Users/vagrant/ios-appstore.keychain-db")
                        //         cleanWs(disableDeferredWipeout: true)
                        //     }
                        // }
                    }
                }
            }
        }
    }
}

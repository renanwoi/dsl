job('job_dsl_example') {

    description('This is my awesome Job')


    parameters {
        stringParam('Planet', defaultValue = 'world', description = 'This is the world')
        booleanParam('FLAG', true)
        choiceParam('OPTION', ['option 1 (default)', 'option 2', 'option 3'])
    }

    scm {
        git('https://github.com/jenkins-docs/simple-java-maven-app', 'master')
    }

    triggers {
        cron('H 5 * * 7')
    }

    steps {
        shell("echo 'Hello World'")
        shell("echo 'Hello World2'")
    }

    publishers {
        mailer('me@example.com', true, true)
    }
}

job('ansible-users-db-dsl') {

    description('Update the html table.')


    parameters {
        choiceParam('AGE', ['21', '22', '23', '24', '25'])
    }

    steps {

        wrappers {
            colorizeOutput(colorMap = 'xterm')
      }
        ansiblePlaybook('/var/jenkins_home/ansible/people.yml') {
            inventoryPath('/var/jenkins_home/ansible/hosts')
            forks(10)
            colorizedOutput(true)
            extraVars {
                extraVar("PEOPLE_AGE", '${AGE}', false)
            }
        }
    }
}

job('maven_dsl') {

    description('Maven dsl project')

    scm {
        git('https://github.com/jenkins-docs/simple-java-maven-app', 'master', {node -> node / 'extensions' << '' })
    }

    steps {
        maven {
            mavenInstallation('jenkins-maven')
            goals('-B -DskipTests clean package')
        }
        maven {
            mavenInstallation('jenkins-maven')
            goals('test')
        }
        shell('''
            echo *************RUNNING THE JAR*************************
            java -jar /var/jenkins_home/workspace/maven_dsl/target/my-app-1.0-SNAPSHOT.jar
        ''')
    }

    publishers {
        archiveArtifacts('target/*.jar')
        archiveJunit('target/surefire-reports/*.xml')
        mailer('rco.renan@outlook.com', true, true)
    }
}
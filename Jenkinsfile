pipeline {
	agent any 
	environment {
		IMAGE_PHP='devopsdr/pub:php${BUILD_NUMBER}'
		IMAGE_DB='devopsdr/pub:DB${BUILD_NUMBER}'
		BUILD_IP='ec2-user@65.2.140.18'
		DEPLOY_IP='ec2-user@3.109.4.137'
	}
	stages {
		stage ('BUILD THE PHPDB IMAGE') {
			steps {
				sshagent(['ssh-agent']) {
					script {
						withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dpwd', usernameVariable: 'docr')]) {
							echo "BUILD THE PHPDB IMAGE"
							sh "scp -o StrictHostKeyChecking=on -r php_files db_files ${BUILD_IP}:/home/ec2_user/"
							sh "ssh -o StrictHostKeyChecking=on ${BUILD_IP} 'bash ~/php_piles/php_script.sh'"
							sh "ssh -o StrictHostKeyChecking=on ${BUILD_IP} 'sudo docker build -t ${IMAGE_PHP} -f /home/ec2_user/php_files .'"
							sh "ssh -o StrictHostKeyChecking=on ${BUILD_IP} 'sudo docker build -t ${IMAGE_DB} -f /home/ec2_user/db_files .'	"
							sh "ssh -o StrictHostKeyChecking=on ${BUILD_IP} 'sudo docker login -u ${docr} -p {dpwd}'"
							sh "ssh -o StrictHostKeyChecking=on ${BUILD_IP} 'sudo docker push ${IMAGE_PHP}'"
							sh "ssh -o StrictHostKeyChecking=on ${BUILD_IP} 'sudo docker push ${IMAGE_DB}'"
						}
					}
				}
			}
		}
		stage ('DEPLOY THE PHPDB CONTAINER') {
			steps {
				sshagent(['ssh-agent']) {
					script {
						//withCredentials([usernamePassword(credentialsId: 'dockerhub', passwordVariable: 'dpwd', usernameVariable: 'docr')]) {
							echo "DEPLOY THE PHPDB CONTAINER"
							sh "scp -o StrictHostKeyChecking=on -r compose_phpdb ${DEPLOY_IP}:/home/ec2_user/"
							sh "ssh -o StrictHostKeyChecking=on ${DEPLOY_IP} 'bash ~/compose_phpdb/docker-compose-script.sh'"
						//	sh "ssh -o StrictHostKeyChecking=on ${BUILD_IP} 'sudo docker login -u ${docr} -p {dpwd}'"
							sh "ssh -o StrictHostKeyChecking=on ${DEPLOY_IP} '1=${IMAGE_PHP} 2=${IMAGE_DB} docker-compose up -d -f /home/ec2-user/compose_phpdb/ .'"
						//}
					}
				}
			}
		}
	}
}
	
resource "null_resource" "app_deploy" {
    count = local.TOTAL_INSTANCE_COUNT

    triggers = {
        always_run = timestamp()            # This ensure your provisioner would be executing all the time
    }

    provisioner "remote-exec" {
    
    # Connection block establish connection to server
    connection {
      type      = "ssh"
      user      = local.SSH_USERNAME
      password  = local.SSH_PASSWORD
      host      = element(local.INSTANCE_IPS, count.index)    # aws_instance.sample.private_ip : Use this only if your provisioner is outside the resource.
    }

    inline = [ 
      "ansible-pull -U https://github.com/Adnan-110/ansible.git -e REDIS_ENDPOINT=${data.terraform_remote_state.db.outputs.REDIS_ENDPOINT} -e MYSQL_ENDPOINT=${data.terraform_remote_state.db.outputs.MYSQL_ENDPOINT} -e DOCDB_ENDPOINT=${data.terraform_remote_state.db.outputs.DOCDB_ENDPOINT} -e APP_VERSION=${var.APP_VERSION} -e ENVIRONMENT=${var.ENV} -e COMPONENT=${var.COMPONENT} roboshop-pull.yml"
     ]
  }  
}